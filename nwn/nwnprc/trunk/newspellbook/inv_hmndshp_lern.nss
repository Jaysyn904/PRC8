//:://////////////////////////////////////////////
//:: Humanoid Shape use
//:: inv_hmndshp_lern
//:://////////////////////////////////////////////
/** @file
    Targets some creature to have it be stored
    as a known template and attempts to shift
    into it.


    @author Shane Hennessy
    @date   Modified - 2006.10.08 - rewritten by Ornedan - modified by Fox
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

    object oPC     = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nSpellID   = GetSpellId();
    
    SetLocalInt(oPC, "HumanoidShapeInvocation", TRUE);

    // Store the PC's current appearance as true appearance
    /// @note This may be a bad idea, we have no way of knowing if the current appearance really is the "true appearance" - Ornedan
    StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);

    // See if the creature is shiftable to. If so, store it as a template and shift
    if(GetCanShiftIntoCreature(oPC, SHIFTER_TYPE_HUMANOIDSHAPE, oTarget))
    {
        StoreShiftingTemplate(oPC, SHIFTER_TYPE_HUMANOIDSHAPE, oTarget);

        // Start shifting.
        if(!ShiftIntoCreature(oPC, SHIFTER_TYPE_HUMANOIDSHAPE, oTarget))
        {
            
        }
    }
    
    DeleteLocalInt(oPC, "HumanoidShapeInvocation");
}
