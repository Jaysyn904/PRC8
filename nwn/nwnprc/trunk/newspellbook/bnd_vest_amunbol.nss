/*
Burst of Life for Amun-her Khepeshef
30-ft burst: all living allies in the area (including the Binder) receive the effects of a Heal spell
(restoring up to 250 HP) and a Greater Restoration spell; hostile/non-friendly undead in the area take
positive energy damage from the Heal effect (10 HP/level, max 250, Will save for half, leaving at least 1d4 HP).
5-round cooldown.
*/
#include "bnd_inc_bndfunc"
#include "prc_sp_func"
#include "spinc_remeffct"

void ScrubBurstOfLifeNegativeEffects(object oBinder, object oTarget)
{
    SpellRemovalCheck(oBinder, oTarget);
    SetLocalInt(oTarget, "PC_Damage", 0);
    effect eCheck = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eCheck))
    {
        int nType = GetEffectType(eCheck);
        string sTag = GetEffectTag(eCheck);
        if (sTag == "PRCFatigue" || sTag == "PRCExhausted" || sTag == "PRC_Fatigue" || sTag == "PRC_Exhausted" || sTag == "Fatigue" || sTag == "Exhausted" ||
            (CheckRemoveEffects(SPELL_GREATER_RESTORATION, nType) && GetEffectSubType(eCheck) != SUBTYPE_EXTRAORDINARY && !GetShouldNotBeRemoved(eCheck)))
        {
            RemoveEffect(oTarget, eCheck);
        }
        eCheck = GetNextEffect(oTarget);
    }
}

void main()
{
    object oBinder = OBJECT_SELF;
    if (!BindAbilCooldown(oBinder, PRCGetSpellId(), VESTIGE_AMUN_HER)) return;

    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_AMUN_HER);
    location lLoc = GetLocation(oBinder);
    float fRadius = FeetToMeters(30.0);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), lLoc);

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        int nRace = MyPRCGetRacialType(oTarget);
        int bWarforged = GetIsWarforged(oTarget);
        int bTombTainted = GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD;
        int bAcererakHeal = GetLocalInt(oTarget, "AcererakHealing");
        int bUndeadLike = (nRace == RACIAL_TYPE_UNDEAD || bTombTainted) && !bAcererakHeal;

        if (bUndeadLike && oTarget != oBinder && !GetIsFriend(oTarget, oBinder))
        {
            int nDC = GetBinderDC(oBinder, VESTIGE_AMUN_HER, oTarget);
            int nDmg = PRCMin(250, 10 * nBinderLevel);
            SignalEvent(oTarget, EventSpellCastAt(oBinder, VESTIGE_AMUN_BURST_OF_LIFE_SPELL));
            if (PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_POSITIVE, oBinder))
            {
                nDmg /= 2;
                if (GetHasMettle(oTarget, SAVING_THROW_WILL))
                    nDmg = 0;
            }
            int nFloor = d4();
            int nCurHP = GetCurrentHitPoints(oTarget);
            if (nDmg > nCurHP - nFloor)
                nDmg = PRCMax(0, nCurHP - nFloor);
            if (nDmg > 0)
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDmg, DAMAGE_TYPE_POSITIVE), oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), oTarget);
        }
        else if ((PRCGetIsAliveCreature(oTarget) || bWarforged || bAcererakHeal) && (GetIsFriend(oTarget, oBinder) || oTarget == oBinder))
        {
            SignalEvent(oTarget, EventSpellCastAt(oBinder, VESTIGE_AMUN_BURST_OF_LIFE_SPELL, FALSE));
            ScrubBurstOfLifeNegativeEffects(oBinder, oTarget);
            int nHealAmt = PRCMin(250, 10 * nBinderLevel);
            if (bWarforged) nHealAmt /= 2;
            if (!bUndeadLike || oTarget == oBinder)
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(nHealAmt, oTarget), oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION_GREATER), oTarget);
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }
}
