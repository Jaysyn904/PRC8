/*
4/1/20 by Stratovarius

Gloves of the Poisoned Hand

Descriptors: Evil
Classes: Soulborn
Chakra: Hands
Saving Throw: See text

Slick green gloves slide over your hands. They appear moist but are dry to the touch.

Once per round, you can attempt to inflict a terrible, mind-wracking poison on a foe with a melee touch attack. The poison deals 1 point of Wisdom damage immediately and another 1 point of Wisdom damage 1 minute later. Each instance of damage can be negated by a Fortitude save. No creature can be affected by the gloves more than once in a 24-hour period. 

Essentia: Every point of essentia you invest in your gloves increases the Wisdom damage dealt (both primary and secondary damage) by 1 point. 

Chakra Bind (Hands) 

The gloves merge with your hands, giving your hands a green cast. Your fingertips drip with viscous slime.

When gloves of the poisoned soul are bound to your hands chakra, the poison also deals Strength damage equal to the amount of Wisdom damage dealt (one save resists both effects).
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper);   
    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_GLOVES_OF_THE_POISONED_SOUL), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_GLOVES_OF_THE_POISONED_SOUL_HANDS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}