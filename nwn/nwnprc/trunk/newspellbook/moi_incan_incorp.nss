/*
3/1/21 by Stratovarius

once per day as a standard action, you can transform your physical body into pure, luminous energy for a number of rounds equal
to your Charisma modifi er (minimum 1). Upon assuming this form, you become incorporeal.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 

	SetIncorporeal(oMeldshaper, RoundsToSeconds(max(GetAbilityModifier(ABILITY_CHARISMA, oMeldshaper),1)), 1);
}