/*
    As a swift action, you can recover any 
    expended maneuver by expending your 
    psionic focus and spending power points 
    equal to the maneuver's level.
*/

#include "inc_dynconv"
#include "psi_inc_psifunc"

void main()
{
    object oInitiator = OBJECT_SELF;
    if(!UsePsionicFocus(oInitiator))
    {
        SendMessageToPC(oInitiator, "You must be psionically focused to use this feat");
        return;
    }
    
	AssignCommand(oInitiator, ClearAllActions(TRUE));
    StartDynamicConversation("tob_ft_renewcnv", oInitiator, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oInitiator);
}