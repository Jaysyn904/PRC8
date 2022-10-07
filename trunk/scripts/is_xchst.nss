#include "x2_inc_switches"
#include "xchst_inc"
//#include "inc_debug"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();
    //DoDebug("nEvent = "+IntToString(nEvent));
    if(nEvent == X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC = GetItemActivator();
        object oChest = GetLocalObject(oPC, XCHST_CONT);

        if(GetIsObjectValid(oChest))
        {
            DismissChest(oChest);
        }
        else
        {
            SummonChest(oPC);
        }
    }
    else if(nEvent = X2_ITEM_EVENT_UNACQUIRE)
    {
        object oKey = GetModuleItemLost();
        object oNewOwner = GetItemPossessor(oKey);

        //if the key was put into the chest - give it back to player
        if(GetResRef(oNewOwner) == "xchst_cont")
        {
            AssignCommand(oNewOwner, ActionGiveItem(oKey, GetModuleItemLostBy()));
        }
    }
}