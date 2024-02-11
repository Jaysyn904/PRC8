/*
   ----------------
   Shadowsmith Armor of Shadow

   shd_smith_armor.nss
   ----------------

   +2 AC, +4 at 7th
   
   02.03.19 by Stratovarius
*/

#include "shd_inc_shdfunc"

void main()
{
    int nArm = 2;
    int nClass = GetLevelByClass(CLASS_TYPE_SHADOWSMITH);
    if (nClass >= 7) nArm = 4;
    effect eDur = SupernaturalEffect(EffectLinkEffects(EffectACIncrease(nArm, AC_DEFLECTION_BONUS), EffectVisualEffect(VFX_DUR_ARMOR_OF_DARKNESS)));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, OBJECT_SELF, TurnsToSeconds(nClass*10));
}