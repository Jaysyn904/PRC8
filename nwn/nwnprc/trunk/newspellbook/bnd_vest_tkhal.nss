/*
Tkhaluuljin, the Cephalopocalypse (Epic Vestige, Level 9, DC 49)
*/
#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject();
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_TKHALUULJIN);
    object oSkin = GetPCSkin(oBinder);

    effect eLink = EffectLinkEffects(EffectVisualEffect(PSI_DUR_SHADOW_BODY), EffectPact(oBinder));

    // Aura of Madness (Persistent toggleable 10-ft aura, active on bind and toggleable via radial feat)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_TKHALUULJIN_AURA_OF_MADNESS))
    {
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_TKHAL_MADNESS), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        effect eAura = EffectLinkEffects(
            EffectAreaOfEffect(VFX_PER_SNARE, "bnd_vest_tkhalen", "bnd_vest_tkhalhb", ""),
            EffectVisualEffect(VFX_DUR_AURA_PULSE_PURPLE_BLACK)
        );
        eAura = TagEffect(SupernaturalEffect(eAura), "TkhalMadnessAura");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAura, oBinder);
        SetLocalInt(oBinder, "TkhalMadnessAuraActive", TRUE);
    }

    // Flight of the Alien (150-ft fly speed -> +99% NWN cap + prc_speed 150 ft, Freedom of Movement, +20 Jump, Flyby Attack/Spring Attack, PRCIsFlying)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_TKHALUULJIN_FLIGHT_OF_THE_ALIEN))
    {
        eLink = EffectLinkEffects(eLink, EffectMovementSpeedIncrease(99));
        eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
        eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
        eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_JUMP, 20));
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_DODGE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_MOBILITY), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_SPRINGATTACK), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        SetLocalInt(oBinder, "TkhalFlight", TRUE);
        SetLocalInt(oBinder, "bFlying", TRUE);
        DelayCommand(0.2f, ExecuteScript("prc_speed", oBinder));
    }

    // Mind Blast (120-ft cone stun for 12 rounds)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_TKHALUULJIN_MIND_BLAST))
    {
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_TKHAL_MINDBLAST), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }

    // Sphere of Annihilation
    if (!GetIsVestigeExploited(oBinder, VESTIGE_TKHALUULJIN_SPHERE_ANNIHILATION))
    {
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_TKHAL_SPHERE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(SetEffectSpellId(SupernaturalEffect(eLink), VESTIGE_TKHALUULJIN), "VestigeMain_Tkhal"), oBinder, HoursToSeconds(24));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_IMPLOSION), oBinder);
}
