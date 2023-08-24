//:://////////////////////////////////////////////
//:: Change Shape - Quickslot use
//:: prc_chngshp_quik
//:://////////////////////////////////////////////
/** @file
    Fires when one of the Change Shape quickslots
    is used. Determines which of the slots was
    used based on spellID and, if that slot is not
    empty, shifts to the form listed in the slot.


    @author Ornedan
    @date   Created  - 2006.10.07
    modified by Fox for Change Shape from PnP Shifter
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_shifting"

void main()
{
    object oPC   = OBJECT_SELF;
    int nSpellID = PRCGetSpellId();
    int bPaid    = FALSE;
    int nSlot;
    int nShiftType;
    string sSource;

    // Determine which quickslot was used
    switch(nSpellID)
    {
        case SPELL_IRDA_CHANGE_SHAPE_QS1:       nSlot = 1; sSource = "Irda_Shape_Quick_"; nShiftType = SHIFTER_TYPE_HUMANOIDSHAPE; break;
        case SPELL_FEYRI_CHANGE_SHAPE_QS1:      nSlot = 1; sSource = "Feyri_Shape_Quick_"; nShiftType = SHIFTER_TYPE_HUMANOIDSHAPE; break;
        case SPELL_RAKSHASA_CHANGE_SHAPE_QS1:   nSlot = 1; sSource = "Rakshasa_Shape_Quick_"; nShiftType = SHIFTER_TYPE_HUMANOIDSHAPE; break;
        case SPELL_DISGUISE_SELF_QS1:           nSlot = 1; sSource = "Disguise_Self_Quick_"; nShiftType = SHIFTER_TYPE_DISGUISE_SELF; break;
        case SPELL_ALTER_SELF_QS1:              nSlot = 1; sSource = "Alter_Self_Quick_"; nShiftType = SHIFTER_TYPE_ALTER_SELF; break;
        case SPELL_CHANGLING_CHANGE_SHAPE_QS1:
        case SPELL_QUICK_CHANGE_SHAPE_QS1:      nSlot = 1; sSource = "Changeling_Shape_Quick_"; nShiftType = SHIFTER_TYPE_DISGUISE_SELF; break;
        case SPELL_IRDA_CHANGE_SHAPE_QS2:       nSlot = 2; sSource = "Irda_Shape_Quick_"; nShiftType = SHIFTER_TYPE_HUMANOIDSHAPE; break;
        case SPELL_CHANGLING_CHANGE_SHAPE_QS2:
        case SPELL_QUICK_CHANGE_SHAPE_QS2:      nSlot = 2; sSource = "Changeling_Shape_Quick_"; nShiftType = SHIFTER_TYPE_DISGUISE_SELF; break;
        case SPELL_FEYRI_CHANGE_SHAPE_QS2:      nSlot = 2; sSource = "Feyri_Shape_Quick_"; nShiftType = SHIFTER_TYPE_HUMANOIDSHAPE; break;
        case SPELL_RAKSHASA_CHANGE_SHAPE_QS2:   nSlot = 2; sSource = "Rakshasa_Shape_Quick_"; nShiftType = SHIFTER_TYPE_HUMANOIDSHAPE; break;
        case SPELL_DISGUISE_SELF_QS2:           nSlot = 2; sSource = "Disguise_Self_Quick_"; nShiftType = SHIFTER_TYPE_DISGUISE_SELF; break;
        case SPELL_ALTER_SELF_QS2:              nSlot = 2; sSource = "Alter_Self_Quick_"; nShiftType = SHIFTER_TYPE_ALTER_SELF; break;
        case SPELL_DISGUISE_SELF_QS3:           nSlot = 3; sSource = "Disguise_Self_Quick_"; nShiftType = SHIFTER_TYPE_DISGUISE_SELF; break;
        case SPELL_ALTER_SELF_QS3:              nSlot = 3; sSource = "Alter_Self_Quick_"; nShiftType = SHIFTER_TYPE_ALTER_SELF; break;

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
        if(nSpellID == SPELL_IRDA_CHANGE_SHAPE_QS1 || nSpellID == SPELL_IRDA_CHANGE_SHAPE_QS2)
             IncrementRemainingFeatUses(oPC, FEAT_IRDA_CHANGE_SHAPE);
        return;
    }

    // See if the shifting starts successfully
    if(!ShiftIntoResRef(oPC, nShiftType, sResRef))
    {
        // In case of shifting failure, refund the shifting use
        if(nSpellID == SPELL_IRDA_CHANGE_SHAPE_QS1 || nSpellID == SPELL_IRDA_CHANGE_SHAPE_QS2)
            IncrementRemainingFeatUses(oPC, FEAT_IRDA_CHANGE_SHAPE);
    }
    
}