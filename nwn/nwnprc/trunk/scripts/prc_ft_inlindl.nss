//::///////////////////////////////////////////////
//:: Name      Inlindl School
//:: FileName  prc_ft_inlindl.nss
//:://////////////////////////////////////////////
/** You can choose to sacrifice your shield bonus 
to AC in exchange for a bonus on melee attack rolls 
equal to one-half that bonus. This bonus applies 
only on attacks made with light weapons.

Author:    Stratovarius
Created:   12.11.2018
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oInitiator = OBJECT_SELF;
    int nSwitch = GetLocalInt(oInitiator, "InlindlSchool");
    
    if (nSwitch == TRUE)
    {
        FloatingTextStringOnCreature("Deactivating Inlindl School", oInitiator, FALSE);
        DeleteLocalInt(oInitiator, "InlindlSchool");
        PRCRemoveEffectsFromSpell(oInitiator, GetSpellId());
    }
    else
    {
        FloatingTextStringOnCreature("Activating Inlindl School", oInitiator, FALSE);
        SetLocalInt(oInitiator, "InlindlSchool", TRUE);
        int nShield = GetItemACValue(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator));
        effect eLink = EffectLinkEffects(EffectACDecrease(nShield), EffectAttackIncrease(nShield/2));
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ARMOR_OF_DARKNESS));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oInitiator, 6.0);         
    }
}

