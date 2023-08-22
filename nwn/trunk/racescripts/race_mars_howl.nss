//::///////////////////////////////////////////////
//:: Name           Marrusault Howl
//:: FileName       race_mars_howl
//:: 
//:://////////////////////////////////////////////

#include "prc_inc_template"

void main()
{
	location lTarget = GetLocation(OBJECT_SELF);
    // Declare the spell shape, size and the location.  Capture the first target object in the shape.
    // Cycle through the targets within the spell shape until an invalid object is captured.
    int nDC = 10 + GetHitDice(OBJECT_SELF)/2 + GetAbilityModifier(ABILITY_CHARISMA);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
    	if (GetRacialType(oTarget) != RACIAL_TYPE_MARRUSAULT)
    	{
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
            {
            	// Fatigue outside of ten feet, exhausted within
				if (MetersToFeet(GetDistanceBetween(OBJECT_SELF,oTarget)) > 10.0)
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectFatigue()), oTarget, HoursToSeconds(GetHitDice(OBJECT_SELF)));
				else
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectExhausted()), oTarget, HoursToSeconds(GetHitDice(OBJECT_SELF)));
            }
    	}
		
    	oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}