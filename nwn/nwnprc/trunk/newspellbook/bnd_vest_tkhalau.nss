/*
Aura of Madness for Tkhaluuljin (Toggleable 10-ft Aura)
As a standard action, you can project or suppress a 10-foot aura that drives others mad.
All living creatures who pass within the aura must make a Will save or become confused for
1 round per 5 effective binder levels. A creature that makes its saving throw cannot be
affected by this binder's Aura of Madness for 24 hours.
If you suppress this ability, you must wait 5 rounds before you reactivate it.
*/
#include "bnd_inc_bndfunc"

int HasTkhalMadnessAura(object oBinder)
{
    if (GetLocalInt(oBinder, "TkhalMadnessAuraActive"))
        return TRUE;
    if (GetHasSpellEffect(VESTIGE_TKHAL_MADNESS_SPELL, oBinder))
        return TRUE;
    effect eCheck = GetFirstEffect(oBinder);
    while (GetIsEffectValid(eCheck))
    {
        if (GetEffectTag(eCheck) == "TkhalMadnessAura")
            return TRUE;
        eCheck = GetNextEffect(oBinder);
    }
    return FALSE;
}

void RemoveTkhalMadnessAura(object oBinder)
{
    DeleteLocalInt(oBinder, "TkhalMadnessAuraActive");
    effect eCheck = GetFirstEffect(oBinder);
    while (GetIsEffectValid(eCheck))
    {
        if (GetEffectTag(eCheck) == "TkhalMadnessAura" || GetEffectSpellId(eCheck) == VESTIGE_TKHAL_MADNESS_SPELL)
            RemoveEffect(oBinder, eCheck);
        eCheck = GetNextEffect(oBinder);
    }
}

void PulseTkhalMadnessOnTarget(object oBinder, object oTarget)
{
    if (!GetIsObjectValid(oBinder) || !GetIsObjectValid(oTarget) || oTarget == oBinder)
        return;
    if (!PRCGetIsAliveCreature(oTarget) || !spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oBinder))
        return;

    string sImmVar = "TkhalMadnessImmune_" + ObjectToString(oBinder);
    if (GetLocalInt(oTarget, sImmVar))
        return;

    // Skip if already confused
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

void main()
{
    object oBinder = OBJECT_SELF;

    // If Aura of Madness is currently active, toggle it OFF and start the 5-round cooldown
    if (HasTkhalMadnessAura(oBinder))
    {
        RemoveTkhalMadnessAura(oBinder);
        BindAbilCooldown(oBinder, VESTIGE_TKHAL_MADNESS_SPELL, VESTIGE_TKHALUULJIN);
        FloatingTextStringOnCreature("Tkhaluuljin's Aura of Madness suppressed (5-round cooldown before reactivation).", oBinder, FALSE);
        return;
    }

    // Check if the 5-round post-suppression cooldown is still running
    if (GetLocalInt(oBinder, "Bind" + IntToString(VESTIGE_TKHAL_MADNESS_SPELL)))
    {
        if (!BindAbilCooldown(oBinder, VESTIGE_TKHAL_MADNESS_SPELL, VESTIGE_TKHALUULJIN))
            return;
    }

    // Toggle Aura of Madness ON permanently (stays active until toggled off or unbound)
    effect eAura = EffectLinkEffects(
        EffectAreaOfEffect(VFX_PER_SNARE, "bnd_vest_tkhalen", "bnd_vest_tkhalhb", ""),
        EffectVisualEffect(VFX_DUR_AURA_PULSE_PURPLE_BLACK)
    );
    eAura = TagEffect(SupernaturalEffect(eAura), "TkhalMadnessAura");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAura, oBinder);
    SetLocalInt(oBinder, "TkhalMadnessAuraActive", TRUE);
    FloatingTextStringOnCreature("Tkhaluuljin's Aura of Madness activated (stays active until toggled off).", oBinder, FALSE);

    // Immediately affect any living creatures currently within 10 feet
    location lLoc = GetLocation(oBinder);
    float fRadius = FeetToMeters(10.0);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        PulseTkhalMadnessOnTarget(oBinder, oTarget);
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }
}
