/*
12/1/20 by Stratovarius

Theft Gloves

Descriptors: None 
Classes: Incarnate 
Chakra: Hands
Saving Throw: None

You shape incarnum into a pair of supple black leather gloves that fit over your hands as well as any other gloves or gauntlets you might wear. Despite the material covering your fingertips, the gloves grant you exacting precision in certain tasks—those that typically relate to thievery.

While you have theft gloves shaped, you gain a +2 insight bonus on Disable Device, Open Lock, and Pick Pocket checks.

Essentia: Every point of essentia you invest in your theft gloves increases the insight bonus by 2. 

Chakra Bind (Hands) 

Instead of physical gloves, your theft gloves manifest as a dusky blue color over the skin of your hands. In addition to great precision, you also find your fingertips tremendously sensitive, and they seem to tingle when you run them over something that carries a trap.

You gain the trapfinding ability.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 23:13:51
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
    int nBonus         = 2 + (nEssentia * 2);  
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_OPEN_LOCK, nBonus), EffectSkillIncrease(SKILL_DISABLE_TRAP, nBonus));  
           eLink       = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PICK_POCKET, nBonus));  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_THEFT_GLOVES), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
  
    // Hands bind (trapfinding) — check regular or double Hands  
    int nBoundToHands = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_HANDS)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_HANDS)) == nMeldId)  
        nBoundToHands = TRUE;  
  
    if (nBoundToHands)  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_TRAPFINDING), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 2+(nEssentia*2);
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_OPEN_LOCK, nBonus), EffectSkillIncrease(SKILL_DISABLE_TRAP, nBonus));
           eLink       = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PICK_POCKET, nBonus));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_THEFT_GLOVES), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_HANDS) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_TRAPFINDING), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
} */