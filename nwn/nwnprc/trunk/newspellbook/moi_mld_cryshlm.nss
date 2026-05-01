/*
29/12/19 by Stratovarius

Crystal Helm

Descriptors: Force 
Classes: Incarnate, soulborn 
Chakra: Crown 
Saving Throw: None

You shape incarnum into a light helm that surrounds your head and anything you might be wearing on it, including another helm. 
The substance of this helm is transparent crystal with a faceted appearance. As it rests over your head, you can almost feel a 
barrier erected behind your eyes, barring the way to those who would intrude into your mind.

The soulmeld provides protection against mental effects, granting you a +2 resistance bonus on Will saving throws against mind-affecting spells.

Essentia: You gain a deflection bonus to your Armor Class equal to the number of points of essentia that you invest in the crystal helm. 

Chakra Bind (Crown) 

Your crystal helm settles snugly around your head, and tendrils of cold power work their way through your body. 
If you close your eyes, you can almost see your own hands glowing like a mystic crystal suffused with unearthly radiance. 
Like the invisible power of magical force, your attacks slice through the boundaries between worlds.

Your melee attacks gain the force descriptor, making them useful against incorporeal foes. [Turn this into Blind-Fight]
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 15:33:07
//::
//:: Double Chakra Bind support added
//:; Fixed broken Brow bind
//::
//:: Updated on: 2026-05-01 12:04:32
//::
//:: Fixed Bonus feats hanging stay around after 
//:: reshaping soulmelds.
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"  
  
void main()  
{  
    object oMeldshaper = PRCGetSpellTargetObject();   
    int nEssentia      = GetEssentiaInvested(oMeldshaper);   
    int nMeldId        = PRCGetSpellId();   
  
    effect eLink = EffectSavingThrowIncrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);  
  
    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectACIncrease(nEssentia, AC_DEFLECTION_BONUS));  
      
    // Check for Brow bind and add Blind-Fight if bound  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_BROW)) == nMeldId ||    
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_BROW)) == nMeldId)  
    {   
        eLink = EffectLinkEffects(eLink, EffectBonusFeat(FEAT_BLIND_FIGHT));  
    }  
      
    // Tag the effect link for easy removal  
    eLink = TagEffect(eLink, "SOULMELD_CRYSTAL_HELM_FEATS");  
    eLink = SupernaturalEffect(eLink);  
      
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oMeldshaper, 9999.0);   
      
    // Keep meld identification as item property  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_CRYSTAL_HELM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}


/* #include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper); 
	int nMeldId        = PRCGetSpellId(); 

    effect eLink = EffectSavingThrowIncrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);

    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectACIncrease(nEssentia, AC_DEFLECTION_BONUS));
    
    //if (GetIsMeldBound(oMeldshaper)) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	
	if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_BROW)) == nMeldId ||  
		GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_BROW)) == nMeldId)
		IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0); 
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_CRYSTAL_HELM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */