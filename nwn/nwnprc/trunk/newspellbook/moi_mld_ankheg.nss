/*
29/12/19 by Stratovarius

Ankheg Breastplate

Descriptors: Acid 
Classes: Totemist 
Chakra: Throat (totem) 
Saving Throw: See text

A thick, chitinous breastplate forms around your torso. The green plates of the armor glisten like the thorax of a living insect. Soft tissue and living muscle
bind the plates together, rather than the chain and leather of conventional armor.

Your ankheg breastplate grants you a +2 armor bonus to your Armor Class. 

Essentia: For every point of essentia you invest in your ankheg breastplate, the armor bonus granted by the soulmeld improves by 1. 

Chakra Bind (Throat) 

Green chitin spreads from your breastplate up your neck, blending into your skin there. This thickened skin seems to pulse slowly, in a rhythm unrelated to the beat of your heart or the movement of your breath.

You gain the ability to spit a line of acid as a standard action. Once per minute, you can emit a line of acid that is 5 feet long plus 5 feet per point of invested essentia.
Targets in the line take 2d6 points of acid damage plus 1d6 points for every point of invested essentia. They can reduce this damage by half with a successful Reflex save. 

Chakra Bind (Totem) 

Green-brown chitin spreads from your breastplate up your neck to your face, and you sprout serrated mandibles like those of a giant insect. Outside of combat, they slowly open 
and close without any conscious direction. In battle, you can use these terrible clenching jaws to tear the flesh of your foes. When you shift essentia to this soulmeld, the mandibles sizzle with acid.

You gain a bite attack that deals 1d8 points of damage. You can use this bite as a primary attack. Every point of essentia invested in this soulmeld adds 1d4 points of acid damage to your bite damage. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 09:17:03
//::
//:: Double Chakra Bind support added
//:: Double Totem bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = PRCGetSpellTargetObject();   
    int nMeldId        = PRCGetSpellId();  
    int nEssentia      = GetEssentiaInvested(oMeldshaper);  
    int nBonus         = 2 + nEssentia;    
  
    effect eLink = EffectACIncrease(nBonus, AC_ARMOUR_ENCHANTMENT_BONUS);  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);    
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_ANKHEG_BREASTPLATE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
      
    // Throat bind (acid line) — check regular or double Throat  
    int nBoundToThroat = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_THROAT)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_THROAT)) == nMeldId)  
        nBoundToThroat = TRUE;  
  
    if (nBoundToThroat)  
    {  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_ANKHEG_BREASTPLATE_THROAT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    }  
  
    // Totem bind (bite) — check regular or double Totem  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (nBoundToTotem)  
    {  
        string sResRef = "prc_hdarc_bite_";  
        int nSize = PRCGetCreatureSize(oMeldshaper);  
        sResRef += GetAffixForSize(nSize);  
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef);   
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackB", sResRef);  
          
        int nDamage = EssentiaToD4(nEssentia);  
          
        // All natural attacks end up here  
        if (nEssentia)  
        {          
            DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, nDamage), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));  
        }      
    }  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper);
    int nBonus = 2 + nEssentia;  

    effect eLink = EffectACIncrease(nBonus, AC_ARMOUR_ENCHANTMENT_BONUS);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_ANKHEG_BREASTPLATE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_THROAT) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_ANKHEG_BREASTPLATE_THROAT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
        string sResRef = "prc_hdarc_bite_";
        int nSize = PRCGetCreatureSize(oMeldshaper);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef); 
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackB", sResRef);
        
        int nDamage = EssentiaToD4(nEssentia);
        
        // All natural attacks end up here
        if (nEssentia)
        {        
	        DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, nDamage), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
	    }    
    }
} */