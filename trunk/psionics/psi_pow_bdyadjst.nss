/** @file psi_pow_bdyadjst

    Body Adjustment

    Psychometabolism (Healing)
    Level: Psion/wilder 3, psychic warrior 2
    Manifesting Time: 1 round
    Range: Personal
    Target: You
    Duration: Instantaneous
    Power Points: Psion/wilder 5, psychic warrior 3
    Metapsionics: Empower, Maximize, Twin

    You take control of your body’s healing process, curing yourself of 1d12
    points of damage.

    Augment: For every 2 additional power points you spend, this power heals an
             additional 1d12 points of damage.

    @author Stratovarius
    @date   Created: Oct 22, 2004
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_sp_func"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nNumberOfDice = 1 + manif.nTimesAugOptUsed_1;
    int nDieSize      = 12;
    int nHeal;
    effect eHeal, eHealVis = EffectVisualEffect(VFX_IMP_HEALING_L);

    // Handle Twin Power
    int nRepeats = manif.bTwin ? 2 : 1;
    for(; nRepeats > 0; nRepeats--)
    {
        nHeal = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, FALSE, FALSE);
        eHeal = EffectHeal(nHeal);

        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal,    oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oTarget);
    }

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
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
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