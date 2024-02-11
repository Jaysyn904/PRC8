//::///////////////////////////////////////////////
//:: Sleep/Paralysis Immunity feat for Diamond Dragon
//:: psi_diadra_imm.nss
//::///////////////////////////////////////////////
/*
    Toggles the Sleep/Paralysis neutralization on and off.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 15, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{

    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    string nMes = "";

    if(!GetLocalInt(oPC, "DiamondImmune"))
    {
        SetLocalInt(oPC, "DiamondImmune", TRUE);
        //activate Immunity script
        AddEventScript(oPC, EVENT_ONHEARTBEAT, "psi_diadra_ntrl", TRUE, FALSE);
        nMes = "*Sleep/Paralysis Immunity Activated*";
    }
    else
    {
        // Removes effects
        DeleteLocalInt(oPC, "DiamondImmune");
        //deactivate immunity script
        RemoveEventScript(oPC, EVENT_ONHEARTBEAT, "psi_diadra_ntrl", TRUE, TRUE);
        nMes = "*Sleep/Paralysis Immunity Deactivated*";
    }

    FloatingTextStringOnCreature(nMes, oPC, FALSE);
}