#include "prc_alterations"
#include "prc_feat_const"

void main()
{
    object oTarget = PRCGetSpellTargetObject();

    if(GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)
    || GetIsImmune(oTarget, IMMUNITY_TYPE_SNEAK_ATTACK))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetAbilityModifier(ABILITY_INTELLIGENCE, OBJECT_SELF)), oTarget);
    }
}