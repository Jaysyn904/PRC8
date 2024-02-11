/*Once per day, a wildren who has taken at least 1 point of damage can choose to enter a brief state of rage-like fury at the beginning of her next turn. 
In this state, a wildren gains +4 to Strength and –2 to Armor Class. The fury lasts for 1 round, and a wildren cannot end her fury voluntarily. The 
effect of this ability stacks with similar effects (such as the barbarian’s rage class feature).*/

#include "inc_vfx_const"

void main()
{
    object oPC = OBJECT_SELF;
    
    // Need to be wounded
    if (GetCurrentHitPoints(oPC) == GetMaxHitPoints(oPC))
        IncrementRemainingFeatUses(oPC, 5386);
    else
    {
        effect eLink = EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, 4), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        eLink = EffectLinkEffects(EffectACDecrease(2), eLink);
        eLink = ExtraordinaryEffect(eLink);
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BONUS_STRENGTH), oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0);
    }    
}