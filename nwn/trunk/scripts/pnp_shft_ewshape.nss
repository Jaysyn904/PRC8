//:://////////////////////////////////////////////
//:: Shifter - Epic Greater Wildshape use
//:: pnp_shft_ewshape
//:://////////////////////////////////////////////
/** @file
    Targets some creature to have it be stored
    as a known template and attempts to shift
    into it, also gaining spell-like abilities.


    @author Shane Hennessy
    @date   Modified - 2006.10.08 - rewritten by Ornedan
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_shifting"


void main()
{
    object oPC     = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    // Store the PC's current appearance as true appearance
    /// @note This may be a bad idea, we have no way of knowing if the current appearance really is the "true appearance" - Ornedan
    StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);

    // See if the creature is shiftable to. If so, store it as a template and shift
    if(GetCanShiftIntoCreature(oPC, SHIFTER_TYPE_SHIFTER, oTarget))
    {
        StoreShiftingTemplate(oPC, SHIFTER_TYPE_SHIFTER, oTarget);

        // Start shifting. If this fails immediately, refund the shifting use
        if(!ShiftIntoCreature(oPC, SHIFTER_TYPE_SHIFTER, oTarget, TRUE))
        {
            IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1);
        }
    }
    // Couldn't shift, refund the feat use
    else
        IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1);
}
