#include "moi_inc_moifunc" 
#include "inc_dynconv"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("moi_spinemeld running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oMeldshaper;
    switch(nEvent)
    {
        case EVENT_ONPLAYERREST_FINISHED:   oMeldshaper = GetLastBeingRested();      break;
        case EVENT_ONCLIENTENTER:           oMeldshaper = GetEnteringObject();       break;

        default:
            oMeldshaper = OBJECT_SELF;
    }
    int nClass = GetLevelByClass(CLASS_TYPE_SPINEMELD_WARRIOR, oMeldshaper);
    object oSkin = GetPCSkin(oMeldshaper);

	if (!GetLocalInt(oMeldshaper, "SpinemeldDelay"))
	{
		SetLocalInt(oMeldshaper, "SpinemeldDelay", TRUE);
		DelayCommand(0.1, DeleteLocalInt(oMeldshaper, "SpinemeldDelay"));
    	// We aren't being called from any event, instead from EvalPRCFeats
    	if(nEvent == FALSE)
    	{
    	    // Add eventhook to OnRestFinished to reset the used marker
    	    if (nClass >= 3) 
    	    {
    	    	AddEventScript(oMeldshaper, EVENT_ONPLAYERREST_FINISHED, "moi_spinemeld", TRUE, FALSE); 
    	    	AddEventScript(oMeldshaper, EVENT_ONPLAYEREQUIPITEM,     "moi_spinemeld", TRUE, FALSE);
    	    }
    	    if (nClass >= 2) 
				SetCompositeBonus(oSkin, "SpinemeldLore", nClass/2, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE); 
    	}
    	else if(nEvent == EVENT_ONPLAYERREST_FINISHED && (PRCGetIsAliveCreature(oMeldshaper)|| GetHasFeat(FEAT_UNDEAD_MELDSHAPER, oMeldshaper)))    
    	{
    		ClearMeldShapes(oMeldshaper);
    	    AssignCommand(oMeldshaper, ClearAllActions(TRUE));
    	    SetLocalInt(oMeldshaper, "MeldshapeClass", CLASS_TYPE_SPINEMELD_WARRIOR);
    	    StartDynamicConversation("moi_meldshapecnv", oMeldshaper, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oMeldshaper);
    	}    
    	else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    	{
    	    oMeldshaper   = GetItemLastEquippedBy();
    	    ChakraBindUnequip(oMeldshaper, GetItemLastEquipped());
    	}    
    }	
}
