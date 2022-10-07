//:://////////////////////////////////////////////
//:: Dynamic Conversation: Show wait node?
//:: dynconv_end
//:://////////////////////////////////////////////
/** @file
    Determines whether to show the wait node. The
    waiting feature is used if the conversation
    is being built in several steps instead of
    at once.

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if(GetLocalInt(oPC, "DynConv_Waiting"))
        return TRUE;
    return FALSE;
}
