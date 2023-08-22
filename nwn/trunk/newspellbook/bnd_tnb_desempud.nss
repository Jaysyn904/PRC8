/*
Tenebrous Apostate - Destroy/Empower Undead

At 3rd level, you gain additional power over mindless undead. You can use two turn or rebuke attempts as a 
single standard action, each dealing (or healing) damage as per the Tenebrous’s rebuke ability, except that
the damage applies only to mindless undead. Neutral characters use the turn effect, evil characters the rebuke.

Strat 05/03/21
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_turning"

void DestroyEmpower(object oBinder)
{
    int nTurnLevel = GetTurningClassLevel(oBinder, SPELL_TURN_UNDEAD);
    location lTarget = GetLocation(oBinder);
    float fRange = FeetToMeters(30.0);
    int nDC = 10 + nTurnLevel + GetAbilityModifier(ABILITY_CHARISMA, oBinder);	
	if (GetAlignmentGoodEvil(oBinder) == ALIGNMENT_EVIL)
    {
    	//ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HORRID_WILTING), lTarget);
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_VAMPIRIC_DRAIN_PRC), lTarget);
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oTarget))
        {
            if(oTarget != oBinder && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && 10 >= GetAbilityScore(oTarget, ABILITY_INTELLIGENCE, TRUE) && !GetIsPC(oTarget))
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGBLAST_ENERGY), oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(d6(nTurnLevel*2)), oTarget);
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
            if(oTarget != oBinder && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && 10 >= GetAbilityScore(oTarget, ABILITY_INTELLIGENCE, TRUE) && !GetIsPC(oTarget))
            {
            	int nDamage = d6(nTurnLevel*2);
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

void main()
{
    object oBinder = OBJECT_SELF;
    object oTarget    = PRCGetSpellTargetObject();

    //make sure there's TU uses left
    if (!GetHasFeat(FEAT_TURN_UNDEAD, oBinder))
    {
        FloatingTextStringOnCreature("You are out of Turn Undead uses for the day.", oBinder, FALSE);
        return;
    }
    DecrementRemainingFeatUses(oBinder, FEAT_TURN_UNDEAD); // Burn one
    
    // Burn the tenebrous turn undead
    if (BindAbilCooldown(oBinder, VESTIGE_TENEBROUS_TURN, VESTIGE_TENEBROUS))
    	DestroyEmpower(oBinder);
    else if (GetHasFeat(FEAT_TURN_UNDEAD, oBinder))
    {
    	DestroyEmpower(oBinder);
    	DecrementRemainingFeatUses(oBinder, FEAT_TURN_UNDEAD); // Burn two
    }	
    else
    {
        FloatingTextStringOnCreature("You do not have enough Turn Undead uses.", oBinder, FALSE);
        IncrementRemainingFeatUses(oBinder, FEAT_TURN_UNDEAD);
        return;
    }
}

