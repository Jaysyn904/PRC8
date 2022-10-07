/*
   ----------------
   Battle Leader's Charge

   tob_wtrn_btlldrc.nss
   ----------------

   08/06/07 by Stratovarius
*/ /** @file

    Battle Leader's Charge

    White Raven (Strike)
    Level: Crusader 2, Warblade 2
    Initiation Action: 1 Full-round Action
    Range: Melee Attack
    Target: One Creature

    You lead from the front, charging your enemies so that your allies
    can follow in your wake.
    
    You charge your opponent, dealing an extra 10 damage if you hit. You take no
    AoOs from the movement.
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
	DoCharge(oInitiator, oTarget, TRUE, FALSE, 10);
    }
}