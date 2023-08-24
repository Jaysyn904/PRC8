#include "inc_dynconv"

void main()
{
	object oMeldshaper = OBJECT_SELF;
	if (GetLocalInt(oMeldshaper, "PerfectMeldshaper")) return;
	if (GetLocalInt(oMeldshaper, "TotemEmbodiment")) return;
	if (GetLocalInt(oMeldshaper, "TotemEmbodiment2")) return;
    AssignCommand(oMeldshaper, ClearAllActions(TRUE));
    StartDynamicConversation("moi_midnightcnv", oMeldshaper, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oMeldshaper);   
}
