//////////////////////////////////////////////////////////
// Flash Pellet
// sp_flashpllt.nss
/////////////////////////////////////////////////////////
/*
Flash Pellet: This tiny brittle object is often disguised
as a button or other decoration. You can throw a flash
pellet as a ranged attack with a range increment of 5
feet. When thrown against a hard surface, it bursts with
a bright flash of light. All creatures within a 5-foot-radius
burst must succeed on a DC 15 Fortitude save or be
blinded for 1 round and dazzled for 1 round after that.*/

#include "prc_inc_spells"

void main()
{
        location lLoc = PRCGetSpellTargetLocation();
        effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
        effect eImp = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M );
        effect eBlind = EffectBlindness();
        
        // -1 attack, search, and spot
        effect eDazzle = EffectDazzle();
        
        //Explosion vis
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc);
        
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(5.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid(oTarget))
        {                
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 15, SAVING_THROW_TYPE_NONE))
                {
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds(1));
                        DelayCommand(RoundsToSeconds(1), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazzle, oTarget, RoundsToSeconds(1)));
                }
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(5.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);
        }
}     