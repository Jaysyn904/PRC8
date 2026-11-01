/*
Firstborn Guardian (Allies) for Amun-her Khepeshef
Extends Firstborn Guardian immunities, Ghost Touch / Blind-Fight, and +4 Deflection AC vs. Undead
to up to 1 ally per 5 Effective Binder Levels within 30 feet for 1 round/level. 5-round cooldown.
*/
#include "bnd_inc_bndfunc"

void ScrubFatigueAndExhaustionOnAlly(object oAlly)
{
    effect eChk = GetFirstEffect(oAlly);
    while (GetIsEffectValid(eChk))
    {
        string sTag = GetEffectTag(eChk);
        if (sTag == "PRCFatigue" || sTag == "PRCExhausted" || sTag == "PRC_Fatigue" || sTag == "PRC_Exhausted" || sTag == "Fatigue" || sTag == "Exhausted")
            RemoveEffect(oAlly, eChk);
        eChk = GetNextEffect(oAlly);
    }
}

void main()
{
    object oBinder = OBJECT_SELF;
    if (!BindAbilCooldown(oBinder, PRCGetSpellId(), VESTIGE_AMUN_HER)) return;

    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_AMUN_HER);
    int nMaxAllies = PRCMax(1, nBinderLevel / 5);
    int nCount = 0;
    float fDur = RoundsToSeconds(nBinderLevel);
    location lLoc = GetLocation(oBinder);
    float fRadius = FeetToMeters(30.0);

    effect eBuff = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
    eBuff = EffectLinkEffects(eBuff, EffectImmunity(IMMUNITY_TYPE_DEATH));
    eBuff = EffectLinkEffects(eBuff, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
    eBuff = EffectLinkEffects(eBuff, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
    eBuff = EffectLinkEffects(eBuff, VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_FEAR), RACIAL_TYPE_UNDEAD));
    eBuff = EffectLinkEffects(eBuff, VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_PARALYSIS), RACIAL_TYPE_UNDEAD));
    eBuff = EffectLinkEffects(eBuff, VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_POISON), RACIAL_TYPE_UNDEAD));
    eBuff = EffectLinkEffects(eBuff, VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_DISEASE), RACIAL_TYPE_UNDEAD));
    eBuff = EffectLinkEffects(eBuff, VersusRacialTypeEffect(EffectACIncrease(4, AC_DEFLECTION_BONUS), RACIAL_TYPE_UNDEAD));
    eBuff = EffectLinkEffects(eBuff, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100));
    eBuff = TagEffect(SupernaturalEffect(eBuff), "AmunFirstbornAllyBuff");

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget) && nCount < nMaxAllies)
    {
        if (oTarget != oBinder && GetIsFriend(oTarget, oBinder))
        {
            ScrubFatigueAndExhaustionOnAlly(oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDur);
            object oAllySkin = GetPCSkin(oTarget);
            if (GetIsObjectValid(oAllySkin))
                IPSafeAddItemProperty(oAllySkin, ItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oTarget);
            nCount++;
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }
}
