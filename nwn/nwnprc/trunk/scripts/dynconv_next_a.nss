//:://////////////////////////////////////////////
//:: Dynamic Conversation: Next choices
//:: dynconv_next_a
//:://////////////////////////////////////////////
/** @file
    Scrolls the choice list forward by 10.

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


void main()
{
    object oPC = GetPCSpeaker();
    int nOffset = GetLocalInt(oPC, DYNCONV_CHOICEOFFSET) + 10;
    SetLocalInt(oPC, DYNCONV_CHOICEOFFSET, nOffset);
}

