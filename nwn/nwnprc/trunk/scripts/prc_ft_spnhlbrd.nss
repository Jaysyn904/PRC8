//::///////////////////////////////////////////////
//:: Spinning Halberd
//:: prc_ft_spnhlbrd.nss
//::///////////////////////////////////////////////
/*
    If you hit the same creature with both your 
    sword and your axe in the same round, you may 
    make a free trip attempt against that foe.
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
