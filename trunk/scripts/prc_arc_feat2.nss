//:://////////////////////////////////////////////
//:: Created By: Solowing
//:: Created On: September 2, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "nw_o0_itemmaker"
void RemoveStrikeProps()
{
   object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
   itemproperty ipTmp = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ipTmp))
    {
        //check for channeled spell as well
        if(GetItemPropertyType(ipTmp)== ITEM_PROPERTY_ONHITCASTSPELL
            && GetItemPropertyDurationType(ipTmp) == DURATION_TYPE_TEMPORARY
            && GetLocalInt(oItem,"spell") != 1)
        {
            RemoveItemProperty(oItem,ipTmp);

        }
    ipTmp = GetNextItemProperty(oItem);
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    int i;
    for(i = 1; i <=10; i++)
    {
        int ntemp = array_get_int(oPC,"arcstrike",i);
        effect eAttack = EffectAttackIncrease(ntemp);
        DelayCommand(RoundsToSeconds(i), ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eAttack,oPC,6.0));
        DelayCommand(RoundsToSeconds(i), SetLocalInt(oPC,"curentspell",ntemp));
        if(ntemp<1)
        {
            DelayCommand(RoundsToSeconds(i), DeleteLocalInt(oPC,"doarcstrike"));
            DelayCommand(RoundsToSeconds(i), RemoveStrikeProps());
        }
    }
}
