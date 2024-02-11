#include "prc_class_const"
#include "inc_vfx_const"

void main()
{
	object oTarget = GetSpellTargetObject();
	object oPC = OBJECT_SELF;
	
	int nBonus = 0;
	if (GetLevelByClass(CLASS_TYPE_NOBLE, oPC) >= 20) nBonus = 7;
	else if (GetLevelByClass(CLASS_TYPE_NOBLE, oPC) >= 18) nBonus = 6;
	else if (GetLevelByClass(CLASS_TYPE_NOBLE, oPC) >= 13) nBonus = 5;
	else if (GetLevelByClass(CLASS_TYPE_NOBLE, oPC) >= 8) nBonus = 4;
	else if (GetLevelByClass(CLASS_TYPE_NOBLE, oPC) >= 4) nBonus = 3;
	
	effect eVis = EffectVisualEffect(VFX_IMP_REGENERATE_IMPACT);
	effect eLink = EffectLinkEffects(EffectAttackIncrease(nBonus), EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus));
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oTarget, 6.0);
}
