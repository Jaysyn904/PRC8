#include "prc_inc_factotum" 
#include "inc_dynconv"

//:: Moved to prc_inc_factotum --Jaysyn
/* void TriggerInspiration(object oPC, int nCombat);

void TriggerInspiration(object oPC, int nCombat)
{
	SetLocalInt(oPC, "InspirationHBRunning", TRUE);
	DelayCommand(0.249, DeleteLocalInt(oPC, "InspirationHBRunning"));
	int nCurrent = GetIsInCombat(oPC);
	// We just entered combat
	if (nCurrent == TRUE && nCombat == FALSE)
		SetInspiration(oPC);
	else if (nCurrent == FALSE && nCombat == TRUE) // Just left combat
		ClearInspiration(oPC);
 
    DelayCommand(0.25, TriggerInspiration(oPC, nCurrent));
}
 */
void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_factotum running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
        case EVENT_ONPLAYERREST_FINISHED:   oPC = GetLastBeingRested();      break;
        case EVENT_ONCLIENTENTER:           oPC = GetEnteringObject();       break;

        default:
            oPC = OBJECT_SELF;
    }
    int nClass = GetLevelByClass(CLASS_TYPE_FACTOTUM, oPC);
    object oSkin = GetPCSkin(oPC);
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int nArmour = GetBaseAC(oArmour);   
    int nBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
    if (nClass >= 16 && 3 >= nArmour)
    	SetCompositeBonus(oSkin, "CunningDefense", nBonus, ITEM_PROPERTY_AC_BONUS);  
    else
    	SetCompositeBonus(oSkin, "CunningDefense", 0, ITEM_PROPERTY_AC_BONUS);
    	
    if (nClass >= 3)
    {
    	SetCompositeBonus(oSkin, "BrainOverBrawn_H", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    	SetCompositeBonus(oSkin, "BrainOverBrawn_M", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
    	SetCompositeBonus(oSkin, "BrainOverBrawn_O", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_OPEN_LOCK);
    	SetCompositeBonus(oSkin, "BrainOverBrawn_P", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_PICK_POCKET);
    	SetCompositeBonus(oSkin, "BrainOverBrawn_S", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_SET_TRAP);
    	SetCompositeBonus(oSkin, "BrainOverBrawn_T", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_TUMBLE);
    	SetCompositeBonus(oSkin, "BrainOverBrawn_R", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_RIDE);
    	SetCompositeBonus(oSkin, "BrainOverBrawn_J", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
    	SetCompositeBonus(oSkin, "BrainOverBrawn_B", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_BALANCE);
    	SetCompositeBonus(oSkin, "BrainOverBrawn_C", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_CLIMB);
    }

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Add eventhook to OnRestFinished to reset the used marker
        AddEventScript(oPC, EVENT_ONPLAYERREST_FINISHED, "prc_factotum", FALSE, FALSE);
        if (!GetLocalInt(oPC, "InspirationHBRunning")) DeleteLocalInt(oPC, "InspirationHB");
        if (!GetLocalInt(oPC, "InspirationHB") && !GetLocalInt(oPC, "InspirationHBRunning")) 
        {
            TriggerInspiration(oPC, FALSE);
            SetLocalInt(oPC, "InspirationHB", TRUE);
        }         	
    }
    else if(EVENT_ONCLIENTENTER)
	{
		if(GetLevelByClass(CLASS_TYPE_FACTOTUM, oPC) > 0)
		{
			DeleteLocalInt(oPC, "InspirationHB");
			DeleteLocalInt(oPC, "InspirationHBRunning");
			TriggerInspiration(oPC, FALSE);
			SetLocalInt(oPC, "InspirationHB", TRUE);
		}
	}
    else if(nEvent == EVENT_ONPLAYERREST_FINISHED && nClass >= 2)    
    {
        AssignCommand(oPC, ClearAllActions(TRUE));
        ClearFactotumSlots(oPC);
        SetLocalInt(oPC, "FactotumArcDil", GetMaxArcDilSpellLevel(oPC));
        StartDynamicConversation("prc_fact_splconv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);
    }    
}
