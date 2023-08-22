/*
    Ollam's Inspire Confidence
*/

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    int nDur = GetLevelByClass(CLASS_TYPE_OLLAM, OBJECT_SELF);
    int nBoost = MyPRCGetRacialType(oTarget) == RACIAL_TYPE_DWARF ? 3 : 2;

    effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, nBoost);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSkill, oTarget, RoundsToSeconds(nDur));
}

