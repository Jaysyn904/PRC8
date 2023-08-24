/*
27/10/21 by Stratovarius

Strength from Magic (Ex) Each time an arkamoi casts an 
arcane spell, magical feedback grants it a rush of power. 
For each arcane spell cast, an arkamoi increases the save 
DC of subsequent arcane spells it casts by 1. Additionally, 
the arkamoi gains a +2 bonus on damage rolls for 
subsequent spells, and gains a +2 deflection bonus to 
AC. These benefits last for 1 minute starting in the round 
during which the arkamoi finishes casting its first spell of 
the encounter.

Bonuses stack each time an arkamoi casts an arcane 
spell within that minute, to a maximum of a +5 bonus 
to save DCs, a +10 bonus on damage rolls, and a +10 
deflection bonus to AC. At the end of that minute, all 
these bonuses disappear. They could begin accumulating 
again if the arkemoi casts more spells. 
*/

#include "prc_inc_function"

void main()
{
    object oCaster = PRCGetSpellTargetObject(); 
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(GetLocalInt(oCaster, "StrengthFromMagic")*2, AC_DEFLECTION_BONUS)), oCaster, 60.0);
}