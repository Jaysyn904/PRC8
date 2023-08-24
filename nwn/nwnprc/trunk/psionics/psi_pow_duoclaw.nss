/*
   ----------------
   Duodimensional Claw

   psi_pow_duoclaw
   ----------------

   5/11/05 by Stratovarius
*/ /** @file

    Duodimensional Claw

    Psychometabolism
    Level: Psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 5
    Metapsionics: Extend

    If you have a claw attack (either from an actual natural weapon or from an
    effect such as claws of the beast), you can use this power to improve that
    weapon. Your claws become two-dimensional, making them razorsharp. The
    weapon is now psionically keen, doubling it's threat range.
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
        object oLClaw       = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
        object oRClaw       = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
        effect eDur         = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eVis         = EffectVisualEffect(VFX_IMP_PULSE_WIND);
        itemproperty ipKeen = ItemPropertyKeen();
        float fDuration = 600.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Must have claws check
        if(!(GetIsObjectValid(oLClaw) || GetIsObjectValid(oRClaw)))
        {
            // "Target does not posses a claw attack!"
            FloatingTextStrRefOnCreature(16826653, oManifester, FALSE);
            return;
        }

        // Apply the itemproperties
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipKeen, oLClaw, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipKeen, oRClaw, fDuration);

        // Do some VFX
                           SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(1.0f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        DelayCommand(2.0f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
    }// end if - Successfull manifestation
}
