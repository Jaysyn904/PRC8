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
#include "prc_inc_spells"

void main()
{
    
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
	
    object oPC   = OBJECT_SELF;
    int nSpellID = PRCGetSpellId();
    int bPaid    = FALSE;
    int nSlot;
    int nShiftType;
    string sSource;

    // Determine which quickslot was used
    switch(nSpellID)
    {
        case SPELL_DISGUISE_SELF_QS1:           nSlot = 1; sSource = "Disguise_Self_Quick_"; nShiftType = SHIFTER_TYPE_DISGUISE_SELF; break;
        case SPELL_ALTER_SELF_QS1:              nSlot = 1; sSource = "Alter_Self_Quick_"; nShiftType = SHIFTER_TYPE_ALTER_SELF; break;
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
        return;
    }

    // See if the shifting starts successfully
    if(!ShiftIntoResRef(oPC, nShiftType, sResRef))
    {
        
    }
    
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the local integer storing the spellschool name
}