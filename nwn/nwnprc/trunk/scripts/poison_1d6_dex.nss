//:://////////////////////////////////////////////
//:: Poison: 1d6 Dexterity damage
//:: poison_1d6_dex
//:://////////////////////////////////////////////
/** @file
    This is one of the scripts that implement causing
    poison ability damage using the ApplyAbilityDamage()
    wrapper.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 01.08.2005
//:://////////////////////////////////////////////

#include "inc_abil_damage"

void main()
{
    object oTarget = OBJECT_SELF;
    int nDamage = d6(1);
    int nAbility = ABILITY_DEXTERITY;

    ApplyAbilityDamage(oTarget, nAbility, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
}
