//:://////////////////////////////////////////////
//:: Start PnP Schools selection conversation
//:: prc_pnp_shcc_s
//:://////////////////////////////////////////////
/** @file
    Starts the 3.5E PnP spell school selection
    conversation.


    @author Ornedan
    @date   Created  - 2005.09.24
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"

void main()
{
	object oPC = OBJECT_SELF;

	StartDynamicConversation("prc_pnp_school", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, TRUE, oPC);
}