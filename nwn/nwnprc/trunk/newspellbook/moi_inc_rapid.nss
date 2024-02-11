#include "moi_inc_moifunc" 
#include "inc_dynconv"

void main()
{
	object oMeldshaper = OBJECT_SELF;
	if (GetLocalInt(oMeldshaper, "PerfectMeldshaper")) return;
    AssignCommand(oMeldshaper, ClearAllActions(TRUE));
    SetLocalInt(oMeldshaper, "RapidMeldshaping", GetSpellId());
    StartDynamicConversation("moi_inc_rpdcnv", oMeldshaper, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oMeldshaper);   
}
