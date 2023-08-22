/*
   ----------------
   Sapphire Nightmare Blade

   tob_dmnd_snhtbld
   ----------------

   29/03/07 by Stratovarius
*/ /** @file

    Sapphire Nightmare Blade

    Diamond Mind (Strike)
    Level: Swordsage 1, Warblade 1
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    You study your opponent for a brief moment, watching his defensive
    maneuvers and making a strike timed to take advantage of a lull in his vigilance.
    
    You make a Concentration check against the target's AC. If you succeed, the target
    takes an extra 1d6 damage and is flat-footed vs your attack. If you fail, you take
    a -2 penalty on the attack.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

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
    	effect eNone;
    	int nDC = GetDefenderAC(oTarget, oInitiator);
    	int nAB = -2;
    	int nDamage = 0;
    	int nDamageType = 0;
    	if (GetIsSkillSuccessful(oInitiator, SKILL_CONCENTRATION, nDC)) 
    	{
    		nAB = 0;
    		nDamageType = DAMAGE_TYPE_MAGICAL;
    		nDamage = d6();
    		AssignCommand(oTarget, ClearAllActions(TRUE));
    	}
    	if (GetLocalInt(oInitiator, "SupernalAttack")) nAB += 1;
		DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, nAB, nDamage, nDamageType, "Sapphire Nightmare Blade Hit", "Sapphire Nightmare Blade Miss"));
    }
}