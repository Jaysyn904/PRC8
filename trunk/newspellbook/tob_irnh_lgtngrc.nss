/*
   ----------------
   Lightning Recovery

   tob_irnh_lgtngrc
   ----------------

   19/08/07 by Stratovarius
*/ /** @file

    Lightning Recovery

    Iron Heart (Counter)
    Level: Warblade 4
    Prerequisite: Two Iron Heart Maneuvers
    Initiation Action: 1 Swift Action
    Range: Melee Attack
    Target: One Creature

    Your foe twists out of the way of your initial attack, but your weapon becomes a blur as 
    you reverse direction and strike at him again with lightning speed. In the blink of an
    eye, you complete your attack and resume your defensive posture.
    
    Make a single attack with a +2 bonus on the attack roll. 
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
	DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 2, 0, 0, "Lightning Recovery Hit", "Lightning Recovery Miss"));
    }
}