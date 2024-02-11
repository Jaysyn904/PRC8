//::///////////////////////////////////////////////
//:: Despana School
//:: prc_ft_despana.nss
//::///////////////////////////////////////////////
/*
    If the attack hits, your summoned creatures gain 
    a +2 morale bonus on attack rolls and damage rolls 
    against that enemy until the start of your next turn.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 11.11.2018
//:://////////////////////////////////////////////

#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eDummy;
    
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    
    if (GetBaseItemType(oRight) == BASE_ITEM_LIGHTMACE)
    {
        PerformAttackRound(oTarget, oPC, eDummy);
        if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
        {
        	int i = 1;
		    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
		    int nRacial = GetRacialType(oTarget);
		    while(GetIsObjectValid(oSummon))
		    {
    			effect eLink = EffectLinkEffects(VersusRacialTypeEffect(EffectDamageIncrease(DAMAGE_BONUS_2), nRacial), VersusRacialTypeEffect(EffectAttackIncrease(2), nRacial));
 				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oSummon, 6.0);
		        i++;
		        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
		    }
        }  
    }
    else
    {
        FloatingTextStringOnCreature("You do not have the right weapon equipped for Despana School", oPC, FALSE);
        PerformAttackRound(oTarget, oPC, eDummy);
    }    
}
