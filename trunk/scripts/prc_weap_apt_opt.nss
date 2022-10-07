//:://////////////////////////////////////////////
//:: Warblade - Weapon Aptitude
//:: prc_weap_apt
//:://////////////////////////////////////////////
/** @file
    Allows Warblade to chose aptitude weapon.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_feat_const"

void main()
{
    object oPC = OBJECT_SELF;
    StartDynamicConversation("tob_aptitudeconv", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, oPC);
}
