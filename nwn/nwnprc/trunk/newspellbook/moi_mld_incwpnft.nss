/*
Incarnate Weapon Arms Bind

Bands of steel form around your forearms. When you hold your incarnate weapon, a chain of nearly invisible blue incarnum connects it to the steel bracer on your 
weapon hand, channeling the force of your conviction directly to your weapon.

As a move action, you can charge the incarnate weapon with the stunning power of pure conviction. If the next melee attack that you make is successful, 
the target (as long as at least one component of its alignment is opposed to your devoted alignment) must succeed on a 
Fortitude saving throw or be stunned for one round. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 19:24:41
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    int nEvent = GetRunningEvent();  
    object oMeldshaper = OBJECT_SELF;  
    object oItem;  
    int nMeldId = MELD_INCARNATE_WEAPON;  
  
    // We aren't being called from any event, instead from EvalPRCFeats  
    if(nEvent == FALSE)  
    {  
        // Check if bound to Arms chakra (regular or double)  
        int nBoundToArms = FALSE;  
        if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_ARMS)) == nMeldId ||  
            GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_ARMS)) == nMeldId)  
            nBoundToArms = TRUE;  
  
        if (!nBoundToArms) return; // Exit if not bound to Arms  
  
        if(!TakeMoveAction(oMeldshaper)) return;  
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);  
        itemproperty ip = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);  
        ip = TagItemProperty(ip, "moi_IncarnateWeaponCharge");  
        IPSafeAddItemProperty(oItem, ip, 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
        AddEventScript(oItem, EVENT_ITEM_ONHIT, "moi_mld_incwpnft", TRUE, FALSE);  
    }  
    else if(nEvent == EVENT_ITEM_ONHIT)  
    {  
        oItem          = GetSpellCastItem();  
        object oTarget = PRCGetSpellTargetObject();  
        if(DEBUG) DoDebug("moi_mld_incwpnft: OnHit:\n"  
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"  
                        + "oItem = " + DebugObject2Str(oItem) + "\n"  
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"  
                          );  
        // Validate bind state on hit as well  
        int nBoundToArms = FALSE;  
        if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_ARMS)) == nMeldId ||  
            GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_ARMS)) == nMeldId)  
            nBoundToArms = TRUE;  
  
        if (!nBoundToArms) return;  
  
        if (GetAlignmentLawChaos(oMeldshaper) != GetAlignmentLawChaos(oTarget) || GetAlignmentGoodEvil(oMeldshaper) != GetAlignmentGoodEvil(oTarget))  
        {  
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetMeldshaperDC(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_INCARNATE_WEAPON), SAVING_THROW_TYPE_NONE))  
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 6.0);  
        }  
        // Remove the temporary OnHitCastSpell: Unique by tag  
        RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "moi_mld_incwpnft", TRUE, FALSE);  
        itemproperty ipCheck = GetFirstItemProperty(oItem);  
        while (GetIsItemPropertyValid(ipCheck))  
        {  
            if (GetItemPropertyTag(ipCheck) == "moi_IncarnateWeaponCharge")  
                RemoveItemProperty(oItem, ipCheck);  
            ipCheck = GetNextItemProperty(oItem);  
        }  
    }  
}

/* void main()
{
	int nEvent = GetRunningEvent();
    object oMeldshaper = OBJECT_SELF;
    object oItem;
	
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
    	if(!TakeMoveAction(oMeldshaper)) return;
    	oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);
		IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		AddEventScript(oItem, EVENT_ITEM_ONHIT, "moi_mld_incwpnft", TRUE, FALSE);
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("moi_mld_incwpnft: OnHit:\n"
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );
		if (GetAlignmentLawChaos(oMeldshaper) != GetAlignmentLawChaos(oTarget) || GetAlignmentGoodEvil(oMeldshaper) != GetAlignmentGoodEvil(oTarget))
		{
			if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetMeldshaperDC(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_INCARNATE_WEAPON), SAVING_THROW_TYPE_NONE))
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 6.0);
		}
            // Remove the temporary OnHitCastSpell: Unique
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "moi_mld_incwpnft", TRUE, FALSE);       
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);                          
    }// end if - Running OnHit event	
} */

