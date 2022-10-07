/*
   ----------------
   Shadowsmith Touch of Shadow

   shd_smith_touch.nss
   ----------------

   Climb bonus equal to class level
   
   02.03.19 by Stratovarius
*/

#include "shd_inc_shdfunc"

void main()
{
    int nClass = GetLevelByClass(CLASS_TYPE_SHADOWSMITH);
    effect eDur = SupernaturalEffect(EffectLinkEffects(EffectSkillIncrease(SKILL_CLIMB, nClass), EffectVisualEffect(VFX_DUR_AURA_CHAOS)));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, OBJECT_SELF, TurnsToSeconds(nClass));
}