//::///////////////////////////////////////////////
//:: Name           Blooded One War Cry script
//:: FileName       tmp_blooded_cry
//:: 
//:://////////////////////////////////////////////

#include "prc_inc_template"

void main()
{
	location lTarget = GetLocation(OBJECT_SELF);
    // Declare the spell shape, size and the location.  Capture the first target object in the shape.
    // Cycle through the targets within the spell shape until an invalid object is captured.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
    	if (GetHasTemplate(TEMPLATE_BLOODED_ONE, oTarget))
    	{
    		effect eLink = EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_1), EffectAttackIncrease(1));
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oTarget, RoundsToSeconds(d4(2)));
    	}
		
    	oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}