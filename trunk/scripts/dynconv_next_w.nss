//:://////////////////////////////////////////////
//:: Dynamic Conversation: Show next choices node?
//:: dynconv_next_w
//:://////////////////////////////////////////////
/** @file
    Determines whether there are more entries to
    show.

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nOffset = GetLocalInt(oPC, DYNCONV_CHOICEOFFSET);
    if(nOffset + 10 < array_get_size(oPC, "ChoiceTokens"))
        return TRUE;
    else
        return FALSE;
}

