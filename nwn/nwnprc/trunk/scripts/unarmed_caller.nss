//::///////////////////////////////////////////////
//:: Unarmed handling script
//:: unarmed_caller
//::///////////////////////////////////////////////
/*
    A single calling point for UnarmedFeats() and
    UnarmedFists(). This is called from EvalPRCFeats
    after all scripts that need these two funtions
    called are run.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 15.03.2005
//:://////////////////////////////////////////////

#include "prc_inc_unarmed"

void main()  
{
	if (DEBUG)
	{
		DoDebug("unarmed_caller: FUNCTION STARTED");  
		DoDebug("unarmed_caller: CALL_UNARMED_FEATS = " + IntToString(GetLocalInt(OBJECT_SELF, CALL_UNARMED_FEATS)));  
		DoDebug("unarmed_caller: CALL_UNARMED_FISTS = " + IntToString(GetLocalInt(OBJECT_SELF, CALL_UNARMED_FISTS)));
	}
	
    int bCont = FALSE;  
    if(GetLocalInt(OBJECT_SELF, CALL_UNARMED_FEATS))  
    {  
        if (DEBUG) DoDebug("unarmed_caller: CALLING UnarmedFeats");  
        UnarmedFeats(OBJECT_SELF);  
        bCont = TRUE;  
    }  
    if(GetLocalInt(OBJECT_SELF, CALL_UNARMED_FISTS))  
    {  
        if (DEBUG) DoDebug("unarmed_caller: CALLING UnarmedFists");  
        UnarmedFists(OBJECT_SELF);  
        bCont = TRUE;  
    }
    
    if(bCont)
    {
        DeleteLocalInt(OBJECT_SELF, CALL_UNARMED_FEATS);
        DeleteLocalInt(OBJECT_SELF, CALL_UNARMED_FISTS);
        
        SetLocalInt(OBJECT_SELF, UNARMED_CALLBACK, TRUE);
        ExecuteAllScriptsHookedToEvent(OBJECT_SELF, CALLBACKHOOK_UNARMED);
        DeleteLocalInt(OBJECT_SELF, UNARMED_CALLBACK);
    }
}