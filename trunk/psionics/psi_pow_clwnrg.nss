/*
   ----------------
   Claw of Energy

   psi_pow_clwnrg
   ----------------

   5/11/05 by Stratovarius
*/ /** @file

    Claw of Energy

    Psychokinesis [see text]
    Level: Psychic warrior 4
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level
    Power Points: 7
    Metapsionics: Extend

    If you have a claw attack (either from an actual natural weapon or from an
    effect such as claws of the beast), you can use this power to energize that
    weapon. The claw attack deals an extra 1d8 points of cold, electricity, or
    fire damage (as chosen by you at the time of manifestation) on a successful
    hit.

    If this power is manifested on a claw attack already benefiting from the
    effect of the power, the newer manifestation supersedes the older
    manifestation, even if both manifestations are of different energy types.

    This power’s subtype is the same as the type of energy infused in the
    natural weapon.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

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
        int nDamageType;
        object oLClaw   = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
        object oRClaw   = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
        effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eVis;
        float fDuration = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Must have claws check
        if(!(GetIsObjectValid(oLClaw) || GetIsObjectValid(oRClaw)))
        {
            // "Target does not posses a claw attack!"
            FloatingTextStrRefOnCreature(16826653, oManifester, FALSE);
            return;
        }

        // Remove previous Claw of Energy, if any
        RemoveSpecificProperty(oLClaw, ITEM_PROPERTY_DAMAGE_BONUS, -1, IP_CONST_DAMAGEBONUS_1d8, 1, "", -1, DURATION_TYPE_TEMPORARY);
        RemoveSpecificProperty(oRClaw, ITEM_PROPERTY_DAMAGE_BONUS, -1, IP_CONST_DAMAGEBONUS_1d8, 1, "", -1, DURATION_TYPE_TEMPORARY);

        // Determine damage type and VFX
        switch(manif.nSpellID)
        {
            case POWER_CLAW_ENERGY_COLD:
                nDamageType = IP_CONST_DAMAGETYPE_COLD;
                eVis        = EffectVisualEffect(VFX_IMP_PULSE_COLD);
                break;
            case POWER_CLAW_ENERGY_ELEC:
                nDamageType = IP_CONST_DAMAGETYPE_ELECTRICAL;
                eVis        = EffectVisualEffect(VFX_IMP_PULSE_WIND);
                break;
            case POWER_CLAW_ENERGY_FIRE:
                nDamageType = IP_CONST_DAMAGETYPE_FIRE;
                eVis        = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
                break;

            default:{
                string sErr = "psi_pow_clwnrg: ERROR: Unknown spellID: " + IntToString(manif.nSpellID);
                if(DEBUG) { DoDebug(sErr); Die(); }
                else      WriteTimestampedLogEntry(sErr);
            }
        }

        // Apply the itemproperties
        itemproperty ipClaw = ItemPropertyDamageBonus(nDamageType, IP_CONST_DAMAGEBONUS_1d8);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipClaw, oLClaw, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipClaw, oRClaw, fDuration);

        // Do some VFX
                           SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(1.0f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        DelayCommand(2.0f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
    }// end if - Successfull manifestation
}
