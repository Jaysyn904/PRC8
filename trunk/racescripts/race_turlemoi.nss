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
    object oCaster = OBJECT_SELF; 

	//FloatingTextStringOnCreature(GetName(GetLastDamager())+ " hit me for "+IntToString(GetTotalDamageDealt()), oCaster, FALSE);
	
	int nStrength = GetLocalInt(oCaster, "StrengthFromPain");
	
	// First time here
	if (!nStrength)
	{
		SetLocalInt(oCaster, "StrengthFromPain", 1);
		DelayCommand(60.0, DeleteLocalInt(oCaster, "StrengthFromPain"));
		DelayCommand(60.0, FloatingTextStringOnCreature("Strength from Pain reset", oCaster, FALSE));
		DelayCommand(60.0, PRCRemoveSpellEffects(SPELL_TURLEMOI_STRENGTH, oCaster, oCaster));
	    DelayCommand(60.0, GZPRCRemoveSpellEffects(SPELL_TURLEMOI_STRENGTH, oCaster, FALSE));
	}
	else if (5 > nStrength) // nStrength equals something, can't go above five
		SetLocalInt(oCaster, "StrengthFromPain", nStrength + 1);
			
	PRCRemoveSpellEffects(SPELL_TURLEMOI_STRENGTH, oCaster, oCaster);
	GZPRCRemoveSpellEffects(SPELL_TURLEMOI_STRENGTH, oCaster, FALSE);			
	ActionCastSpellOnSelf(SPELL_TURLEMOI_STRENGTH);		
	//FloatingTextStringOnCreature("Lesser Strength from Pain at "+IntToString(nStrength+1), oCaster, FALSE);	
}