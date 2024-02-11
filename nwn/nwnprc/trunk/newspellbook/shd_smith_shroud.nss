/*
   ----------------
   Shadowsmith Shroud of Shadow

   shd_smith_shroud.nss
   ----------------

   Hide/MS bonus equal to class level
   
   02.03.19 by Stratovarius
*/

#include "shd_inc_shdfunc"

void main()
{
    int nClass = GetLevelByClass(CLASS_TYPE_SHADOWSMITH);
    effect eDur = EffectLinkEffects(EffectSkillIncrease(SKILL_HIDE, nClass), EffectSkillIncrease(SKILL_MOVE_SILENTLY, nClass));
           eDur = SupernaturalEffect(EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_SHADOWS_ANTILIGHT)));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, OBJECT_SELF, TurnsToSeconds(nClass));
}