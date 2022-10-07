/*
    Sudden Recovery.
    Recover one maneuver as an instant action.
*/
#include "tob_inc_tobfunc"
#include "inc_dynconv"
void main()
{
	object oInitiator = OBJECT_SELF;
	AssignCommand(oInitiator, ClearAllActions(TRUE));
    StartDynamicConversation("tob_ft_sdnrcrcnv", oInitiator, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oInitiator);
}