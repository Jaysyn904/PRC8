/** @file psi_pow_shrpain

    Share Pain

    Psychometabolism
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Touch
    Targets: You and one willing creature
    Duration: 1 hour/level
    Power Points: 3
    Metapsionics: Extend

    This power creates a psychometabolic connection between you and a willing
    subject so that some of your wounds are transferred to the subject. You take
    half damage from all attacks that deal hit point damage to you, and the
    subject takes the remainder. The amount of damage not taken by you is taken
    by the subject. If your hit points are reduced by a lowered Constitution
    score, that reduction is not shared with the subject because it is not a
    form of hit point damage. When this power ends, subsequent damage is no
    longer divided between the subject and you, but damage already shared is not
    reassigned.

    If you and the subject move farther away from each other than close range,
    the power ends.


    Implementation notes:
    You may not have more than one Share Pain or Share Pain, Forced active at
    any one time. Any subsequent uses override the previous.
    We're lazy bastards :P

    @author Stratovarius
    @date   Created: Feb 19, 2004
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_sp_func"

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nManifesterLevel, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0)                                            ||
       GetIsDead(oTarget)                                                  ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)     ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oManifester, oManifester) /*||
       GetDistanceBetween(oManifester, oTarget) > FeetToMeters(25.0f + (5.0f * (nManifesterLevel / 2))) This does not work in NWN */ 
       )
    {
        if(DEBUG) DoDebug("psi_pow_shrpain: Effect expired, clearing");
        // Clear the target local
        DeleteLocalObject(oManifester, "PRC_Power_SharePain_Target");
        // Remove the eventscript
        RemoveEventScript(oManifester, EVENT_ONHIT, "psi_pow_shrpnaux", TRUE, FALSE);

        // Remove remaining effects
        PRCRemoveSpellEffects(nSpellID, oManifester, oTarget);
        PRCRemoveSpellEffects(nSpellID, oManifester, oManifester);
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nManifesterLevel, nBeatsRemaining));
}

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    effect eDur     = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    float fDuration = HoursToSeconds(manif.nManifesterLevel);
    if(manif.bExtend) fDuration *= 2;

    // Let the AI know
    PRCSignalSpellEvent(oTarget, FALSE, manif.nSpellID, oManifester);

    // Get the OnHitCast: Unique on the manifester's armor / hide
    ExecuteScript("prc_keep_onhit_a", oManifester);

    // Hook eventscript
    AddEventScript(oManifester, EVENT_ONHIT, "psi_pow_shrpnaux", TRUE, FALSE);

    // Store the target for use in the damage script
    SetLocalObject(oManifester, "PRC_Power_SharePain_Target", oTarget);

    // Do VFX for the monitor to look for
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget,     fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oManifester, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

    // Start effect end monitor
    DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, manif.nSpellID, manif.nManifesterLevel, FloatToInt(fDuration) / 6));

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