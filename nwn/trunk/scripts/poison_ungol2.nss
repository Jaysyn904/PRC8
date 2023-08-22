//::///////////////////////////////////////////////
//:: Ungol Dust On Hit
//:: poison_ungol2
//:://////////////////////////////////////////////
/** @file
    1 point permanent Charisma damage and
    1d6 points of temporary Charisma damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: December 24, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_abil_damage"

void main()
{
    object oTarget = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

    ApplyAbilityDamage(oTarget, ABILITY_CHARISMA, 1, DURATION_TYPE_PERMANENT, TRUE);
    ApplyAbilityDamage(oTarget, ABILITY_CHARISMA, d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}