//Spell script for reserve feat Face-Changer Quickselects
//prc_reservfcqs
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "prc_inc_shifting"
#include "prc_inc_spells"

void main()
{
    object oPC   = OBJECT_SELF;
    int nSpellID = PRCGetSpellId();
    int bPaid    = FALSE;
    int nSlot;
    int nShiftType;
    string sSource;

    if (!GetLocalInt(oPC, "FaceChangerBonus"))
    {
        FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
        return;
    }

    // Determine which quickslot was used
    switch(nSpellID)
    {
        case SPELL_FACECHANGER_QS1:           nSlot = 1; sSource = "Disguise_Self_Quick_"; nShiftType = SHIFTER_TYPE_DISGUISE_SELF; break;
        case SPELL_FACECHANGER_QS2:           nSlot = 2; sSource = "Disguise_Self_Quick_"; nShiftType = SHIFTER_TYPE_DISGUISE_SELF; break;
        case SPELL_FACECHANGER_QS3:           nSlot = 3; sSource = "Disguise_Self_Quick_"; nShiftType = SHIFTER_TYPE_DISGUISE_SELF; break;

        default:
            if(DEBUG) DoDebug("prc_chngshp_quik: ERROR: Unknown nSpellID value: " + IntToString(nSpellID));
            return;
    }

    // Read the data from this slot
    string sResRef = GetPersistantLocalString(oPC, sSource + IntToString(nSlot) + "_ResRef");

    // Make sure the slot wasn't empty
    if(sResRef == "")
    {
        FloatingTextStrRefOnCreature(16828382, oPC, FALSE); // "This Quick Shift Slot is empty!"
        return;
    }

    SetLocalInt(oPC, "HasFaceChanger", TRUE);
    DelayCommand(2.0, DeleteLocalInt(oPC, "HasFaceChanger"));

    // See if the shifting starts successfully
    if(!ShiftIntoResRef(oPC, nShiftType, sResRef))
    {
        DeleteLocalInt(oPC, "HasFaceChanger");
    }
}