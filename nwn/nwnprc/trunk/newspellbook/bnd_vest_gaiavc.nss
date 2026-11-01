/*
Earth's Voice for Gaia (Toggleable 30-ft Aura)
Projects a persistent 30-foot aura in which any living non-friendly creature that hears your voice
must succeed on a Will save or have its attitude changed to Friendly (Charmed) for 1 round per Effective Binder Level.
Stays active indefinitely unless toggled off (5-round cooldown after suppressing).
*/
#include "bnd_inc_bndfunc"

int HasGaiaVoiceAura(object oBinder)
{
    if (GetLocalInt(oBinder, "GaiaVoiceAuraActive"))
        return TRUE;
    if (GetHasSpellEffect(VESTIGE_GAIA_VOICE_SPELL, oBinder))
        return TRUE;
    effect eCheck = GetFirstEffect(oBinder);
    while (GetIsEffectValid(eCheck))
    {
        if (GetEffectTag(eCheck) == "GaiaVoiceAura")
            return TRUE;
        eCheck = GetNextEffect(oBinder);
    }
    return FALSE;
}

void RemoveGaiaVoiceAura(object oBinder)
{
    DeleteLocalInt(oBinder, "GaiaVoiceAuraActive");
    effect eCheck = GetFirstEffect(oBinder);
    while (GetIsEffectValid(eCheck))
    {
        if (GetEffectTag(eCheck) == "GaiaVoiceAura" || GetEffectSpellId(eCheck) == VESTIGE_GAIA_VOICE_SPELL)
            RemoveEffect(oBinder, eCheck);
        eCheck = GetNextEffect(oBinder);
    }
}

void ApplyGaiaVoiceToTarget(object oBinder, object oTarget)
{
    if (!GetIsObjectValid(oBinder) || !GetIsObjectValid(oTarget) || oTarget == oBinder || GetIsFriend(oTarget, oBinder))
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

void main()
{
    object oBinder = OBJECT_SELF;

    if (HasGaiaVoiceAura(oBinder))
    {
        RemoveGaiaVoiceAura(oBinder);
        BindAbilCooldown(oBinder, VESTIGE_GAIA_VOICE_SPELL, VESTIGE_GAIA);
        FloatingTextStringOnCreature("Gaia's Earth's Voice aura suppressed (5-round cooldown before reactivation).", oBinder, FALSE);
        return;
    }

    if (GetLocalInt(oBinder, "Bind" + IntToString(VESTIGE_GAIA_VOICE_SPELL)))
    {
        if (!BindAbilCooldown(oBinder, VESTIGE_GAIA_VOICE_SPELL, VESTIGE_GAIA))
            return;
    }

    effect eVoiceAura = EffectLinkEffects(
        EffectAreaOfEffect(136, "bnd_vest_gaiavce", "bnd_vest_gaiavch", "bnd_vest_gaiavcx"),
        EffectVisualEffect(VFX_DUR_AURA_PULSE_GREEN_YELLOW)
    );
    eVoiceAura = TagEffect(SupernaturalEffect(eVoiceAura), "GaiaVoiceAura");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVoiceAura, oBinder);
    SetLocalInt(oBinder, "GaiaVoiceAuraActive", TRUE);
    FloatingTextStringOnCreature("Gaia's Earth's Voice aura activated (stays active until toggled off).", oBinder, FALSE);

    location lLoc = GetLocation(oBinder);
    float fRadius = FeetToMeters(30.0);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        ApplyGaiaVoiceToTarget(oBinder, oTarget);
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }
}
