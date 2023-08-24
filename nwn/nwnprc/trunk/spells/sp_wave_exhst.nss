//::///////////////////////////////////////////////
//:: Name      Wave of Exhaustion
//:: FileName  sp_wave_exhst.nss
//:://////////////////////////////////////////////
/**@file Waves of Exhaustion
Necromancy
Level: Sor/Wiz 7 
Components: V, S 
Casting Time: 1 standard action 
Range: 60 ft. 
Area: Cone-shaped burst 
Duration: Instantaneous 
Saving Throw: No 
Spell Resistance: Yes

Waves of negative energy cause all living creatures
in the spell’s area to become exhausted. This spell
has no effect on a creature that is already exhausted.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
        
        object oPC = OBJECT_SELF;
        location lLoc = PRCGetSpellTargetLocation();
        object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 18.29f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
        int nCasterLevel = PRCGetCasterLevel(oPC);
        int nPenetr = nCasterLevel + SPGetPenetr();
        
        while(GetIsObjectValid(oTarget))
        {
                if(!PRCDoResistSpell(OBJECT_SELF, oTarget, nPenetr) && PRCGetIsAliveCreature(oTarget))
                {
                        effect eEff = EffectExhausted();

                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff, oTarget, HoursToSeconds(8));
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);

                        if(GetIsPC(oTarget))
                        {
                                SendMessageToPC(oTarget, "You are exhausted. You need to rest.");
                        }
                }
                oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 18.29f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
        }
        PRCSetSchool();
}