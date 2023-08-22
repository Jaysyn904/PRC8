/*
   ----------------
   Mithral Tornado

   tob_irnh_mthtrn
   ----------------

   19/08/07 by Stratovarius
*/ /** @file

    Mithral Tornado

    Iron Heart (Strike)
    Level: Warblade 4
    Prerequisite: Two Iron Heart Maneuvers
    Initiation Action: 1 Standard action
    Range: Melee Attack
    Target: Adjacent Creatures

    Your weapon becomes a blur of motion as you swing it in a tight arc over your head.
    Once you build up enough speed, you explode into a sweeping attack that chops the
    enemies around you.
    
    You make a single attack against each adjacent opponent with a +2 bonus.
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
	
       oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oInitiator), TRUE, OBJECT_TYPE_CREATURE);
       while(GetIsObjectValid(oTarget))
       {
           // No hitting yourself or your friends, and they need to be within hitting range.
           if(oTarget != oInitiator && GetIsEnemy(oTarget, oInitiator) && GetIsInMeleeRange(oTarget, oInitiator))
           {
		        DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 2, 0, 0, "Mithral Tornado Hit", "Mithral Tornado Miss"));
           }// end if - Target validity check
     
     // Get next target
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oInitiator), TRUE, OBJECT_TYPE_CREATURE);
        }// end while - Target loop	
    }
}