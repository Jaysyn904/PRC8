//////////////////////////////////////////////////
//  Time Stands Still
//  tob_dmnd_timess.nss
//  Tenjac  10/3/07
//////////////////////////////////////////////////
/** @file Time Stands Still
Diamond Mind(Strike)
Level: Swordsage 9, warblade 9
Prerequisite: Four Diamond Mind maneuvers
Initiation Action: 1 full-round action
Range: Personal
Target: You

The raindrops themselves stand still as you act at the speed of thought. You move
like a blur, catching your enemies by surprise with a complex action carried our in 
a tiny fraction of the time normally needed to complete it.

In an unmatched burst of speed, agility, and decisive action, you move more quickly
than the eye can follow. You can lash out with your blade, striking your opponent so
rapidly that observers can't keep track of your moves.

As part of this maneuver, you can use a full attack action two times in succession.
Take your first full attack as normal. Once you have resolved those attacks, you can 
then take another full attack action. You must resolve these actions separately. You
cannot combine the attacks provided by both atcions as you wish. Instead, you must 
take them separately and in order as normal for a full attack.
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
        effect eNone;
        
        if(move.bCanManeuver)
        {
                DelayCommand(0.0, PerformAttackRound(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, TRUE, "Time Stands Still Hit", "Time Stands Still Miss", FALSE, FALSE, TRUE));                
                DelayCommand(1.0, PerformAttackRound(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, TRUE, "Time Stands Still Hit", "Time Stands Still Miss", FALSE, FALSE, FALSE));
        }
}