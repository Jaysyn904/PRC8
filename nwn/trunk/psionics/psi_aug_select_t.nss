//::///////////////////////////////////////////////
//:: Augment Psionics - Set tens
//:: psi_aug_select_t
//:://////////////////////////////////////////////
/** @file
    Sets the second digit of augmentation profile
    index to the selected number.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 01.05.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_augment"


const int START = 2369; // Spells.2da of 00

void main()
{
    object oPC = OBJECT_SELF;
    int nVal = GetLocalInt(oPC, PRC_CURRENT_AUGMENT_PROFILE) % 10 // Remove the old second digit
               + (GetSpellId() - START) * 10;

    SetLocalInt(oPC, PRC_CURRENT_AUGMENT_PROFILE, nVal);
    //                           "Current augmentation"
    FloatingTextStringOnCreature(GetStringByStrRef(16823589) + " - " + UserAugmentationProfileToString(GetUserAugmentationProfile(oPC, nVal)), oPC, FALSE);
}