//////////////////////////////////////////////////
// Elder Mountain Strike
// tob_stdr_emntstr.nss
// Tenjac 9/11/07
//////////////////////////////////////////////////
/** @file Elder Mountain Strike
Stone Dragon (Strike)
Level: Crusader 5, swordsage 5, warblade 5
Prerequisite: Two Stone Dragon maneuvers
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature or unattended object

You draw strength from the earth beneath your feet and transfer it into ruinous power.
Your next attack drops like an avalanche upon your foe, hammering him into submission.

The students of the Stone Dragon discipline learn to tap into the power of the earth, 
channel its endless strength, and use it to grant their attacks tremendous force. A 
strike delivered by a Stone Dragon adept can shatter a warrior's shield, turn a wooden
door into splinters, or slay an ogre with a single blow.

when you use this maneuver, you make a single melee attack. That attack deals an extra
6d6 points of damage and automatically overcomes damage reduction.

*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

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
                SetLocalInt(oInitiator, "MoveIgnoreDR", TRUE);
                object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
                DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(6), GetWeaponDamageType(oWeap), "Elder Mountain Strike Hit", "Elder Mountain Strike Miss"));
                // Cleanup
                DelayCommand(3.0, DeleteLocalInt(oInitiator, "MoveIgnoreDR"));
        }
}