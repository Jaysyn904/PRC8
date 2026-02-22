/*
12/1/20 by Stratovarius

Wind Cloak

Descriptors: None
Classes: Incarnate, Soulborn
Chakra: Shoulders
Saving Throw: None

A gauzy cloak of incarnum settles over you, swirling about you as a gentle breeze blows through your hair. A stirring of air at your feet disturbs nearby dust.

You gain damage resistance 2/- against piercing damage.

Essentia: Every point of essentia invested increases the damage resistance by 2. 

Chakra Bind (Shoulder) 

As arrows fly in, the wind of your soulmeld swirls around, deflecting them away, perhaps even back at your attackers.

You gain the Deflect Arrows feat.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 19:24:41
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
    int nBonus         = 2 + (2 * nEssentia);  
    effect eLink       = EffectDamageResistance(DAMAGE_TYPE_PIERCING, nBonus);  
  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);    
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_WIND_CLOAK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
      
    // Shoulders bind (Deflect Arrows) — check regular or double Shoulders  
    int nBoundToShoulders = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_SHOULDERS)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_SHOULDERS)) == nMeldId)  
        nBoundToShoulders = TRUE;  
  
    if (nBoundToShoulders)  
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_DEFLECT_ARROWS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
}


/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper);
    int nBonus         = 2 + (2 * nEssentia);
    effect eLink       = EffectDamageResistance(DAMAGE_TYPE_PIERCING, nBonus);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_WIND_CLOAK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper, MELD_WIND_CLOAK) == CHAKRA_SHOULDERS) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_DEFLECT_ARROWS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
} */