//:://////////////////////////////////////////////
//:: Maze spellscript
//:: sp_maze
//:://////////////////////////////////////////////
/** @file

    Maze

    Conjuration (Teleportation)
    Level: Sor/Wiz 8
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: See text
    Saving Throw: None
    Spell Resistance: Yes

    You banish the subject into an extradimensional labyrinth of force planes.
    Each round on its turn, it may attempt a DC 20 Intelligence check to escape
    the labyrinth as a full-round action. If the subject doesn’t escape, the
    maze disappears after 10 minutes, forcing the subject to leave. *

    On escaping or leaving the maze, the subject reappears where it had been
    when the maze spell was cast. If this location is filled with a solid
    object, the subject appears in the nearest open space. Spells and abilities
    that move a creature within a plane, such as teleport and dimension door,
    do not help a creature escape a maze spell, although a plane shift spell
    allows it to exit to whatever plane is designated in that spell.
    Minotaurs are not affected by this spell.


    * Implemented such that NPCs always try escape and PCs are given a choice
    whether to attempt escape or not.

    @author Ornedan
    @date   Created - 2005.10.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_maze"

void main()
{
    // Set the spell school
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);
    // Spellhook
    if(!X2PreSpellCastCode()) return;


    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel();
    int nPenetr    = nCasterLvl + SPGetPenetr();
    //int nSpellID   = PRCGetSpellId();

    // Fire cast spell at event for the specified target. For friendlies, Maze is considered non-hostile
    PRCSignalSpellEvent(oTarget, !GetIsFriend(oTarget));

    // Minotaur check
    if(GetRacialType(oTarget) == RACIAL_TYPE_MINOTAUR       ||
       GetRacialType(oTarget) == RACIAL_TYPE_KRYNN_MINOTAUR
       )
    {
        SendMessageToPCByStrRef(oCaster, 16825703); // "The spell fails - minotaurs cannot be mazed."
        return;
    }

    // Make SR check
    if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
    {
        // Get the maze area
        object oMazeArea = GetObjectByTag("prc_maze_01");

        if(DEBUG && !GetIsObjectValid(oMazeArea))
            DoDebug("Maze: ERROR: Cannot find maze area!", oCaster);

        // Determine which entry to use
        int nMaxEntry = GetLocalInt(oMazeArea, "PRC_Maze_Entries_Count");
        int nEntry = Random(nMaxEntry) + 1;
        object oEntryWP = GetWaypointByTag("PRC_MAZE_ENTRY_WP_" + IntToString(nEntry));
        location lTarget = GetLocation(oEntryWP);

        // Validity check
        if(DEBUG && !GetIsObjectValid(oEntryWP))
            DoDebug("Maze: ERROR: Selected waypoint does not exist!");

        // Make sure the target can be teleported
        if(GetCanTeleport(oTarget, lTarget, TRUE))
        {
            // Store the target's current location for return
            SetLocalLocation(oTarget, "PRC_Maze_Return_Location", GetLocation(oTarget));

            // Jump the target to the maze - the maze's scripts will handle the rest
            DelayCommand(1.5f, AssignCommand(oTarget, JumpToLocation(lTarget)));

            // Clear the action queue, so there's less chance of getting to abuse the ghost effect
            AssignCommand(oTarget, ClearAllActions());

            // Make the character ghost for the duration of the maze. Apply here so the effect gets a spellID association
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneGhost(), oTarget, 600.0f);

            // Apply some VFX
            DoMazeVFX(GetLocation(oTarget));
        }
        else
            SendMessageToPCByStrRef(oCaster, 16825702); // "The spell fails - the target cannot be teleported."
    }

    PRCSetSchool();
}