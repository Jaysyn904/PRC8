#include "moi_inc_moifunc" 
#include "inc_dynconv"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("moi_soulborn running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oMeldshaper;
    switch(nEvent)
    {
        case EVENT_ONPLAYERREST_FINISHED:   oMeldshaper = GetLastBeingRested();      break;
        case EVENT_ONCLIENTENTER:           oMeldshaper = GetEnteringObject();       break;

        default:
            oMeldshaper = OBJECT_SELF;
    }
    int nClass = GetLevelByClass(CLASS_TYPE_SOULBORN, oMeldshaper);
    object oSkin = GetPCSkin(oMeldshaper);

	if (!GetLocalInt(oMeldshaper, "SoulbornDelay"))
	{
		SetLocalInt(oMeldshaper, "SoulbornDelay", TRUE);
		DelayCommand(0.1, DeleteLocalInt(oMeldshaper, "SoulbornDelay"));
	    // We aren't being called from any event, instead from EvalPRCFeats
	    if(nEvent == FALSE)
	    {
	        // Add eventhook to OnRestFinished to reset the used marker
	        if (nClass >= 4) 
	        {
	        	AddEventScript(oMeldshaper, EVENT_ONPLAYERREST_FINISHED, "moi_soulborn", TRUE, FALSE); 
	        	AddEventScript(oMeldshaper, EVENT_ONPLAYEREQUIPITEM,     "moi_soulborn", TRUE, FALSE);
	        }
	        if (nClass >= 2) 
	        {
	        	object oSkin = GetPCSkin(oMeldshaper);
				if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD)
					IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_FEAR), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, TRUE);
				if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD)
					IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, TRUE);	
				if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL)	
					SetLocalInt(oMeldshaper, "IncarnumDefenseLE", TRUE);
				if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL)
	        		SetLocalInt(oMeldshaper, "IncarnumDefenseCE", TRUE);
	        }
	    }
	    else if(nEvent == EVENT_ONPLAYERREST_FINISHED && (PRCGetIsAliveCreature(oMeldshaper)|| GetHasFeat(FEAT_UNDEAD_MELDSHAPER, oMeldshaper)))    
	    {
	    	ClearMeldShapes(oMeldshaper);
	        AssignCommand(oMeldshaper, ClearAllActions(TRUE));
	        SetLocalInt(oMeldshaper, "MeldshapeClass", CLASS_TYPE_SOULBORN);
	        StartDynamicConversation("moi_meldshapecnv", oMeldshaper, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oMeldshaper);
	    }    
	    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
	    {
	        oMeldshaper   = GetItemLastEquippedBy();
	        ChakraBindUnequip(oMeldshaper, GetItemLastEquipped());
	    }    
	}    
}
