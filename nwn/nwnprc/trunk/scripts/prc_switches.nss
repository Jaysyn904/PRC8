//:://////////////////////////////////////////////
//:: PRC Switch manipulation conversation
//:: prc_switches
//:://////////////////////////////////////////////
/** @file
    Starts a dynamic conversation for changing
    values of the PRC switches.


    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


void main()
{
    object oPC = OBJECT_SELF;
    StartDynamicConversation("prc_switchesc", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, oPC);
}
