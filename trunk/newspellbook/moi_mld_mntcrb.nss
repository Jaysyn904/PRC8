/*
7/1/20 by Stratovarius

Manticore Belt

Descriptors: None  
Classes: Incarnate 
Chakra: Brow
Saving Throw: None

Incarnum forms a belt of spotted fur around your waist. At your back, short spines emerge from the belt. You note a marked increase in your appetite while you wear the belt.

While wearing your manticore belt, you gain a +2 enhancement bonus on Jump and Spot checks. 

Essentia: For every point of essentia you invest in your manticore belt, your enhancement bonus on Jump and Spot checks increases by 2.  

Chakra Bind (Waist)

Your manticore belt sprouts a pair of large, draconic wings. Though they are perched at your waist and flap awkwardly, these wings give you a reasonable ability of flight.

You can jump unlimited distances, and you gain the Spring Attack feat. 
 
Chakra Bind (Totem)

A long, thick tail emerges from the back of your manticore belt, writhing and lashing at your command. At its tip is a cluster of spikes. Like a manticore, you can propel those spikes at your foes.

As a standard action, you can snap your tail to loose a volley of spikes equal to the number of points of essentia you invest in your manticore belt. Make a ranged attack roll for each spike using your full base attack bonus. A successful hit deals 1d6 points of damage plus one-half your Strength modifier. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    int nBonus = 2 + (nEssentia * 2);     
    effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_SPOT, nBonus), EffectSkillIncrease(SKILL_JUMP, nBonus));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MANTICORE_BELT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_WAIST) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_SPRINGATTACK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MANTICORE_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}