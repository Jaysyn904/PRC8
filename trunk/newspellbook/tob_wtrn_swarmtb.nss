/*
   ----------------
   Swarm Tactics, Exit

   tob_wtrn_swarmt.nss
   ----------------

    29/09/07 by Stratovarius
*/ /** @file

    Swarm Tactics

    Devoted Spirit (Stance)
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
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(MOVE_WR_SWARM_TACTICS, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                    //If the effect was created by MOVE_WR_SWARM_TACTICS
                    if(GetEffectSpellId(eAOE) == MOVE_WR_SWARM_TACTICS)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}

