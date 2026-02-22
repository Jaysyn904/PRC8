/*
17/10/20 by Stratovarius

Necrocarnum Mantle

Descriptors: Evil, necrocarnum
Classes: Incarnate, soulborn
Chakra: Throat
Saving Throw: None

A long cloak of shifting shadow drapes from your shoulders and down your back. Faint forms seem to swim in the depths of this shadow, tortured and twisted shapes that once might have been
human. These apparitions writhe and buckle, wracked by incomprehensible agony. Their tortured, elongated faces hold their gaping mouths open in soundless eternal screams.

While you have a necrocarnum mantle shaped, you gain immunity to disease. 

Essentia: For every point of essentia you invest in your necrocarnum mantle, you gain a +1 bonus on saving throws against mind-affecting effects.

Chakra Bind (Throat)

As long as the necrocarnum mantle is bound to your throat chakra, you gain immunity to poison.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 21:08:02
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
  
    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE), EffectImmunity(IMMUNITY_TYPE_DISEASE));  
    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nEssentia, SAVING_THROW_TYPE_MIND_SPELLS));  
  
    // Throat bind (poison immunity) — check regular or double Throat  
    int nBoundToThroat = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_THROAT)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_THROAT)) == nMeldId)  
        nBoundToThroat = TRUE;  
  
    if (nBoundToThroat) eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_POISON));  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);    
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECROCARNUM_MANTLE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE), EffectImmunity(IMMUNITY_TYPE_DISEASE));
    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nEssentia, SAVING_THROW_TYPE_MIND_SPELLS));
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_THROAT) eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_POISON));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECROCARNUM_MANTLE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */