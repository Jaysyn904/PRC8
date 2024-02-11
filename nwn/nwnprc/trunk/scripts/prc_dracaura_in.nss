//::///////////////////////////////////////////////
//:: Draconic Aura Enter
//:: prc_dracaura_in.nss
//::///////////////////////////////////////////////
/*
    Handles PCs entering the Aura AoE for all
    draconic auras.
*/
//:://////////////////////////////////////////////
//:: Created By: xwarren
//:: Created On: Apr 2, 2011
//:://////////////////////////////////////////////

#include "moi_inc_moifunc"

void DraconicAuraVigor(object oTarget, int nBonus);

void DraconicAuraVigor(object oTarget, int nBonus)
{
	if (GetHasSpellEffect(SPELL_DRACONIC_AURA_VIGOR, oTarget))
	{
    	int nCurHP = GetCurrentHitPoints(oTarget);
    	int nMaxHP = GetMaxHitPoints(oTarget);
    	
    	// Is the HP total lower than half?
    	if ((nMaxHP/2) > nCurHP)
    	{
    	    if (!GetIsResting(oTarget)) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nBonus), oTarget);
    	}
    	DelayCommand(6.0, DraconicAuraVigor(oTarget, nBonus));
	}
}

void main()
{
    object oAura = OBJECT_SELF;
    object oTarget = GetEnteringObject();
    object oShaman = GetAreaOfEffectCreator();

    // Only apply to allies
    if(!GetIsFriend(oTarget, oShaman))
        return;

    int nAuraID     = GetLocalInt(oAura, "SpellID");
    int nAuraBonus  = GetLocalInt(oAura, "AuraBonus");
    int nDamageType = GetLocalInt(oAura, "DamageType");

    effect eBonus = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis   = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

    switch(nAuraID)
    {
        case SPELL_DRACONIC_AURA_TOUGHNESS:
            eBonus = EffectLinkEffects(eBonus, EffectDamageReduction(nAuraBonus, DAMAGE_POWER_PLUS_TWENTY));
            eVis   = EffectVisualEffect(VFX_IMP_POLYMORPH);
            break;
        case SPELL_DRACONIC_AURA_VIGOR:
            DraconicAuraVigor(oTarget, nAuraBonus);
            eVis   = EffectVisualEffect(VFX_IMP_HEALING_M);
            break;
        case SPELL_DRACONIC_AURA_PRESENCE:
            eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_PERSUADE, nAuraBonus));
            eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_BLUFF, nAuraBonus));
            eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_INTIMIDATE, nAuraBonus));
            eVis   = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            break;
        case SPELL_DRACONIC_AURA_SENSES:
            eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_LISTEN, nAuraBonus));
            eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_SPOT, nAuraBonus));
            eVis   = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            break;
        case SPELL_DRACONIC_AURA_ENERGY_SHIELD:
            eBonus = EffectLinkEffects(eBonus, EffectDamageShield(2 * nAuraBonus, 0, nDamageType));
            eBonus = EffectLinkEffects(eBonus, EffectVisualEffect(VFX_DUR_ENTROPIC_SHIELD));
            break;
        case SPELL_DRACONIC_AURA_RESISTANCE:
            eBonus = EffectLinkEffects(eBonus, EffectDamageResistance(nDamageType, 5 * nAuraBonus));
            eVis   = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
            break;
        case SPELL_DRACONIC_AURA_POWER:
            eBonus = EffectLinkEffects(eBonus, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nAuraBonus), DAMAGE_TYPE_MAGICAL));
            eVis   = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
            break;
        case SPELL_DRACONIC_AURA_INSIGHT:
            eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_LORE, nAuraBonus));
            eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_SPELLCRAFT, nAuraBonus));
            eVis   = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            break;
        case SPELL_DRACONIC_AURA_RESOLVE:
            eBonus = EffectLinkEffects(eBonus, EffectSavingThrowIncrease(SAVING_THROW_WILL, nAuraBonus, SAVING_THROW_TYPE_FEAR));
            eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_CONCENTRATION, nAuraBonus));
            eVis   = EffectVisualEffect(VFX_IMP_HOLY_AID);
            break;
        case SPELL_DRACONIC_AURA_STAMINA:
            eBonus = EffectLinkEffects(eBonus, EffectSavingThrowIncrease(SAVING_THROW_FORT, nAuraBonus));
            eVis   = EffectVisualEffect(VFX_IMP_HOLY_AID);   
            break;
        case SPELL_DRACONIC_AURA_SWIFTNESS:
            eBonus = EffectLinkEffects(eBonus, EffectMovementSpeedIncrease(nAuraBonus * 5));
            eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_JUMP, nAuraBonus));
            eVis   = EffectVisualEffect(VFX_IMP_HASTE);
            break;
        case SPELL_DRACONIC_AURA_MAGICPOWER:
            if(nAuraBonus > GetLocalInt(oTarget, "MagicPowerAura"))
                SetLocalInt(oTarget, "MagicPowerAura", nAuraBonus);
            eVis   = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
            break;
        case SPELL_DRACONIC_AURA_ENERGY:
            if(nDamageType == DAMAGE_TYPE_ACID && nAuraBonus > GetLocalInt(oTarget, "AcidEnergyAura"))
                SetLocalInt(oTarget, "AcidEnergyAura", nAuraBonus);
            else if(nDamageType == DAMAGE_TYPE_COLD && nAuraBonus > GetLocalInt(oTarget, "ColdEnergyAura"))
                SetLocalInt(oTarget, "ColdEnergyAura", nAuraBonus);
            else if(nDamageType == DAMAGE_TYPE_ELECTRICAL && nAuraBonus > GetLocalInt(oTarget, "ElecEnergyAura"))
                SetLocalInt(oTarget, "ElecEnergyAura", nAuraBonus);
            else if(nDamageType == DAMAGE_TYPE_FIRE && nAuraBonus > GetLocalInt(oTarget, "FireEnergyAura"))
                SetLocalInt(oTarget, "FireEnergyAura", nAuraBonus);
            eVis   = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
            break;
    }

    eBonus = ExtraordinaryEffect(eBonus);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}