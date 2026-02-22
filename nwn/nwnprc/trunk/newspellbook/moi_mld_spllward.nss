/*
11/1/20 by Stratovarius

Spellward Shirt

Descriptors: None  
Classes: Incarnate, Soulborn 
Chakra: Heart 
Saving Throw: None

Incarnum forms into a cerulean tunic that covers your torso, fitting comfortably over any other clothing or armor you wear. Except for its unusual color, it seems like a relatively mundane garment—until you are subjected to any spell effect. When that happens, the color of the shirt comes alive, forming intricate patterns of swirls, bursts, and spirals as the shirt attempts to deflect the magical energy.

While worn, the spellward shirt grants you spell resistance 5. 

Essentia: Every point of essentia you invest in your spellward shirt increases the spell resistance granted by the soulmeld by 4. 

Chakra Bind (Heart) 

The soul energy of your spellward shirt is bound into your flesh, its cerulean color tinting your skin all over your body.

You become immune to the first 24 levels of spell that affect you each day of 6th level and lower spells.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 18:29:06
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
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
      
    // Heart bind (spell level absorption) — check regular or double Heart  
    int nBoundToHeart = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_HEART)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_HEART)) == nMeldId)  
        nBoundToHeart = TRUE;  
  
    if (nBoundToHeart)  
    {  
        effect eWard = EffectSpellLevelAbsorption(6, 24);  
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eWard), oMeldshaper, 9999.0);  
    }  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_SPELLWARD_SHIRT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_HEART) 
    {
    	effect eWard       = EffectSpellLevelAbsorption(6, 24);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eWard), oMeldshaper, 9999.0);
    }	
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_SPELLWARD_SHIRT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
} */