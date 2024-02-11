//////////////////////////////////////////////////
// Mountain Tombstone Strike
// tob_stdr_mttmbst.nss
// Tenjac 9/12/07
//////////////////////////////////////////////////
/** @file Mountain Tombstone Strike
Stone Dragon (Strike)
Level: Crusader 9, swordsage 9, warblade 9
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature

You slam into your foe, turning bones into dust and muscle into bloody pulp. Your foe's 
body is left a crippled, twisted mockery.

Your attack causes damage to the structure of your foe's body. As part of this maneuver, 
you make a single melee attack. If this attack hits, you deal 2d6 points of Constitution
damage in addition to your normal damage.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
                effect eNone;
                PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Mountain Tombstone Strike Hit", "Mountain Tombstone Strike Miss");
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                        ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, d6(2), DURATION_TYPE_PERMANENT);    
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
               
        if(move.bCanManeuver)
        {
        	DelayCommand(0.0, TOBAttack(oTarget, oInitiator));
        }
}