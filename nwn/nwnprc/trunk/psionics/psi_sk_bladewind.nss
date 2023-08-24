//::///////////////////////////////////////////////
//:: Soulknife: Bladewind
//:: psi_sk_bladewind
//::///////////////////////////////////////////////
/*
    Does a whirlwind attack.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"

void main()
{
    object oPC = OBJECT_SELF;

    // Make sure they are wielding a mindblade
    if(!GetIsMindblade(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)))
    {
        SendMessageToPCByStrRef(oPC, 16824509);
        return;
    }

    /* Play random battle cry */
    int nSwitch = d10();
    switch (nSwitch)
    {
        case 1: PlayVoiceChat(VOICE_CHAT_BATTLECRY1); break;
        case 2: PlayVoiceChat(VOICE_CHAT_BATTLECRY2); break;
        case 3: PlayVoiceChat(VOICE_CHAT_BATTLECRY3); break;
    }

    SetLocalInt(oPC, BLADEWIND, TRUE);
    DelayCommand(4.0, DeleteLocalInt(oPC, BLADEWIND));

    DoWhirlwindAttack(TRUE, GetHasFeat(FEAT_IMPROVED_WHIRLWIND, oPC));
}