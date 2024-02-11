//::///////////////////////////////////////////////
//:: [Ki Skill]
//:: [prc_s_kiskill.nss]
//:://////////////////////////////////////////////
//::
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 21, 2003
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    //Declare major variables
    int nWis = GetAbilityModifier(ABILITY_WISDOM);
    int nBonus = nWis;

    if(GetHasFeat(FEAT_FREE_KI_2, OBJECT_SELF))
        nBonus += nWis;
    if(GetHasFeat(FEAT_FREE_KI_3, OBJECT_SELF))
        nBonus += nWis;
    if(GetHasFeat(FEAT_FREE_KI_4, OBJECT_SELF))
        nBonus += nWis;

    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus);
    effect eLink = EffectLinkEffects(eVis, eSkill);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(1));
}
