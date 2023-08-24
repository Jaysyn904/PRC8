/** @file psi_pow_psirev

    Psionic Revivify

    Psychometabolism (Healing) [Good]
    Level: Egoist 5
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Dead creature touched
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 9, XP
    Metapsionics: None

    Psionic revivify lets a manifester reconnect a corpse’s psyche with its
    body, restoring life to a recently deceased creature.

    This power functions like the raise dead spell, except that the affected
    creature receives no level loss, no Constitution loss, and no loss of
    powers.

    The creature has -1 hit points (but is stable) after being restored to life.

    XP Cost: 200 XP.

    @author Stratovarius
    @date   Created: May 17, 2005
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_sp_func"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    effect eResurrect = EffectResurrection();
    effect eVis       = EffectVisualEffect(VFX_IMP_RAISE_DEAD);

    // Make sure the target is in fact dead
    if(GetIsDead(oTarget))
    {
        // Let the AI know - Special handling
        PRCSignalSpellEvent(oTarget, FALSE, SPELL_RAISE_DEAD, oManifester);

        // Apply effects
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eResurrect, oTarget);

        // Pay the XP cost
        SetXP(oManifester, GetXP(oManifester) - 200);

        // Do special stuff
        ExecuteScript("prc_pw_raisedead", oManifester);
        if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oTarget))
            SetPersistantLocalInt(oTarget, "persist_dead", FALSE);

        // [Good] descriptor causes an alignent shift
        //SPGoodShift(oManifester);
    }// end if - Deadness check

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