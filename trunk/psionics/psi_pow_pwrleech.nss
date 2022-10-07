/*
   ----------------
   Power Leech

   psi_pow_pwrleech
   ----------------

   19/2/04 by Stratovarius
*/ /** @file

    Telepathy (Compulsion) [Mind-Affecting]
    Level: Psion/wilder 4
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: Any psionic creature
    Duration: Concentration, up to 1 round/level; see text
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 7
    Metapsionics: Empower, Extend, Maximize

    Your brow erupts with an arc of crackling dark energy that connects with
    your foe, draining it of 1d6 power points and adding 1 of those points to
    your reserve (unless that gain would cause you to exceed your maximum).

    The drain continues in each round you maintain concentration while the
    subject of the drain remains in range. If the subject is drained to 0 power
    points, this power ends.

    Concentrating to maintain power leech is a full-round action (you can take
    no other actions aside from a 5-foot step).
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

void DoDrain(struct manifestation manif, location lManifesterOld, object oTarget);

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
                              METAPSIONIC_EMPOWER | METAPSIONIC_EXTEND | METAPSIONIC_MAXIMIZE
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        effect eLink      = EffectLinkEffects(EffectBeam(VFX_BEAM_BLACK, oManifester, BODY_NODE_CHEST),
                                              EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE)
                                              );
        float fDuration   = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Let the AI know
        PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

        // Check for Power Resistance
        if(PRCMyResistPower(oManifester, oTarget, nPen))
        {
            // Save - Will negates
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                // Apply the visuals. Used for power expiration tracking
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

                // Start the drain HB
                DoDrain(manif, GetLocation(oManifester), oTarget);
            }// end if - Save
        }// end if - SR check
    }// end if - Successfull manifestation
}

void DoDrain(struct manifestation manif, location lManifesterOld, object oTarget)
{
    // Check expiration
    if(!PRCGetDelayedSpellEffectsExpired(manif.nSpellID, oTarget, manif.oManifester)                    && // No dispel or duration expiration
       GetCurrentPowerPoints(oTarget) != 0                                                              && // The target hasn't run out of PP yet
       !GetBreakConcentrationCheck(manif.oManifester)                                                      // The manifester's concentration hasn't been broken
       )
    {
        // Determine amount of PP drained
        int nNumberOfDice = 1;
        int nDieSize      = 6;
        int nDrain        = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, FALSE, FALSE);

        // Apply drain
        LosePowerPoints(oTarget, nDrain, TRUE);
        GainPowerPoints(manif.oManifester, 1, FALSE, TRUE);

        // Schedule next HB
        DelayCommand(6.0f, DoDrain(manif, GetLocation(manif.oManifester), oTarget));
    }
    // Power expired for some reason, make sure VFX are gone
    else
    {
        if(DEBUG) DoDebug("psi_pow_pwrleech: Power expired, clearing VFX");
        PRCRemoveSpellEffects(manif.nSpellID, manif.oManifester, oTarget);
    }
}