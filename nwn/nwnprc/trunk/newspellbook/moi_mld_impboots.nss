/*
4/1/20 by Stratovarius

Impulse Boots

Descriptors: None 
Classes: Incarnate, Soulborn 
Chakra: Feet 
Saving Throw: None

YYou shape incarnum into boots that surround your feet (as well as any other footwear you might have) and reach up almost to your knees. Midnight blue in color, the impulse boots seem to be made of smooth, supple leather.

While wearing this soulmeld, you gain the uncanny dodge ability.

Essentia: You gain an enhancement bonus on Reflex saves equal to the number of points of essentia invested.

Chakra Bind (Feet) 

Your impulse boots merge with your feet, and extend their midnight-blue color in tendrils reaching up your legs to your waist, like snaking veins just under your skin.

You gain the evasion ability.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 15:33:07
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nEssentia));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_IMPULSE_BOOTS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_FEET || GetIsMeldBound(oMeldshaper) == CHAKRA_DOUBLE_FEET) 
		IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_EVASION), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}