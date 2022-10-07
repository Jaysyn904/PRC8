/*
3/1/20 by Stratovarius

Enigma Helm

Descriptors: None 
Classes: Incarnate, Soulborn 
Chakra: Crown
Saving Throw: None

You form incarnum into a shadowy helm floating above and around your head. Shadows swirl like rising smoke beneath its surface. 
The helm wraps itself like a cloak around your mind, protecting your secrets and shielding your will.

Your enigma helm protects you from divinations. While wearing this soulmeld, you become difficult to detect by divination spells (as the nondetection spell).

Essentia: You gain an enhancement bonus on Will saves equal to the number of points of essentia invested. 

Chakra Bind (Crown) 

Your enigma helm rests solidly on your head. In the center of your forehead, a dusky gem holds swirling shadowstuff—and it’s not clear whether the gem is part of the helm or part of your own head.

Any attempt to charm you is redirected to the gem in your forehead. As a result, you gain complete immunity to enchantment (charm) effects.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
	if (nEssentia) eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL, nEssentia));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_ENIGMA_HELM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}