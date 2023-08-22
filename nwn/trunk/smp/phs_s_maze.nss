/*:://////////////////////////////////////////////
//:: Spell Name Maze
//:: Spell FileName PHS_S_Maze
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    8M range, SR yes. Forces them into a maze - DC 20 intelligence check to get
    out each round, or a 10 minute duration.
    Minotaurs are not affected by this spell.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Easy peasy! It will teleport the creature (by JumpToObject) to the maze
    area, and it then autoamtically does the 6 second checks, not full
    round actions. Running around finds the way out as fast as anything.

    Cannot use teleport or anything in the maze area.

    Plotted as well, stops hostile creatures attacking each other (Creatures
    are also uncommandable, so they don't move and AI scripts cannot run).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_MAZE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    // - Use oTarget location in case GetSpellTargetLocatoin() isn't equal to it.
    location lTarget = GetLocation(oTarget);
    object oNewMazeObject;
    object oMazePoint = GetWaypointByTag(PHS_S_MAZE_TARGET);
    object oTargetArea = GetArea(oTarget);

    // Maximum duration is 10 Minutes (turns)
    float fDuration = PHS_GetDuration(PHS_MINUTES, 10, GetMetaMagicFeat());

    // Delcare impact effect
    effect eImpact1 = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    effect eImpact2 = EffectVisualEffect(PHS_VFX_FNF_MAZE);
    // A duration effect, just so it is something to check.
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);

    // Always fire spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MAZE, TRUE);

    // - It is a minotaur?
    // - Can it be destroyed?
    if(!PHS_GetIsMinotaur(oTarget) &&
        PHS_CanCreatureBeDestroyed(oTarget) &&
        GetIsObjectValid(oMazePoint) &&
       !PHS_IsInMazeArea(oTarget) &&
       !PHS_IsInMazeArea(oCaster))
    {
        // Spell Resistance Check
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Apply AOE visuals to the location
            PHS_ApplyLocationVFX(lTarget, eImpact1);
            PHS_ApplyLocationVFX(lTarget, eImpact2);

            // Apply a duration effect, just so it is something to check.
            PHS_ApplyDuration(oTarget, eDur, fDuration);

            // Set variables to jump back to.
            SetLocalLocation(oTarget, PHS_S_MAZEPRISON_LOCATION, lTarget);
            SetLocalObject(oTarget, PHS_S_MAZEPRISON_OLD_AREA, oTargetArea); // A check for LOCATION is valid.
            // Set amount of rounds left we can DC check for.
            SetLocalInt(oTarget, PHS_S_MAZE_ROUND_COUNTER, 600);

            // Create Maze object, and set local object to the target
            oNewMazeObject = CreateObject(OBJECT_TYPE_PLACEABLE, PHS_MAZE_OBJECT, lTarget);
            // Set local object so freedom works.
            SetLocalObject(oNewMazeObject, PHS_MAZEPRISON_OBJECT, oTarget);
            // Set local object on the PC so they know which is thiers
            // - Same variable name.
            SetLocalObject(oTarget, PHS_MAZEPRISON_OBJECT, oNewMazeObject);

            // Move there and commandable.
            AssignCommand(oTarget, ClearAllActions());
            AssignCommand(oTarget, JumpToObject(oMazePoint));

            // Set plot flag on enter, and NPCs are set to uncommandable.
        }
    }
}
