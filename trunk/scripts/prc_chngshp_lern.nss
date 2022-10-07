//:://////////////////////////////////////////////
//:: Change Shape use
//:: prc_chngshp_lern
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


void main()
{
    object oPC     = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nSpellID   = GetSpellId();
    int nShiftType;
    
    switch(nSpellID)
    {
        case SPELL_IRDA_CHANGE_SHAPE_LEARN:       
        case SPELL_FEYRI_CHANGE_SHAPE_LEARN:      
        case SPELL_RAKSHASA_CHANGE_SHAPE_LEARN:   nShiftType = SHIFTER_TYPE_HUMANOIDSHAPE; break;
        case SPELL_ALTER_SELF_LEARN:              nShiftType = SHIFTER_TYPE_ALTER_SELF; break;
        case SPELL_DISGUISE_SELF_LEARN:           
        case SPELL_CHANGLING_CHANGE_SHAPE_LEARN:
        case SPELL_QUICK_CHANGE_SHAPE_LEARN:      nShiftType = SHIFTER_TYPE_DISGUISE_SELF; break;
    }

    // Store the PC's current appearance as true appearance
    /// @note This may be a bad idea, we have no way of knowing if the current appearance really is the "true appearance" - Ornedan
    StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);

    // See if the creature is shiftable to. If so, store it as a template and shift
    if(GetCanShiftIntoCreature(oPC, nShiftType, oTarget))
    {
        StoreShiftingTemplate(oPC, nShiftType, oTarget);
        
        // Start shifting. If this fails immediately, refund the shifting use
        if(!ShiftIntoCreature(oPC, nShiftType, oTarget))
        {
            // In case of shifting failure, refund the shifting use
            if(nSpellID == SPELL_IRDA_CHANGE_SHAPE_LEARN)
                IncrementRemainingFeatUses(oPC, FEAT_IRDA_CHANGE_SHAPE);
        }
    }
    // Couldn't shift, refund the feat use
    else
        if(nSpellID == SPELL_IRDA_CHANGE_SHAPE_LEARN)
            IncrementRemainingFeatUses(oPC, FEAT_IRDA_CHANGE_SHAPE);
}
