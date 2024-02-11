/*
   ----------------
   Counter Charge

   tob_stsn_cntrcrg.nss
   ----------------

    31/03/07 by Stratovarius
*/ /** @file

    Counter Charge

    Setting Sun (Counter)
    Level: Swordsage 1
    Initiation Action: 1 Swift Action
    Range: Melee Attack.
    Target: One Creature.

    With a quick sidestep, you send a charging opponent sprawling.
    
    You attempt to redirect a charging creature. Make a Strength or Dexterity check
    against the charging creature. You get a +4 bonus to strength if you are larger than
    the target, and +4 bonus on dexterity if you are smaller. If you succeed, the target 
    does not get to attack you and is redirected 10 feet away from you. If you fail
    the target gets a +2 bonus to its attack.
*/

#include "tob_inc_move"
#include "tob_movehook"
#include "prc_inc_combmove"

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
    	if (GetIsCharging(oTarget))
    	{
    		int nPCSize = PRCGetCreatureSize(oInitiator);
    		int nTargetSize = PRCGetCreatureSize(oTarget);
    		int nPCStat, nTargetStat;
    		int nBonus = 0;
    		// If you're larger, use Strength
    		if (nPCSize > nTargetSize)
    		{
			nPCStat = GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
			nTargetStat = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
			nBonus = 4;
		}
		else if (nTargetSize > nPCSize) // If smaller, we use dex
		{
			nPCStat = GetAbilityModifier(ABILITY_DEXTERITY, oInitiator);
			nTargetStat = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);		
			nBonus = 4;
		}
		else // Check to see which is larger
		{
			if (GetAbilityModifier(ABILITY_STRENGTH, oInitiator) > GetAbilityModifier(ABILITY_DEXTERITY, oInitiator))
			{
				nPCStat = GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
				nTargetStat = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
			}
			else
			{
				nPCStat = GetAbilityModifier(ABILITY_DEXTERITY, oInitiator);
				nTargetStat = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);	
			}
		}
		// The stats
		int nPCCheck = nPCStat + nBonus + d20();
		int nTargetCheck = nTargetStat + d20();
		// Now check
		if (nPCCheck >= nTargetCheck)
		{
			// We succeeded, so the enemy gets knocked off course
			_DoBullRushKnockBack(oTarget, oInitiator, 10.0);
		}
		else // Enemy gets a +2 Attack Bonus
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(2), oTarget, 6.0);
	}
	else
	{
		FloatingTextStringOnCreature(GetName(oTarget) + " has not initiated a charge attack.", oInitiator, FALSE);
	}
    }
}