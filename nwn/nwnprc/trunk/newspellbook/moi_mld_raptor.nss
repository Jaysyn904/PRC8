/*
4/1/20 by Stratovarius

Great Raptor Mask

Descriptors: None 
Classes: Totemist 
Chakra: Brow (totem) 
Saving Throw: None

You shape incarnum into a large mask that surrounds your whole head, resembling the head of a giant eagle or a giant owl. The feathered plumage is brown and white with the faintest tinge of purple-blue, and the mask’s large, glassy eyes gleam sky blue.

You gain a +2 competence bonus on Spot checks. 

Essentia: Every point of essentia you invest in your great raptor mask increases the competence bonus by 2. 

Chakra Bind (Brow) 

Your great raptor mask has large eyes that gather every scrap of light and reflect it as a pale, blue-green glow. The mask is fused to your forehead, and your eyes are melded into the eyes of the mask—which no longer look glassy, but very much alive.

You gain darkvision. 

Chakra Bind (Totem) Your head transforms to take on the appearance of a giant eagle, becoming one with your great raptor mask. While still enhancing your vision, this soulmeld also heightens your reflexive reaction to danger, allowing you to dodge entirely out of the way of dangerous effects.

You gain evasion. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 23:20:37
//::
//:: Double Totem Bind support added
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = PRCGetSpellTargetObject();   
    int nMeldId        = PRCGetSpellId();  
    int nEssentia      = GetEssentiaInvested(oMeldshaper);  
    effect eLink       = EffectSkillIncrease(SKILL_SPOT, 2 + (nEssentia * 2));  
  
    // Brow bind (darkvision) — check regular or double Brow  
    int nBoundToBrow = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_BROW)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_BROW)) == nMeldId)  
        nBoundToBrow = TRUE;  
  
    if (nBoundToBrow) eLink = EffectLinkEffects(eLink, EffectUltravision());  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_GREAT_RAPTOR_MASK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
  
    // Totem bind (evasion) — check regular or double Totem  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (nBoundToTotem) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_EVASION), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectSkillIncrease(SKILL_SPOT, 2+(nEssentia*2));

    if (GetIsMeldBound(oMeldshaper) == CHAKRA_BROW) eLink = EffectLinkEffects(eLink, EffectUltravision());

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_GREAT_RAPTOR_MASK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_EVASION), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */