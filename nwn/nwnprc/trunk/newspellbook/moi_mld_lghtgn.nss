/*
6/1/20 by Stratovarius

Lightning Gauntlets

Descriptors: Electricity  
Classes: Incarnate  
Chakra: Hands
Saving Throw: None

Incarnum forms into a pair of metallic gloves that hover around your hands and any other gloves or gauntlets you wear. Blue arcs of electricity crackle between the fingers and spark between the gloves when you bring your hands close to each other.

While wearing lightning gauntlets, you can deal 1d6 points of electricity damage with a successful melee touch attack (a standard action). 

Essentia: Every point of essentia you invest in your lightning gauntlets increases the damage dealt by 1d6 points.  
 
Chakra Bind (Hands)

Your lightning gauntlets settle firmly around your hands. When you grip a weapon, electricity courses up its length and crackles at its tip. A lingering scent of ozone clings to you.

You can add the electricity damage dealt by lightning gauntlets to one attack per round made with a handheld weapon. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 00:25:27
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////

#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = PRCGetSpellTargetObject();   
    int nMeldId        = PRCGetSpellId();  
    int nEssentia      = GetEssentiaInvested(oMeldshaper);  
  
    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LIGHTNING_GAUNTLETS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LIGHTNING_GAUNTLETS_ZAP), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
  
    // Hands bind (add electricity damage to weapon attacks) — check regular or double Hands  
    int nBoundToHands = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_HANDS)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_HANDS)) == nMeldId)  
        nBoundToHands = TRUE;  
  
    if (nBoundToHands)  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LIGHTNING_GAUNTLETS_HANDS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);

    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LIGHTNING_GAUNTLETS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LIGHTNING_GAUNTLETS_ZAP), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_HANDS) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LIGHTNING_GAUNTLETS_HANDS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);   
} */