//:://////////////////////////////////////////////
//:: Teleport options dialog starter
//:: prc_telp_odlg_s
//:://////////////////////////////////////////////
/** @file
    This script starts the Teleport Options dynamic
    conversation.

    @author Ornedan
    @date   Created  - 2005.06.18
    @date   Modified - 2005.09.25
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


void main()
{
    object oPC = OBJECT_SELF;
    StartDynamicConversation("prc_telep_optdlg", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, TRUE, oPC);
}