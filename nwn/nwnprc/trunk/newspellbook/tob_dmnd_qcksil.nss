//////////////////////////////////////////////////
//  Quicksilver Motion
//  tob_dmnd_qcksil.nss
//  Tenjac 10/3/07
//////////////////////////////////////////////////
/** @file Quicksilver Motion
Diamond Mind (Boost)
Level: Swordsage 7, warblade 7
Prerequisite: Three Diamond Mind maneuvers
Inititation Action: 1 swirft action
Range: Personal
Target: You

In the blink of an eye, you make your move. Your speed, reflexes, and boundless confidence
combine to allow you to make a fast, bold move that catches your fores off guard.

Your speed doubles for one round.

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
                EffectMovementSpeedIncrease(99);
        }
}