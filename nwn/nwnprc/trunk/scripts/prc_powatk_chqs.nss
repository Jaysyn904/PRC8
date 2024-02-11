//::///////////////////////////////////////////////
//:: Power Attack - Change Quickselect
//:: prc_powatk_chqs
//:://////////////////////////////////////////////
/*
    Sets the local int signifying that next use of
    a quickslot is to store the current value
    of power attack instead of changing it.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 22.05.2005
//:://////////////////////////////////////////////


void main()
{
    object oPC = OBJECT_SELF;

    SetLocalInt(oPC, "ChangePowerAttackQuickselect", TRUE);
    SendMessageToPCByStrRef(oPC, 16823461);
    // Ten seconds to change the selection
    DelayCommand(10.0f, DeleteLocalInt(oPC, "ChangePowerAttackQuickselect"));
}