/*
   ----------------
   Swarm Tactics, Enter

   tob_wtrn_swarmta.nss
   ----------------

    29/09/07 by Stratovarius
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

void CheckAndApply(object oTarget, object oCreator)  
{  
    if ((GetObjectSeen(oTarget, oCreator) || GetObjectHeard(oTarget, oCreator)) &&  
        GetIsInMeleeRange(oTarget, oCreator))  
    {  
        effect eAC = ExtraordinaryEffect(EffectACDecrease(5));  
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oTarget, 7.0f);  
    }  
}

void main()  
{  
    //Declare major variables  
    object oTarget = GetEnteringObject();  
    object oCreator = GetAreaOfEffectCreator();  
      
    // Only check enemies (not the creator)  
    if (oTarget != oCreator && GetIsEnemy(oTarget, oCreator))  
    {  
        // Check if we can perceive them and they're in melee range  
        if ((GetObjectSeen(oTarget, oCreator) || GetObjectHeard(oTarget, oCreator)) &&  
            GetIsInMeleeRange(oTarget, oCreator))  
        {  
            effect eAC = ExtraordinaryEffect(EffectACDecrease(5));  
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oTarget, 7.0f);  
        }  
        else  
        {  
            // Recheck after a short delay in case they move into range and become perceivable  
            DelayCommand(0.5, CheckAndApply(oTarget, oCreator));  
        }  
    }  
}  
  
