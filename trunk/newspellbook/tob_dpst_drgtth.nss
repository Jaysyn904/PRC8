/*
    ----------------
    Dragon's Tooth

    tob_dpst_drgtth
    ----------------

    27/01/08 by Stratovarius
*/ /** @file

    Dragon's Tooth

    Deepstone Sentinel level 4

    You cause a pillar of earth to erupt, tossing foes to the ground.
    
    You cause a 10 foot tall pillar of stone to appear, tossing enemies to the ground.
*/

#include "prc_inc_spells"

void main()
{
	object oInitiator = OBJECT_SELF;
	object oCreature = CreateObject(OBJECT_TYPE_PLACEABLE, "tob_dpst_pillar", PRCGetSpellTargetLocation());
	object oProneTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oInitiator));
	while(GetIsObjectValid(oProneTarget))
	{
                // Save check
		if (!PRCMySavingThrow(SAVING_THROW_WILL, oProneTarget, (10 + GetHitDice(oInitiator)/2 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator))))
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oProneTarget, 6.0);
   	        }

    	oProneTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oInitiator));
	}  	
}
