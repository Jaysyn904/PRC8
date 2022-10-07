//Spell script for reserve feat Face-Changer Shape Learning
//prc_reservlern
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "prc_inc_shifting"
#include "prc_inc_spells"


void main()
{
    object oPC     = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nSpellID   = GetSpellId();
    int nShiftType = SHIFTER_TYPE_DISGUISE_SELF;

    if (!GetLocalInt(oPC, "FaceChangerBonus"))
    {
        FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
        return;
    }

    // Store the PC's current appearance as true appearance
    /// @note This may be a bad idea, we have no way of knowing if the current appearance really is the "true appearance" - Ornedan
    StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);

    // See if the creature is shiftable to. If so, store it as a template and shift
    if(GetCanShiftIntoCreature(oPC, nShiftType, oTarget))
    {
        StoreShiftingTemplate(oPC, nShiftType, oTarget);

        FloatingTextStringOnCreature("Face-changer appearance stored", oPC, FALSE);

        SetLocalInt(oPC, "HasFaceChanger", TRUE);
        DelayCommand(2.0, DeleteLocalInt(oPC, "HasFaceChanger"));
        
        // Start shifting. If this fails immediately, refund the shifting use
        if(!ShiftIntoCreature(oPC, nShiftType, oTarget))
        {
            DeleteLocalInt(oPC, "HasFaceChanger");
        }
    }
}
