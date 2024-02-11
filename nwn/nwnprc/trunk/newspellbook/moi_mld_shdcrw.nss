/*
11/1/20 by Stratovarius

Shedu Crown

Descriptors: Good, mind-affecting  
Classes: Totemist 
Chakra: Heart (totem) 
Saving Throw: See text

Glowing argent incarnum forms a shining crown that hovers slightly above your head. Its presence lends a regal air to your bearing, and you feel yourself become more calm, more dignified, and more stable—emotionally and even physically grounded.

You are immune to being pushed back as the result of a bull rush.

Essentia: You gain a competence bonus on saving throws against mind-affecting spells and effects equal to the number of points of essentia you invest in your shedu crown. 

Chakra Bind (Heart) 

The appearance of your shedu crown is unchanged, but when you use the power of this chakra bind, it briefly flares with brilliant silver light. 

You can shift from the Material Plane to the Ethereal Plane as a standard action. The effect lasts for a number of rounds equal to your meldshaper level. You can do this once per day.

Chakra Bind (Totem) 

Your hair grows into a bushy mane beneath your crown. If you are male, your beard likewise grows. Your body looks and feels more solid and strong.

You gain the ability to make a trample attack. As a full-round action, you can move up to twice your speed and literally run over any creature equal to your own size or smaller. Your trample attack deals 1d8 points of bludgeoning damage (or 1d6 points if you are Small) plus 1-1/2 times your Strength modifier. Opponents have a Reflex save for half damage.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
    if (nEssentia) EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nEssentia, SAVING_THROW_TYPE_MIND_SPELLS));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_SHEDU_CROWN), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_HEART) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_SHEDU_CROWN_HEART), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
    // This is correct, it's identical to the Shedu Crown ability for trample
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_GORGON_MASK_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
}