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
#include "prc_inc_spells"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    object oPC     = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nSpellID   = GetSpellId();
    int nShiftType = SHIFTER_TYPE_DISGUISE_SELF;
    int nCasterLvl = GetInvokerLevel(oPC, GetInvokingClass());
    
    SetLocalInt(oPC, "MaskOfFleshInvocation", nCasterLvl);
    
    if(nSpellID == INVOKE_MASK_OF_FLESH_HOSTILE)
    {
        
	    PRCSignalSpellEvent(oTarget, TRUE, INVOKE_MASK_OF_FLESH_HOSTILE, oPC);
	    
        //save
		if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetInvocationSaveDC(oTarget, oPC), SAVING_THROW_TYPE_SPELL))
		{
			effect eCha = EffectAbilityDecrease(ABILITY_CHARISMA, d6());
            effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
			
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCha, oTarget, HoursToSeconds(nCasterLvl),TRUE,-1,nCasterLvl);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		}
		else
		    return;
    }

    // Store the PC's current appearance as true appearance
    /// @note This may be a bad idea, we have no way of knowing if the current appearance really is the "true appearance" - Ornedan
    StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);

    // See if the creature is shiftable to. If so, store it as a template and shift
    if(GetCanShiftIntoCreature(oPC, nShiftType, oTarget))
    {
        // Start shifting. If this fails immediately, refund the shifting use
        if(!ShiftIntoCreature(oPC, nShiftType, oTarget))
        {
            DeleteLocalInt(oPC, "MaskOfFleshInvocation");
        }
    }
    
}
