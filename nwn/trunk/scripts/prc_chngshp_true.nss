//:://////////////////////////////////////////////
//:: Change Shape - return to true form
//:: prc_chngshp_true
//:://////////////////////////////////////////////
/** @file
    Undoes any shifting that the character may
    have undergone. Also removes any polymorph
    effects.
    
    Note: Also attempts to clear old shifter style shifting.
    Depending on which one overrides, may need to change the
    order of the if statements.


    @author Shane Hennessy
    @date   Modified - 2006.10.08 - rewritten by Ornedan - modded by Fox
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_shifting"
#include "pnp_shft_poly"
#include "prc_racial_const"

void main()
{
    object oPC = OBJECT_SELF;
	
	int nRace = GetRacialType(oPC);

    if(GetSpellId() == SPELL_IRDA_CHANGE_SHAPE_TRUE)
         IncrementRemainingFeatUses(oPC, FEAT_IRDA_CHANGE_SHAPE);

    //End treeshape
    if(GetHasSpellEffect(SPELL_TREESHAPE, oPC))
    {
        effect eVis;
        string sTag = "Tree" + GetName(oPC);
        object oTree = GetNearestObjectByTag(sTag, oPC);
        if(GetIsObjectValid(oTree))
            eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
        DestroyObject(oTree);

        PRCRemoveSpellEffects(SPELL_TREESHAPE, oPC, oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    }

	// Aranea Alternate Form 
	PRCRemoveSpellEffects(1489, oPC, oPC);
	PRCRemoveSpellEffects(1490, oPC, oPC);
	PRCRemoveSpellEffects(1491, oPC, oPC);

    // Undead Wildshape
    PRCRemoveSpellEffects(2283, oPC, oPC);
    PRCRemoveSpellEffects(2284, oPC, oPC);
    PRCRemoveSpellEffects(2285, oPC, oPC);
    PRCRemoveSpellEffects(2286, oPC, oPC);
    PRCRemoveSpellEffects(2287, oPC, oPC);
    PRCRemoveSpellEffects(2288, oPC, oPC);   

    if(GetLocalInt(oPC, "AraneaHumanoidForm") == TRUE || GetLocalInt(oPC, "AraneaHybridForm") == TRUE || GetPersistantLocalInt(oPC, "nPCShifted") == TRUE || GetLocalInt(oPC, "shifting") == TRUE)
    {
        SetLocalInt(oPC, "AraneaBiteEquip", TRUE);
    }

    //clear old style shifting first
    if(GetLocalInt(oPC, "shifting"))
    {
        effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
        //re-use unshifter code from shifter instead
        //this will also remove complexities with lich/shifter characters
        SetShiftTrueForm(oPC);
    }
    // Attempt to unshift and if it fails, inform the user with a message so they don't wonder whether something is happening or not
    else if(UnShift(oPC, TRUE) == UNSHIFT_FAIL)
        FloatingTextStrRefOnCreature(16828383, oPC, FALSE); // "Failed to return to true form!"

    if(nRace==RACIAL_TYPE_ARANEA)
    {
        //string sResRef = "prc_ara_bite_";
        //int nSize = PRCGetCreatureSize(oPC);
        //primary weapon
        //sResRef += GetAffixForSize(nSize);
        //DelayCommand(0.5f, AddNaturalPrimaryWeapon(oPC, sResRef, 1, TRUE));
		
	DeleteLocalInt(oPC, "AraneaHumanoidForm");
	DeleteLocalInt(oPC, "AraneaHybridForm");
    }
}
