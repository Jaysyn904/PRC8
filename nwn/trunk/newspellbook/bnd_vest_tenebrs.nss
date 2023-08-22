/*
05/03/21 by Stratovarius

Tenebrous, the Shadow That Was
  
Tenebrous, once a powerful demon prince, offers dominion over darkness and death.

Vestige Level: 4th
Binding DC: 21
Special Requirement: You must draw Tenebrous’s seal at night.

Influence: While influenced by Tenebrous, you are filled with a sense of detachment and an aching feeling of loss and abandonment. 
Tenebrous requires that you never be the first to act in combat. If your initiative check result is the highest, you must delay until someone else takes a turn.

Granted Abilities: 
Tenebrous grants you power over undead and shadows. He gives you the ability to chill your foes.

Deeper Darkness: You can cloak an area in shadows as though using the deeper darkness spell (caster level equals your effective binder level), with the effect always centered on you.

See in Darkness: You can see perfectly through darkness of any kind.

Touch of the Void: As a swift action, you can charge a melee attack or melee touch attack with cold energy. Your next melee attack deals an extra 1d8 points of cold 
damage, plus 1d8 points of cold damage for every four effective binder levels beyond 7th that you possess. When you attain an effective binder level of 11th, you 
can charge your weapon for an entire round. Once you have used this ability, you cannot do so again for 5 rounds.

Turn/Rebuke Undead: You can turn or rebuke undead as a cleric of your effective binder level. As with a cleric, you turn if you are good and rebuke if you are evil. 
Once you have used this ability, you cannot do so again for 5 rounds.

Vessel of Emptiness: You can use the flicker shadow magic mystery once per day. At 13th level, you can use this ability two times per day, and at 19th level, you can use it three times per day.
*/

#include "bnd_inc_bndfunc"

void TenebrousInfluence(object oBinder, int nCombat);

void TenebrousInfluence(object oBinder, int nCombat)
{
	if (GetHasSpellEffect(VESTIGE_TENEBROUS, oBinder))
	{
		int nCurrent = GetIsInCombat(oBinder);
		// We just entered combat
		if (nCurrent == TRUE && nCombat == FALSE)
		{
        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectSlow()), oBinder, 6.0);
		}	
		 
    	DelayCommand(0.25, TenebrousInfluence(oBinder, nCurrent));
    }	
}

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
    SetLocalObject(GetModule(), "TenebrousCharm", oBinder);
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_TENEBROUS);

    effect eLink = EffectLinkEffects(EffectVisualEffect(PSI_DUR_SHADOW_BODY), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_TENEBROUS_DARKNESS))     IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_TENEBROUS_DARKNESS),   HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_TENEBROUS_SEE_DARKNESS)) eLink = EffectLinkEffects(eLink, EffectUltravision());
	if (!GetIsVestigeExploited(oBinder, VESTIGE_TENEBROUS_TOUCH_VOID))   IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_TENEBROUS_TOUCH_VOID), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_TENEBROUS_TURN_UNDEAD))  IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_TENEBROUS_TURN),       HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_TENEBROUS_EMPTY_VESSEL)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_TENEBROUS_VESSEL),     HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	    
    if (!GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_TENEBROUS)))
    {
    	FloatingTextStringOnCreature("You have made a poor pact, and Tenebrous prevents you from acting first in combat!", oBinder, FALSE);    
    	// Lets the spell apply first
    	DelayCommand(3.0, TenebrousInfluence(oBinder, FALSE));
    }	
    if (GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oBinder) >= 2) eLink = EffectLinkEffects(eLink, EffectAreaOfEffect(136, "bnd_tnb_visage", "", ""));
     
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}