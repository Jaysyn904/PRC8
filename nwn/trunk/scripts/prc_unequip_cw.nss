// This script unequips the PC's creature weapons, if any (for debugging purposes).
// Called from debug console only.

void main()
{
    object oPC = OBJECT_SELF;

    object oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
    if (GetIsObjectValid(oWeapCR))
        ActionUnequipItem(oWeapCR);

    object oWeapCL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
    if (GetIsObjectValid(oWeapCL))
        ActionUnequipItem(oWeapCL);

    object oWeapCB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
    if (GetIsObjectValid(oWeapCB))
        ActionUnequipItem(oWeapCB);
}
