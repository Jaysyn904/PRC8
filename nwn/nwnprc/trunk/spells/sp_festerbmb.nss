/////////////////////////////////////////////////////
// Festering Bomb
// sp_festerbmb.nss
//////////////////////////////////////////////////////
/*
Festering Bomb: This small ceramic sphere is packed
with alchemical explosives, rotting meat, and offal infected
with filth fever. When thrown as a grenadelike weapon, it
spreads disease in its wake. The explosion on impact is not
enough to cause physical harm, but it does spray the rotten
contents and infection in a 20-foot burst. All within the
burst must make saving throws as if exposed to filth fever
Unlike normal exposure to filth fever, the victim need not be injured.
*/

#include "prc_inc_spells"

void main()
{
        location lLoc = PRCGetSpellTargetLocation();
        effect eDur = EffectVisualEffect(VFX_DUR_FLIES);
        effect eFnF = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);        
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
        
        //VFX
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFnF, lLoc);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDur, lLoc, 5.0);
        
        while(GetIsObjectValid(oTarget))
        {        
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDisease(DISEASE_FILTH_FEVER), oTarget);
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
        }
}        