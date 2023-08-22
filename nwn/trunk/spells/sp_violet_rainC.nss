///////////////////////////////////////////////////////////////
//  Violet Rain AoE HB
//  sp_violet_rainC.nss
///////////////////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        location lLoc = GetLocation(OBJECT_SELF);
        int nType;
        float fDur;
        
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 500.0f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid(oTarget))        
        {                
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BRIGHT_LIGHT_INDIGO_PULSE_SLOW), oTarget, HoursToSeconds(24));
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, 500.0f, lLoc, FALSE, OBJECT_TYPE_CREATURE);                
        }
}                        