//::///////////////////////////////////////////////
//:: Strength Domain Power
//:: prc_domain_str.nss
//::///////////////////////////////////////////////
/*
    Grants Char level to Strength for 1 round
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_domain"
#include "inc_addragebonus"

void main()
{
    object oTarget = OBJECT_SELF;

    // Used by the uses per day check code for bonus domains
    if(!DecrementDomainUses(PRC_DOMAIN_STRENGTH, oTarget)) return;

    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nStrBeforeBonuses = GetAbilityScore(oTarget, ABILITY_STRENGTH);
    int nConBeforeBonuses = GetAbilityScore(oTarget, ABILITY_CONSTITUTION);
    // Variables effected by MCoK levels
    int nDur = 1;
    int nBoost = GetDomainCasterLevel(oTarget);

    // Mighty Contender class abilities
    int nKord = GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oTarget);
    if(nKord)
    {
        int nFeatPower = 0;
        nBoost += nKord;
        // At 3rd level of MCoK, the duration increases
        if(nKord >= 3)
            nDur = d4() + 1;
        // At 7th level of MCoK, add 1.5 * combined cleric + MCoK levels to strength for the first round
        // At level 10 the boost is for the entire time so you don't need this to run
        if(nKord >= 7 && nKord < 10)
        {
            nFeatPower = FloatToInt(nBoost * 1.5);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_STRENGTH, nFeatPower), oTarget, 6.0);
        }
        if(nKord >= 10)
            nBoost = FloatToInt(nBoost * 1.5);
    }

    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nBoost);
    effect eLink = EffectLinkEffects(eStr, eDur);
           eLink = SupernaturalEffect(eLink);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur));

    DelayCommand(0.1, GiveExtraRageBonuses(nDur, nStrBeforeBonuses, nConBeforeBonuses, nBoost, 0, 0, DAMAGE_TYPE_BASE_WEAPON, oTarget));
}

