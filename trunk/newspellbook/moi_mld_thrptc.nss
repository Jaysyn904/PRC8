/*
12/1/20 by Stratovarius

Therapeutic Mantle

Descriptors: None 
Classes: Incarnate, Soulborn 
Chakra: Shoulders
Saving Throw: None

A sheath of incarnum energy surrounds your body and is slowly absorbed into your skin. As healing magic is applied to you, the affected area sparkles with tiny blue motes. 

Whenever you are the target of a spell or effect that heals hit point damage, the spell heals additional damage equal to its spell level. 

Essentia: Every point of essentia invested increases the additional healing by 2 more hit points.  

Chakra Bind (Shoulders) 

Focused outward, incarnum from the mantle bonds with the healing magic you conjure. Healing spells you cast are accompanied by blue-white motes of incarnum energy.

When bound to your shoulders chakra, therapeutic mantle increases the potency of healing spells that you cast. You gain an insight bonus (equal to the number of points of essentia invested in the soulmeld) to your caster level when casting spells of the healing subschool. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_THERAPEUTIC_MANTLE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
}