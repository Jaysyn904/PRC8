//::///////////////////////////////////////////////
//:: Augment Psionics - Augment Off
//:: psi_aug_off
//:://////////////////////////////////////////////
/** @file
    Sets the augmentation profile pointer to 0.
    Also sets the maximum augmentation toggle
    off.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 01.05.2005
//:://////////////////////////////////////////////


#include "prc_alterations"
#include "psi_inc_augment"

void main()
{
    object oCreature = OBJECT_SELF;
    SetLocalInt(oCreature, PRC_CURRENT_AUGMENT_PROFILE, PRC_AUGMENT_PROFILE_NONE);
    SetLocalInt(oCreature, PRC_AUGMENT_MAXAUGMENT, FALSE);
    FloatingTextStrRefOnCreature(16823588, oCreature, FALSE); // "Augment Off"
}