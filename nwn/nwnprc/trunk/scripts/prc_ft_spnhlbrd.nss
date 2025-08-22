//::///////////////////////////////////////////////
//:: Spinning Halberd
//:: prc_ft_spnhlbrd.nss
//::///////////////////////////////////////////////
/*
    Type of Feat: General
	Prerequisite: Two-Weapon Fighting, Weapon Focus (halberd)
	Benefit: When you make a full attack with your halberd, you gain 
	a +1 dodge bonus to your Armor Class as well as an additional 
	attack with the weapon at a -5 penalty. This attack deals points 
	of bludgeoning damage equal to 1d6 + 1/2 your Strength modifier.
	Use: Selected
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
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDummy;
    
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oLeft  = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    
    if (GetBaseItemType(oRight) == BASE_ITEM_HALBERD)
    {
        PerformAttackRound(oTarget, oPC, eDummy);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(1, AC_DODGE_BONUS)), oPC, 6.0);
        
        int nAttack = GetAttackRoll(oTarget, oPC, oRight, 0, 0, -5);
        if (nAttack > 0)
        {
            int nDam = d6(nAttack) + (GetAbilityModifier(ABILITY_STRENGTH, oPC) * nAttack);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, ExtraordinaryEffect(EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING)), oTarget);
        }
    }
    else
    {
        FloatingTextStringOnCreature("You do not have the right weapon equipped for Spinning Halberd", oPC, FALSE);
        PerformAttackRound(oTarget, oPC, eDummy);
    }    
}
