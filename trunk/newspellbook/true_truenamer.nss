/*
   ----------------
   Truenamer Passives
   
   true_truenamer
   ----------------

   4/9/06 by Stratovarius
*/ /** @file

   Gives him the +3 (or greater) Lore bonus at the appropriate levels.
*/

#include "true_inc_trufunc"
#include "inc_dynconv"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("true_truenamer running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
        case EVENT_ONPLAYERREST_FINISHED:   oPC = GetLastBeingRested();      break;

        default:
            oPC = OBJECT_SELF;
    }
    object oSkin = GetPCSkin(oPC);
    int nClass = GetLevelByClass(CLASS_TYPE_TRUENAMER, oPC);
    int nLore;
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {    
        // Add eventhook to OnRestFinished to reset the used marker
        AddEventScript(oPC, EVENT_ONPLAYERREST_FINISHED, "true_truenamer", FALSE, FALSE);    
	    if (nClass >= 14) nLore = 12;
	    else if (nClass >= 10 && nClass < 14) nLore = 9;
	    else if (nClass >= 7 && nClass < 10) nLore = 6;
	    else if (nClass >= 2 && nClass < 7) nLore = 3;
    
    	SetCompositeBonus(oSkin, "TruenamerLore", nLore, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
    }
    else if(nEvent == EVENT_ONPLAYERREST_FINISHED)    
    {
    	if ((!GetPersistantLocalInt(oPC, "SilverTongueLesser") && GetGold(oPC) >= 2500) || (!GetPersistantLocalInt(oPC, "SilverTongueGreater") && GetGold(oPC) >= 10000))
    	{
        	AssignCommand(oPC, ClearAllActions(TRUE));
        	StartDynamicConversation("true_tru_silver", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);
        }	
    }     
}
