/*
   ----------------
   Pouncing Charge

   tob_tgcw_pnchrg.nss
   ----------------

    11/12/07 by Stratovarius
*/ /** @file

    Pouncing Charge

    Tiger Claw (Strike)
    Level: Swordsage 5, Warblade 5
    Prerequisite: Two Tiger Claw maneuvers
    Initiation Action: 1 Full-round action
    Range: Personal
    Target: You

    With the roar of a wild beast, you throw yourself into the fray.
    Your weapons are little more than a blur as you hack at your foe with feral speed.
    
    You charge your foe, but instead of performing a single attack at the end of the charge,
    you perform a full attack.
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
    	// Yup, thats it.
    	int nBonus = TOBSituationalAttackBonuses(oInitiator, DISCIPLINE_TIGER_CLAW);
	    DoCharge(oInitiator, oTarget, TRUE, TRUE, 0, -1, FALSE, 0, FALSE, FALSE, nBonus, TRUE);
        DelayCommand(0.1, TigerBlooded(oInitiator, oTarget));
    }
}