//::///////////////////////////////////////////////
//:: Augment Psionics - Quickselect
//:: psi_aug_qslot
//:://////////////////////////////////////////////
/** @file
    Sets augmentation to the value of the selected
    quickselection.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 01.05.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_augment"


const int SLOT_1 = 2357;
const int SLOT_2 = 2358;
const int SLOT_3 = 2392;
const int SLOT_4 = 2393;
const int SLOT_5 = 2394;
const int SLOT_6 = 2395;
const int SLOT_7 = 2396;


void main()
{
    object oPC = OBJECT_SELF;

    // Determine which quickslot was used
    int nSpellID = PRCGetSpellId();
    int nSlot;
    switch(nSpellID)
    {
        case SLOT_1: nSlot = 1; break;
        case SLOT_2: nSlot = 2; break;
        case SLOT_3: nSlot = 3; break;
        case SLOT_4: nSlot = 4; break;
        case SLOT_5: nSlot = 5; break;
        case SLOT_6: nSlot = 6; break;
        case SLOT_7: nSlot = 7; break;

        default:
            if(DEBUG) DoDebug("prc_aug_qslot: ERROR: Unknown spellID - " + IntToString(nSpellID));
            return;
    }

    // The quickslot indexes are stored as negative to differentiate them from normal slots
    SetLocalInt(oPC, PRC_CURRENT_AUGMENT_PROFILE, -nSlot);

    //                           "Current augmentation"
    FloatingTextStringOnCreature(GetStringByStrRef(16823589) + " - " + UserAugmentationProfileToString(GetUserAugmentationProfile(oPC, nSlot, TRUE)), oPC, FALSE);
}
