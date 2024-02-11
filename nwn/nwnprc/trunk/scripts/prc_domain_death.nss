//::///////////////////////////////////////////////
//:: Death Domain Power
//:: prc_domain_death.nss
//::///////////////////////////////////////////////
/*
    Roll d6 per cleric level. If it is equal or greater
    than the targets current Hitpoints, it dies.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_domain"

void main()
{
    object oPC = OBJECT_SELF;

    // Used by the uses per day check code for bonus domains
    if (!DecrementDomainUses(PRC_DOMAIN_DEATH, oPC)) return;

    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
    effect eDeath = EffectDeath();
    effect eLink = EffectLinkEffects(eDeath, eVis);
    int nHP = GetCurrentHitPoints(oTarget);
    int nDices = GetDomainCasterLevel(oPC);
    int nRoll = d6(nDices);

    // If the roll is greater or equal and you hit on a melee touch attack
    if(nRoll >= nHP && TouchAttackMelee(oTarget) > 0) ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
}