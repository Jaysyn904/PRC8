/*
11/1/20 by Stratovarius

Shadow Mantle

Descriptors: Darkness  
Classes: Totemist 
Chakra: Shoulders (totem) 
Saving Throw: None

Incarnum forms a rough cloak of stony gray around your shoulders and back. As you move, the cloak writhes behind you, suggesting the movement of tentacles. It seems to collect shadow, always appearing darker than the surrounding area.

Channeling the merest suggestion of a darkmantle’s powerful blindsight, you gain a +4 competence bonus on Listen checks. 

Essentia: Every point of essentia you invest in your shadow mantle increases the competence bonus on Listen checks by 2. 

Chakra Bind (Shoulders) 

The shadows of your mantle deepen, and its coloration grows darker. Blackness seems to cling in every fold and sometimes trail off in wisps from the mantle’s substance. You start to hear sounds too high for most humans to detect, and occasionally sounds too low, as well.

As a swift action, you can surround yourself with a globe of magical darkness and gain the benefits of ultravision. You can end the darkness effect as a swift action; ending the darkness effect also ends your ultravision. 

Chakra Bind (Totem) 

Your shadow mantle literally draws shadows to itself, and it changes color to match your surroundings. You find it much easier to hide from view by drawing the cloak around your body and ducking your head into its membranous collar.

You gain a competence bonus on Hide checks equal to the bonus the soulmeld grants on Listen checks (+4 plus an additional +2 per point of invested essentia). 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 4+(nEssentia*2);
    effect eLink       = EffectSkillIncrease(SKILL_LISTEN, nBonus);
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_HIDE, nBonus));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_SHADOW_MANTLE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_SHOULDERS) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_SHADOW_MANTLE_SHOULDERS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
}