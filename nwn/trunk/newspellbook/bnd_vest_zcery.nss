/*
18/03/21 by Stratovarius

Zceryll, the Star Spawn
  
Zceryll was a mortal sorceress who communed with alien powers from the far realm. She became obsessed with immortality, seeking out the alien beings in the hopes 
of learning their eternal secrets. When she died, she became a hideously twisted vestige, forever seeking to re-enter the Realms via numerous artifacts she dispersed 
across the world. Zceryll grants you the ability to transform your body and mind into an alien form, granting you telepathy, resistance to effects related to insanity, 
the ability to summon pseudonatural creatures, and the power to unleash bolts of pure madness.

Vestige Level: 6th
Binding DC: 25
Special Requirement: No

Influence: Never admit that you need help or that you are weaker than anyone else. Treat those that are weaker than you with scorn and contempt, especially young women and spontaneous spellcasters.

Granted Abilities: 
While bound to Zceryll, your body and mind become alien, allowing you to channel the power of the star spawn in a variety of ways.

Alien form: While bound to Zceryll, you gain the pseudonatural template.

Alien Mind: Your mind is alien and does not work like that of a normal mortal. You are immune to confusion, insanity, and weird spells. In addition, you receive a +1 bonus per 
four binder levels on saving throws against mind-affecting effects.

Bolts of Madness: You can fire a ray that dazes an opponent for 1d3 rounds. You must succeed on a ranged touch attack with a range of 100 ft. + 10 ft./binder level. A successful
Will save negates the effect. Once you have used this ability, you cannot do so again for 5 rounds.

Summon Alien: You can summon any creature from the summon monster list that a sorcerer of your level could summon. Any creature you summon with this ability gains the pseudonatural
template. Thus, at 10th level you could summon any creature from the summon monster I-V list. When you reach 14th level, you can summon any creature from the summon monster I-VII 
list.Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
    
    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR), EffectPact(oBinder));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(PSI_DUR_SHADOW_BODY));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_TENTACLE));
    
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ZCERYLL_ALIEN_FORM)) 
	{
    	int nHD = GetHitDice(oBinder);
    	int nResist;
    	effect eDR;
    	if (nHD >= 12)
    	{
    	    eDR = EffectDamageReduction(10, DAMAGE_POWER_PLUS_THREE);
    	    nResist = 20;
    	}
    	else if (12 > nHD && nHD >= 8)
    	{
    	    eDR = EffectDamageReduction(5, DAMAGE_POWER_PLUS_TWO);
    	    nResist = 15;
    	}
    	else if (8 > nHD && nHD >= 4)
    	{
    	    eDR = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE);
    	    nResist = 10;
    	}
    	else if (4 > nHD)
    	{
    	    nResist = 5;
    	}
	
    	eLink = EffectLinkEffects(eLink, eDR);
    	eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ACID, nResist));
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResist));
        eLink = EffectLinkEffects(eLink, EffectACIncrease(1,AC_NATURAL_BONUS));	
        IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ZCERYLL_TRUE_STRIKE),   HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_SPELL10),   HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ZCERYLL_ALIEN_MIND))    
	{
		eLink = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_CONFUSION));
		eLink = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_INSANITY));
		eLink = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_WEIRD));
		eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, GetBinderLevel(oBinder, VESTIGE_ZCERYLL)/4, SAVING_THROW_TYPE_MIND_SPELLS));
	}
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ZCERYLL_BOLTS))  IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ZCERYLL_BOLTS),   HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ZCERYLL_SUMMON)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ZCERYLL_SUMMON),  HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}