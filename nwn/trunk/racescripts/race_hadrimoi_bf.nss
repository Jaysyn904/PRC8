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
    object oCaster = PRCGetSpellTargetObject(); 

	int nBonus = GetLocalInt(oCaster, "SpeedFromPain");
	effect eLink = EffectLinkEffects(EffectACIncrease(nBonus*2, AC_DODGE_BONUS), EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nBonus));
	       eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nBonus));
	       
	ExecuteScript("prc_speed", oCaster);
	if (nBonus >= 3) IPSafeAddItemProperty(GetPCSkin(oCaster), ItemPropertyBonusFeat(IP_CONST_FEAT_SPRINGATTACK), 60.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	       
	FloatingTextStringOnCreature("Applying Speed from Pain for "+IntToString(nBonus), oCaster, FALSE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oCaster, 60.0);
}