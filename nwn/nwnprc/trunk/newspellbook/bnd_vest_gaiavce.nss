/*
OnEnter script for Gaia's Earth's Voice Aura (bnd_vest_gaiavce)
*/
#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = GetAreaOfEffectCreator();
    if (!GetIsObjectValid(oBinder) ||
        !GetHasSpellEffect(VESTIGE_GAIA, oBinder) ||
        !GetLocalInt(oBinder, "GaiaVoiceAuraActive"))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    object oTarget = GetEnteringObject();
    if (!GetIsObjectValid(oTarget) || oTarget == oBinder || GetIsFriend(oTarget, oBinder))
        return;

    if (!PRCGetIsAliveCreature(oTarget) || GetPlotFlag(oTarget))
        return;

    if (PRCGetHasEffect(EFFECT_TYPE_DEAF, oTarget))
        return;

    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff))
    {
        if (GetEffectType(eEff) == EFFECT_TYPE_CHARMED || GetEffectTag(eEff) == "GaiaVoiceCharm")
            return;
        eEff = GetNextEffect(oTarget);
    }

    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_GAIA);
    int nDC = GetBinderDC(oBinder, VESTIGE_GAIA, oTarget);

    SignalEvent(oTarget, EventSpellCastAt(oBinder, VESTIGE_GAIA_VOICE_SPELL, FALSE));
    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oBinder))
    {
        effect eCharm = PRCGetScaledEffect(EffectCharmed(), oTarget);
        eCharm = TagEffect(SupernaturalEffect(eCharm), "GaiaVoiceCharm");
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharm, oTarget, RoundsToSeconds(nBinderLevel));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), oTarget);
    }
}
