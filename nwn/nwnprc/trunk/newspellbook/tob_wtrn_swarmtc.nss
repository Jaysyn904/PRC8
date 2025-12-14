/*
   ----------------
   Swarm Tactics, Heartbeat

   tob_wtrn_swarmtc.nss
   ----------------

    2025-12-11 23:47:04 by Jaysyn
*/ /** @file

    Swarm Tactics

    White Raven (Stance)
    Level: Crusader 5, Warblade 5
    Prerequisite: One White Raven maneuver
    Initiation Action: 1 Swift Action
    Range: 60 ft.
    Area: 60 ft.
    Duration: Stance.

    Your quick directions enable close teamwork between you and an ally.
    At your urging, your allies seize the initiative and work in close
    coordination with you to defeat an enemy.
    
    Any creature you threaten takes a -5 penalty to armour class.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
//#include "prc_alterations"

void main()  
{  
    //Declare major variables  
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);  
    object oCreator = GetAreaOfEffectCreator();  
    effect eAC = EffectACDecrease(5);  
           eAC = ExtraordinaryEffect(eAC);  
      
    // Loop through all creatures in the AoE  
    while(GetIsObjectValid(oTarget))  
    {  
        // Targets it can apply to - must be perceived, enemy, and in melee range  
        if (GetIsEnemy(oTarget, oCreator) &&   
            GetIsInMeleeRange(oTarget, oCreator) &&  
            (GetObjectSeen(oTarget, oCreator) || GetObjectHeard(oTarget, oCreator)))  
        {  
            // One round at a time.  
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oTarget, 6.0f);  
        }  
        //Get next target in the AoE  
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);  
    }  
}