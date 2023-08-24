//:://////////////////////////////////////////////
//:: Humanoid Shape - Quickslot use
//:: inv_hmndshp_quik
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
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook

    object oPC   = OBJECT_SELF;
    int nSpellID = PRCGetSpellId();
    int bPaid    = FALSE;
    int nSlot;

    SetLocalInt(oPC, "HumanoidShapeInvocation", TRUE);

    // Determine which quickslot was used
    switch(nSpellID)
    {
        case INVOKE_HUMANOID_SHAPE_QS1:      nSlot = 1;  break;
        case INVOKE_HUMANOID_SHAPE_QS2:      nSlot = 2;  break;

        default:
            if(DEBUG) DoDebug("prc_chngshp_quik: ERROR: Unknown nSpellID value: " + IntToString(nSpellID));
            return;
    }

    // Read the data from this slot
    string sResRef = GetPersistantLocalString(oPC, "Humanoid_Shape_Quick_" + IntToString(nSlot) + "_ResRef");

    // Make sure the slot wasn't empty
    if(sResRef == "")
    {
        FloatingTextStrRefOnCreature(16828382, oPC, FALSE); // "This Quick Shift Slot is empty!"
        return;
    }

    // See if the shifting starts successfully
    if(ShiftIntoResRef(oPC, SHIFTER_TYPE_HUMANOIDSHAPE, sResRef))
    {
    }
        
    DeleteLocalInt(oPC, "HumanoidShapeInvocation");
}