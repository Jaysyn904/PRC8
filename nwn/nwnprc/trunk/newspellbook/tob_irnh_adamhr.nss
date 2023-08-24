//////////////////////////////////////////////////
//  Adamantine Hurricane
//  tob_irnh_adamhr.nss
//  Tenjac 9/20/07
//////////////////////////////////////////////////
/** @file Adamantine Hurrican
Iron Heart(Strike)
Level: Warblade 8
Prerequisite: Three Iron Heart Maneuvers
Initiation Action: 1 standard action
Range: Melee attack
Targets: One or more adjacent creatures you threaten

In a blur of motion, you make a short, twisting leap in the air. As you turn, your
weapon flashes through the enemies around you like a blazing comet. As you drop 
back to the ground in your fighting stance, your enemies crumple to the ground
around you.

You sweep your weapon in a circle around you, striking out at nearby enemies. You
strike with the speed and ferocity of a lightning bolt, forcing your enemies to 
rely on their relexes for protection rather than their armor and shields.

You make two melee attacks against each adjacent oppoenent you threaten when you
initiate this maneuver. You receive a +4 bonus on each of these attacks, which are
otherwise made with your highest attack bonus.

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
                                //Attack
                                DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 4, 0, 0,"Adamantine Hurricane Hit", "Adamantine Hurricane Miss"));
                                
                                //Do it again :D
                                DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 4, 0, 0,"Adamantine Hurricane Hit", "Adamantine Hurricane Miss"));
                                
                        }// end if - Target validity check
                        
                        // Get next target
                        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oInitiator), TRUE, OBJECT_TYPE_CREATURE);
                }// end while - Target loop 
        }
}
                
                