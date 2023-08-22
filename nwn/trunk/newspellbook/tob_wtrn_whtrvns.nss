/*
   ----------------
   White Raven Strike

   tob_stsn_whtrvns
   ----------------

   19/08/07 by Stratovarius
*/ /** @file

    White Raven Strike

    White Raven (Strike)
    Level: Crusader 4, Warblade 4
    Prerequisite: One White Raven maneuver
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    Your eye for tactics allows you to notice an enemy's weak points and attack them with a mighty blow.
    
    You make an attack that deals 4d6 extra damage. If it connects, is flatfooted for one round.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(4), 0, "White Raven Strike Hit", "White Raven Strike Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
		AssignCommand(oTarget, ClearAllActions(TRUE));
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