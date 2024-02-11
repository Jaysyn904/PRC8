/*
1/2/21 by Stratovarius

Dragon Tail

Descriptors: Draconic
Classes: Incarnate, totemist
Chakra: Feet, waist (totem)
Saving Throw: See text

Incarnum forms a row of dragon vertebrae floating inches from your own spine. Ribs grow from the vertebrae, creating a cloak that conceals your back. The cloak continues to grow behind you, extending into a long dragon tail.

You form a draconic tail that can strike foes, dealing 1d8 points of bludgeoning damage + your Strength modifier. You can make one attack per round with the tail as a standard action.

Essentia: For every point of essentia invested in your dragon tail, the tail's attack gains a +1 enhancement bonus on attack rolls and damage rolls.

Chakra Bind (Feet)

The tail of this soulmeld grows broad and thick.

The dragon foil provides you with a measure of stability. You gain a +2 competence bonus on Balance and Jump checks. For each point of essentia invested in your dragon tail, the bonus improves by 2.

Chakra Bind (Waist)

The vertebrae fuse to your back, the ribs blending into your own. The tail becomes lively and animate, constantly twitching from side to side.

The dragon tail's damage dealt increases to 2d6 points + 1–1/2 × your Strength bonus.

Chakra Bind (Totem)

The tail takes on the appearance of flesh and bone and becomes more agile and animated

As a standard action, you can make a tail sweep. All creatures adjacent to you automatically take damage as if they had been struck by your dragon tail (Reflex half). 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper);
    
    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
	if (GetIsMeldBound(oMeldshaper) == CHAKRA_FEET)
	{
		int nBonus = 2 + (nEssentia * 2);
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_BALANCE, nBonus));
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_JUMP, nBonus));
	}
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DRAGON_TAIL), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DRAGON_TAIL_SLAM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DRAGON_TAIL_SWEEP), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}