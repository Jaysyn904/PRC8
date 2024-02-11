#include "moi_inc_moifunc" 
#include "inc_dynconv"

void main()
{
	object oMeldshaper = OBJECT_SELF;
	if (GetLocalInt(oMeldshaper, "PerfectMeldshaper")) return;
	if (GetLocalInt(oMeldshaper, "TotemEmbodiment")) return;
	if (GetLocalInt(oMeldshaper, "TotemEmbodiment2")) return;
    AssignCommand(oMeldshaper, ClearAllActions(TRUE));
    StartDynamicConversation("moi_essentiacnv", oMeldshaper, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, TRUE, oMeldshaper);   
}
