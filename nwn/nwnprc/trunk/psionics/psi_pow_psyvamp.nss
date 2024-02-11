/** @file psi_pow_psyvamp

    Psychic Vampire

    Psychometabolism
    Level: Egoist 4, psychic warrior 4
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: Fortitude negates
    Power Resistance: Yes
    Power Points: 7
    Metapsionics: Twin

    This power shrouds your hand with darkness that you can use to drain an
    opponent’s power.

    If you make a successful melee touch attack (if the victim fails its
    Fortitude save), the darkness drains 2 power points from your foe for every
    manifester level you have. The drained points simply dissipate.

    Against a psionic being that has no power points or a nonpsionic foe, your
    attack instead deals 2 points of Intelligence, Wisdom, and Charisma damage.

    @author Stratovarius
    @date   Created: May 17, 2005
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
    effect eVis     = EffectVisualEffect(VFX_IMP_HARM);

    int nDamage, nTouchAttack;
    int bHit = 0;

    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

    int nRepeats = manif.bTwin ? 2 : 1;
    for(; nRepeats > 0; nRepeats--)
    {
        nTouchAttack = PRCDoMeleeTouchAttack(oTarget);
        if(nTouchAttack > 0)
        {
            bHit = 1;
            if((PRCMyResistPower(oManifester, oTarget, nPen) == POWER_RESIST_FAIL) && PRCGetIsAliveCreature(oTarget))
            {
                // Save - Fortitude negates
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                    // Check if the target has PP to lose
                    if(GetCurrentPowerPoints(oTarget) != 0)
                    {
                        LosePowerPoints(oTarget, 2 * manif.nManifesterLevel, TRUE);
                    }
                    // No PP, do ability damage
                    else
                    {
                        ApplyAbilityDamage(oTarget, ABILITY_CHARISMA,     2, DURATION_TYPE_PERMANENT);
                        ApplyAbilityDamage(oTarget, ABILITY_WISDOM,       2, DURATION_TYPE_PERMANENT);
                        ApplyAbilityDamage(oTarget, ABILITY_INTELLIGENCE, 2, DURATION_TYPE_PERMANENT);
                    }

                    // Do VFX
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }// end if - Save
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
                              METAPSIONIC_TWIN
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