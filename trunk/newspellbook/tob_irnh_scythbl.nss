//////////////////////////////////////////////////
//  Scything Blade
//  tob_irnh_scythbl.nss
//  Tenjac 9/26/07
//////////////////////////////////////////////////
/** @file Scything Blade
Iron Heat(Boost)
Level: Warblade 7
Prerequisite Three Iron Heart maneuvers
Initiation Action: 1 swift action
Range: Personal
Target: You

You strike at one foe with a long, high backhand cut, then make a quick turn to
continue the stroke against another nearby enemy.

You swing your weapon in a wide, deadly arc. With your supreme skill and martial
training, you aim your attack so that as you strike one opponent, you set yourslef
up perfectly to make a second attack against a different foe. As your weapon strikes
one opponent, it cuts into him, then ricochets to your second target.

If the first melee attack you make during your turn hits, you can immediately make a 
free attack at your highest attack bonus against a different enemy that you threaten.
You can only gain one free attack each time you initiate this maneuver, regardless of
how many successful attacks you make in this round.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
        	effect eNone;
                PerformAttackRound(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, FALSE, "Scything Blade Hit", "Scything Blade Miss");
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                        location lLoc = GetLocation(oInitiator);
                        object oTarget2 = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(15.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);
                        
                        while(GetIsObjectValid(oTarget2))
                        {
                                if(!GetIsReactionTypeFriendly(oTarget2) && oTarget2 != oInitiator)
                                {
                                        PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Scything Blade Hit", "Scything Blade Miss");
                                        break;
                                }
                                
                                else oTarget2 = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(15.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);
                        }
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
        effect eVis;
        
        if(move.bCanManeuver)
        {
        	DelayCommand(0.0, TOBAttack(oTarget, oInitiator));
        }
}
                                