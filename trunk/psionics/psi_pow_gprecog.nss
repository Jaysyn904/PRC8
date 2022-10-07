/*
   ----------------
   Precognition, Greater

   psi_pow_gprecog
   ----------------

   15/7/05 by Stratovarius
*/ /** @file

    Precognition, Greater

    Clairsentience
    Level: Seer 6
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 hour/level
    Power Points: 11
    Metapsionics: Extend

    Precognition allows your mind to glimpse fragments of potential future
    events - what you see will probably happen if no one takes action to change
    it. However, your vision is incomplete, and it makes no real sense until the
    actual events you glimpsed begin to unfold. That’s when everything begins to
    come together, and you can act, if you act swiftly, on the information you
    previously received when you manifested this power.

    In practice, manifesting this power grants you a “precognitive edge.”
    Normally, you can have only a single precognitive edge at one time. You must
    use your edge within a period of no more than 1 hour per level, at which
    time your preknowledge fades and you lose your edge.

    You can use your precognitive edge in a variety of ways. Essentially, the
    edge translates into a +4 insight bonus that you can apply at any time to
    either an attack roll, a damage roll, a saving throw, or a skill check. To
    apply this bonus for one round, press either the Attack, Save, Skill, or
    Damage option on the radial menu.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining);

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
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        float fDuration = HoursToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDuration *= 2;

        // Set the marker local
        SetLocalInt(oTarget, "PRC_Power_GreaterPrecognition_Active", TRUE);

        // Set a VFX for the monitor to watch
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

        // Start the monitor
        DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6));
    }
}

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0)                                         ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)
       )
    {
        if(DEBUG) DoDebug("psi_pow_gprecog: Power expired, clearing");

        // Clear the marker
        DeleteLocalInt(oTarget, "PRC_Power_GreaterPrecognition_Active");
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nBeatsRemaining));
}
