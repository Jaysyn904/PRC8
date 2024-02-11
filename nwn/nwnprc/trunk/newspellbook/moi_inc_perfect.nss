/*
Perfect Meldshaper
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper  = OBJECT_SELF;
    SetLocalInt(oMeldshaper, "PerfectMeldshaper", TRUE);
	WipeMelds(oMeldshaper);
	ReshapeMelds(oMeldshaper);
	DelayCommand(RoundsToSeconds(GetAbilityModifier(ABILITY_WISDOM, oMeldshaper)+3), DeleteLocalInt(oMeldshaper, "PerfectMeldshaper"));
}