//:://////////////////////////////////////////////
//:: Truenaming Crafted Tool Conversation
//:: true_ct_target
//:://////////////////////////////////////////////
/** @file
    This allows you to pick the target for the Crafted Tool utterances


    @author Stratovarius
    @date   Created  - 5.8.2006
*/
//:://////////////////////////////////////////////

//#include "prc_alterations"
#include "inc_dynconv"

void main()
{
	StartDynamicConversation("true_ct_target", OBJECT_SELF, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, OBJECT_SELF);
}
