/*
28/10/21 by Stratovarius

Speed from Pain (Ex) Each time a hadrimoi takes damage, 
the fibrous tendrils that make up its body become 
increasingly elastic and responsive. The hadrimoi gains 
a +2 dodge bonus to AC, a +1 bonus on attack rolls and 
Reflex saves, and a +10-foot bonus to its land speed. 
These benefits last for 1 minute starting in the round 
during which a hadrimoi first takes damage in the 
encounter.
 Bonuses stack each time a hadrimoi takes damage, 
to a maximum of a +10 dodge bonus to AC, a +5 
bonus on attack rolls and Reflex saves, and a +50-foot 
bonus to land speed. These bonuses accrue each time 
a hadrimoi takes damage during that minute, even 
from multiple attacks in the same round. At the end of 
that minute, all these bonuses disappear. They could 
begin accumulating again if the hadremoi takes more 
damage.
*/

#include "prc_inc_function"

void main()
{
    object oCaster = OBJECT_SELF; 

	//FloatingTextStringOnCreature(GetName(GetLastDamager())+ " hit me for "+IntToString(GetTotalDamageDealt()), oCaster, FALSE);
	
	int nStrength = GetLocalInt(oCaster, "SpeedFromPain");
	
	// First time here
	if (!nStrength)
	{
		SetLocalInt(oCaster, "SpeedFromPain", 1);
		DelayCommand(60.0, DeleteLocalInt(oCaster, "SpeedFromPain"));
		DelayCommand(60.0, FloatingTextStringOnCreature("Speed from Pain reset", oCaster, FALSE));
		DelayCommand(60.0, PRCRemoveSpellEffects(SPELL_HADRIMOI_STRENGTH, oCaster, oCaster));
	    DelayCommand(60.0, GZPRCRemoveSpellEffects(SPELL_HADRIMOI_STRENGTH, oCaster, FALSE));
	    DelayCommand(60.0, ExecuteScript("prc_speed", oCaster));
	}
	else if (5 > nStrength) // nStrength equals something, can't go above five
		SetLocalInt(oCaster, "SpeedFromPain", nStrength + 1);
			
	PRCRemoveSpellEffects(SPELL_HADRIMOI_STRENGTH, oCaster, oCaster);
	GZPRCRemoveSpellEffects(SPELL_HADRIMOI_STRENGTH, oCaster, FALSE);			
	ActionCastSpellOnSelf(SPELL_HADRIMOI_STRENGTH);		
	//FloatingTextStringOnCreature("Lesser Strength from Pain at "+IntToString(nStrength+1), oCaster, FALSE);	
}