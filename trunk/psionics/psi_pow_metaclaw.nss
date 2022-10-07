/*
   ----------------
   Metaphysical Claw

   psi_pow_metaclaw
   ----------------

   29/10/05 by Stratovarius
*/ /** @file

    Metaphysical Claw

    Psychometabolism
    Level: Psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 1
    Metapsionics: Extend

    If you have a claw attack (either from an actual natural weapon or from an
    effect such as claws of the beast) or a bite attack (which could be a
    natural bite attack or one you gain by means of the power bite of the wolf),
    you can use this power to provide your natural weapons a +1 enhancement
    bonus on attack rolls and damage rolls.

    Augment: If you spend 4 additional power points, this power’s duration
             increases to 1 hour per level.
             In addition, for every 4 additional power points you spend, this
             power improves the natural weapon’s enhancement bonus on attack
             rolls and damage rolls by 1.
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
                              PowerAugmentationProfile(4,
                                                       4, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nBonus           = 1 + manif.nTimesAugOptUsed_1;
        object oLClaw        = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
        object oRClaw        = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
        object oBite         = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
        effect eDur          = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eVis          = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
        itemproperty ipBonus = ItemPropertyEnhancementBonus(nBonus);
        float fDuration      = (manif.nTimesAugOptUsed_1 == 0 ? 60.0f : HoursToSeconds(1)) * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Must have a natural attack
        if(!(GetIsObjectValid(oLClaw) || GetIsObjectValid(oRClaw) || GetIsObjectValid(oBite)))
        {
            // "Target does not posses a natural attack!"
            FloatingTextStrRefOnCreature(16826656, oManifester, FALSE);
            return;
        }

        // Add the enhancement bonus
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipBonus, oLClaw, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipBonus, oRClaw, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipBonus, oBite,  fDuration);

        // Do VFX
                          SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDur, oTarget, fDuration);
    }// end if - Successfull manifestation
}
