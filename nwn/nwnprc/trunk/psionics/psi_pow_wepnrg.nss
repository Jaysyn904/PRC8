/** @file psi_pow_wepnrg

    Weapon of Energy

    Psychokinesis [see text]
    Level: Psychic warrior 4
    Range: Touch
    Target: Weapon touched
    Duration: 1 round/level
    Power Points: 7
    Metapsionics: Extend

    You can use this power to energize a weapon. That weapon deals an extra 1d8
    points of cold, electricity, or fire damage (as chosen by you at the time of
    manifestation) on a successful hit.

    If this power is manifested on a already benefiting from the effect of the
    power, the newer manifestation supersedes the older manifestation, even if
    both manifestations are of different energy types.

    This power’s subtype is the same as the type of energy infused in the
    touched weapon.

    @author Stratovarius
    @date   Created: Nov 5, 2005
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_sp_func"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nDamageType;
    effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis;
    float fDuration = 6.0f * manif.nManifesterLevel;
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

    // Remove previous Weapon of Energy, if any
    RemoveSpecificProperty(oTarget, ITEM_PROPERTY_DAMAGE_BONUS, -1, IP_CONST_DAMAGEBONUS_1d8, 1, "", -1, DURATION_TYPE_TEMPORARY);

    // Determine damage type and VFX
    switch(manif.nSpellID)
    {
        case POWER_WEAPON_ENERGY_COLD:
            nDamageType = IP_CONST_DAMAGETYPE_COLD;
            eVis        = EffectVisualEffect(VFX_IMP_PULSE_COLD);
            break;
        case POWER_WEAPON_ENERGY_ELEC:
            nDamageType = IP_CONST_DAMAGETYPE_ELECTRICAL;
            eVis        = EffectVisualEffect(VFX_IMP_PULSE_WIND);
            break;
        case POWER_WEAPON_ENERGY_FIRE:
            nDamageType = IP_CONST_DAMAGETYPE_FIRE;
            eVis        = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
            break;

        default:{
            string sErr = "psi_pow_wepnrg: ERROR: Unknown spellID: " + IntToString(manif.nSpellID);
            if(DEBUG) { DoDebug(sErr); Die(); }
            else      WriteTimestampedLogEntry(sErr);
        }
    }

    // Apply the itemproperties
    itemproperty ipNrg = ItemPropertyDamageBonus(nDamageType, IP_CONST_DAMAGEBONUS_1d8);
    AddItemProperty(DURATION_TYPE_TEMPORARY, ipNrg, oTarget, fDuration);

    // Do some VFX
                       SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
    DelayCommand(1.0f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget)));
    DelayCommand(2.0f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget)));
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oTarget), fDuration);

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