//::///////////////////////////////////////////////
//:: Psionic Hole evaluationscript
//:: psi_psionic_hole
//:://////////////////////////////////////////////
/*
	Depending on where this is being run from,
	either adds itself to be run from OnHit event
	or removes Psionic Focus from the creature
	hitting this.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 23.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

void main()
{
    // Check if we are being run from OnHit
    if(GetRunningEvent() == EVENT_ONHIT)
    {
        object oItem = GetSpellCastItem();
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR ||
           GetBaseItemType(oItem) == BASE_ITEM_CREATUREITEM)
        {
            object oTarget = PRCGetSpellTargetObject();
            LosePsionicFocus(oTarget);
        }
    }
    // We aren't so assume we are being run from EvalPRCFeats
    else
    {
        object oSkin = GetPCSkin(OBJECT_SELF);
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
        
        if(GetIsObjectValid(oArmor))
        {
            IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }
        else
        {
            IPSafeAddItemProperty(oSkin, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }
        
        AddEventScript(OBJECT_SELF, EVENT_ONHIT, "psi_psionic_hole", TRUE, FALSE);
    }
}