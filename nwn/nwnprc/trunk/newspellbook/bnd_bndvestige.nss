#include "bnd_inc_bndfunc"
#include "inc_dynconv"

void main()
{
	object oBinder = OBJECT_SELF;
	// If we have room to bind another vestige
	if (GetMaxVestigeCount(oBinder) > GetBindCount(oBinder))
	{
    	AssignCommand(oBinder, ClearAllActions(TRUE));
    	StartDynamicConversation("bnd_bindingcnv", oBinder, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, TRUE, oBinder);   
    }
    else
    	FloatingTextStringOnCreature("You have bound the maximum number of vestiges allowed", oBinder, FALSE);
}
