#include "inc_dynconv"

void main()
{
	object oBinder = OBJECT_SELF;
   	AssignCommand(oBinder, ClearAllActions(TRUE));
   	StartDynamicConversation("bnd_expelcnv", oBinder, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, TRUE, oBinder);   
}
