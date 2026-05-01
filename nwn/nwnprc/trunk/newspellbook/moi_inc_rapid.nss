#include "moi_inc_moifunc"   
#include "inc_dynconv"  

// Stage constant for Rapid Meldshaping  
const int STAGE_SELECT_UNSHAPE_MELD = 3;  

void main()  
{  
    object oMeldshaper = OBJECT_SELF;  
    if (GetLocalInt(oMeldshaper, "PerfectMeldshaper")) return;  
    AssignCommand(oMeldshaper, ClearAllActions(TRUE));  
    SetLocalInt(oMeldshaper, "RapidMeldshaping", GetSpellId());  
      
    // Set the initial stage for unshape selection  
    SetStage(STAGE_SELECT_UNSHAPE_MELD, oMeldshaper);  
      
    StartDynamicConversation("moi_inc_rpdcnv", oMeldshaper, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oMeldshaper);     
}

/* #include "moi_inc_moifunc" 
#include "inc_dynconv"

void main()
{
	object oMeldshaper = OBJECT_SELF;
	if (GetLocalInt(oMeldshaper, "PerfectMeldshaper")) return;
    AssignCommand(oMeldshaper, ClearAllActions(TRUE));
    SetLocalInt(oMeldshaper, "RapidMeldshaping", GetSpellId());
    StartDynamicConversation("moi_inc_rpdcnv", oMeldshaper, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oMeldshaper);   
} */
