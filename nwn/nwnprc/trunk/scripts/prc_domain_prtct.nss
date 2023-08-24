//::///////////////////////////////////////////////
//:: Protection Domain Power
//:: prc_domain_prtct.nss
//::///////////////////////////////////////////////
/*
    Grants Char level to saves for 1 round
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
    if (!DecrementDomainUses(PRC_DOMAIN_PROTECTION, oPC)) return;

    object oTarget = PRCGetSpellTargetObject();
    effect eDur = EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE);
    effect eCha = EffectSavingThrowIncrease(SAVING_THROW_ALL, GetHitDice(oPC));
    effect eLink = EffectLinkEffects(eCha, eDur);
           eLink = SupernaturalEffect(eLink);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
}

