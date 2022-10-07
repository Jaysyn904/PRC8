/*
    prc_pyro_lash

    Fire Lash code

    By: Flaming_Sword
    Created: Dec 6, 2007
    Modified: Dec 7, 2007
*/

#include "prc_alterations"
#include "prc_x2_itemprop"

void main()
{
    object oPC = OBJECT_SELF;
    object oWhip = CreateItemOnObject("prc_pyro_lash_wh", oPC);
    SetName(oWhip, GetPersistantLocalString(oPC, "PyroString") + " Lash");
    IPSafeAddItemProperty(oWhip, ItemPropertyVisualEffect(GetPersistantLocalInt(oPC, "PyroVis")), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    AssignCommand(oPC, ActionEquipItem(oWhip, INVENTORY_SLOT_RIGHTHAND));
    SetDroppableFlag(oWhip, FALSE);
    SetItemCursedFlag(oWhip, TRUE);
}
