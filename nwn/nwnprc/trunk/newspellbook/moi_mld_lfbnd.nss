/*
6/1/20 by Stratovarius

Lifebond Vestments

Descriptors: None  
Classes: Incarnate  
Chakra: Arms, Heart
Saving Throw: None

You shape incarnum into a fine, long-sleeved robe. It is a solid color—silver if you are good, gray if you are evil, red if you are lawful, or green if you are chaotic—but raw incarnum dances like elegant embroidery at the ends of the sleeves and the hem by your feet.

By laying your hands upon a living creature (a standard action), you heal the touched creature 1 hit point per meldshaper level. At the same time, you take damage equal to one-half the amount healed. You may not use this ability more than once per hour. 

Essentia: Every point of essentia you invest in your lifebond vestments adds 5 hit points to the limit of healing you can bestow when using the vestments. 
 
Chakra Bind (Arms)

The sleeves of your lifebond vestments clasp tightly around your wrists, bound there by glowing rings of blue incarnum. Every wave of your hands sends shimmering blue sparks into the air.

You can bestow healing upon a creature up to 30 feet away, instead of by touch. 

Chakra Bind (Heart) 

Additional embroidered designs, formed not of thread but of incarnum, appear down the front of your lifebond vestments, glowing brightly when you use the powers of the vestments but otherwise appearing simply decorative.

You can bestow healing at will on any given creature. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 09:56:03
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
  
    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LIFEBOND_VESTMENTS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LIFEBOND_VESTMENTS_HEAL), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
  
    // Arms bind (30-foot range heal) — check regular or double Arms  
    int nBoundToArms = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_ARMS)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_ARMS)) == nMeldId)  
        nBoundToArms = TRUE;  
  
    if (nBoundToArms)  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LIFEBOND_VESTMENTS_ARMS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
   
}


/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);

    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LIFEBOND_VESTMENTS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LIFEBOND_VESTMENTS_HEAL), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_ARMS) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LIFEBOND_VESTMENTS_ARMS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);   
} */