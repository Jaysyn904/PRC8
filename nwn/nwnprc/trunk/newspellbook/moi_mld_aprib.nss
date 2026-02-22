/*
30/12/19 by Stratovarius

Apparition Ribbon

Descriptors: None 
Classes: Incarnate 
Chakra: Throat 
Saving Throw: None

A diaphanous scarf wraps around your neck, its ends trailing off into wispy tendrils that seem to follow or mimic the movement of your arms.

You form incarnum into a bridge of energy between yourself and the incorporeal world of spirits and other ghostly creatures. You gain the Blind-Fight feat.

Essentia: Every point of essentia invested in apparition ribbon grants you a +2 bonus on damage rolls against undead creatures. 

Chakra Bind (Throat) 

The wispy tendrils of the scarf lengthen and surround you as you appear to become incorporeal.

When you bind apparition ribbon to your throat chakra, you gain the ability to become incorporeal for brief periods of time. Activating this 
ability is a standard action, and your incorporealness lasts for 1 round plus 1 round per point of essentia invested in the soulmeld at the time 
it was activated. Each day, you can spend a total number of rounds incorporeal equal to your meldshaper level. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 09:54:24
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
  
    effect eLink;  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
  
    if (nEssentia) eLink = VersusRacialTypeEffect(EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nEssentia)), RACIAL_TYPE_UNDEAD);  
      
    // Throat bind (incorporeal) — check regular or double Throat  
    int nBoundToThroat = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_THROAT)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_THROAT)) == nMeldId)  
        nBoundToThroat = TRUE;  
  
    if (nBoundToThroat)  
    {  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_APPARITION_RIBBON_THROAT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    }  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);   
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_APPARITION_RIBBON), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper); 

    effect eLink;
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);

    if (nEssentia) eLink = VersusRacialTypeEffect(EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nEssentia)), RACIAL_TYPE_UNDEAD);
    
    if (GetIsMeldBound(oMeldshaper)) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_APPARITION_RIBBON_THROAT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0); 
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_APPARITION_RIBBON), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */