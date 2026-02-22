/*
11/1/20 by Stratovarius

Silvertongue Mask

Descriptors: None  
Classes: Incarnate, Soulborn 
Chakra: Brow or throat 
Saving Throw: See text

A plain silver mask conceals your lower face while exposing your eyes. The mask is initially featureless, with a simple horizontal slot at your mouth, but subtle images shift across its surface as you interact with others.

You shape incarnum into a silver-blue mask that you wear over your face. Your silvertongue mask grants you a +2 insight bonus on Bluff and Diplomacy checks. 

Essentia: Every point of essentia you invest in your silvertongue mask increases the insight bonus by 2. 

Chakra Bind (Brow) 

Blue crystalline lenses grow out from the mask, covering your eyes. These lenses enhance your sensitivity to body language and mannerisms.

You gain an insight bonus on Sense Motive checks equal to the bonus granted on Bluff and Diplomacy checks by the mask. 

Chakra Bind (Throat) 

The silver mask melds into your face and neck, from your cheekbones down to your collar, as if your skin were turned to silver. When you attempt to compel a creature, that creature sees a face that is recognizable, but not quite familiar.

When bound to the throat chakra, the silvertongue mask allows you to cast charm person at will. A creature targeted by this ability, regardless of whether or not it succeeds on its save, can’t be targeted again by the same ability for 24 hours.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 12:23:13
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
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_BLUFF, nBonus), EffectSkillIncrease(SKILL_PERSUADE, nBonus));  
  
    // Brow bind (Sense Motive) — check regular or double Brow  
    int nBoundToBrow = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_BROW)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_BROW)) == nMeldId)  
        nBoundToBrow = TRUE;  
  
    if (nBoundToBrow)  
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SENSE_MOTIVE, nBonus));  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_SILVERTONGUE_MASK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);   
  
    // Throat bind (charm person) — check regular or double Throat  
    int nBoundToThroat = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_THROAT)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_THROAT)) == nMeldId)  
        nBoundToThroat = TRUE;  
  
    if (nBoundToThroat)  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_SILVERTONGUE_MASK_THROAT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);   
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 2+(nEssentia*2);
    effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_BLUFF, nBonus), EffectSkillIncrease(SKILL_PERSUADE, nBonus));
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_BROW) EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SENSE_MOTIVE, nBonus));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_SILVERTONGUE_MASK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_THROAT) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_SILVERTONGUE_MASK_THROAT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
} */