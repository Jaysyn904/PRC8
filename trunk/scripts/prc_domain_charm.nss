//::///////////////////////////////////////////////
//:: Charm Domain Power
//:: prc_domain_charm.nss
//::///////////////////////////////////////////////
/*
    Grants +4 Charisma for 1 Minute
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_domain"

void main()
{
    object oTarget = OBJECT_SELF;

    // Used by the uses per day check code for bonus domains
    if (!DecrementDomainUses(PRC_DOMAIN_CHARM, oTarget)) return;

    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eCha = EffectAbilityIncrease(ABILITY_CHARISMA, 4);
    effect eLink = EffectLinkEffects(eCha, eDur);
           eLink = SupernaturalEffect(eLink);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 60.0);
}

