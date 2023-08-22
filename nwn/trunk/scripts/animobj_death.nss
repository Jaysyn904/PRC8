#include "x0_i0_henchman"

void main()
{
    object oAnimate = OBJECT_SELF;
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST);
    if (GetIsObjectValid(oItem))
    {
        CopyObject(oItem, GetLocation(oAnimate));
        AssignCommand(GetModule(),DestroyObject(oItem,0.9));
        AssignCommand(GetModule(),DestroyObject(oAnimate,1.0));
//        ActionUnequipItem(oItem);
//        ActionPutDownItem(oItem);
    }
    else
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        if (GetIsObjectValid(oItem))
        {
            CopyObject(oItem, GetLocation(oAnimate));
            AssignCommand(GetModule(),DestroyObject(oItem,0.9));
            AssignCommand(GetModule(),DestroyObject(oAnimate,1.0));
        }
    }
}
