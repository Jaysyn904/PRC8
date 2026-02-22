#include "moi_inc_moifunc" 
#include "inc_dynconv"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("moi_totemist running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oMeldshaper;
    switch(nEvent)
    {
        case EVENT_ONPLAYERREST_FINISHED:   oMeldshaper = GetLastBeingRested();      break;
        case EVENT_ONCLIENTENTER:           oMeldshaper = GetEnteringObject();       break;

        default:
            oMeldshaper = OBJECT_SELF;
    }
    int nClass = GetLevelByClass(CLASS_TYPE_TOTEMIST, oMeldshaper);    

	if (!GetLocalInt(oMeldshaper, "TotemistDelay"))
	{
		SetLocalInt(oMeldshaper, "TotemistDelay", TRUE);
		DelayCommand(0.1, DeleteLocalInt(oMeldshaper, "TotemistDelay"));
	    // We aren't being called from any event, instead from EvalPRCFeats
	    if(nEvent == FALSE)
	    {
	        object oSkin = GetPCSkin(oMeldshaper);
			
			// Add eventhook to OnRestFinished to reset the used marker
	        AddEventScript(oMeldshaper, EVENT_ONPLAYERREST_FINISHED, "moi_totemist", TRUE, FALSE); 
	        AddEventScript(oMeldshaper, EVENT_ONPLAYEREQUIPITEM,     "moi_totemist", TRUE, FALSE);
	    }
	    else if(nEvent == EVENT_ONPLAYERREST_FINISHED && (PRCGetIsAliveCreature(oMeldshaper)|| GetHasFeat(FEAT_UNDEAD_MELDSHAPER, oMeldshaper)))    
	    {
	    	ClearMeldShapes(oMeldshaper);
	        AssignCommand(oMeldshaper, ClearAllActions(TRUE));
	        SetLocalInt(oMeldshaper, "MeldshapeClass", CLASS_TYPE_TOTEMIST);
	        StartDynamicConversation("moi_meldshapecnv", oMeldshaper, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oMeldshaper);
	    }    
		else if(nEvent == EVENT_ONPLAYEREQUIPITEM)  
		{  
			oMeldshaper = GetItemLastEquippedBy();  
			if (!GetIsObjectValid(oMeldshaper) || GetObjectType(oMeldshaper) != OBJECT_TYPE_CREATURE) return;  
			ChakraBindUnequip(oMeldshaper, GetItemLastEquipped());  
		} 
	}    
}
