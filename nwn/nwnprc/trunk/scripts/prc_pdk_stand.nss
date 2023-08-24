/*
    Purple Dragon Knight's Final Stand
*/

#include "prc_inc_spells"

void main()
{
	object oPDK = OBJECT_SELF;
	int nCount = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPDK) + GetAbilityModifier(ABILITY_CHARISMA, oPDK);
	
	int nHP = d10(2);
	effect eHP = EffectTemporaryHitpoints(nHP);
	eHP = ExtraordinaryEffect(eHP);
	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);

	int nTargetsLeft = nCount;
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);

	//Cycle through the targets within the spell shape until you run out of targets.
	while (GetIsObjectValid(oTarget) && nTargetsLeft > 0)
	{
                if(oTarget == OBJECT_SELF)
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, RoundsToSeconds(nCount));
                    // Every time you apply effects, count down
                    nTargetsLeft -= 1;

                }
                else if(GetIsFriend(oTarget))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, RoundsToSeconds(nCount));
                    // Every time you apply effects, count down
                    nTargetsLeft -= 1;
                }
			
		//Select the next target within the spell shape.
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
	}
}