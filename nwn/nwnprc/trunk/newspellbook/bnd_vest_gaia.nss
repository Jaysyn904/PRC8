/*
Gaia, Soul of the Land (Epic Vestige, Level 9, DC 39)
*/
#include "bnd_inc_bndfunc"

effect MakeEarthsFuryForRace(int nRace)
{
    effect eR = VersusRacialTypeEffect(EffectACIncrease(4, AC_DODGE_BONUS), nRace);
    eR = EffectLinkEffects(eR, VersusRacialTypeEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 4), nRace));
    return eR;
}

void main()
{
    object oBinder = PRCGetSpellTargetObject();
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_GAIA);
    object oSkin = GetPCSkin(oBinder);

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PROT_BARKSKIN), EffectPact(oBinder));

    // Earth's Fury (+4 AC and +4 Saving Throws vs. Aberrations, Constructs, Oozes, and Undead,
    // +4 DC in GetBinderDC(), and critical hit / sneak attack immunity bypass + automatic critical threat
    // confirmation in prc_inc_combat.nss and prc_inc_sneak.nss)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_GAIA_EARTHS_FURY))
    {
        eLink = EffectLinkEffects(eLink, MakeEarthsFuryForRace(RACIAL_TYPE_ABERRATION));
        eLink = EffectLinkEffects(eLink, MakeEarthsFuryForRace(RACIAL_TYPE_CONSTRUCT));
        eLink = EffectLinkEffects(eLink, MakeEarthsFuryForRace(RACIAL_TYPE_OOZE));
        eLink = EffectLinkEffects(eLink, MakeEarthsFuryForRace(RACIAL_TYPE_UNDEAD));
        object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oBinder);
        if (GetIsObjectValid(oWeapR) && (IPGetIsMeleeWeapon(oWeapR) || GetWeaponRanged(oWeapR)))
        {
            AddEventScript(oWeapR, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);
            IPSafeAddItemProperty(oWeapR, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oBinder);
        if (GetIsObjectValid(oWeapL) && (IPGetIsMeleeWeapon(oWeapL) || GetWeaponRanged(oWeapL)))
        {
            AddEventScript(oWeapL, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);
            IPSafeAddItemProperty(oWeapL, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }

    // Earthsense (Ultravision, True Seeing, Track, Scent / +10 Spot & Search)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_GAIA_EARTHSENSE))
    {
        eLink = EffectLinkEffects(eLink, EffectUltravision());
        eLink = EffectLinkEffects(eLink, EffectTrueSeeing());
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, 10));
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SEARCH, 10));
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_TRACK), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }

    // Earth's Voice (+10 Persuade & +10 Animal Empathy + persistent toggleable 30-ft Charm aura on non-friendly living creatures)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_GAIA_EARTHS_VOICE))
    {
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PERSUADE, 10));
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_ANIMAL_EMPATHY, 10));
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_GAIA_VOICE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        effect eVoiceAura = EffectLinkEffects(
            EffectAreaOfEffect(136, "bnd_vest_gaiavce", "bnd_vest_gaiavch", "bnd_vest_gaiavcx"),
            EffectVisualEffect(VFX_DUR_AURA_PULSE_GREEN_YELLOW)
        );
        eVoiceAura = TagEffect(SupernaturalEffect(eVoiceAura), "GaiaVoiceAura");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVoiceAura, oBinder);
        SetLocalInt(oBinder, "GaiaVoiceAuraActive", TRUE);
    }

    // Elemental Fortitude (4-element switchable radial, defaults to 100% Acid immunity on bind)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_GAIA_ELEMENTAL_FORTITUDE))
    {
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_GAIA_ELEMENTAL), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        effect eElem = TagEffect(SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 100)), "GaiaElemFort");
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eElem, oBinder, HoursToSeconds(24));
        SetLocalInt(oBinder, "GaiaElemFortType", DAMAGE_TYPE_ACID);
    }

    // Planetary Healing (Classic NWN Troll Regeneration = nBinderLevel / 4 overcome by fire/acid, shareable 1 point at a time & recallable;
    // controlled by PRC_GAIA_PLANETARY_HEALING_NERF: 0 = everyone with >=1 pt is a Troll, 1 = Option 1a single-creature Troll cap, 2 = fast healing only)
    if (!GetIsVestigeExploited(oBinder, VESTIGE_GAIA_PLANETARY_HEALING))
    {
        int nRegen = PRCMax(1, nBinderLevel / 4);
        SetLocalInt(oBinder, "GaiaPlanetaryRegen", nRegen);
        SetLocalInt(oBinder, "GaiaPlanetaryRegenMax", nRegen);
        SetLocalInt(oBinder, "GaiaPlanetaryRegenSelf", nRegen);
        DeleteLocalInt(oBinder, "GaiaRegenFireAcidLock");
        SetCreatureGaiaRegenEff(oBinder, nRegen, "GaiaPlanetaryRegenEff", HoursToSeconds(24));
        ReconcileGaiaTrollImmunity(oBinder);
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_VESTIGE_GAIA_PLANETARY), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(SetEffectSpellId(SupernaturalEffect(eLink), VESTIGE_GAIA), "VestigeMain_Gaia"), oBinder, HoursToSeconds(24));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oBinder);
}
