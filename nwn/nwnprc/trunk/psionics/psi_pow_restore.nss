/** @file psi_pow_restore

    Restoration, Psionic

    Psychometabolism (Healing)
    Level: Egoist 6
    Manifesting Time: 3 rounds
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 11
    Metapsionics: None

    As the restoration spell, except as noted here.

    @author Stratovarius
    @date   Created: Feb 19, 2004
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_sp_func"
#include "spinc_remeffct"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nEffectType;
    effect eVis = EffectVisualEffect(VFX_IMP_RESTORATION);
    effect eTest;

    // Let the AI know - Special handling
    PRCSignalSpellEvent(oTarget, FALSE, SPELL_RESTORATION, oManifester);

    // Loop over remaining effects, remove any negative ones
    eTest = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eTest))
    {
        nEffectType = GetEffectType(eTest);
        if(nEffectType == EFFECT_TYPE_ABILITY_DECREASE          ||
           nEffectType == EFFECT_TYPE_AC_DECREASE               ||
           nEffectType == EFFECT_TYPE_ATTACK_DECREASE           ||
           nEffectType == EFFECT_TYPE_DAMAGE_DECREASE           ||
           nEffectType == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE  ||
           nEffectType == EFFECT_TYPE_SAVING_THROW_DECREASE     ||
           nEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
           nEffectType == EFFECT_TYPE_SKILL_DECREASE            ||
           nEffectType == EFFECT_TYPE_BLINDNESS                 ||
           nEffectType == EFFECT_TYPE_DEAF                      ||
           nEffectType == EFFECT_TYPE_PARALYZE                  ||
           nEffectType == EFFECT_TYPE_NEGATIVELEVEL
           )
        {
            if(!GetShouldNotBeRemoved(eTest))
                RemoveEffect(oTarget, eTest);
        }

        eTest = GetNextEffect(oTarget);
    }// end while - Effect loop

    // Apply visuals
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

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
                              METAPSIONIC_NONE
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