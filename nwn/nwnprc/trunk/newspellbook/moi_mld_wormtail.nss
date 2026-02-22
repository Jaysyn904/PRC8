/*
13/1/20 by Stratovarius

Wormtail Belt

Descriptors: None  
Classes: Totemist 
Chakra: Waist (totem) 
Saving Throw: See text

Incarnum forms a wide belt of thick purple scales around your waist. Though the belt does not serve as armor (and easily fits around any armor you might wear), it thickens your skin and tints it a faint purple color.

You gain a +2 enhancement bonus to natural armor.

Essentia: The enhancement bonus to your natural armor increases by 1 for every point of essentia you invest in your wormtail belt. 

Chakra Bind (Waist) 

Rather than forming a belt of purple scales at your waist, the soulmeld shapes plating on the skin of your torso and legs. Dark purple on the back and lighter in front, these scales seem to add to your bulk, and definitely increase your power in melee combat.

You gain the Awesome Blow feat and are treated as one size category larger than usual when using it (up to a maximum of Colossal). The save DC to resist your awesome blow is calculated as normal for your soulmelds, rather than being based on the damage you deal. 

Chakra Bind (Totem)

A thick, purple-scaled tail emerges from the back of your wormtail belt. It is long enough that you can reach it around you to attack your foes with the stinger at its end, which drips with poison.

You can use your wormtail belt’s stinger to make natural attacks. You cannot use the stinger as a natural secondary weapon—using the stinger is the only attack you can make in a given round. You use your full base attack bonus for the attack roll, and the stinger deals 1d6 points of damage. In addition, the stinger delivers a weakening poison that deals initial damage of 1d4 Strength (no secondary damage). A successful Fortitude save negates the poison damage. Every point of essentia you invest in your wormtail belt gives you a +1 enhancement bonus on your attack rolls with the stinger, as well as increasing the poison’s save DC
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 09:24:52
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
    effect eLink       = EffectACIncrease(nBonus, AC_NATURAL_BONUS);  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_WORMTAIL_BELT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);   
      
    // Waist bind (Awesome Blow) — check regular or double Waist  
    int nBoundToWaist = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_WAIST)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_WAIST)) == nMeldId)  
        nBoundToWaist = TRUE;  
  
    if (nBoundToWaist)  
    {  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_AWESOME_BLOW), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);   
    }  
  
    // Totem bind (stinger) — check regular or double Totem  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (nBoundToTotem)  
    {  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_WORMTAIL_BELT_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);   
    }  
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	int nBonus         = 2+nEssentia;
    effect eLink       = EffectACIncrease(nBonus, AC_NATURAL_BONUS);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_WORMTAIL_BELT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_WAIST) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_AWESOME_BLOW), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_WORMTAIL_BELT_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 

} */