//::///////////////////////////////////////////////
//:: Combat Maneuver calling script: 
//:: prc_combatmove
//::///////////////////////////////////////////////
/** @file
    Relies on prc_inc_combmove to do various things
    This is only for the basic maneuvers, special 
    versions of these things should be called from
    their own scripts.

    Things:
    Trip
    Bullrush
    Charge
    Overrun
    Disarm
    Shield Bash

    @author Stratovarius
    @date   Created - 2018.9.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_combmove"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    location lTarget = PRCGetSpellTargetLocation();
    int nMoveType = PRCGetSpellId();
    
    if (oTarget == oPC) return; // No hitting yourself
    if (GetLocalInt(oPC, "CombatLoopProtection")) return; // Stop the damn loop
    
    //FloatingTextStringOnCreature("MoveID: "+IntToString(nMoveType), oPC, FALSE);
   
    if (nMoveType == COMBAT_CHARGE)
        DoCharge(oPC, oTarget);
    else if (nMoveType == COMBAT_CHARGE_BULL_RUSH)
        DoCharge(oPC, oTarget, FALSE, TRUE, 0, -1, TRUE); 
    else if (nMoveType == COMBAT_BULL_RUSH)
        DoBullRush(oPC, oTarget, 0);   
    else if (nMoveType == COMBAT_TRIP)
        DoTrip(oPC, oTarget, 0);    
    else if (nMoveType == COMBAT_OVERRUN)
        DoOverrun(oPC, oTarget, lTarget);  
    else if (nMoveType == COMBAT_DISARM)
        DoDisarm(oPC, oTarget);        
    else if (nMoveType == COMBAT_SHIELD_BASH)
        DoShieldBash(oPC, oTarget);    
    else if (nMoveType == COMBAT_SHIELD_CHARGE)
        DoShieldCharge(oPC, oTarget);       
    else if (nMoveType == COMBAT_SHIELD_SLAM)
    {
    	// If we're far enough away, charge, else, slam
    	if (MetersToFeet(GetDistanceBetweenLocations(GetLocation(oPC), GetLocation(oTarget))) >= 10.0)
        	DoShieldCharge(oPC, oTarget, TRUE);
        else
        	DoShieldBash(oPC, oTarget, 0, 0, 0, FALSE, FALSE, TRUE);
    }    
    
    SetLocalInt(oPC, "CombatLoopProtection", TRUE);
    DelayCommand(4.0, DeleteLocalInt(oPC, "CombatLoopProtection"));
}