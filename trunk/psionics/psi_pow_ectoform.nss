/*
   ----------------
   Ectoplasmic Form

   psi_pow_ectoform
   ----------------

   14/5/05 by Stratovarius
*/ /** @file

    Ectoplasmic Form

    Psychometabolism
    Level: Egoist 3, psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 5
    Metapsionics: Extend

    You and all your gear become a partially translucent mass of rippling
    ectoplasm that generally conforms to your normal shape. You gain damage
    reduction 10/+2, and you gain immunity to poison and critical hits. Your
    material armor becomes meaningless, although your size, Dexterity,
    deflection bonuses, and armor bonuses from force effects (such as those
    gained by inertial armor) still apply to your Armor Class.

    You can manifest powers while in ectoplasmic form, but you must make a
    Concentration check (DC 20 + power level) for each power you attempt to
    manifest.


    @todo 2da entries
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining);

void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Create effects
        effect eLink =                          EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_POISON));
               eLink = EffectLinkEffects(eLink, EffectDamageReduction(10, DAMAGE_POWER_PLUS_TWO));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_BLUR));
        effect eVis  = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);

        // Apply effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, manif.nManifesterLevel);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

        // Set marker for use in powerhook
        SetLocalInt(oTarget, "PRC_Power_EctoForm", TRUE);
        // Start effect end monitor
        DelayCommand(6.0f, DispelMonitor(manif.oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6));
    }
}

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0) ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)
       )
    {
        if(DEBUG) DoDebug("psi_pow_ectoform: Removing marker");
        // Clear the effect presence marker
        DeleteLocalInt(oTarget, "PRC_Power_EctoForm");
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nBeatsRemaining));
}
