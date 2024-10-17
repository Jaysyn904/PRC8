/*
Secular Aptitude (Ex): At 1st level, you gain Secular
Authority as a bonus feat. In addition, you receive a
competence bonus to Secular Authority checks equal to
half your class level.

Note: Secular Authority is mostly RP feat. In order
to make it also usable in SP mode, we've changed it
a bit - we're adding 1/2 Templar level to bluff,
persuade and intimidate skills for 1 turn.
*/

#include "inc_vfx_const"
#include "prc_class_const"

void main()
{
    object oPC = OBJECT_SELF;
    int nBonus = (1 + GetLevelByClass(CLASS_TYPE_TEMPLAR, oPC)) / 2;
    float fDuration = TurnsToSeconds(1);

    effect eBonus = EffectSkillIncrease(SKILL_PERSUADE, nBonus);
           eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_BLUFF, nBonus));
           eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_INTIMIDATE, nBonus));
           eBonus = EffectLinkEffects(eBonus, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
           eBonus = ExtraordinaryEffect(eBonus);

    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M_PUR);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
}