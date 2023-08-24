/////////////////////////////////////////////////////////////
//  Rain of Frogs or Fish AoE Heartbeat
//  sp_rain_ffishC.nss
/////////////////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        location lLoc = GetLocation(OBJECT_SELF);
        int nType;
        float fDur;
        
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 500.0f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid(oTarget))
        {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d3(1), DAMAGE_TYPE_BLUDGEONING), oTarget);
                
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, 500.0f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
        }
}