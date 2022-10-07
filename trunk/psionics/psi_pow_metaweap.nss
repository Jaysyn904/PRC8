/** @file psi_pow_metaweap

    Metaphysical Weapon

    Metacreativity
    Level: Psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Weapon touched
    Duration: 1 min./level
    Saving Throw: None
    Power Resistance: No
    Power Points: 1
    Metapsionics: Extend

    Metaphysical weapon gives a weapon a +1 enhancement bonus on attack rolls
    and damage rolls.

    Alternatively, you can affect up to 99 arrows, bolts, or bullets. The
    projectiles must be of the same type, and they have to be together (in the
    same stack).

    You can’t manifest this power on most natural weapons, including a psychic
    warrior’s claw strike. This power does work on a weapon brought into being
    by the graft weapon power.

    Augment: If you spend 4 additional power points, this power’s duration
             increases to 1 hour per level.
             In addition, for every 4 additional power points you spend, this
             power improves the weapon’s enhancement bonus on attack rolls and
             damage rolls by 1.

    @author Stratovarius
    @date   Created: Oct 29, 2005
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_sp_func"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nBonus           = 1 + manif.nTimesAugOptUsed_1;
    effect eDur          = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis          = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
    itemproperty ipBonus = ItemPropertyEnhancementBonus(nBonus);
    float fDuration      = (manif.nTimesAugOptUsed_1 == 0 ? 60.0f : HoursToSeconds(1)) * manif.nManifesterLevel;
    if(manif.bExtend) fDuration *= 2;

    // Determine if we targeted a weapon or a creature
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        // It's a creature, target their primary weapon
        oTarget = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    }
    // Make sure the target is either weapon or ammo
    if(!(GetWeaponRanged(oTarget) || IPGetIsMeleeWeapon(oTarget) ||
         GetBaseItemType(oTarget) == BASE_ITEM_ARROW ||
         GetBaseItemType(oTarget) == BASE_ITEM_BOLT  ||
         GetBaseItemType(oTarget) == BASE_ITEM_BULLET
       ) )
        oTarget = OBJECT_INVALID;

    // Make sure we have a valid target
    if(!GetIsObjectValid(oTarget))
    {
        // "Target is not a weapon!"
        FloatingTextStrRefOnCreature(16826667, oManifester, FALSE);
        return TRUE;
    }

    // Add the enhancement bonus
    AddItemProperty(DURATION_TYPE_TEMPORARY, ipBonus, oTarget, fDuration);

    // Do VFX
                      SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDur, oTarget, fDuration);

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
                              PowerAugmentationProfile(4,
                                                       4, PRC_UNLIMITED_AUGMENTATION
                                                       ),
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