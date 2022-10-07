//::///////////////////////////////////////////////
//:: Name      Divine Intercession
//:: FileName  prc_ft_intrcssn.nss
//:://////////////////////////////////////////////
/** You can spend three turn or rebuke undead 
attempts to teleport to any point up to 30 feet 
away within line of sight. This effect functions 
as dimension door, except that you can't bring 
along other creatures.

Author:    Stratovarius
Created:   13.11.2018
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_dimdoor"

void main()
{
    object oInitiator = OBJECT_SELF;

    //make sure there's TU uses left
    if (!GetHasFeat(FEAT_TURN_UNDEAD, oInitiator))
    {
        FloatingTextStringOnCreature("You are out of Turn Undead uses for the day.", oInitiator, FALSE);
        return;
    }
    DecrementRemainingFeatUses(oInitiator, FEAT_TURN_UNDEAD); // Burn one
    if (!GetHasFeat(FEAT_TURN_UNDEAD, oInitiator))
    {
        FloatingTextStringOnCreature("You are out of Turn Undead uses for the day.", oInitiator, FALSE);
        IncrementRemainingFeatUses(oInitiator, FEAT_TURN_UNDEAD); // Restore one 
        return;
    }
    DecrementRemainingFeatUses(oInitiator, FEAT_TURN_UNDEAD); // Burn two    
    if (!GetHasFeat(FEAT_TURN_UNDEAD, oInitiator))
    {
        FloatingTextStringOnCreature("You are out of Turn Undead uses for the day.", oInitiator, FALSE);
        IncrementRemainingFeatUses(oInitiator, FEAT_TURN_UNDEAD); // Restore two 
        IncrementRemainingFeatUses(oInitiator, FEAT_TURN_UNDEAD); // Restore two
        return;
    }
    DecrementRemainingFeatUses(oInitiator, FEAT_TURN_UNDEAD); // Burn three, and we're good      
    
    DimensionDoor(oInitiator, GetHitDice(oInitiator));    
}

