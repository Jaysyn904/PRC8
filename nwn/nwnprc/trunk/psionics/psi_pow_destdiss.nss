/** @file psi_pow_destdiss

    Destiny Dissonance

    Clairsentience
    Level: Seer 1
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 round/level
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Extend, Twin

    Your mere touch grants your foe an imperfect, unfocused glimpse of the many
    possible futures in store. Unaccustomed to and unable to process the information,
    the subject becomes sickened for 1 round per level of the manifester.

    @author Stratovarius
    @date   Created: Jul 15, 2005
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_sp_func"
#include "prc_inc_sp_tch"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nDC         = GetManifesterDC(oManifester);
    int nPen        = GetPsiPenetration(oManifester);
    effect eShaken  = EffectSickened();
    effect eImpact  = EffectVisualEffect(VFX_IMP_DOOM);
    float fDuration = RoundsToSeconds(manif.nManifesterLevel);
    if(manif.bExtend) fDuration *= 2;

    int bHit = 0;
    int nTouchAttack;
    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

    int nRepeats = manif.bTwin ? 2 : 1;
    for(; nRepeats > 0; nRepeats--)
    {
        nTouchAttack = PRCDoMeleeTouchAttack(oTarget);
        if(nTouchAttack > 0)
        {
            bHit = 1;
            if(PRCMyResistPower(oManifester, oTarget, nPen) == POWER_RESIST_FAIL)
            {
                //Apply VFX Impact and shaken effect
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShaken, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
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
                              PowerAugmentationProfile(),
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