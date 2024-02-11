//::///////////////////////////////////////////////
//:: Blink
//:: sp_blink.nss
//:://////////////////////////////////////////////
/*
Transmutation
Level: Brd 3, Sor/Wiz 3
Components: V, S
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 round/level (D)


    1. Apply blur effect.
    2. Apply miss chance of 20% (We miss 20% of the time)
    3. Apply a 20% spell failure.
    4. Apply a concealment of 50%
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: December 31, 2019
//:://////////////////////////////////////////////

#include "prc_sp_func"

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    float fDuration = RoundsToSeconds(nCasterLevel);
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);

    // Declare effects
    effect eDur = EffectVisualEffect(VFX_DUR_BLUR);
    effect eMiss = EffectMissChance(20);
    effect eFail = EffectSpellFailure(20);
    effect eConceal = EffectConcealment(50);
    effect eAttack = EffectAttackIncrease(2);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eMiss);
    eLink = EffectLinkEffects(eFail, eLink);
    eLink = EffectLinkEffects(eConceal, eLink);
    eLink = EffectLinkEffects(eLink, eAttack);

    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;

    // Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BLINK, FALSE));

    // Remove previous castings
    PRCRemoveEffectsFromSpell(oTarget, SPELL_BLINK);

    // Apply the bonuses and the VFX impact
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, SPELL_BLINK, nCasterLevel);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    PRCSetSchool();
}