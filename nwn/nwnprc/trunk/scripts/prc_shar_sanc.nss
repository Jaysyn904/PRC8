/*
    Celebrant of Sharess Sanctuary
*/

#include "prc_inc_spells"  

void main()
{
	object oPC = OBJECT_SELF;
	int nClass = GetLevelByClass(CLASS_TYPE_CELEBRANT_SHARESS, oPC);
    int nDC = GetSkillRank(SKILL_PERFORM, oPC) + d20();
    location lTarget = GetLocation(oPC);

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (GetIsFriend(oPC, oTarget) || oTarget == oPC)
        {
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSanctuary(nDC), oTarget, HoursToSeconds(nClass));
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}