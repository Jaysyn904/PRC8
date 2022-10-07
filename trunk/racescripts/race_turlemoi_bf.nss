/*
28/10/21 by Stratovarius

Strength from Pain (Ex) Whenever a turlemoi takes damage 
from any source, it gains a +1 bonus on attack rolls, a +2 
bonus on damage rolls, and its natural armor bonus 
to AC increases by 2. These benefits last for 1 minute 
starting in the round during which a turlemoi first takes 
damage in the encounter.
 Bonuses stack each time a turlemoi takes damage, 
to a maximum of a +5 bonus on attack rolls, a +10 bonus 
on damage rolls, and a +10 natural armor bonus to AC. 
These bonuses accrue each time a turlemoi takes damage 
during that minute, even from multiple attacks in the 
same round. At the end of that minute, all these bonuses 
disappear. They could begin accumulating again if the 
turlemoi takes more damage 
*/

#include "prc_inc_function"

void main()
{
    object oCaster = PRCGetSpellTargetObject(); 

	int nBonus = GetLocalInt(oCaster, "StrengthFromPain");
	effect eLink = EffectLinkEffects(EffectACIncrease(nBonus*2, AC_NATURAL_BONUS), EffectDamageIncrease(nBonus*2, DAMAGE_TYPE_SLASHING | DAMAGE_TYPE_BLUDGEONING | DAMAGE_TYPE_PIERCING));
	       eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nBonus));
	       
	if (nBonus >= 3) eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));

	FloatingTextStringOnCreature("Applying Strength from Pain for "+IntToString(nBonus), oCaster, FALSE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oCaster, 60.0);
}