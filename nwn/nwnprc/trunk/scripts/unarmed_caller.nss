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
    //PrintString("Executing unarmed_caller");
    int bCont = FALSE;
    if(GetLocalInt(OBJECT_SELF, CALL_UNARMED_FEATS))
    {
        UnarmedFeats(OBJECT_SELF);
        bCont = TRUE;
    }
    if(GetLocalInt(OBJECT_SELF, CALL_UNARMED_FISTS))
    {
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