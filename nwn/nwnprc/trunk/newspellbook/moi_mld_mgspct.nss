/*
7/1/20 by Stratovarius

Mage's Spectacles

Descriptors: None  
Classes: Incarnate 
Chakra: Brow
Saving Throw: None

You shape incarnum into pair of blue-lensed spectacles. While perched on your nose, these spectacles give you a peculiar visual acuity, heightening your sensitivity to arcane details while granting you insight into the meaning and significance behind those details.

While you wear the mage’s spectacles, you gain a +4 insight bonus on Spellcraft and Use Magic Device checks. 

Essentia: Every point of essentia you invest in your mage’s spectacles increases the insight bonus granted to the listed skill checks by 2. 
 
Chakra Bind (Brow)

Instead of spectacles perched on your nose, your mage’s spectacles manifest as a third eye embedded in your forehead, its iris a rich azure. Through this eye, magical inscriptions open their secrets.

You can cast read magic at will.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 13:11:35
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
    int nBonus = 4 + (nEssentia * 2);       
    effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_SPELLCRAFT, nBonus), EffectSkillIncrease(SKILL_USE_MAGIC_DEVICE, nBonus));  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MAGES_SPECTACLES), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
      
    // Brow bind (read magic at will) — check regular or double Brow  
    int nBoundToBrow = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_BROW)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_BROW)) == nMeldId)  
        nBoundToBrow = TRUE;  
  
    if (nBoundToBrow)  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MAGES_SPECTACLES_BROW), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}


/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    int nBonus = 4 + (nEssentia * 2);     
    effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_SPELLCRAFT, nBonus), EffectSkillIncrease(SKILL_USE_MAGIC_DEVICE, nBonus));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MAGES_SPECTACLES), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_BROW) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_MAGES_SPECTACLES_BROW), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
} */