/*
31/01/21 by Stratovarius

Psion's Eyes
Descriptor: None
Classes: Incarnate
Chakra: Brow
Saving Throw: None

You shape incarnum into blue-green lensed spectacles. While perched on your nose, these spectacles give you peculiar visual acuity, heightening your sensitivity to psychic details while granting you insight into the meaning and significance of those details.

With this soulmeld, you summon forth soul energy from generations of psions to grant you acuity and psychic aptitude.

While you wear the psion's eyes, you gain a +4 insight bonus on Concentration, Psicraft, and Use Magical Device checks.

Essentia: Every point of essentia you invest in your psion's eyes increases the insight bonus granted by +2.

Chakra Bind (Brow)

Instead of spectacles perched on your nose, your psion's eyes appear as a third eye embedded in your forehead, and its iris glows a rich azure blue.

You can use the call to mind power at will for the duration of this soulmeld.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 13:16:34
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
    int nBonus         = 4 + (nEssentia * 2);  
  
    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);  
    eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_CONCENTRATION, nBonus));  
    eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PSICRAFT, nBonus));  
    eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_USE_MAGIC_DEVICE, nBonus));  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PSIONS_EYES), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
  
    // Brow bind (call to mind at will) — check regular or double Brow  
    int nBoundToBrow = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_BROW)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_BROW)) == nMeldId)  
        nBoundToBrow = TRUE;  
  
    if (nBoundToBrow)  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PSIONS_EYES_BROW), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper);
    int nBonus         = 4 + (nEssentia * 2);

    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_CONCENTRATION, nBonus));
    eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PSICRAFT, nBonus));
    eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_USE_MAGIC_DEVICE, nBonus));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PSIONS_EYES), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_BROW) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PSIONS_EYES_BROW), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */