/*:://////////////////////////////////////////////
//:: Spell Name Maze : Jump Out
//:: Spell FileName PHS_S_MazeC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Jump Mazed Out

    This is executed on the (N)PC and jumps them out of the area.

    This is also used for Imprisonment removal VIA. freedom.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Delcare Major Variables
    object oTarget = OBJECT_SELF;

    // Imprisonment or Maze?
    if(GetHasSpellEffect(PHS_SPELL_IMPRISONMENT, oTarget))
    {
        SendMessageToPC(oTarget, "You are released from your prison!");
    }
    else
    {
        SendMessageToPC(oTarget, "You see the maze's exit!");
    }
    // - Move them back to thier location
    location lMoveTo = GetLocalLocation(oTarget, PHS_S_MAZEPRISON_LOCATION);
    object oMoveToArea = GetLocalObject(oTarget, PHS_S_MAZEPRISON_OLD_AREA);
    // Debug check...
    if(GetIsObjectValid(oMoveToArea) &&
       GetAreaFromLocation(lMoveTo) == oMoveToArea)
    {
        // Set NPCs to commandable
        SetCommandable(TRUE, oTarget);
        ClearAllActions();
        JumpToLocation(lMoveTo);
    }
}
