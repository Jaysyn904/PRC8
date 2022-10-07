//::///////////////////////////////////////////////
//:: Breath of Life for the Swift Wing
//:: prc_swftwg_bol.nss
//::///////////////////////////////////////////////
/*
    Handles the Breath of Life ability for Swift Wings
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 20, 2007
//:://////////////////////////////////////////////


#include "prc_alterations"
#include "prc_inc_spells"
#include "prc_inc_breath"

void main()
{
    object oPC = OBJECT_SELF;
	
    //make sure there's TU uses left
    if (!GetHasFeat(FEAT_TURN_UNDEAD,oPC))
    {
    	FloatingTextStringOnCreature("You are out of Turn Undead uses for the day.", oPC, FALSE);
    	return;
    }
    
    //use up one
    DecrementRemainingFeatUses(OBJECT_SELF,FEAT_TURN_UNDEAD);
    
    int nClass                    = GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC);
    struct breath SwiftWingBreath = CreateBreath(oPC, FALSE, 30.0, DAMAGE_TYPE_POSITIVE, 6, nClass, ABILITY_CHARISMA, nClass, BREATH_SWIFT_WING, 0);
    location lTarget              = PRCGetSpellTargetLocation();
    
    ApplyBreath(SwiftWingBreath, lTarget);
    
}