/*:://////////////////////////////////////////////
//:: Spell Name Zone of Truth: On Exit
//:: Spell FileName PHS_S_ZoneTruthB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    On Exit:
    - Tell them they may speak as they like, out of the zones.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oTarget = GetExitingObject();

    // Tell the player, and DM's, about the sucess or failure, and why.
    FloatingTextStringOnCreature("You feel as if you are out of a zone of truth now.", oTarget, FALSE);
    // Make them speak a string to the DM channel so DM's can see it.
    SpeakString("Zone of Truth: Exited/Spell Ended. Can lie as normal.", TALKVOLUME_SILENT_SHOUT);
}
