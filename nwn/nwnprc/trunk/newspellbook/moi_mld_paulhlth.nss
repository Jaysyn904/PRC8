/*
10/1/20 by Stratovarius

Pauldrons of Health

Descriptors: None 
Classes: Incarnate, Soulborn 
Chakra: Shoulders 
Saving Throw: None

Incarnum shapes heavy plates of armor that hover above your shoulders. They seem formed of pearly white alabaster except for a thin band of runic carvings etched in midnight blue.

While wearing pauldrons of health, you are immune to disease, as well as being sickened or nauseated.

Essentia: You gain an enhancement bonus on Fortitude saves equal to the number of points of essentia you invest in your pauldrons of health.

Chakra Bind (Shoulders) 

Settled directly on your shoulders, your incarnate pauldrons glow with a faint but vibrant silver-blue energy. In the immediate presence of the undead, they glow a little brighter, and if you are subjected to an energy drain attack, they momentarily flare to brilliant intensity as the attack dissipates.

You gain immunity to energy drain. 
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
    effect eLink       = EffectImmunity(IMMUNITY_TYPE_DISEASE);  
  
    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_FORT, nEssentia));  
  
    // Shoulders bind (energy drain immunity) — check regular or double Shoulders  
    int nBoundToShoulders = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_SHOULDERS)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_SHOULDERS)) == nMeldId)  
        nBoundToShoulders = TRUE;  
  
    if (nBoundToShoulders) eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PAULDRONS_OF_HEALTH), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectImmunity(IMMUNITY_TYPE_DISEASE);
    
    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_FORT, nEssentia));
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_SHOULDERS) EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PAULDRONS_OF_HEALTH), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */