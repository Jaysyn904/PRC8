/*
   ----------------
   Hydra Slaying Strike

   tob_stsn_hdrstrk
   ----------------

   05/12/07 by Stratovarius
*/ /** @file

    Hydra Slaying Strike

    Setting Sun (Strike)
    Level: Swordsage 7
    Prerequisite: Three Setting Sun maneuvers
    Initiation Action: 1 Standard action
    Range: Melee Attack.
    Target: One Creature.

    You take stock of an opponent's fighting style and make a single, carefully aimed attack
    that leaves the creature unable to make all of its attacks.
    
    You make an attack that deals deals normal damage, and leaves the creature unable to take the full-attack action.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone;
    	
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Hydra Slaying Strike Hit", "Hydra Slaying Strike Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
		SetBaseAttackBonus(1, oTarget);
		DelayCommand(6.0, RestoreBaseAttackBonus(oTarget));		
        }
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
    	DelayCommand(0.0, TOBAttack(oTarget, oInitiator));
    }
}