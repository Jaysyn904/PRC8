//::///////////////////////////////////////////////
//:: Name           Marrutact Howl
//:: FileName       race_mart_howl
//:: 
//:://////////////////////////////////////////////

#include "prc_inc_template"

void main()
{
	location lTarget = GetLocation(OBJECT_SELF);

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
    	if (GetRacialType(oTarget) == RACIAL_TYPE_MARRUSAULT || GetRacialType(oTarget) == RACIAL_TYPE_MARRULURK || GetRacialType(oTarget) == RACIAL_TYPE_MARRUTACT)
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectHeal(d8(3)+5)), oTarget);
		
    	oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
    
	oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
    	if (GetRacialType(oTarget) == RACIAL_TYPE_MARRUSAULT || GetRacialType(oTarget) == RACIAL_TYPE_MARRULURK || GetRacialType(oTarget) == RACIAL_TYPE_MARRUTACT)
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectHeal(d8()+1)), oTarget);
		
    	oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }    
}