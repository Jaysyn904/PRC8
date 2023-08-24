#include "moi_inc_moifunc"

void IronsoulUnequip(object oMeldshaper, object oItem)
{
    object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oMeldshaper);                  
	if (GetTag(oShield) != ReplaceChars(GetName(oMeldshaper), " ","")) 
	{
	    PRCRemoveSpellEffects(MELD_IRONSOUL_SHIELD, oMeldshaper, oMeldshaper);
	    GZPRCRemoveSpellEffects(MELD_IRONSOUL_SHIELD, oMeldshaper, FALSE);  
	}
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oMeldshaper);                  
	if (GetTag(oArmor) != ReplaceChars(GetName(oMeldshaper), " ","")) 
	{
	    PRCRemoveSpellEffects(MELD_IRONSOUL_ARMOR, oMeldshaper, oMeldshaper);
	    GZPRCRemoveSpellEffects(MELD_IRONSOUL_ARMOR, oMeldshaper, FALSE);  
	}		
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);                  
	if (GetTag(oWeapon) != ReplaceChars(GetName(oMeldshaper), " ","")) 
	{
	    PRCRemoveSpellEffects(MELD_IRONSOUL_WEAPON, oMeldshaper, oMeldshaper);
	    GZPRCRemoveSpellEffects(MELD_IRONSOUL_WEAPON, oMeldshaper, FALSE); 
	    RemoveEventScript(oMeldshaper, EVENT_ONHIT, "moi_ironsoul", TRUE, FALSE);
	}
}		

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("moi_ironsoul running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oMeldshaper;
    object oItem;    
    switch(nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:   oMeldshaper = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oMeldshaper = GetItemLastUnequippedBy(); break;

        default:
            oMeldshaper = OBJECT_SELF;
    }

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
    	object oSkin = GetPCSkin(oMeldshaper);
    	int nClass = GetLevelByClass(CLASS_TYPE_IRONSOUL_FORGEMASTER, oMeldshaper);
    	if (nClass >= 3)
    	{
    		SetCompositeBonus(oSkin, "IronsoulCA", nClass, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_ARMOR);
			SetCompositeBonus(oSkin, "IronsoulCW", nClass, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_WEAPON);
		}	
        // Hook in the events, needed from level 1 for Skirmish
        if(DEBUG) DoDebug("moi_ironsoul: Adding eventhooks");
        AddEventScript(oMeldshaper, EVENT_ONPLAYEREQUIPITEM,   "moi_ironsoul", TRUE, FALSE);
        AddEventScript(oMeldshaper, EVENT_ONPLAYERUNEQUIPITEM, "moi_ironsoul", TRUE, FALSE);
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oMeldshaper's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oMeldshaper   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("moi_ironsoul - OnEquip\n"
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );
        //FloatingTextStringOnCreature("Equipped Item Tag is "+GetTag(oItem), oMeldshaper);                
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oMeldshaper's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oMeldshaper   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("moi_ironsoul - OnUnEquip\n"
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );
		DelayCommand(0.1, IronsoulUnequip(oMeldshaper, oItem));	
		RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, -1, "", -1, DURATION_TYPE_TEMPORARY); 		
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("moi_ironsoul: OnHit:\n"
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );
        int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_IRONSOUL_WEAPON);                  
		if (PRCGetIsAliveCreature(oTarget) && nEssentia) 
		{
			int nDC = 10 + GetAbilityModifier(ABILITY_CONSTITUTION, oMeldshaper) + nEssentia;
			if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oTarget, 6.0);
			}
		}	
    }// end if - Running OnHit event    
}
