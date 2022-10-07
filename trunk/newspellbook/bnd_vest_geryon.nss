/*
12/03/21 by Stratovarius

Geryon, the Deposed Lord
  
Once a devil of great power, Geryon now exists only as a vestige. He gives binders powers associated with his eyes, as well as the ability to fly at a moment’s notice.

Vestige Level: 5th
Binding DC: 25
Special Requirement: Geryon answers the calls of only those summoners who show an understanding of the relationship between souls and the planes. Thus, you must have at least 5 ranks in Lore to summon him.

Influence: While influenced by Geryon, you become overly trusting of and loyal to those you see as allies, even in the face of outright treachery. Because he values trust, if you make a Sense Motive check or use any ability to read thoughts or detect lies, you rebel against Geryon’s influence.

Granted Abilities: 
Geryon gives you his eyes and his baleful gaze, as well as the ability to fly.

Acidic Gaze: The gaze of your devilish eyes can cause foes to erupt with acid. When you use this ability, each opponent within 30 feet of you must succeed on a Will save or take 2d6 points of acid damage. 

All-Around Vision: Your extra eyes allow you to look in any direction, granting you a +4 bonus on Spot and Search checks. Opponents gain no benefits when flanking you.

See in Darkness: You can see perfectly in darkness of any kind, even that created by a deeper darkness spell.

Swift Flight: You can fly for 1 round by using the Jump ability. Once you have used swift flight, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_DEATHWARD), EffectPact(oBinder));
    
    if (!GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_GERYON))) 
    {
    	FloatingTextStringOnCreature("You have made a poor pact, and Geryon enjoins you from being untrusting!", oBinder, FALSE);    
    	eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_SENSE_MOTIVE, 50));
    }	
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_GERYON_GAZE))     IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_GERYON_GAZE),   HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_GERYON_DARKNESS)) eLink = EffectLinkEffects(eLink, EffectUltravision());
	if (!GetIsVestigeExploited(oBinder, VESTIGE_GERYON_VISION))
	{
        eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT,   4));
        eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SEARCH, 4));
        IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE1),   HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE2),   HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}	
	if (!GetIsVestigeExploited(oBinder, VESTIGE_GERYON_FLIGHT))  IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_GERYON_FLIGHT),       HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));     
}