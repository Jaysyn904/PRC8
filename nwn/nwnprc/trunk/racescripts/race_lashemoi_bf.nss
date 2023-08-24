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

	int nBonus = GetLocalInt(oCaster, "LesserStrengthFromPain");
	effect eLink = EffectLinkEffects(EffectACIncrease(nBonus, AC_NATURAL_BONUS), EffectDamageIncrease(nBonus, DAMAGE_TYPE_SLASHING | DAMAGE_TYPE_BLUDGEONING | DAMAGE_TYPE_PIERCING));
	       eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nBonus));

	FloatingTextStringOnCreature("Applying Lesser Strength from Pain for "+IntToString(nBonus), oCaster, FALSE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oCaster, 60.0);
}