/*
5/1/20 by Stratovarius

Keeneye Lenses

Descriptors: None 
Classes: Incarnate 
Chakra: Brow, soul 
Saving Throw: None

Incarnum forms a pair of transparent blue lenses that hover in front of your eyes. As you peer through them, the world does not take on their blue color, but you find yourself more easily able to notice small details, even at long distances.

While you have keeneye lenses shaped, you gain a +4 insight bonus on Spot checks. 

Essentia: Every point of essentia you invest in your keeneye lenses increases the insight bonus by 2. 
 
Chakra Bind (Brow) 

Instead of blue lenses hovering before you, the actual lenses of your eyes gain the blue tinge of incarnum. To an outside observer, your eyes look like solid blue orbs, although some distinction between the blue “white,” the iris, and the pupil of your eyes is still noticeable. To you, the world simply seems sharp and clear—even things that are invisible to unaided sight.

You gain the ability to see invisible creatures and objects normally (as if under the effect of a see invisibility spell). 

Chakra Bind (Soul) 

Neither your appearance nor that of your keeneye lenses changes at all, but the way you see the world changes dramatically. It is as though you are seeing into a different layer of reality, piercing some veil of obscurity to see beyond mere appearances.

You see all things as they truly are, as if you were constantly under the effect of a true seeing spell.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectSkillIncrease(SKILL_SPOT, 4+(nEssentia*2));
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_BROW) eLink = EffectLinkEffects(eLink, EffectSeeInvisible());
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_SOUL) 
    {
    	effect eSight = EffectTrueSeeing();
    	if(GetPRCSwitch(PRC_PNP_TRUESEEING))
    	{
        	eSight = EffectSeeInvisible();
        	int nSpot = GetPRCSwitch(PRC_PNP_TRUESEEING_SPOT_BONUS);
        	if(nSpot == 0)
        	    nSpot = 15;
        	effect eSpot = EffectSkillIncrease(SKILL_SPOT, nSpot);
        	effect eUltra = EffectUltravision();
        	eSight = EffectLinkEffects(eSight, eSpot);
        	eSight = EffectLinkEffects(eSight, eUltra);
        	eSight = EffectLinkEffects(eSight, eLink);
    	}    
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_KEENEYE_LENSES), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}