/*
   ----------------
   Bounding Assault

   tob_dmnd_bndaslt
   ----------------

   19/08/07 by Stratovarius
*/ /** @file

    Bounding Assault

    Diamond Mind (Strike)
    Level: Swordsage 4, Warblade 4
    Prerequisite: Two Diamond Mind Maneuvers
    Initiation Action: 1 Full-round action
    Range: Melee Attack
    Target: One Creature
    Duration: 1 round.

    You hack into your foe's legs, forcing his movement to slow and his resolution to falter.
    
    You make a double move and attack a foe with a +2 bonus to attack. This counts as a charge attack.
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
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(2), oTarget, 6.0);
	    int nAB = 0;
    	if (GetLocalInt(oInitiator, "SupernalAttack")) nAB += 1;
		DoCharge(oInitiator, oTarget, TRUE, TRUE, 0, -1, FALSE, 0, FALSE, TRUE, nAB);
    }
}