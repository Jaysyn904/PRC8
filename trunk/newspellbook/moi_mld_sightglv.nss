/*
11/1/20 by Stratovarius

Sighting Gloves

Descriptors: None 
Classes: Incarnate, Soulborn 
Chakra: Hands 
Saving Throw: None

Turquoise incarnum energy briefly forms a sheath around your hands before merging with your flesh. The energy steadies your hands so that when you launch an arrow or throw a weapon, it flies true, leaving blue-green sparks in its wake.

You gain a +1 insight bonus on damage rolls made with ranged weapons. 
 
Essentia: Every point of essentia invested in sighting gloves increases the insight bonus by 1.

Chakra Bind (Hands) 

Your grip on your ranged weapon is as light as can be, requiring only the slightest motion to release your arrow, pull the trigger of your crossbow, or deliver your throw.

When you bind sighting gloves to your hands chakra, you gain the Point Blank Shot feat.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_SIGHTING_GLOVES), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_HANDS) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_POINTBLANK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
}