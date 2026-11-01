/*
OnEnter script for Tkhaluuljin's Aura of Madness (bnd_vest_tkhalen)
*/
#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = GetAreaOfEffectCreator();
    if (!GetIsObjectValid(oBinder) ||
        !GetHasSpellEffect(VESTIGE_TKHALUULJIN, oBinder) ||
        !GetLocalInt(oBinder, "TkhalMadnessAuraActive"))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    object oTarget = GetEnteringObject();
    if (!GetIsObjectValid(oTarget) || oTarget == oBinder)
        return;

    if (!PRCGetIsAliveCreature(oTarget) || !spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oBinder))
        return;

    string sImmVar = "TkhalMadnessImmune_" + ObjectToString(oBinder);
    if (GetLocalInt(oTarget, sImmVar))
        return;

    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff))
    {
        if (GetEffectType(eEff) == EFFECT_TYPE_CONFUSED)
            return;
        eEff = GetNextEffect(oTarget);
    }

    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_TKHALUULJIN);
    int nDC = GetBinderDC(oBinder, VESTIGE_TKHALUULJIN, oTarget);
    int nRounds = PRCMax(1, nBinderLevel / 5);

    SignalEvent(oTarget, EventSpellCastAt(oBinder, VESTIGE_TKHAL_MADNESS_SPELL));
    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oBinder))
    {
        effect eRawConf = PRCEffectConfused(oTarget);
        if (GetIsEffectValid(eRawConf) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oBinder) &&
            !GetIsImmune(oTarget, IMMUNITY_TYPE_CONFUSED, oBinder))
        {
            effect eConf = EffectLinkEffects(eRawConf, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eConf), oTarget, RoundsToSeconds(nRounds));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CONFUSION_S), oTarget);
        }
    }
    else
    {
        SetLocalInt(oTarget, sImmVar, TRUE);
        AssignCommand(oTarget, DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, sImmVar)));
    }
}
