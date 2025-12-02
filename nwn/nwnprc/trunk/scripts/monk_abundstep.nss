/*
Abundant Step (Su)
Type of Feat: Class Specific
Prerequisite: Monk 12
Specifics: At 12th level or higher, a monk can slip magically between spaces, as if using the spell dimension door, once per day. Her caster level for this effect is one-half her monk level (rounded down). 
Use: Selected
*/

#include "spinc_dimdoor"

void main()
{
    object oMonk = OBJECT_SELF;
	
	int nLevel = GetLevelByClass(CLASS_TYPE_MONK, oMonk);
	
    DimensionDoor(oMonk, nLevel/2);    
}