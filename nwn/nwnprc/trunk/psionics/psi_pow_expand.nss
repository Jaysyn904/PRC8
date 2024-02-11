/*
   ----------------
   Expansion

   psi_pow_expand
   ----------------

   4/12/05 by Stratovarius
*/ /** @file

    Expansion

    Psychometabolism
    Level: Psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round./level
    Power Points: 1
    Metapsionics: Extend

    This power causes instant growth, doubling your height, length, and width
    and multiplying your weight by 8. This increase changes your size category
    to the next larger one. You gain a +2 size bonus to Strength, a -2 size
    penalty to Dexterity (to a minimum effective Dexterity score of 1), a -1
    size penalty on attack rolls, and a -1 size penalty to Armor Class due to
    your increased size.

    This power doesn’t change your speed.

    Multiple effects that increase size do not stack, which means (among other
    things) that you can’t use a second manifestation of this power to further
    expand yourself.

    Augment: You can augment this power in one or more of the following ways.
    1. If you spend 6 additional power points, this power increases your size by
        two size categories instead of one. You gain a +4 size bonus to
        Strength, a -4 size penalty to Dexterity (to a minimum effective
        Dexterity score of 1), a -2 size penalty on attack rolls, and a -2 size
        penalty to Armor Class due to your increased size.
    2. If you spend 2 additional power points, this power’s duration is 10
       minutes per level rather than 1 round per level.
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
        effect eLink    =                          EffectAttackDecrease(nCategories);
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SANCTUARY));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
               eLink    = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_DEXTERITY, 2 * nCategories));
               eLink    = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 2 * nCategories));
               eLink    = EffectLinkEffects(eLink, EffectACDecrease(nCategories));
         
        float fDuration = (manif.nTimesAugOptUsed_2 == 1 ? 600.0f : 6.0f) * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Fail to do anything if the target is already under the effects of Compression
        if(GetLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease"))
        {
            // "Target is already under effect of the Expansion power!"
            FloatingTextStrRefOnCreature(16826655, oManifester, FALSE);
            return;
        }

        // Apply effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

        // Set local int for PRCGetCreatureSize()
        SetLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease", nCategories);

        // Size has changed, evaluate PrC feats again
        EvalPRCFeats(oTarget);

        // Start power end monitor
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
        if(DEBUG) DoDebug("psi_pow_expand: Power expired, clearing");

        // Clear the marker
        DeleteLocalInt(oTarget, "PRC_Power_Expansion_SizeIncrease");

        // Size has changed, evaluate PrC feats again
        EvalPRCFeats(oTarget);
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nBeatsRemaining));
}
