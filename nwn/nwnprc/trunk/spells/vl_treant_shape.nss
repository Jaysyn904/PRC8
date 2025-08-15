//::///////////////////////////////////////////////
//:: Wild Shape
//:: NW_S2_WildShape
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the Druid to change into animal forms.

    Updated: Sept 30 2003, Georg Z.
      * Made Armor merge with druid to make forms
        more useful.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 22, 2002
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified Date: January 15th-16th, 2008
//:://////////////////////////////////////////////
/*
    Modified to insure no shapeshifting spells are castable upon
    mounted targets.  This prevents problems that can occur due
    to dismounting after shape shifting, or other issues that can
    occur due to preserved appearances getting out of synch.

    This can additional check can be disabled by setting the variable
    X3_NO_SHAPESHIFT_SPELL_CHECK to 1 on the module object.  If this
    variable is set then this script will function as it did prior to
    this modification.

*/

//#include "x3_inc_horse"
#include "prc_alterations"
#include "pnp_shft_poly"

void main()
{
    object oPC = OBJECT_SELF;
    int nSpell = GetSpellId();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLevel  = GetLevelByClass(CLASS_TYPE_DRUID, oPC)
					+ GetLevelByClass(CLASS_TYPE_LION_OF_TALISID, oPC)
					+ GetLevelByClass(CLASS_TYPE_VERDANT_LORD, oPC)					
					+ GetLevelByClass(CLASS_TYPE_ARCANE_HIEROPHANT, oPC);
					
	float fDuration = HoursToSeconds(nCasterLevel);

    int bShiftingDruid = GetLocalInt(GetModule(), "PRC_DRUID_USES_SHIFTING");

    if (!GetLocalInt(GetModule(), "X3_NO_SHAPESHIFT_SPELL_CHECK"))
    {
        if (PRCHorseGetIsMounted(oPC))
        {
            if (GetIsPC(oPC))
                FloatingTextStrRefOnCreature(111982, oPC, FALSE);
            return;
        }
    }

    ShifterCheck(oPC);
    StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);

    // Always shift into treant form
    string sTreantShape = "prc_sum_treant";

    ClearAllActions();
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oPC);
	
	effect eBark = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);
	eBark = ExtraordinaryEffect(eBark);
	

    if (bShiftingDruid)
    {
        ShiftIntoResRef(oPC, SHIFTER_TYPE_DRUID, sTreantShape, FALSE);
        DelayCommand(fDuration, SetShiftTrueForm(oPC));
		
    }
    else
    {
        ShiftIntoResRef(oPC, SHIFTER_TYPE_DRUID, sTreantShape, FALSE);
        DelayCommand(fDuration, SetShiftTrueForm(oPC));
    }

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBark, oPC, fDuration);
	
    DelayCommand(1.5, ActionCastSpellOnSelf(SPELL_SHAPE_INCREASE_DAMAGE));
	
	
}

