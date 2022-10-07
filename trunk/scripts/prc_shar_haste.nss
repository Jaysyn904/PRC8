/*
    Celebrant of Sharess Haste
*/

#include "prc_class_const"  

void main()
{
	object oPC = OBJECT_SELF;
	int nClass = GetLevelByClass(CLASS_TYPE_CELEBRANT_SHARESS, oPC);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectHaste(), oPC, RoundsToSeconds(nClass));
}
