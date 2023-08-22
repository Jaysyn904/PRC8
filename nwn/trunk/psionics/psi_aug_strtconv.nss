//::///////////////////////////////////////////////
//:: Augment Psionics - Start augmentation convo
//:: psi_aug_strtconv
//:://////////////////////////////////////////////
/** @file
    Starts the augmentation setup conversation.

    @author Ornedan
    @date   Created - 2005.12.05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


void main()
{
    object oPC = OBJECT_SELF;

    StartDynamicConversation("psi_augment_conv", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE);
}