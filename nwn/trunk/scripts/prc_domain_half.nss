//::///////////////////////////////////////////////
//:: Halfling Domain Power
//:: prc_domain_half.nss
//::///////////////////////////////////////////////
/*
    Grants Charisma to Jump, Move Silently, and Hide for 10 Minutes
    Free Action to activate.
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
    if (!DecrementDomainUses(PRC_DOMAIN_HALFLING, oTarget)) return;

    int nBonus = GetAbilityModifier(ABILITY_CHARISMA, oTarget);
    effect eJump = EffectSkillIncrease(SKILL_JUMP, nBonus);
    effect eHide = EffectSkillIncrease(SKILL_HIDE, nBonus);
    effect eMS = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus);

    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eJump, eDur);
           eLink = EffectLinkEffects(eLink, eHide);
           eLink = EffectLinkEffects(eLink, eMS);
           eLink = SupernaturalEffect(eLink);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(10));
}

