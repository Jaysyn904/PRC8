//:://////////////////////////////////////////////
//:: Dynamic Conversation: Show header node
//:: dynconv_main_w
//:://////////////////////////////////////////////
/** @file
    Determines whether to show the "NPC" response
    text or the wait node.

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if(GetLocalInt(oPC, "DynConv_Waiting"))
        return FALSE;
    _DynConvInternal_RunScript(oPC, DYNCONV_SETUP_STAGE);
    if(GetLocalInt(oPC, "DynConv_Waiting")                              ||
       GetLocalInt(oPC, "DynConv_AllowExit") == DYNCONV_EXIT_FORCE_EXIT
       )
        return FALSE;
    return TRUE;
}
