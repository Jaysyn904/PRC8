/*
   ----------------
   Compression

   psi_pow_compress
   ----------------

   4/12/05 by Stratovarius
*/ /** @file

    Compression

    Psychometabolism
    Level: Psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level
    Power Points: 1
    Metapsionics: Extend

    This power causes instant diminution, halving your height, length, and width
    and dividing your weight by 8. This decrease changes your size category to
    the next smaller one. You gain a +2 size bonus to Dexterity, a -2 size
    penalty to Strength (to a minimum effective Strength score of 1), a +1 size
    bonus on attack rolls, and a +1 size bonus to Armor Class due to your
    reduced size. This power doesn’t change your speed.

    Multiple effects that reduce size do not stack, which means (among other
    things) that you can’t use a second manifestation of this power to further
    reduce yourself.

    Augment: You can augment this power in one or more of the following ways.
    1. If you spend 6 additional power points, this power decreases your size by
       two size categories. You gain a +4 size bonus to Dexterity, a -4 size
       penalty to Strength (to a minimum effective Strength score of 1), a +2
       size bonus on attack rolls, and a +2 size bonus to Armor Class due to
       your reduced size.
    2. If you spend 2 additional power points, this power’s duration is 1 minute
       per level rather than 1 round per level.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_function"

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
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       6, 1,
                                                       2, 1
                                                       ),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nCategories = 1 + manif.nTimesAugOptUsed_1;
        effect eLink    =                          EffectAttackIncrease(nCategories);
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SANCTUARY));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
               eLink    = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_DEXTERITY, 2 * nCategories));
               eLink    = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_STRENGTH, 2 * nCategories));
               eLink    = EffectLinkEffects(eLink, EffectACIncrease(nCategories));
               
        float fDuration = (manif.nTimesAugOptUsed_2 == 1 ? 60.0f : 6.0f) * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Fail to do anything if the target is already under the effects of Compression
        if(GetLocalInt(oTarget, "PRC_Power_Compression_SizeReduction"))
        {
            // "Target is already under effect of the Compression power!"
            FloatingTextStrRefOnCreature(16826654, oManifester, FALSE);
            return;
        }

        // Apply effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

        // Set local int for PRCGetCreatureSize()
        SetLocalInt(oTarget, "PRC_Power_Compression_SizeReduction", nCategories);

        // Size has changed, evaluate PrC feats again
        EvalPRCFeats(oTarget);

        // Start power end monitor HB
        DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6));
    }// end if - Successfull manifestation
}

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0)                                         ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)
       )
    {
        if(DEBUG) DoDebug("psi_pow_compress: Power expired, clearing");

        // Clear the marker
        DeleteLocalInt(oTarget, "PRC_Power_Compression_SizeReduction");

        // Size has changed, evaluate PrC feats again
        EvalPRCFeats(oTarget);
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nBeatsRemaining));
}
