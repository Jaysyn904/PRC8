//::///////////////////////////////////////////////
//:: Maze
//:: MD_s0_maze.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Banishes a creature into an extradimensional labyrinth of force planes.
    Each round on its turn, the target attempts an Intelligence check to escape.
    DC = 20 + 5 per Spell Focus Conjuration tier of the caster.
    If the target doesn't escape, the maze disappears after 10 minutes,
    forcing the subject to leave.

    Now features procedurally generated random mazes
    using native SetTileJson for unique player experiences.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 12, 2001
//:: Modified: December 2024 - Added random maze generation
//:: Modified: December 2024 - Reworked to use EffectRunScript with interval saving throws
//:://////////////////////////////////////////////

#include "X2_I0_Spells"
#include "fw_cast_level"
#include "nwnx_util"
#include "sf_inc_fixes"
#include "sp_inc_maze"
#include "x2_inc_spellhook"


// Helper function to clean up maze when effect ends or target escapes
void Maze_CleanupOnEscape(object oTarget);

void Maze_CleanupOnEscape(object oTarget)
{
    location lExit   = GetLocalLocation(oTarget, "MazeEnt");
    object oMazeArea = GetLocalObject(oTarget, "MazeArea");


    // Find and destroy the maze placeable marker
    object oMazePlaceable = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, lExit);
    if (GetIsObjectValid(oMazePlaceable) && TestStringAgainstPattern("spellmaze", GetTag(oMazePlaceable)))
    {
        DestroyObject(oMazePlaceable, 2.0);
        // Teleport target back to entrance location
        AssignCommand(oTarget, ClearAllActions());
        AssignCommand(oTarget, ActionJumpToLocationSafe(lExit));
    }

    // Clean up dynamic maze area if it exists
    if (GetIsObjectValid(oMazeArea))
    {
        DelayCommand(3.0, Maze_DestroyArea(oMazeArea));
        DeleteLocalObject(oTarget, "MazeArea");
    }

    // Clean up local variables
    DeleteLocalLocation(oTarget, "MazeEnt");
    DeleteLocalInt(oTarget, "MazeDC");

    //Make sure NPCs re-enter combat properly
    if (!GetIsPC(oTarget))
        DelayCommand(0.5, DetermineCombatRound(oTarget));
}

