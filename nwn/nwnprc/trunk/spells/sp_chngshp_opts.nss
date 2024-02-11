//:://////////////////////////////////////////////
//:: Change Shape - Start options conversation
//:: prc_chngshp_opts
//:://////////////////////////////////////////////
/** @file
    Starts the Change Shape Options dynamiv conversation.


    @author Shane Hennessy
    @date   Modified - 2006.10.08 - rewritten by Ornedan - modified by Fox
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//#include "prc_inc_shifting"
#include "inc_dynconv"
#include "prc_alterations"
#include "prc_inc_spells"


void main()
{
    
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
	
    object oPC = OBJECT_SELF;
    
    SetLocalInt(oPC, "ChangeShapeConfig", GetSpellId());
    
    StartDynamicConversation("prc_chngshp_conv", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, oPC);
    
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the local integer storing the spellschool name
}