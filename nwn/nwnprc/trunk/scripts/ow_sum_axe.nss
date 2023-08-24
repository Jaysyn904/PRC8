//::///////////////////////////////////////////////
//:: Orc Warlord
//:://////////////////////////////////////////////
/*
    Gather Horde - Summons an Axe thrower of proper level as a henchmen.
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:://////////////////////////////////////////////
//#include "prc_inc_spells"
#include "prc_inc_util"

// sets how many of a specific orc can be summoned
const int iNumSummon = 2;

void CleanHenchman(object oImage)
{     
     SetLootable(oImage, FALSE);
     object oItem = GetFirstItemInInventory(oImage);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        if (GetBaseItemType(oItem) == BASE_ITEM_THROWINGAXE) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_80_PERCENT), oItem);
        oItem = GetNextItemInInventory(oImage);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
     {
        oItem = GetItemInSlot(i, oImage);
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        if (GetBaseItemType(oItem) == BASE_ITEM_THROWINGAXE) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_80_PERCENT), oItem);
     }
     TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

int GetCanSummonOrc(object oPC, string sCreatureResRef)
{
     int bCanSummon;
     int iNumOrc = 0;
     
     object oHench1 = GetHenchman(oPC, 1);
     object oHench2 = GetHenchman(oPC, 2);
     object oHench3 = GetHenchman(oPC, 3);
     object oHench4 = GetHenchman(oPC, 4);
     
     if(GetResRef(oHench1) ==  sCreatureResRef) iNumOrc += 1;
     if(GetResRef(oHench2) ==  sCreatureResRef) iNumOrc += 1;
     if(GetResRef(oHench3) ==  sCreatureResRef) iNumOrc += 1;
     if(GetResRef(oHench4) ==  sCreatureResRef) iNumOrc += 1;
     
     if(iNumSummon > iNumOrc) bCanSummon = TRUE;
     else                     bCanSummon = FALSE;

     return bCanSummon;
}

void main()
{
    if(GetPRCSwitch(PRC_ORC_WARLORD_COHORT))
    {
        FloatingTextStringOnCreature("This has been disabled.", OBJECT_SELF);
        return;
    }    
    object oPC = OBJECT_SELF;
    int iOrcWarlordLevel = GetLevelByClass(CLASS_TYPE_ORC_WARLORD, oPC);
    int iHD = GetHitDice(oPC);
    
    int iMaxHenchmen = GetMaxHenchmen();
    SetMaxHenchmen(99);
    
//    if(GetNumHenchmen(oPC) < iMaxHenchmen)
//    {
         string sSummon;
         object oCreature;
    
         effect eSummon = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
         effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    
         if      (iHD >= 39) sSummon = "ow_sum_axe_12";
         else if (iHD >= 36) sSummon = "ow_sum_axe_11";
         else if (iHD >= 33) sSummon = "ow_sum_axe_10";
         else if (iHD >= 30) sSummon = "ow_sum_axe_9";
         else if (iHD >= 27) sSummon = "ow_sum_axe_8";
         else if (iHD >= 24) sSummon = "ow_sum_axe_7";
         else if (iHD >= 21) sSummon = "ow_sum_axe_6";
         else if (iHD >= 18) sSummon = "ow_sum_axe_5";
         else if (iHD >= 15) sSummon = "ow_sum_axe_4";
         else if (iHD >= 12) sSummon = "ow_sum_axe_3";
         else if (iHD >= 9)  sSummon = "ow_sum_axe_2";
         else if (iHD >= 6)  sSummon = "ow_sum_axe_1";
         
         if( GetCanSummonOrc(oPC, sSummon) )
         {
              oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());
              DelayCommand(1.0f, CleanHenchman(oCreature));
              AddHenchman(OBJECT_SELF, oCreature);
              ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
         }
         else
         {
              string sMes = "You cannot gather more than " + IntToString(iNumSummon) + " of this type of orc.";
              SendMessageToPC(oPC, sMes);
              
              if(GetHasFeat(FEAT_GATHER_HORDE_II, oPC) )
                   IncrementRemainingFeatUses(oPC, FEAT_GATHER_HORDE_II);
              else
                   IncrementRemainingFeatUses(oPC, FEAT_GATHER_HORDE_I);  
         }
    //}
    SetMaxHenchmen(iMaxHenchmen);
}