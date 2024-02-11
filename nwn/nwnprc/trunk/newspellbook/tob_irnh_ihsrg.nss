/*
   ----------------
   Iron Heart Surge

   tob_irnh_ihsrg.nss
   ----------------

    15/07/07 by Stratovarius
*/ /** @file

    Iron Heart Surge

    Iron Heart 
    Level: Warblade 3
    Prerequisite: One Iron Heart maneuver.
    Initiation Action: 1 Standard Action
    Range: Personal
    Target: You
    Duration: 1 round.

    By drawing on your mental strength and physical fortitude, you break free
    of a debilitating state that might otherwise defeat you.
    
    You remove one negative status effect on you, and gain a +2 bonus to attacks for one round.
*/

#include "tob_inc_move"
#include "tob_movehook"

int IronHeartCheck(int nSpellId)
{
    switch (nSpellId)
    {
        case SPELL_POWER_ATTACK1: 
        case SPELL_POWER_ATTACK2: 
        case SPELL_POWER_ATTACK3: 
        case SPELL_POWER_ATTACK4: 
        case SPELL_POWER_ATTACK5: 
        case SPELL_POWER_ATTACK6: 
        case SPELL_POWER_ATTACK7: 
        case SPELL_POWER_ATTACK8: 
        case SPELL_POWER_ATTACK9: 
        case SPELL_POWER_ATTACK10:
        case SPELL_INTUITIVE_ATK:
        case MOVE_IH_PUNISHING_STANCE:
        case MOVE_DM_STANCE_OF_CLARITY:
        case POWER_EXPANSION:

        return FALSE;
        break;
    }
    return TRUE;    
}

void main()
{
    if (!PreManeuverCastCode())
    {
    // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
	    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SOUL_TRAP), oTarget);
	    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(2), oTarget, 6.0);
	
	    int nStop = FALSE;
	    effect eBad = GetFirstEffect(oTarget);
	    //Search for negative effects
	    while(GetIsEffectValid(eBad) && !nStop)
	    {
	        int nInt = GetEffectSpellId(eBad);
	        if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
	            GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
	            GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
	            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
		        GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
	            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
	            GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
	            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
	            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
	            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
	            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
	            GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL)
	            {
	                //Remove effect if it is negative.
	                if(IronHeartCheck(nInt))
	                {
	                    RemoveEffect(oTarget, eBad);
	                    nStop = TRUE; // One effect only
	                }
	            }
	        eBad = GetNextEffect(oTarget);
	    }	
    }
}