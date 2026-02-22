/*
30/12/19 by Stratovarius

Arcane Focus

Descriptors: None 
Classes: Incarnate, Soulborn 
Chakra: Throat 
Saving Throw: See text

A necklace of blue crystals fits around your neck. The crystals shed a faint glow that increases in brightness when you cast a damaging spell.

When you cast an arcane spell that deals damage, your spell’s damage is increased by 1 point. Spells that divide their damage among multiple targets, such as magic missile, deal the extra damage once to each affected target. 

Essentia: Every point of essentia you invest in your arcane focus increases the extra damage by 1 point. 

Chakra Bind (Throat) 

Barely visible wisps of incarnum writhe from your arcane focus, tendrils of soul energy that twist into arcane symbols as you cast arcane spells. When you cast a damaging spell, the spell is accompanied by a blue-white burst of raw incarnum energy.

Whenever you cast a spell that deals damage to a single living creature, that creature must succeed on a Fortitude save (using the soulmeld’s save DC, not the spell’s) or be dazed for 1 round. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 16:15:04
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = PRCGetSpellTargetObject();   
    int nMeldId        = PRCGetSpellId();  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectVisualEffect(VFX_DUR_BAELN_EYES)), oMeldshaper, 9999.0);   
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_ARCANE_FOCUS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
      
    // Throat bind (daze on single-target arcane damage) — check regular or double Throat  
    int nBoundToThroat = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_THROAT)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_THROAT)) == nMeldId)  
        nBoundToThroat = TRUE;  
  
    if (nBoundToThroat)  
    {  
        int nClass = GetMeldShapedClass(oMeldshaper, MELD_ARCANE_FOCUS);  
        int nDC = GetMeldshaperDC(oMeldshaper, nClass, MELD_ARCANE_FOCUS);  
        SetLocalInt(oMeldshaper, "ArcaneFocusBound", nDC);  
    }  
    else  
    {  
        DeleteLocalInt(oMeldshaper, "ArcaneFocusBound");  
    }  
}


/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectVisualEffect(VFX_DUR_BAELN_EYES)), oMeldshaper, 9999.0); 
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_ARCANE_FOCUS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    if (GetIsMeldBound(oMeldshaper)) 
    {
    	// We know it's bound, now to check which class bound it 
    	int nClass = GetMeldShapedClass(oMeldshaper, MELD_ARCANE_FOCUS);
    	int nDC = GetMeldshaperDC(oMeldshaper, nClass, MELD_ARCANE_FOCUS);
    		    	
    	SetLocalInt(oMeldshaper, "ArcaneFocusBound", nDC);
    }	
} */