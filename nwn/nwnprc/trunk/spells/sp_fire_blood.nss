//::///////////////////////////////////////////////
//:: Name      Fire in the Blood
//:: FileName  sp_fire_blood.nss
//:://////////////////////////////////////////////
/**@file Fire in the Blood
Necromancy
Level: Clr 5
Components: V, S, M
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 Minute/level

You deal 4d6 damage to any enemy who strikes you in melee.

**/

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    // Define caster and target
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    // Set spell school for other systems (e.g. counters, logs)
    SetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    // Pre-spell cast checks (e.g. UMD, conditions)
    if (!X2PreSpellCastCode())
    {
        // Clean up and exit if the spell shouldn't be cast
        DeleteLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }

    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMetaMagic   = PRCGetMetaMagicFeat();

    // Base duration (1 round per caster level)
    int nDuration = nCasterLevel;

    // Double duration if Extended
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration *= 2;
    }

    // Prepare effects
    effect eShield = EffectDamageShield(0, DAMAGE_BONUS_2d12, DAMAGE_TYPE_MAGICAL);
    effect eVFX    = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    effect eFinal  = EffectLinkEffects(eShield, eVFX);

    // Prevent stacking
    PRCRemoveEffectsFromSpell(oTarget, GetSpellId());

    // Fire event for spellcasting
    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));

    // Apply effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFinal, oTarget, RoundsToSeconds(nDuration));

    // Cleanup
    DeleteLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR");
}


/* 	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook
    object oTarget = PRCGetSpellTargetObject();

    int nDuration = PRCGetCasterLevel(oTarget);
    int nMetaMagic = PRCGetMetaMagicFeat();

    effect eShield = EffectDamageShield(0, DAMAGE_BONUS_2d12, DAMAGE_TYPE_MAGICAL);
    effect eDur = EffectVisualEffect(463);

    //Link effects
    effect eLink = EffectLinkEffects(eShield, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Stacking Spellpass, 2003-07-07, Georg
    PRCRemoveEffectsFromSpell(oTarget, GetSpellId());

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, nDuration * 60.0);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school */
