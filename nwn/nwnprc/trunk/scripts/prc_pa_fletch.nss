//::///////////////////////////////////////////////
//:: Peerless Archer Fletching
//:: PRC_PA_Fletch.nss
//:://////////////////////////////////////////////
/*
    Creates a stack of 99 Arrows.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Apr 4, 2004
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "prc_spell_const"
#include "inc_utility"

void main()
{
 int nXPCost, nFeatID;
 string sArrow;

 switch(GetSpellId())
 {
     case SPELL_PA_FLETCH_1:
         nXPCost = 30;
         nFeatID = FEAT_PA_FLETCH_1;
         sArrow = "NW_WAMMAR009";
         break;
     case SPELL_PA_FLETCH_2:
         nXPCost = 80;
         nFeatID = FEAT_PA_FLETCH_2;
         sArrow = "NW_WAMMAR010";
         break;
     case SPELL_PA_FLETCH_3:
         nXPCost = 300;
         nFeatID = FEAT_PA_FLETCH_3;
         sArrow = "NW_WAMMAR011";
         break;
     case SPELL_PA_FLETCH_4:
         nXPCost = 675;
         nFeatID = FEAT_PA_FLETCH_4;
         sArrow = "X2_WAMMAR012";
         break;
     case SPELL_PA_FLETCH_5:
         nXPCost = 1200;
         nFeatID = FEAT_PA_FLETCH_5;
         sArrow = "X2_WAMMAR013";
         break;
 }

 int nGoldCost = nXPCost * 10;

 if (!GetHasXPToSpend(OBJECT_SELF, nXPCost))
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough XP
       IncrementRemainingFeatUses(OBJECT_SELF, nFeatID);
       return ;
 }
 if (!GetHasGPToSpend(OBJECT_SELF, nGoldCost))
 {
       FloatingTextStrRefOnCreature(3785, OBJECT_SELF); // Item Creation Failed - Not enough GP
       IncrementRemainingFeatUses(OBJECT_SELF, nFeatID);
       return ;
 }


 SetIdentified(CreateItemOnObject(sArrow, OBJECT_SELF, 99), TRUE);
 SpendXP(OBJECT_SELF, nXPCost);
 SpendGP(OBJECT_SELF, nGoldCost);
}