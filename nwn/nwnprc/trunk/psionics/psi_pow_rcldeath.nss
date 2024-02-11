/*
    ----------------
    Recall Death

    psi_pow_rcldeath
    ----------------

    28/10/04 by Stratovarius
*/ /** @file

    Recall Death

    Clairsentience [Death, Mind-Affecting]
    Level: Psion/wilder 8
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Will partial; see text
    Power Resistance: Yes
    Power Points: 15
    Metapsionics: Empower, Maximize, Twin

    As recall agony, except the wounds revealed by folding the fourth dimension
    are potentially fatal. If the target fails its Will save, it dies. If the
    save succeeds, the target instead takes 5d6 points of damage.
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
                              PowerAugmentationProfile(),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 5;
        int nDieSize      = 6;
        int nDamage;
        effect eDeathLink = EffectLinkEffects(EffectDeath(),
                                              EffectVisualEffect(VFX_IMP_DEATH_L)
                                              );
        effect eDamageVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        effect eDamage;

        // Let the AI know
        PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

        // Check immunities
        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH,       oManifester) &&
           !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oManifester)
           )
        {
            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                // Check for immunity and Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    // Save - Will partial for just damage
                    if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS) && !GetHasMettle(oTarget, SAVING_THROW_WILL))
                    {
                        // Roll damage
                        nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
                        // Target-specific stuff
                        nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, FALSE);

                        //Apply the VFX impact and effects
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamageVis, oTarget);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                    }// end if - Save success
                    // Failed save -> Death
                    else
                    {
                            DeathlessFrenzyCheck(oTarget);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeathLink, oTarget);
                    }// end else - Save failure
                }// end if - SR check
            }// end for - Twin Power
        }// end if - Immunity check
    }// end if - Successfull manifestation
}
