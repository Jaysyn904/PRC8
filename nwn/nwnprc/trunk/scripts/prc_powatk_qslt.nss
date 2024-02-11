//::///////////////////////////////////////////////
//:: Power Attack - Quickselect
//:: prc_powatk_qslt
//:://////////////////////////////////////////////
/*
    Sets power attack to the value of the selected
    quickselection.
    Or stores the current power attack level in
    the selected quickselection if Change Quickselect
    has been used.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 22.05.2005
//:://////////////////////////////////////////////

#include "prc_alterations"


void main()
{
    object oPC = OBJECT_SELF;
    
    // Check what we are supposed to do
    if(GetLocalInt(oPC, "ChangePowerAttackQuickselect"))
    {// Change the quickselection
        int nVal = GetLocalInt(oPC, "PRC_PowerAttack_Level");
        SetPersistantLocalInt(oPC, "PRC_PowerAttackQuickselect_" + IntToString(PRCGetSpellId()), nVal);
        DeleteLocalInt(oPC, "ChangePowerAttackQuickselect");
        //                                     Quickselection set to
        SendMessageToPC(oPC, GetStringByStrRef(16824182) + " " + IntToString(nVal));
    }
    // Change the augmentation level
    else
    {
        int nVal = GetPersistantLocalInt(oPC, "PRC_PowerAttackQuickselect_" + IntToString(PRCGetSpellId()));
        SetLocalInt(oPC, "PRC_PowerAttack_Level", nVal);
        
        // Run the power attack applying script
        ExecuteScript("ft_poweratk", oPC);
    }
}