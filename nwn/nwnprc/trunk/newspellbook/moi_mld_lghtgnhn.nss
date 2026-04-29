/*
Lightning Gauntlets Hands Bind

Your lightning gauntlets settle firmly around your hands. When you grip a weapon, electricity courses up its length and crackles at its tip. A lingering scent of ozone clings to you.

You can add the electricity damage dealt by lightning gauntlets to one attack per round made with a handheld weapon. 
*/

#include "moi_inc_moifunc"

void main()  
{  
	int nEvent = GetRunningEvent();  
    object oMeldshaper = OBJECT_SELF;  
    object oItem;  
    int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_LIGHTNING_GAUNTLETS);  
	  
    // We aren't being called from any event, instead from EvalPRCFeats  
    if(nEvent == FALSE)  
    {  
    	if(!TakeMoveAction(oMeldshaper)) return;  
    	oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);  
		IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 60.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
		AddEventScript(oItem, EVENT_ITEM_ONHIT, "moi_mld_lghtgnhn", TRUE, FALSE);  
    }  
    else if(nEvent == EVENT_ITEM_ONHIT)  
    {  
        oItem          = GetSpellCastItem();  
        object oTarget = PRCGetSpellTargetObject();  
        if(DEBUG) DoDebug("moi_mld_lghtgnhn: OnHit:\n"  
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"  
                        + "oItem = " + DebugObject2Str(oItem) + "\n"  
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"  
                          );  
          
        // Check if already used this round  
        if (!GetLocalInt(oMeldshaper, "LightningGauntlets_UsedThisRound"))  
        {  
            // Apply damage  
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(nEssentia+1), DAMAGE_TYPE_ELECTRICAL), oTarget);  
              
            // Mark as used this round  
            SetLocalInt(oMeldshaper, "LightningGauntlets_UsedThisRound", TRUE);  
              
            // Clear the flag at start of next round (6 seconds)  
            DelayCommand(6.0, DeleteLocalInt(oMeldshaper, "LightningGauntlets_UsedThisRound"));  
        }  
          
        // Don't remove the OnHitCastSpell property - let it persist for future rounds  
    }// end if - Running OnHit event	  
}

/* void main()
{
	int nEvent = GetRunningEvent();
    object oMeldshaper = OBJECT_SELF;
    object oItem;
    int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_LIGHTNING_GAUNTLETS);
	
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
    	if(!TakeMoveAction(oMeldshaper)) return;
    	oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);
		IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 60.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		AddEventScript(oItem, EVENT_ITEM_ONHIT, "moi_mld_lghtgnhn", TRUE, FALSE);
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("moi_mld_lghtgnhn: OnHit:\n"
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(nEssentia+1), DAMAGE_TYPE_ELECTRICAL), oTarget);
            // Remove the temporary OnHitCastSpell: Unique
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "moi_mld_lghtgnhn", TRUE, FALSE);       
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);                          
    }// end if - Running OnHit event	
} */

