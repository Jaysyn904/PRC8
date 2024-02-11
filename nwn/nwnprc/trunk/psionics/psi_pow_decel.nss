/*
   ----------------
   Deceleration

   psi_pow_decel
   ----------------

   25/10/04 by Stratovarius
*/ /** @file

    Deceleration

    Psychoportation
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./level)
    Target: One Medium or smaller creature
    Duration: 1 min./level
    Saving Throw: Reflex negates
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Extend, Twin

    You warp space around an individual, hindering the subject’s ability to move.
    The subject’s speed (in any movement mode it possesses) is halved. A
    subsequent manifestation of deceleration on the subject does not further
    decrease its speed.

    Augment: For every 2 additional power points you spend, this power can affect
            a target one size category larger.
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
                                                       2, 4
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC         = GetManifesterDC(oManifester);
        int nPen        = GetPsiPenetration(oManifester);
        int nMaxSize    = CREATURE_SIZE_MEDIUM + manif.nTimesAugOptUsed_1;
        int nSize       = PRCGetCreatureSize(oTarget);
        effect eLink    =                          EffectSlow();
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
        effect eVis     = EffectVisualEffect(VFX_IMP_SLOW);
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        if(nSize <= nMaxSize)
        {
            // Let the AI know
            PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    //Make a saving throw check
                    if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                    {
                        //Apply VFX Impact and daze effect
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }
                }
            }
        }
    }
}
