//:://////////////////////////////////////////////
//:: Dynamic Conversation
//:: dynconv_rep0_w
//:://////////////////////////////////////////////
/** @file
    Checks that there is a valid option for
    conversation choice 0.

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if(GetLocalString(oPC, GetTokenIDString(DYNCONV_TOKEN_REPLY_0)) == "")
        return FALSE;
    else
        return TRUE;
}
