//::///////////////////////////////////////////////
//:: Name           Blademeld Throat Bind
//:: FileName       moi_iblade_sht
//:: At will as a standard action, each enemy within 60 feet who can hear you shout must save or become shaken for 1 round (Will DC 10 + incarnum blade level + Con modifier).
//:://////////////////////////////////////////////

#include "prc_inc_template"

void main()
{
	location lTarget = GetLocation(OBJECT_SELF);
    // Declare the spell shape, size and the location.  Capture the first target object in the shape.
    // Cycle through the targets within the spell shape until an invalid object is captured.
    int nDC = 10 + GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, OBJECT_SELF) + GetAbilityModifier(ABILITY_CONSTITUTION);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
    	if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
    	{
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
            {
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectShaken()), oTarget, RoundsToSeconds(1));
            }
    	}
		
    	oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}