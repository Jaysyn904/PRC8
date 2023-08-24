//::///////////////////////////////////////////////
//:: Sufferfume On Hit
//:: poison_sufrfume
//:://////////////////////////////////////////////
/*
    1 point of damage to all abilities
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 10.01.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    object oTarget = OBJECT_SELF;

    //effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, 1);
    //effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 1);
    //effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, 1);
    //effect eInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 1);
    //effect eWis = EffectAbilityDecrease(ABILITY_WISDOM, 1);
    //effect eCha = EffectAbilityDecrease(ABILITY_CHARISMA, 1);

    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

    ApplyAbilityDamage(oTarget, ABILITY_STRENGTH,     1, DURATION_TYPE_PERMANENT, TRUE);
    ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY,    1, DURATION_TYPE_PERMANENT, TRUE);
    ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, 1, DURATION_TYPE_PERMANENT, TRUE);
    ApplyAbilityDamage(oTarget, ABILITY_INTELLIGENCE, 1, DURATION_TYPE_PERMANENT, TRUE);
    ApplyAbilityDamage(oTarget, ABILITY_WISDOM,       1, DURATION_TYPE_PERMANENT, TRUE);
    ApplyAbilityDamage(oTarget, ABILITY_CHARISMA,     1, DURATION_TYPE_PERMANENT, TRUE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}