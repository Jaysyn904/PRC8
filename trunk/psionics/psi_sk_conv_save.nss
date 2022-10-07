//::///////////////////////////////////////////////
//:: Soulknife: Conversation - Save settings
//:: psi_sk_conv_save
//::///////////////////////////////////////////////
/*
    Saves the new mindblade enhancement selections
    and queues an event to OnRest for them to
    come to effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 07.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"
#include "inc_utility"

void main()
{
    object oPC = GetPCSpeaker();
    
    SetLocalInt(oPC, MBLADE_FLAGS + "_Q", GetLocalInt(oPC, MBLADE_FLAGS + "_T"));
    
    AddEventScript(oPC, EVENT_ONPLAYERREST_FINISHED, "psi_sk_event", FALSE, FALSE);
}
