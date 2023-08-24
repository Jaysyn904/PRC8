//:://////////////////////////////////////////////
//:: Dynamic Conversation: End conversation
//:: dynconv_end
//:://////////////////////////////////////////////
/** @file
    Run when the PC exits the conversation via
    the exit node.

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


void main()
{
    object oPC = GetPCSpeaker();

    // Run the exit handler
    _DynConvInternal_ExitedConvo(oPC, FALSE);
}
