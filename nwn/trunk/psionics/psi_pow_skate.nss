/** @file psi_pow_skate

    Skate

    Psychoportation
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal or touch; see text
    Target: You or one willing creature
    Duration: 1 min./level
    Saving Throw: None
    Power Resistance: No
    Power Points: 1
    Metapsionics: Extend

    You or another willing creature can slide along solid ground as if on smooth
    ice. If you manifest skate on yourself or another creature, the subject of
    the power retains equilibrium by mental desire alone, allowing her to
    gracefully skate along the ground, turn, or stop suddenly as desired. The
    skater’s speed increases by 50%.

    @author Stratovarius
    @date   Created: Dec 7, 2004
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_sp_func"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    effect eLink = EffectLinkEffects(EffectMovementSpeedIncrease(50),
                                     EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)
                                     );
    effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
    float fDuration = 60.0f * manif.nManifesterLevel;
    if(manif.bExtend) fDuration *= 2;

    if(oTarget == oManifester                                       ||
       spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oManifester)
       )
    {
        // Let the AI know
        PRCSignalSpellEvent(oTarget, FALSE, manif.nSpellID, oManifester);

        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID,manif.nManifesterLevel);
    }// end if - Targeting check

    return TRUE;    //Held charge is used if at least 1 touch from twinned power hits
}

void main()
{
    if(!PsiPrePowerCastCode()) return;
    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif;
    int nEvent = GetLocalInt(oManifester, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

        if(manif.bCanManifest)
        {
            if(GetLocalInt(oManifester, PRC_SPELL_HOLD) && oManifester == oTarget)
            {   //holding the charge, manifesting power on self
                SetLocalSpellVariables(oManifester, 1);   //change 1 to number of charges
                SetLocalManifestation(oManifester, PRC_POWER_HOLD_MANIFESTATION, manif);
                return;
            }
            DoPower(oManifester, oTarget, manif);
        }
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            manif = GetLocalManifestation(oManifester, PRC_POWER_HOLD_MANIFESTATION);
            if(DoPower(oManifester, oTarget, manif))
                DecrementSpellCharges(oManifester);
        }
    }
}