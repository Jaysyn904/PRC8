/*
30/12/19 by Stratovarius

Basilisk Mask

Descriptors: None 
Classes: Totemist 
Chakra: Brow (totem)
Saving Throw: See text

A hideous mask with red-brown scales forms around and over your face, actually floating about an inch in front of your nose. The visage is reptilian, with a protruding lower jaw and teeth jutting upward. Bony spines stick up from the top of the mask, completing the portrait of a basilisk.

While the basilisk is feared primarily for its petrifying gaze, totemists also revere it as a patron of vision. Your basilisk mask grants you ultravision

Essentia: Every point of essentia invested increases your Spot skill by 2 points. 

Chakra Bind (Brow) 

Your basilisk mask merges into your forehead, and your eyes are now clearly visible in the face of the basilisk. The visual effect is a little unsettling, but the improvement to your perception is dramatic.

You gain the benefit of the Blind-Fight feat.

Chakra Bind (Totem) 

Behind the mask, your eyes glow with a pale green radiance that is clearly visible through the eyes of the basilisk. There is a sense of weight in your forehead, but it is not entirely unpleasant—more like a power anxious to be exercised.

By directing your gaze on a creature within 30 feet, you can temporarily turn that creature to stone (as the flesh to stone spell, except that the duration is only 1 round). A successful Fortitude save negates this effect.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectUltravision();

    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, nEssentia*2));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BASILISK_MASK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_THROAT) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BASILISK_MASK_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}