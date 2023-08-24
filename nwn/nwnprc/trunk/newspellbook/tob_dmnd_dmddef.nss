//////////////////////////////////////////////////
//  Diamond Defense
//  tob_dmnd_dmddef.nss
//  Tenjac  10/3/07
//////////////////////////////////////////////////
/** @file Diamond Defense
Diamond Mind(Counter)
Level: Swordsage 8, warblade 8
Initiation Action: 1 immediate action
Range: Personal
Target: You

You steel yourself against an opponent's spell, drawing on your focus and training
to overcome its effect.

You can initiate this maneuver any time you would be required to make a saving throw.
You gain a bonus on that save equal to your initiator level. You must use this maneuver
before you roll the saving throw.
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
                SetLocalInt(oInitiator, "PRC_TOB_DIAMOND_DEFENSE", GetInitiatorLevel(oInitiator));
        }
}