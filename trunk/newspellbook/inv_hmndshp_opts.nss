//:://////////////////////////////////////////////
//:: Humanoid Shape - Start options conversation
//:: inv_hmndshp_opts
//:://////////////////////////////////////////////
/** @file
    Starts the Change Shape Options dynamiv conversation.


    @author Shane Hennessy
    @date   Modified - 2006.10.08 - rewritten by Ornedan - modified by Fox
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "inv_inc_invfunc"
#include "inv_invokehook"


void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook

    object oPC = OBJECT_SELF;
    
    SetLocalInt(oPC, "ChangeShapeConfig", GetSpellId());

    StartDynamicConversation("prc_chngshp_conv", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, oPC);
}