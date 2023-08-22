//::///////////////////////////////////////////////
//:: Hatred Domain Power
//:: prc_domain_hate.nss
//::///////////////////////////////////////////////
/*
    Grants +2 Attack, Saving Throws and AC vs the targeted race.
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
    if (!DecrementDomainUses(PRC_DOMAIN_HATRED, oPC)) return;

    //Declare main variables.
    object oTarget = PRCGetSpellTargetObject();
    int nRace = MyPRCGetRacialType(oTarget);
    int nBonus = 2;

    effect eAttack = EffectAttackIncrease(nBonus);
    effect eAC = EffectACIncrease(nBonus);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
    effect eLink = EffectLinkEffects(eAttack, eAC);
           eLink = EffectLinkEffects(eLink, eSave);
           eLink = VersusRacialTypeEffect(eLink, nRace);
           eLink = SupernaturalEffect(eLink);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(1));
}
