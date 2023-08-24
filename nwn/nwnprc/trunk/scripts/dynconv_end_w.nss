//:://////////////////////////////////////////////
//:: Dynamic Conversation: Show end node?
//:: dynconv_end_w
//:://////////////////////////////////////////////
/** @file
    Determines whether the PC is allowed to see
    the conversation exit node.

    @author Ornedan
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if(GetLocalInt(oPC, "DynConv_AllowExit") == DYNCONV_EXIT_ALLOWED_SHOW_CHOICE)
    	return TRUE;
    else
    	return FALSE;
}
