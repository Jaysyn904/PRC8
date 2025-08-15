//:://////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//:://////////////////////////////////////////////
//::  
/*
	Invulnerability to Elements
	Abjuration
	Level: Druid 9
	Components: V, S, DF
	Casting Time: 1 action
	Range: Touch
	Target: Creature touched
	Duration: 10 minutes/level
	Saving Throw: None
	Spell Resistance: Yes

	As protection from all elements, but the target creature
	becomes immune to damage from acid, cold, electricity,
	fire, and sonic damage while the spell is in effect.
	
*/
//::  
//::////////////////////////////////////////////// 
//::	Script:     sp_inv_elements
//::	Author:     Jaysyn
//::	Created:    2025-08-11 22:28:40
//:://////////////////////////////////////////////
#include "prc_sp_func"

// Implements the spell impact
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nSpellID = PRCGetSpellId();
    int nMetaMagic = PRCGetMetaMagicFeat();

    float fDuration = MinutesToSeconds(10 * nCasterLevel); // 10 min/level

    // Extend Spell metamagic check
    if (nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2.0;

    // Fire spell cast at event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));

    // Remove old versions
    PRCRemoveEffectsFromSpell(oTarget, nSpellID);

    // Visual Effects
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
    effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Immunities
	effect eImmAcid  = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 100);
	effect eImmCold  = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100);
	effect eImmElec  = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100);
	effect eImmFire  = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100);
	effect eImmSonic = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100);

    // Tag everything for possible later use
    eImmAcid  = TagEffect(eImmAcid,  "invuln_elements");
    eImmCold  = TagEffect(eImmCold,  "invuln_elements");
    eImmElec  = TagEffect(eImmElec,  "invuln_elements");
    eImmFire  = TagEffect(eImmFire,  "invuln_elements");
    eImmSonic = TagEffect(eImmSonic, "invuln_elements");
    eDur      = TagEffect(eDur,      "invuln_elements");
    eDur2     = TagEffect(eDur2,     "invuln_elements");

    // Link Effects
    effect eLink = EffectLinkEffects(eImmAcid, eImmCold);
    eLink = EffectLinkEffects(eLink, eImmElec);
    eLink = EffectLinkEffects(eLink, eImmFire);
    eLink = EffectLinkEffects(eLink, eImmSonic);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);

    // Apply immunity effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, nCasterLevel);

    // Instant cast VFX
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    return TRUE;
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));

    if (!X2PreSpellCastCode()) return;

    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT);

    if (!nEvent) // Normal cast
    {
        if (GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {
            SetLocalSpellVariables(oCaster, 1); // Hold the charge
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if (nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if (DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }

    PRCSetSchool();
}


