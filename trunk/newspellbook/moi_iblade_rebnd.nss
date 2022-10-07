#include "moi_inc_moifunc" 
#include "inc_dynconv"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    AssignCommand(oMeldshaper, ClearAllActions(TRUE));
    StartDynamicConversation("moi_iblade_bind", oMeldshaper, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, TRUE, oMeldshaper);   
}
