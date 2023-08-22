/*
3/1/20 by Stratovarius

Fellmist Robe

Descriptors: None
Classes: Incarnate
Chakra: Soul
Saving Throw: None

Incarnum coalesces around your body into a sheath of gray mist. It hangs about you like a thick fog that moves with you, creating the illusion that you are drifting over the ground rather than walking. This robe of mist masks your true location, protecting you from ranged attacks.

Your fellmist robe provides you with minor concealment (10% miss chance) against ranged attacks.

Essentia: Every point of essentia invested in your fellmist robe improves the concealment slightly, increasing the miss chance by 5% (up to a maximum of 50%). 

Chakra Bind (Soul) 

Your fellmist robe draws closer to your body, at the same time growing denser and shrouding your form more effectively—even against adjacent foes.

Your fellmist robe provides its concealment against melee and ranged attackers. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper);
    int nConceal = 10 + (nEssentia * 5);
    if (nConceal > 50) nConceal = 50;
    int nType = MISS_CHANCE_TYPE_VS_RANGED;
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_SOUL) nType = MISS_CHANCE_TYPE_NORMAL; 

    effect eLink = EffectConcealment(nConceal, nType);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_FELLMIST_ROBE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}