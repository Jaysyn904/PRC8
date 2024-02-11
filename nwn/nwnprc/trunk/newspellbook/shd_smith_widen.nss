/*
   ----------------
   Shadowsmith Widen Shroud

   shd_smith_widen.nss
   ----------------

   Climb bonus to friends
   
   02.03.19 by Stratovarius
*/

#include "shd_inc_shdfunc"

void main()
{
    object oShadow = OBJECT_SELF;
    
    if (!GetHasFeat(FEAT_TOUCH_SHADOW, oShadow))  return;
    DecrementRemainingFeatUses(oShadow, FEAT_TOUCH_SHADOW);
    
    location lTarget = GetLocation(oShadow);
    int nClass = GetLevelByClass(CLASS_TYPE_SHADOWSMITH);
    float fRad = FeetToMeters(10.0);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_INVISIBILITY_SPHERE), lTarget);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRad, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    //Cycle through the targets within the spell shape until an invalid object is captured.
    int nCount = 0;
    while (GetIsObjectValid(oTarget) && (nClass/2) >= nCount)
    {
        if (GetIsFriend(oTarget, oShadow))
        {
            effect eDur = SupernaturalEffect(EffectLinkEffects(EffectSkillIncrease(SKILL_CLIMB, nClass), EffectVisualEffect(VFX_DUR_AURA_CHAOS)));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, OBJECT_SELF, TurnsToSeconds(nClass));
            nCount++;
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRad, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }
}