void main()
{
    // Handle EffectRunScript callbacks
    if (GetLastRunScriptEffectScriptType() == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_REMOVED)
    {
        // Effect was removed (by dispel, duration expiry, exit portal, or Intelligence check)
        // Clean up and teleport target back
        object oTarget = OBJECT_SELF;

        // Only clean up if we're still in a maze
        location lExit   = GetLocalLocation(oTarget, "MazeEnt");
        object oExitArea = GetAreaFromLocation(lExit);
        if (GetIsObjectValid(oExitArea))
        {  
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FREEDOM), oTarget);
            SendMessageToPC(oTarget, "The maze fades away and you find yourself back where you started.");

            //Slight delay to allow message to be seen before teleport
            DelayCommand(3.0, Maze_CleanupOnEscape(oTarget));
        }
        return;
    }
    else if (GetLastRunScriptEffectScriptType() == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_INTERVAL)
    {
        // Each round: target attempts an Intelligence check to escape
        object oTarget = OBJECT_SELF;

        // Get current DC from local variable (decreases by 2 each round)
        int nDC = GetLocalInt(oTarget, "MazeDC");

        // Roll Intelligence check: d20 + INT modifier vs DC
        int nIntMod  = GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget);
        int nRoll    = d20();
        int nTotal   = nRoll + nIntMod;
        int bSuccess = nTotal >= nDC;

        if (bSuccess)
        {
            SendMessageToPC(oTarget, "You find your way out of the maze! (" + IntToString(nRoll) + " + " + IntToString(nIntMod) + " = " + IntToString(nTotal) + " vs DC " + IntToString(nDC) + ")");

            // Remove the maze effect (this will trigger ON_REMOVED which handles cleanup)
            effect eCheck = GetFirstEffect(oTarget);
            while (GetIsEffectValid(eCheck))
            {
                if (GetEffectSpellId(eCheck) == SPELL_MAZE)
                {
                    RemoveEffect(oTarget, eCheck);
                    break;
                }
                eCheck = GetNextEffect(oTarget);
            }
        }
        else
        {
            // Reduce DC by 1 for next round (minimum 1)
            int nNewDC = (nDC > 3) ? (nDC - 1) : 1;
            SetLocalInt(oTarget, "MazeDC", nNewDC);

            SendMessageToPC(oTarget, "You wander the maze, searching for an exit... (" + IntToString(nRoll) + " + " + IntToString(nIntMod) + " = " + IntToString(nTotal) + " vs DC " + IntToString(nDC) + ")");
        }
        return;
    }

    // Initial spell cast handling
    object oTarget   = GetSpellTargetObject();
    object oArea     = GetArea(oTarget);
    int nTargetLook  = GetAppearanceType(oTarget);
    location lTarget = GetLocation(oTarget);
    object oNewMazeObject;
    effect eVis  = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    effect eVis2 = EffectVisualEffect(VFX_MAZE);

    // Immunity checks
    if (GetIsDM(oTarget) || GetIsDMPossessed(oTarget) || GetHasSpellEffect(SPELL_DIMENSIONAL_ANCHOR, oTarget) || GetLocalInt(oTarget, "BOSS") || GetLocalInt(oTarget, "NoMaze") || GetLocalInt(oArea, "NO_TELEPORT") || nTargetLook == APPEARANCE_TYPE_MINOTAUR || nTargetLook == APPEARANCE_TYPE_MINOTAUR_CHIEFTAIN || nTargetLook == APPEARANCE_TYPE_MINOTAUR_SHAMAN)
    {
        SendMessageToPC(OBJECT_SELF, NWNX_Util_StripColors(GetName(oTarget)) + " : Immune to Maze.");
        return;
    }

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    if (!MyPRCResistSpell(OBJECT_SELF, SPELL_SCHOOL_CONJURATION, oTarget))
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, lTarget);

        // Calculate DC: base from spell save DC, scaled down
        int nDC = SPGetSpellSaveDC(OBJECT_SELF, SPELL_SCHOOL_CONJURATION, SPELL_MAZE);

        // Store entrance location and initial DC before teleporting
        SetLocalLocation(oTarget, "MazeEnt", lTarget);
        SetLocalInt(oTarget, "MazeDC", nDC);

        // Create maze placeable marker at entrance
        oNewMazeObject = CreateObject(OBJECT_TYPE_PLACEABLE, "spellmaze", lTarget);
        SetLocalString(oNewMazeObject, "Mazed One", GetName(oTarget));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, UnyieldingEffect(EffectCutsceneGhost()), oNewMazeObject);

        // Apply the maze effect with 1 round interval for Intelligence checks
        // Duration: 10 minutes max
        effect eMaze = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);
        eMaze        = EffectLinkEffects(eMaze, EffectRunScript("", "md_s0_maze", "md_s0_maze", 6.0));
        eMaze        = SupernaturalEffect(eMaze);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMaze, oTarget, 600.0);  // 10 minutes
        AssignCommand(oTarget, ClearAllActions());

        // Create a unique randomized maze area for this target
        object oMazeArea = Maze_CreateRandomArea(oTarget, "spellmaze");

        if (GetIsObjectValid(oMazeArea))
        {
            // Store reference to the maze area on the target and placeable
            SetLocalObject(oTarget, "MazeArea", oMazeArea);
            SetLocalObject(oNewMazeObject, "MazeArea", oMazeArea);

            // Get spawn location within the maze
            location lMazeSpawn = Maze_GetSpawnLocation(oMazeArea);

            // Jump target to the randomized maze
            DelayCommand(1.5, AssignCommand(oTarget, ActionJumpToLocation(lMazeSpawn)));
        }
        else
        {
            // Failed to create maze area - clean up and abort
            SendMessageToPC(OBJECT_SELF, "Maze spell failed: could not create maze area.");
            DestroyObject(oNewMazeObject, 2.0);
            DeleteLocalLocation(oTarget, "MazeEnt");
            DeleteLocalInt(oTarget, "MazeDC");
            return;
        }

        SendMessageToPC(oTarget, "You are banished into an extradimensional labyrinth! Find the exit or make an Intelligence check each round to escape.");
    }
}
