/*
   ----------------
   Temporal Acceleration

   psi_pow_tempacc
   ----------------

   27/3/05 by Stratovarius
*/ /** @file

    Temporal Acceleration

    Psychoportation
    Level: Psion/wilder 6
    Manifesting Time: 1 swift action
    Range: Personal
    Target: You
    Duration: 1 round (in apparent time); see text
    Power Points: 11
    Metapsionics: Extend

    You enter another time frame, speeding up so greatly that all other
    creatures seem frozen, though they are actually still moving at normal
    speed. You are free to act for 1 round of apparent time. You can manifest
    powers, cast spells, move, or perform other types of actions.

    When your temporal acceleration expires, you resume acting during your
    current turn in the standard time frame. You are shaken for 1 round upon
    your return to the standard time frame.

    Manifesting this power is a swift action, like manifesting a quickened
    power, and it counts toward the normal limit of one quickened power per
    round.

    Augment: For every 4 additional power points you spend, this power’s
             duration (in apparent time) increases by 1 round.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"
#include "inc_timestop"

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
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       4, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {

        location lTarget = PRCGetSpellTargetLocation();
        effect eImpact   = EffectVisualEffect(VFX_FNF_TIME_STOP);
        effect eDur      = EffectVisualEffect(PSI_DUR_TEMPORAL_ACCELERATION);
        effect eTStop    = EffectTimeStop();
        float fDuration  = 6.0f * (1 + manif.nTimesAugOptUsed_1);
        if(manif.bExtend) fDuration *= 2;

        // Local timestop modifications
        if(GetPRCSwitch(PRC_TIMESTOP_LOCAL))
        {
            eTStop = EffectAreaOfEffect(VFX_PER_NEW_TIMESTOP);
            eTStop = EffectLinkEffects(eTStop, EffectEthereal());
            if(GetPRCSwitch(PRC_TIMESTOP_NO_HOSTILE))
            {
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_LEFTHAND,  oManifester), fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oManifester), fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_BULLETS,   oManifester), fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_ARROWS,    oManifester), fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_BOLTS,     oManifester), fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oManifester), fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oManifester), fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oManifester), fDuration);
                /*
                DelayCommand(RoundsToSeconds(nDur), RemoveTimestopEquip());
                string sSpellscript = PRCGetUserSpecificSpellScript();
                DelayCommand(RoundsToSeconds(nDur), PRCSetUserSpecificSpellScript(sSpellscript));
                PRCSetUserSpecificSpellScript("tsspellscript");
                now in main spellhook */
            }
        }

        // Let the AI know - Special handling
        PRCSignalSpellEvent(oTarget, FALSE, SPELL_TIME_STOP, oManifester);

        // Apply the VFX impact and effects
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oManifester, fDuration);
        // Delayed a bit to let the VFX start
        DelayCommand(0.75f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTStop, oManifester, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel));
    }// end if - Successfull manifestation
}
