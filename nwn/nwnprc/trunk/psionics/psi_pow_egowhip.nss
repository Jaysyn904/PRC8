/*
    ----------------
    Ego Whip

    psi_pow_egowhip
    ----------------

    6/11/04 by Stratovarius
*/ /** @file

    Ego Whip

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. +10 ft./level)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Will half; see text
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin

    Your rapid mental lashings assault the ego of your enemy, debilitating its
    confidence. The target takes 1d4 points of Charisma damage, or half that
    amount (minimum 1 point) on a successful save. A target that fails its save
    is also dazed for 1 round.

    Augment: For every 4 additional power points you spend, this power’s Charisma
             damage increases by 1d4 points and its save DC increases by 2.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

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
    object oTarget = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       4, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester) + (2 * manif.nTimesAugOptUsed_1);
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 1 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 4;
        int nDamage;
        effect eDaze =                          EffectDazed();
               eDaze = EffectLinkEffects(eDaze, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
               eDaze = EffectLinkEffects(eDaze, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
        effect eVis  = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
        effect eRay  = EffectBeam(VFX_BEAM_FIRE_LASH, oManifester, BODY_NODE_CHEST);

        // Let the AI know
        PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

        // Mind-affecting immunity check
        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
        {
            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    // Roll damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, FALSE, FALSE);
                    // Target-specific stuff
                    nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, FALSE, FALSE);

                    // Will save for half and not being dazed
                    if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        nDamage = max(nDamage / 2, 1); // Minimum 1 damage
                    }
                    else if (GetHasMettle(oTarget, SAVING_THROW_WILL))
                {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE), oTarget);
                }
                    // Failed save, daze
                    else
                    {
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, RoundsToSeconds(1), FALSE);
            }
                    //Apply the VFX impact
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7 ,FALSE);
                    DelayCommand(0.5, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    // Apply the ability damage. Wears off at rate of 1 point / day
                    ApplyAbilityDamage(oTarget, ABILITY_CHARISMA, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0f, TRUE);
                }// end if - SR check
            }// end for - Twin Power
        }// end if - Mind-affecting immunity check
    }// end if - Successfull manifestation
}
