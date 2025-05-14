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
    int nSpell = GetSpellId();
    int nBonus = 0;

    switch (nSpell)
    {
        case SPELL_PA_FLETCH_1:
            nXPCost = 30;
            nFeatID = FEAT_PA_FLETCH_1;
            sArrow = "NW_WAMMAR009"; // +1
            nBonus = 1;
            break;
        case SPELL_PA_FLETCH_2:
            nXPCost = 80;
            nFeatID = FEAT_PA_FLETCH_2;
            sArrow = "NW_WAMMAR010"; // +2
            nBonus = 2;
            break;
        case SPELL_PA_FLETCH_3:
            nXPCost = 300;
            nFeatID = FEAT_PA_FLETCH_3;
            sArrow = "NW_WAMMAR011"; // +3
            nBonus = 3;
            break;
        case SPELL_PA_FLETCH_4:
            nXPCost = 675;
            nFeatID = FEAT_PA_FLETCH_4;
            sArrow = "X2_WAMMAR012"; // +4
            nBonus = 4;
            break;
        case SPELL_PA_FLETCH_5:
        default:
        {
			int nLevel = GetLevelByClass(CLASS_TYPE_PEERLESS, OBJECT_SELF);
            nBonus = nLevel / 2;
            if (nBonus < 5) nBonus = 5;
            if (nBonus > 15) nBonus = 15;

            sArrow = "X2_WAMMAR013"; // base +5 arrow

			switch (nBonus)
			{
				case 6: nXPCost = 1875; break;
				case 7: nXPCost = 2700; break;
				case 8: nXPCost = 3675; break;
				case 9: nXPCost = 4800; break;
				case 10: nXPCost = 6075; break;
				case 11: nXPCost = 7500; break;
				case 12: nXPCost = 9075; break;
				case 13: nXPCost = 10800; break;
				case 14: nXPCost = 12675; break;
				case 15: nXPCost = 14700; break;
				default: nXPCost = 1200; break; // +5
			}
			
            nFeatID = FEAT_PA_FLETCH_5;
        }
    }

    int nGoldCost = nXPCost * 10;

    if (!GetHasXPToSpend(OBJECT_SELF, nXPCost))
    {
        FloatingTextStrRefOnCreature(3785, OBJECT_SELF);
        IncrementRemainingFeatUses(OBJECT_SELF, nFeatID);
        return;
    }

    if (!GetHasGPToSpend(OBJECT_SELF, nGoldCost))
    {
        FloatingTextStrRefOnCreature(3785, OBJECT_SELF);
        IncrementRemainingFeatUses(OBJECT_SELF, nFeatID);
        return;
    }

    object oArrow = CreateItemOnObject(sArrow, OBJECT_SELF, 99);
    SetIdentified(oArrow, TRUE);
    
	// Add extra enhancement bonus if higher than original
    if (nBonus > 5)
    {
        itemproperty ipEnhance = ItemPropertyAttackBonus(nBonus);
        AddItemProperty(DURATION_TYPE_PERMANENT, ipEnhance, oArrow);
    }

    // Rename and retag the arrows
    string sTag = "PA_ARROW_PLUS_" + IntToString(nBonus);
    string sName = "+" + IntToString(nBonus) + " Peerless Arrows";

    SetTag(oArrow, sTag);
    SetName(oArrow, sName);
	SetStolenFlag(oArrow, TRUE);

    SpendXP(OBJECT_SELF, nXPCost);
    SpendGP(OBJECT_SELF, nGoldCost);
}


/* void main()
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
} */