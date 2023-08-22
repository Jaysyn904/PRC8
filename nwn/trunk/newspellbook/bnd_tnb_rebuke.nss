/*
Tenebrous Apostate - Tenebrous's Rebuke

When you use the turn or rebuke undead ability granted by Tenebrous, your connection to your dark master allows you to channel the 
energy in a unique way. You can use a turn attempt to deal 1d6 points of damage per effective turning level you possess to every 
undead creature within 30 feet. Each affected undead can attempt a Will save (DC 10 + your effective turning level + your Cha 
modifier) for half damage. If you use a rebuke attempt, each undead within 30 feet is instead cured of 1d6 points of damage per 
effective turning level. This effect occurs instead of the normal result. Neutral characters use the turn effect, evil characters the rebuke.

Strat 05/03/21
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_turning"

void main()
{
    object oBinder = OBJECT_SELF;
    int nTurnLevel = GetTurningClassLevel(oBinder, SPELL_TURN_UNDEAD);
    location lTarget = GetLocation(oBinder);
    float fRange = FeetToMeters(30.0);
    int nDC = 10 + nTurnLevel + GetAbilityModifier(ABILITY_CHARISMA, oBinder);
    
    if(!BindAbilCooldown(OBJECT_SELF, VESTIGE_TENEBROUS_TURN, VESTIGE_TENEBROUS)) return;
    else if (GetAlignmentGoodEvil(oBinder) == ALIGNMENT_EVIL)
    {
    	//ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HORRID_WILTING), lTarget);
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_VAMPIRIC_DRAIN_PRC), lTarget);
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oTarget))
        {
            if(oTarget != oBinder && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGBLAST_ENERGY), oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(d6(nTurnLevel)), oTarget);
            }
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
        }
    }    
    else
    {
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_VAMPIRIC_DRAIN_PRC), lTarget);
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oTarget))
        {
            if(oTarget != oBinder && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
            {
            	int nDamage = d6(nTurnLevel);
                if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                    nDamage /= 2;
                    if (GetHasMettle(oTarget, SAVING_THROW_WILL)) // Ignores partial effects
                    {
                        nDamage = 0;
                    }
                }            
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REGENERATE_IMPACT), oTarget);
                if (nDamage) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_DIVINE), oTarget);
            }
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
        }
    }         
}

