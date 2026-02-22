/*
11/1/20 by Stratovarius

Truthseeker Goggles

Descriptors: None 
Classes: Incarnate, Soulborn 
Chakra: Brow
Saving Throw: None

Incarnum forms blue-lensed goggles that hover in front of your eyes. The world does not seem blue to you; rather, small details become apparent, whether they are in something you search or in someone’s facial expression and posture.

While you wear your truthseeker goggles, you gain a +2 insight bonus on Search and Sense Motive checks. 

Essentia: Every point of essentia you invest in your truthseeker goggles increases the insight bonus by 2. 	

Chakra Bind (Brow) 

Your truthseeker goggles rest firmly before your eyes, granting you sight even in darkness.

You gain darkvision.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 00:53:56
//::
//:: Added missing Sense Motive skill bonus
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
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_SEARCH, nBonus), EffectSkillIncrease(SKILL_SENSE_MOTIVE, nBonus));  
  
    // Brow bind (darkvision) — check regular or double Brow  
    int nBoundToBrow = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_BROW)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_BROW)) == nMeldId)  
        nBoundToBrow = TRUE;  
  
    if (nBoundToBrow) eLink = EffectLinkEffects(eLink, EffectUltravision());  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_TRUTHSEEKER_GOGGLES), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 2 + (nEssentia * 2);
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_SEARCH, nBonus), EffectSkillIncrease(SKILL_SEARCH, nBonus));

    if (GetIsMeldBound(oMeldshaper) == CHAKRA_BROW)  eLink = EffectLinkEffects(eLink, EffectUltravision());

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_TRUTHSEEKER_GOGGLES), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */