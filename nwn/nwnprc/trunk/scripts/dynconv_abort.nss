//:://////////////////////////////////////////////
//:: Dynamic Conversation: Conversation aborted
//:: dynconv_abort
//:://////////////////////////////////////////////
/** @file
    Run when the conversation is exited through
    being aborted.

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


void main()
{
    object oPC = GetPCSpeaker();

    // Run the exit handler
    _DynConvInternal_ExitedConvo(oPC, TRUE);
}
