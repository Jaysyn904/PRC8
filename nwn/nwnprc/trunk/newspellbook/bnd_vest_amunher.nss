/*
Amun-her Khepeshef, the Desecrated Scion (Epic Vestige, Level 9, DC 47)
*/
#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject();
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_AMUN_HER);
    object oSkin = GetPCSkin(oBinder);

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_GLOW_LIGHT_YELLOW), EffectPact(oBinder));

    // Burst of Life (Active Radial)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_AMUN_HER_BURST_OF_LIFE))
    {
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_AMUN_BURST_LIFE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }

    // Delay Death (Reactive 1 round/level per day death-prevention pool: stays dormant until a hit drops you to 1 HP)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_AMUN_HER_DELAY_DEATH))
    {
        int nUsed = GetLocalInt(oBinder, "AmunDelayDeathRoundsUsed");
        int nRem = PRCMax(0, nBinderLevel - nUsed);
        SetLocalInt(oBinder, "AmunDelayDeathMaxRounds", nBinderLevel);
        SetLocalInt(oBinder, "AmunDelayDeathRounds", nRem);
        DeleteLocalInt(oBinder, "AmunDelayDeathActive");
        AddEventScript(oBinder, EVENT_VIRTUAL_ONDAMAGED, "bnd_events", TRUE, FALSE);
        AddEventScript(oBinder, EVENT_NPC_ONDAMAGED, "bnd_events", TRUE, FALSE);
        if (nRem > 0)
            SetImmortal(oBinder, TRUE);
    }

    // Firstborn Guardian (Constant death/energy drain/ability drain/negative energy/fatigue/exhaustion immunities,
    // undead-inflicted fear/disease/paralysis/poison immunities, +4 deflection AC vs. undead, Ghost Touch / Blind-Fight,
    // plus active swift-action extension to 1 ally per 5 EBL within 30 feet for 1 round/level)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_AMUN_HER_FIRSTBORN_GUARDIAN))
    {
        eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEATH));
        eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
        eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
        eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_FEAR), RACIAL_TYPE_UNDEAD));
        eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_PARALYSIS), RACIAL_TYPE_UNDEAD));
        eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_POISON), RACIAL_TYPE_UNDEAD));
        eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectImmunity(IMMUNITY_TYPE_DISEASE), RACIAL_TYPE_UNDEAD));
        eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectACIncrease(4, AC_DEFLECTION_BONUS), RACIAL_TYPE_UNDEAD));
        eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100));
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_AMUN_FIRSTBORN), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }

    // Scion of War (Persistent 60-ft aura granting +2 * Cha mod to combat maneuvers for self and allies within 60 feet)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_AMUN_HER_SCION_OF_WAR))
    {
        int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, oBinder);
        if (nChaMod > 0)
            SetLocalInt(oBinder, "AmunScionOfWarBonus", 2 * nChaMod);
        SetLocalInt(oBinder, "AmunScionAuraActive", TRUE);
        effect eScionAura = TagEffect(
            SupernaturalEffect(EffectAreaOfEffect(136, "bnd_vest_amunsoe", "bnd_vest_amunsoh", "bnd_vest_amunsox")),
            "AmunScionOfWarAura"
        );
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eScionAura, oBinder);
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(SupernaturalEffect(eLink), VESTIGE_AMUN_HER), oBinder, HoursToSeconds(24));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), oBinder);
}
