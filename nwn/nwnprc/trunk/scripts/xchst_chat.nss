#include "xchst_inc"
#include "prc_inc_chat"

void main()
{
    object oPC = OBJECT_SELF;
    object oChest = GetLocalObject(oPC, XCHST_CONT);

    int nGold = StringToInt(GetLocalString(oPC, PRC_PLAYER_RESPONSE));

    if(GetIsObjectValid(oChest) && nGold > 0)
    {
        int nCurrentGP = GetGold(oPC);
        if(nGold > 10000000)
            nGold = 10000000;
        if(nGold > nCurrentGP)
            nGold = nCurrentGP;

        TakeGoldFromCreature(nGold, oPC, TRUE);

        object oBag = CreateItemOnObject("bagofgold", oChest);
        string sName = GetStringByStrRef(6407)+" "+IntToString(nGold);
        SetName(oBag, sName);
    }
}