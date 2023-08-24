///////////////////////////////////////////////
// Nerv
// sp_nerv.nss
////////////////////////////////////////////////
/*
Nerv: This is the street name for a substance also known as liquid courage, 
a gold-colored syrup in a clear glass bottle painted with interweaving blue 
and red swirls. Drinking a dose of nerv grants the drinker a +2 alchemical 
bonus on saves against fear effects for 1 hour.
*/

#include "prc_inc_spells"

void main()
{
        object oTarget = OBJECT_SELF;
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_FEAR), oTarget, HoursToSeconds(1));
        SendMessageToPC(oTarget, "You feel braver.");
}