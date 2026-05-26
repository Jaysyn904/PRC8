/*
    ----------------
    Dragon's Tooth

    tob_dpst_drgtth
    ----------------

    27/01/08 by Stratovarius
	
	Fixed by: Jaysyn
	On: 2026-05-25 19:11:53
	
*/ /** @file

    Dragon's Tooth

    Deepstone Sentinel level 4

    You cause a pillar of earth to erupt, tossing foes to the ground.
    
    You cause a 10 foot tall pillar of stone to appear, tossing enemies to the ground.
*/
#include "tob_inc_move"
#include "prc_inc_spells"

void main()
{
	object oInitiator = OBJECT_SELF;
	object oCreature = CreateObject(OBJECT_TYPE_PLACEABLE, "tob_dpst_pillar", PRCGetSpellTargetLocation());
	object oProneTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), PRCGetSpellTargetLocation());
	while(GetIsObjectValid(oProneTarget))
	{
		int nDC = 10 + GetHitDice(oInitiator)/2 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
		
		int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));
		if (nBladeMed)
		{
			nDC += 1;
		}      
	// Save check
		if (!PRCMySavingThrow(SAVING_THROW_REFLEX, oProneTarget, nDC))
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oProneTarget, 6.0);
		}

    	oProneTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), PRCGetSpellTargetLocation());
	}  	
}
