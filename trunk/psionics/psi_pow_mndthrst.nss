/*
   ----------------
   Mind Thrust

   psi_pow_mndthrst
   ----------------

   21/10/04 by Stratovarius
*/ /** @file

    Mind Thrust

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Empower, Maximize, Twin

    You instantly deliver a massive assault on the thought pathways of any one
    creature, dealing 1d10 points of damage to it.

    Augment: For every additional power point you spend, this power’s damage
             increases by 1d10 points. For each extra 2d10 points of damage,
             this power’s save DC increases by 1.
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
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(2,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester) + manif.nTimesGenericAugUsed;
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 1 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 10;
        int nDamage;
        effect eVis       = EffectVisualEffect(VFX_IMP_HEAD_MIND);
        effect eLink;

        // Let the AI know
        PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Check for Power Resistance
            if(PRCMyResistPower(oManifester, oTarget, nPen))
            {
                // Save - Will negates
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    // Roll damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
                    // Target-specific stuff
                    nDamage = GetTargetSpecificChangesToDamage(oTarget, manif.oManifester, nDamage, TRUE, FALSE);

                    // Generate damage effect
                    eLink = EffectLinkEffects(eVis, EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL));
                    // Apply effect
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                }// end if - Save
            }// end if - SR check
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
