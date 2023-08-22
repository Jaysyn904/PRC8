/*:://////////////////////////////////////////////
//:: Spell Name Alarm : Mental : On Enter
//:: Spell FileName phs_s_alarm2a
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Message version. Caster must be in area and a message is sent to them.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // AOE check
    if(!PHS_CheckAOECreator()) return;

    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();
    if(!GetFactionEqual(oTarget, oCreator))
    {
        // Only display a message if we are in the same area as the creator!
        if(GetArea(oCreator) == GetArea(OBJECT_SELF))
        {
            string sMessage = "Your mental alarm has been set off!";
            SpeakString("I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
            SendMessageToPC(oCreator, sMessage);
        }
    }
}
