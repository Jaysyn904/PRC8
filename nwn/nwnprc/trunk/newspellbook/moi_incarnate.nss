#include "moi_inc_moifunc" 
#include "inc_dynconv"
#include "prc_nui_moi_cst"

// Add this function to handle delayed processing  
void DelayedChakraBindUnequip(object oMeldshaper, object oItem)  
{  
    // Check if we're still in a valid state  
    if(GetIsObjectValid(oMeldshaper) && GetIsObjectValid(oItem))  
    {  
        ChakraBindUnequip(oMeldshaper, oItem);  
    }  
}

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
		case EVENT_ONPLAYEREQUIPITEM:		oMeldshaper = GetItemLastEquippedBy();   break;

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
	    // Older builds allowed this permanent hook to duplicate on every feat
	    // rebuild.  Remove all legacy copies, then install one canonical hook.
	    RemoveEventScript(oMeldshaper, EVENT_ONPLAYERREST_FINISHED, "moi_incarnate", TRUE);
	    RemoveEventScript(oMeldshaper, EVENT_ONPLAYEREQUIPITEM,     "moi_incarnate", TRUE);
	    AddEventScript(oMeldshaper, EVENT_ONPLAYERREST_FINISHED, "moi_incarnate", TRUE, FALSE); 
	    AddEventScript(oMeldshaper, EVENT_ONPLAYEREQUIPITEM,     "moi_incarnate", TRUE, FALSE);
	}
     else if(nEvent == EVENT_ONPLAYERREST_FINISHED && nClass > 0 && IncarnateAlignment(oMeldshaper) && (PRCGetIsAliveCreature(oMeldshaper)|| GetHasFeat(FEAT_UNDEAD_MELDSHAPER, oMeldshaper)))    
     {
	    	if (GetPersistantLocalInt(oMeldshaper, PRC_MOI_LOADOUT_VERSION_VAR)
	    	    != PRC_MOI_LOADOUT_VERSION
	    	    || GetLocalInt(oMeldshaper, PRC_MOI_LOADOUT_REST_GENERATION_VAR)
	    	        != GetLocalInt(oMeldshaper, PRC_Rest_Generation))
	    	{
	    	    ClearMeldShapes(oMeldshaper);
	    	    AssignCommand(oMeldshaper, ClearAllActions(TRUE));
	    	    SetLocalInt(oMeldshaper, "MeldshapeClass", CLASS_TYPE_INCARNATE);
	    	    StartDynamicConversation("moi_meldshapecnv", oMeldshaper, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oMeldshaper);
	    	}
     	}	
    	else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    	{
    	    oMeldshaper   = GetItemLastEquippedBy();
    	    ChakraBindUnequip(oMeldshaper, GetItemLastEquipped());
    	}
    }	
}
