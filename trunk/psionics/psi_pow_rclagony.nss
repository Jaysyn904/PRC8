/*
    ----------------
    Recall Agony

    psi_pow_rclagony
    ----------------

    28/10/04 by Stratovarius
*/ /** @file

    Recall Agony

    Clairsentience [Mind-Affecting]
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Will half
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin

    The fabric of time parts to your will, revealing wounds your foe has
    received in the past (or has yet to receive). That foe takes 2d6 points of
    damage as the past (or future) impinges briefly on the present.

    Augment: For every additional power point you spend, this power’s damage
             increases by 1d6 points. For each extra 2d6 points of damage, this
             power’s save DC increases by 1.
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
        int nNumberOfDice = 2 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 6;
        int nDamage;
        effect eVis       = EffectVisualEffect(PSI_FNF_RECALL_AGONY);
        effect eDamage;

        // Let the AI know
        PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Check for immunity and Power Resistance
            if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oManifester) &&
               PRCMyResistPower(oManifester, oTarget, nPen)
               )
            {
                // Save - Will half
                if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    nDamage /= 2;
                    
                    	if (GetHasMettle(oTarget, SAVING_THROW_WILL)) // Ignores partial effects
                    	{
                		nDamage = 0;
                    	}                     
                }

                // Roll damage
                nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
                // Target-specific stuff
                nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, FALSE);

                //Apply the VFX impact and effects
                eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
            }// end if - SR check
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
