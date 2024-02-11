/*
   ----------------
   Cloud Mind

   psi_pow_cldmnd
   ----------------

    25/9/07 by Stratovarius
*/ /** @file

    Cloud Mind

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: 1 min./level
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Extend, Twin

    You make yourself completely undetectable to the subject by erasing all awareness of your presence from its mind.
    However, if you attack the creature it becomes fully aware of your presence.
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
                                  PowerAugmentationProfile(),
                                  METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC      = GetManifesterDC(oManifester);
        int nPen     = GetPsiPenetration(oManifester);
        effect eLink = EffectCharmed();
        effect eVis  = EffectVisualEffect(VFX_IMP_SLOW);
        float fDur   = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDur *= 2;

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
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply VFX Impact and cloud mind effect effect
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, manif.nSpellID, manif.nManifesterLevel);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    int nRep = GetReputation(oTarget, oManifester);
                    AssignCommand(oManifester, ClearAllActions(TRUE));
                    AssignCommand(oTarget, ClearAllActions(TRUE));
                    
                    // None of this crap worked :(
                    //AdjustReputation(oManifester, oTarget, 100);
                    //DelayCommand(fDur, AdjustReputation(oManifester, oTarget, nRep));
                    //SetIsTemporaryFriend(oManifester, oTarget, FALSE);
                    //SetIsTemporaryFriend(oTarget, oManifester, FALSE);
                    //DelayCommand(fDur, SetIsTemporaryEnemy(oManifester, oTarget, FALSE));
                }
            }
        }
    }
}
