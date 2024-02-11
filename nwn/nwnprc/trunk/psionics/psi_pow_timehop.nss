/*
   ----------------
   Time Hop

   psi_pow_timehop
   ----------------

   27/3/05 by Stratovarius
*/ /** @file

    Time Hop

    Psychoportation
    Level: Psion/wilder 3
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Targets: One Medium or smaller creature
    Duration: 1 round/level; see text
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Extend, Twin, Widen

    The subject of the power hops forward in time 1 round for every manifester
    level you have. In effect, the subject seems to disappear in a shimmer of
    silver energy, then reappear after the duration of this power expires. The
    subject reappears in exactly the same orientation and condition as before.
    From the subject’s point of view, no time has passed at all.

    In each round of the power’s duration, it can attempt a DC 15 Wisdom check.
    Success allows the subject to return. The subject can act normally on its
    next turn after this power ends.

    Augment: You can augment this power in one or both of the following ways.
    1. For every 2 additional power points you spend, you can affect a creature
       of one size category larger.
    2. For every 2 additional power points you spend, this power can affect an
       additional target. Any additional target cannot be more than 15 feet from
       another target of the power.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

void WisCheck(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining);

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
    object oMainTarget = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oMainTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, 4,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        int nMaxSize      = CREATURE_SIZE_MEDIUM + manif.nTimesAugOptUsed_1;
        int nExtraTargets = manif.nTimesAugOptUsed_2;
        int nTargetsLeft;
        effect eLink      =                          EffectCutsceneParalyze();
               eLink      = EffectLinkEffects(eLink, EffectCutsceneGhost());
               eLink      = EffectLinkEffects(eLink, EffectEthereal());
               eLink      = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_ALL_SPELLS));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,        100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,        100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE,      100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,  100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,        100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL,     100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,    100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,    100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE,    100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,    100));
               eLink      = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC,       100));
        object oExtraTarget;
        location lTarget  = GetLocation(oMainTarget);
        float fRadius     = EvaluateWidenPower(manif, FeetToMeters(15.0f));
        float fDuration   = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Main target
            // Target size check
            if(PRCGetCreatureSize(oMainTarget) <= nMaxSize)
            {
                // Let the AI know
                PRCSignalSpellEvent(oMainTarget, TRUE, manif.nSpellID, oManifester);

                // Check for Power Resistance
                if(PRCMyResistPower(oManifester, oMainTarget, nPen))
                {
                    // Save - Will negates
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oMainTarget, nDC, SAVING_THROW_TYPE_NONE))
                    {
                        // Apply effect. Not dispellable
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oMainTarget, fDuration, FALSE);
                        // Start Wis check HB
                        DelayCommand(6.0f, WisCheck(oManifester, oMainTarget, manif.nSpellID, (FloatToInt(fDuration) / 6) - 1));
                    }// end if - Save
                }// end if - SR check
            }// end if - Target size check

            // Additional targets
            if(nExtraTargets)
            {
                // Get targets until out of potential targets or cannot affect any more
                int nTargetsLeft = nExtraTargets;
                oExtraTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                while(nTargetsLeft > 0 && GetIsObjectValid(oExtraTarget))
                {
                    if(oExtraTarget != oManifester                                              && // Does not affect the manifester
                       oExtraTarget != oMainTarget                                              && // Does not affect the same target twice
                       spellsIsTarget(oExtraTarget, SPELL_TARGET_SELECTIVEHOSTILE, oManifester) && // User gets to pick targets
                       PRCGetCreatureSize(oExtraTarget) <= nMaxSize                                // Target size check
                       )
                    {
                        // Let the AI know
                        PRCSignalSpellEvent(oExtraTarget, TRUE, manif.nSpellID, oManifester);

                        // Check for Power Resistance
                        if(PRCMyResistPower(oManifester, oExtraTarget, nPen))
                        {
                            // Save - Will negates
                            if(!PRCMySavingThrow(SAVING_THROW_WILL, oExtraTarget, nDC, SAVING_THROW_TYPE_NONE))
                            {
                                // Apply effect. Not dispellable
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oExtraTarget, fDuration, FALSE);
                                // Start Wis check HB
                                DelayCommand(6.0f, WisCheck(oManifester, oExtraTarget, manif.nSpellID, (FloatToInt(fDuration) / 6) - 1));
                            }// end if - Save
                        }// end if - SR check

                        // Use up a target slot only if we actually did something to it
                        nTargetsLeft -= 1;
                    }// end if - Targeting check

                    //Select the next target within the spell shape.
                    oExtraTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                }// end while - Target loop
            }// end if - More than one target
        }// end for - Twin Power
    }// end if - Successfull manifestation
}

void WisCheck(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining)
{
    if((--nBeatsRemaining == -1)                                         || // Is the power expiring now
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)  || // Or has it expired already
       ((d20() + GetAbilityModifier(ABILITY_WISDOM, oTarget)) >= 15)       // Or does the creature succeed at it's Wis check
       )
    {
        if(DEBUG) DoDebug("psi_pow_timehop: Power expired or Wis check succeeded, clearing");

        // Remove the effects
        PRCRemoveSpellEffects(nSpellID, oManifester, oTarget);
    }
    else
       DelayCommand(6.0f, WisCheck(oManifester, oTarget, nSpellID, nBeatsRemaining));
}
