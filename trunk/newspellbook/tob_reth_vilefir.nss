/*
28/5/21 by Stratovarius

Reth Dekala Vilefire Blast

A reth dekala can attack foes at range by
lashing out with bolts of the corrupt flames that
compose its body. This is a ranged touch attack with a
range of 60 feet that deals 1d8 points of damage. Half
the damage dealt is acid damage and half is fire damage.
Living creatures struck by a vilefire blast must succeed
on a Fortitude save (DC 15) or become sickened for 1
round. The save DC is Constitution-based.
*/

#include "prc_inc_sp_tch"

void main()
{
	object oInitiator = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
		
	//Exclude the caster from the damage effects
	if (oTarget != oInitiator)
	{
	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oInitiator))
	    {
    		int nAttack = PRCDoRangedTouchAttack(oTarget);
    		if (nAttack > 0)
    		{
		        int nDamage = d8();
		        ApplyTouchAttackDamage(oInitiator, oTarget, nAttack, nDamage/2, DAMAGE_TYPE_FIRE);
           		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oTarget);
           		// The +1 makes acid round up instead of round down, so you don't miss out on odd numbers
		        ApplyTouchAttackDamage(oInitiator, oTarget, nAttack, (nDamage+1)/2, DAMAGE_TYPE_ACID);
           		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_L), oTarget);
        		
        		int nDC = 10 + GetHitDice(oInitiator)/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oInitiator);
        		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
        		{
        			// Half fire, half acid
            		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectSickened()), oTarget, 6.0);
            	}		            
		    }
	    }
	}
    
}