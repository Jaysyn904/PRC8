//:://////////////////////////////////////////////
//:: Dynamic Conversation
//:: dynconv_rep1_w
//:://////////////////////////////////////////////
/** @file
    Checks that there is a valid option for
    conversation choice 1.

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if(GetLocalString(oPC, GetTokenIDString(DYNCONV_TOKEN_REPLY_1)) == "")
        return FALSE;
    else
        return TRUE;
}
