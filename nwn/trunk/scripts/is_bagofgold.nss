#include "x2_inc_switches"

void main()
{
    if(GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_UNACQUIRE)
    {
        object oBag = GetModuleItemLost();
        object oNewOwner = GetItemPossessor(oBag);

        if(GetIsPC(oNewOwner))
        {
            string sName = GetName(oBag);
            string sGP = GetStringByStrRef(6407)+" ";
            int nGold = StringToInt(GetStringRight(sName, GetStringLength(sName) - GetStringLength(sGP)));

            DestroyObject(oBag);
            GiveGoldToCreature(oNewOwner, nGold);
        }
    }
}