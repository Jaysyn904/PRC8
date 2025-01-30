//:://////////////////////////////////////////////
//:: Name     Righteous Aura On Death
//:: FileName   prc_rightaura.nss
//:://////////////////////////////////////////////
/** @file 
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/20/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{	
	object oPC = OBJECT_SELF;
	int nDice = PRCMin(20, PRCGetCasterLevel(oPC) * 2);
	location lLoc = GetLocation(oPC);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_STRIKE_HOLY), lLoc);
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20), lLoc, FALSE, OBJECT_TYPE_CREATURE);
	
	while(GetIsObjectValid(oTarget))
	{
		if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)
		{
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(d6(nDice)), oTarget);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oTarget);
		}
		
		if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
		{
			int nDam = d6(nDice);
			//Double damage for undead
			if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) nDam+=nDam;
			effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_IMP_HOLY_AID), EffectDamage(DAMAGE_TYPE_DIVINE, nDam));
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20), lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
}
