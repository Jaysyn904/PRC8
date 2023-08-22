/*
27/10/21 by Stratovarius

Lesser Strength from Pain (Ex) Whenever a lashemoi takes 
damage from any source, it gains a +1 bonus on attack 
rolls, a +1 bonus on damage rolls, and its natural armor 
bonus to AC increases by 1. These benefits last for 1 
minute starting in the round during which a lashemoi 
first takes damage in the encounter.
 Bonuses stack each time a lashemoi takes damage, to 
a maximum of a +5 bonus on attack rolls, a +5 bonus on 
damage rolls, and a +5 natural armor bonus to AC. These 
bonuses accrue each time a lashemoi takes damage 
during that minute, even from multiple attacks in the 
same round. At the end of that minute, all these bonuses 
disappear. They could begin accumulating again if the 
lashemoi takes more damage
*/

#include "prc_inc_function"

void main()
{
    object oCaster = OBJECT_SELF; 

	//FloatingTextStringOnCreature(GetName(GetLastDamager())+ " hit me for "+IntToString(GetTotalDamageDealt()), oCaster, FALSE);
	
	int nStrength = GetLocalInt(oCaster, "LesserStrengthFromPain");
	
	// First time here
	if (!nStrength)
	{
		SetLocalInt(oCaster, "LesserStrengthFromPain", 1);
		DelayCommand(60.0, DeleteLocalInt(oCaster, "LesserStrengthFromPain"));
		DelayCommand(60.0, FloatingTextStringOnCreature("Lesser Strength from Pain reset", oCaster, FALSE));
		DelayCommand(60.0, PRCRemoveSpellEffects(SPELL_LASHEMOI_STRENGTH, oCaster, oCaster));
	    DelayCommand(60.0, GZPRCRemoveSpellEffects(SPELL_LASHEMOI_STRENGTH, oCaster, FALSE));
	}
	else if (5 > nStrength) // nStrength equals something, can't go above five
		SetLocalInt(oCaster, "LesserStrengthFromPain", nStrength + 1);
			
	PRCRemoveSpellEffects(SPELL_LASHEMOI_STRENGTH, oCaster, oCaster);
	GZPRCRemoveSpellEffects(SPELL_LASHEMOI_STRENGTH, oCaster, FALSE);			
	ActionCastSpellOnSelf(SPELL_LASHEMOI_STRENGTH);		
	//FloatingTextStringOnCreature("Lesser Strength from Pain at "+IntToString(nStrength+1), oCaster, FALSE);	
}