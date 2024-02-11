//:://////////////////////////////////////////////
//:: Dynamic Conversation: Show prev choices node?
//:: dynconv_prev_w
//:://////////////////////////////////////////////
/** @file
    Determines whether the list can be scrolled
    backwards anymore.

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nOffset = GetLocalInt(oPC, DYNCONV_CHOICEOFFSET);
    if(nOffset >= 10)
        return TRUE;
    else
        return FALSE;
}
