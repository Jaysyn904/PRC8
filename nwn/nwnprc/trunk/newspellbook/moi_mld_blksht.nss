/*
31/12/19 by Stratovarius

Blink Shirt

Descriptors: None 
Classes: Totemist 
Chakra: Heart (totem) 
Saving Throw: None

This rough-looking garment looks like it has been made of coarse brown fur, but it displays obviously magical features. The shirt seems to shift and move on its own, and it 
fades into a barely corporeal mist near your waist. Most disconcerting of all, patches of the garment seem transparent, as if they have temporarily shifted to some strange 
elsewhere. Because different parts of the garment appear phased out at different times, these patches of incorporeality seem to roam over the surface of the shirt.

You gain the ability to teleport yourself (as dimension door) up to 10 feet at will. Using this ability is a standard action.

Essentia: For every point of essentia invested, you can teleport an additional 10 feet.  

Chakra Bind (Heart) 

The appearance of your blink shirt changes little, except that now wherever it seems transparent, you do as well. Strange patches of incorporeality float over your entire body.

You can use blink as the spell (with a caster level equal to your meldshaper level). 

Chakra Bind (Totem) 

Your posture becomes slightly hunched, giving you the merest hint of a canine appearance. Your ears also take on sharp points.

You can use the dimension door ability of this soulmeld as a move action.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 20:55:58
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
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);    
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLINK_SHIRT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
      
    // Heart bind (blink) — check regular or double Heart  
    int nBoundToHeart = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_HEART)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_HEART)) == nMeldId)  
        nBoundToHeart = TRUE;  
  
    if (nBoundToHeart)  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLINK_SHIRT_HEART), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
      
    // Totem bind (move-action dimension door) — check regular or double Totem  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (nBoundToTotem)  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLINK_SHIRT_DOOR_MV), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    else  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLINK_SHIRT_DOOR_ST), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper); 

    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLINK_SHIRT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_HEART) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLINK_SHIRT_HEART), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM)
    	IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLINK_SHIRT_DOOR_MV), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    else
    	IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_BLINK_SHIRT_DOOR_ST), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */