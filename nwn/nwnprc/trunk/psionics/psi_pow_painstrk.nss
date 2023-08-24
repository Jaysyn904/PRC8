/*
   ----------------
   Painful Strike

   psi_pow_painstrk
   ----------------

   5/11/05 by Stratovarius
*/ /** @file

    Painful Strike

    Psychometabolism
    Level: Psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level
    Power Points: 3
    Metapsionics: Extend

    Your natural weapons cause additional pain. Each successful attack you make
    with a natural weapon deals an extra 1d4 points of bludgeoning damage to the target.
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
        object oLClaw      = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
        object oRClaw      = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
        object oBite       = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
        effect eDur        = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eVis        = EffectVisualEffect(VFX_IMP_PULSE_WATER);
        itemproperty ipDam = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d4);
        float fDuration    = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Must have a natural attack
        if(!(GetIsObjectValid(oLClaw) || GetIsObjectValid(oRClaw) || GetIsObjectValid(oBite)))
        {
            // "Target does not posses a natural attack!"
            FloatingTextStrRefOnCreature(16826656, oManifester, FALSE);
            return;
        }

        // Apply the itemproperties
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipDam, oLClaw, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipDam, oRClaw, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipDam, oBite,  fDuration);

        // Do some VFX
                           SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(1.0f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        DelayCommand(2.0f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
    }// end if - Successfull manifestation
}