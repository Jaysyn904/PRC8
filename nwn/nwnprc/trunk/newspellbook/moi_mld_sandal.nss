/*
1/1/20 by Stratovarius

Cerulean Sandals

Descriptors: None 
Classes: Incarnate, Soulborn
Chakra: Feet
Saving Throw: None

Incarnum forms into a pair of sandals that surround your feet and any other footwear you might have on. The sandals resemble blue crystal ice, but just beneath the surface, they seem to flow like water.

Your cerulean sandals make you immune to movement speed decreases. 

Essentia: Every point of essentia invested in this soulmeld grants an enhancement bonus of +5 feet to your base land speed.

Chakra Bind (Feet)

Your feet and lower legs are encased in a sheath of blue-gray energy. This substance resembles ice, but motes of light like tiny stars drift through it as well.

You can use dimension door as the spell, up to a total distance of 10 feet per meldshaper level. You can use this ability (in increments of 10 feet) any number of times, until the total distance has been traversed, at which point the soulmeld unshapes. This requires a standard action to activate.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_CERULEAN_SANDALS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_FEET) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_CERULEAN_SANDALS_FEET), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}