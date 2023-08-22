// Acidic Blood for the Bloodarcher by Zedium
#include "prc_class_const"

void main()
{
    //Declare major variables
    location lTarget = GetLocation(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eDam;

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    while(GetIsObjectValid(oTarget))
    {
         if(!GetIsFriend(oTarget) && !GetLevelByClass(CLASS_TYPE_BLARCHER, oTarget))
         {
              eDam = EffectDamage(d6(1), DAMAGE_TYPE_ACID);
              ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
              ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
         }
         oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    }
}