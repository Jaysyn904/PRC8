/////////////////////////////////////////////////////////
// Brittlebone On-death
// prc_evnt_brtbn.nss
/////////////////////////////////////////////////////////
/*Brittlebone: This unguent must be spread over a set of
bones before animation as a skeleton. The ointment reduces
the skeleton’s natural armor by 2 points (to a minimum of 0),
but when the skeleton is destroyed, its bones splinter and fl y
apart, sending shards in all directions. Any creature within
the skeleton’s reach takes 1 point of piercing damage per HD
of the skeleton (Reflex DC 15 half; minimum 1 point).
*/

#include "prc_inc_spells"

void main()
{
        object oSkell = GetLastBeingDied();
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oSkell), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
        int nDam = GetHitDice(oSkell);
        
        while(GetIsObjectValid(oTarget))
        {
                if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, 15, SAVING_THROW_TYPE_NONE))
                {
                        nDam = nDam / 2;
                }
                
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_PIERCING), oTarget);
                
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oSkell), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
        }
} 