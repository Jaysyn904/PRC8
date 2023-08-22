/*
31/1/21 by Stratovarius

Elder Spirit

Descriptors: Draconic
Classes: Incarnate
Chakra: Crown, soul
Saving Throw: None 

A serpentine dragon of blue fire coils in the air above your head, twisting and undulating in response to your own movements.

You gain a +4 insight bonus on Lore and Use Magic Device checks.

Essentia: Every point of essentia you have invested in your elder spirit increases the insight bonus by 2.

Chakra Bind (Crown)
 
The dragon roils around your forehead, its facial expression matching your own.

You are immune to sleep and paralysis effects. You gain a +4 insight bonus on Intimidate checks; each point of essentia invested in your elder spirit increases this bonus by 2.

Chakra Bind (Soul)

The dragon becomes a symbol on a heraldic device of blue fire that settles onto your chest.

You gain blindsense. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper);
    int nBonus    = 4 + (2 * nEssentia);
    
    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_LORE, nBonus));
    eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_USE_MAGIC_DEVICE, nBonus));    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_CROWN) 
    {
    	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_INTIMIDATE, nBonus));
    	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLEEP));
    	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
    }	
	if (GetIsMeldBound(oMeldshaper) == CHAKRA_SOUL) eLink = EffectLinkEffects(eLink, EffectUltravision());

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_ELDER_SPIRIT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}