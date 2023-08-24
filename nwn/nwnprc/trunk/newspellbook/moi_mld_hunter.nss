/*
4/1/20 by Stratovarius

Hunter's Circlet

Descriptors: None 
Classes: Soulborn, Totemist 
Chakra: Crown (totem) 
Saving Throw: None

You shape incarnum into a sky-blue headband that resembles a wreath of twining ivy.

Your hunter’s circlet grants you a +2 insight bonus on Heal and Search checks. 

Essentia: Every point of essentia you invest in your hunter’s circlet increases the insight bonus by 2. 

Chakra Bind (Crown) 

The sky-blue ivy of your hunter’s circlet weaves into your hair, winding down to your shoulders.

You gain the benefit of the Track feat. 

Chakra Bind (Totem) 

There is no change to your own appearance or that of the circlet, but from your perspective, the world around you changes enormously. It is suddenly alive with smells—from obvious, overpowering odors you noticed before but not in such richness of detail, to subtle scents unlike anything in your experience.

You gain the benefit of the Scent feature.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 2+(nEssentia*2);
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_HEAL, nBonus), EffectSkillIncrease(SKILL_SEARCH, nBonus));

    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, 4));
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_LISTEN, 4));
    }	

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_HUNTERS_CIRCLET), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_CROWN) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_TRACK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}