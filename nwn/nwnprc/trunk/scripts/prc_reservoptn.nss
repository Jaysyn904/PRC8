//Spell script for reserve feat Face-Changer Convo
//prc_reservoptn
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

//#include "prc_inc_shifting"
#include "inc_dynconv"
#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    
    SetLocalInt(oPC, "ChangeShapeConfig", GetSpellId());
    
    StartDynamicConversation("prc_chngshp_conv", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, oPC);
}