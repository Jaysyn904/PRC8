#include "moi_inc_moifunc" 
#include "inc_dynconv"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("moi_incarnate running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oMeldshaper;
    switch(nEvent)
    {
        case EVENT_ONPLAYERREST_FINISHED:   oMeldshaper = GetLastBeingRested();      break;
        case EVENT_ONCLIENTENTER:           oMeldshaper = GetEnteringObject();       break;

        default:
            oMeldshaper = OBJECT_SELF;
    }
    
	if (!GetLocalInt(oMeldshaper, "IncarnateDelay"))
	{
		SetLocalInt(oMeldshaper, "IncarnateDelay", TRUE);
		DelayCommand(0.1, DeleteLocalInt(oMeldshaper, "IncarnateDelay"));
    	int nClass = GetLevelByClass(CLASS_TYPE_INCARNATE, oMeldshaper);
    	object oSkin = GetPCSkin(oMeldshaper);
	
    	// We aren't being called from any event, instead from EvalPRCFeats
    	if(nEvent == FALSE)
    	{
    		//DoDebug("moi_incarnate Event False");
    	    // Add eventhook to OnRestFinished to reset the used marker
    	    AddEventScript(oMeldshaper, EVENT_ONPLAYERREST_FINISHED, "moi_incarnate", TRUE, TRUE); 
    	    AddEventScript(oMeldshaper, EVENT_ONPLAYEREQUIPITEM,     "moi_incarnate", TRUE, TRUE);
    	}
    	else if(nEvent == EVENT_ONPLAYERREST_FINISHED && IncarnateAlignment(oMeldshaper) && (PRCGetIsAliveCreature(oMeldshaper)|| GetHasFeat(FEAT_UNDEAD_MELDSHAPER, oMeldshaper)))    
    	{
    		ClearMeldShapes(oMeldshaper);
    	    AssignCommand(oMeldshaper, ClearAllActions(TRUE));
    	    SetLocalInt(oMeldshaper, "MeldshapeClass", CLASS_TYPE_INCARNATE);
    	    StartDynamicConversation("moi_meldshapecnv", oMeldshaper, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oMeldshaper);
    	}    
    	else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    	{
    	    oMeldshaper   = GetItemLastEquippedBy();
    	    ChakraBindUnequip(oMeldshaper, GetItemLastEquipped());
    	}
    }	
}
