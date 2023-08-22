//:://////////////////////////////////////////////
//:: Shifter - Start options conversation
//:: pnp_shft_options
//:://////////////////////////////////////////////
/** @file
    Starts the Shifter Options dynamiv conversation.


    @author Shane Hennessy
    @date   Modified - 2006.10.08 - rewritten by Ornedan
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//#include "prc_inc_shifting"
#include "inc_dynconv"
#include "prc_inc_shifting"


void main()
{
    object oPC = OBJECT_SELF;
    StartDynamicConversation("prc_shift_convo", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, oPC);
}