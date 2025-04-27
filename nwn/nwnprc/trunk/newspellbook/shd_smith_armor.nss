/*
   ----------------
   Shadowsmith Armor of Shadow

   shd_smith_armor.nss
   ----------------

   +2 AC, +4 at 7th
   
   02.03.19 by Stratovarius
*/

// Shadow Armor: Deflection AC bonus continues increasing at a rate of +2 per 3 epic shadowsmith levels past 10th.

#include "shd_inc_shdfunc"

void main()
{
    int nClass = GetLevelByClass(CLASS_TYPE_SHADOWSMITH);
    if (nClass < 4)
        return; // No Armor of Shadow before 4th level

    int nAC = 2;

    if (nClass >= 7)
        nAC = 4;

    if (nClass > 10)
        nAC += 2 * ((nClass - 10) / 3);

    effect eDur = SupernaturalEffect(EffectLinkEffects(EffectACIncrease(nAC, AC_DEFLECTION_BONUS), EffectVisualEffect(VFX_DUR_ARMOR_OF_DARKNESS)));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, OBJECT_SELF, TurnsToSeconds(nClass * 10));
}

/* void main()
{
    int nArm = 2;
    int nClass = GetLevelByClass(CLASS_TYPE_SHADOWSMITH);
    if (nClass >= 7) nArm = 4;
    effect eDur = SupernaturalEffect(EffectLinkEffects(EffectACIncrease(nArm, AC_DEFLECTION_BONUS), EffectVisualEffect(VFX_DUR_ARMOR_OF_DARKNESS)));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, OBJECT_SELF, TurnsToSeconds(nClass*10));
} */