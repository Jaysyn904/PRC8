//::///////////////////////////////////////////////
//:: FileName mh_at_002
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/02/2004 15:33:49
//:://////////////////////////////////////////////

#include "prc_inc_clsfunc"

void main()
{
    // Donner les objets à la personne qui parle
    object oSpeaker = GetPCSpeaker();
    object oItem = CreateItemOnObject("mh_it_luth", oSpeaker, 1);
    SetIdentified(oItem,TRUE);
    SetLocalObject(oItem, "mh_createur", oSpeaker);
    SetLocalInt(oItem,"cout_instrument",15000);
    //ExecuteScript("mh_ins_sp_script", oSpeaker);
    TakeGoldFromCreature(7500, GetPCSpeaker(), TRUE);
    SetXP(GetPCSpeaker(), GetXP(GetPCSpeaker()) - 600);
    if(!GetLocalInt(oSpeaker,"use_CIMM"))
    {
        ActiveModeCIMM(oSpeaker);
    }
}
