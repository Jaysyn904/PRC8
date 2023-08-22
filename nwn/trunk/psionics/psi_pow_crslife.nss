/*
    ----------------
    Crisis of Life

    psi_pow_crslife
    ----------------

    21/10/04 by Stratovarius
*/ /** @file

    Crisis of Life

    Telepathy [Mind-Affecting, Death]
    Level: Telepath 7
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Fortitude partial; see text
    Power Resistance: Yes
    Power Points: 13
    Metapsionics: Empower, Maximize, Twin

    You interrupt the subject’s autonomic heart rhythm, killing it instantly on
    a failed saving throw if it has 11 Hit Dice or less. If the target makes its
    saving throw or has more than 11 Hit Dice, it takes 7d6 points of damage.

    Augment: For every additional power point you spend, this power can kill a
             subject that has Hit Dice equal to 11 + the number of additional
             points.
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
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 7;
        int nDieSize      = 6;
        int nMaxHD        = 11 + manif.nTimesAugOptUsed_1;
        int nTargetHD     = GetHitDice(oTarget);
        int nDamage;
        effect eVisDeath  = EffectVisualEffect(VFX_IMP_DEATH_L);
        effect eVisDamage = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        effect eVis       = EffectVisualEffect(PSI_FNF_CRISIS_OF_LIFE);
        effect eDamage;

        // Let the AI know
        PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);
    
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        // Check immunities
        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH,       oManifester) &&
           !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oManifester)
           )
        {
            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    // Can the target die outright and if it can, does it fail the save?
                    if(nTargetHD <= nMaxHD && !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        DeathlessFrenzyCheck(oTarget);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisDeath, oTarget);
                        
                    }
                    else
                    {
				if (GetHasMettle(oTarget, SAVING_THROW_FORT))
				// This script does nothing if it has Mettle, bail
					return;                       
                        // Roll damage
                        nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
                        // Target-specific stuff
                        nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, FALSE);
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);

                        //Apply the VFX impact and effects
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisDamage, oTarget);
                    }// end if - Too much HD or succeeded at save
                }// end if - SR check
            }// end if - Twin Power
        }// end if - Immunity check
    }
}
