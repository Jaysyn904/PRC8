/** @file psi_pow_fuseflsh

    Fuse Flesh

    Psychometabolism
    Level: Psion/wilder 6
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 round/level
    Saving Throw: Fortitude negates and Fortitude partial; see text
    Power Resistance: Yes
    Power Points: 11
    Metapsionics: Extend, Twin

    You cause the touched subject’s flesh to ripple, grow together, and fuse
    into a nearly seamless whole. The subject is forced into a fetal position
    (if humanoid), with only the vaguest outline of its folded arms and legs
    visible below the all-encompassing wave of flesh.

    If the target fails its Fortitude save to avoid the power’s effect, the
    subject must immediately attempt a second Fortitude save. If this second
    save is failed, the creature’s eyes and ears fuse over, effectively blinding
    and deafening it.

    Augment: For every 2 additional power points you spend, this power’s save DC
             increases by 1.

    @author Stratovarius
    @date   Created: Feb 24, 2005
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_sp_func"
#include "prc_inc_sp_tch"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nDC           = GetManifesterDC(oManifester);
    int nPen          = GetPsiPenetration(oManifester);
    effect ePrimary   =                             EffectParalyze();
           ePrimary   = EffectLinkEffects(ePrimary, EffectVisualEffect(VFX_DUR_PARALYZED));
           ePrimary   = EffectLinkEffects(ePrimary, EffectVisualEffect(VFX_DUR_PARALYZE_HOLD));
           ePrimary   = EffectLinkEffects(ePrimary, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
    effect eSecondary =                               EffectBlindness();
           eSecondary = EffectLinkEffects(eSecondary, EffectDeaf());
           eSecondary = EffectLinkEffects(eSecondary, EffectVisualEffect(VFX_IMP_BLIND_DEAF_M));
    float fDuration   = 6.0f * manif.nManifesterLevel;
    if(manif.bExtend) fDuration *= 2;

    // Let the AI know
    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);
    int nTouchAttack;
    int bHit = 0;

    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

    int nRepeats = manif.bTwin ? 2 : 1;
    for(; nRepeats > 0; nRepeats--)
    {
        nTouchAttack = PRCDoMeleeTouchAttack(oTarget);
        if(nTouchAttack > 0)
        {
            bHit = 1;
            if((PRCMyResistPower(oManifester, oTarget, nPen) == POWER_RESIST_FAIL) && !GetIsIncorporeal(oTarget) && PRCGetIsAliveCreature(oTarget))
            {
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePrimary, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                    {
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSecondary, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                    }// end if - Save vs secondary effect
                }// end if - Save vs primary effect
            }
        }
    }

    return bHit;    //Held charge is used if at least 1 touch from twinned power hits
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
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN
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