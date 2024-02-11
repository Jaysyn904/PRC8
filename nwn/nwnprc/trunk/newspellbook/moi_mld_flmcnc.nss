/*
3/1/20 by Stratovarius

Flame Cincture

Descriptors: None
Classes: Incarnate, Soulborn
Chakra: Waist
Saving Throw: See text

Incarnum forms into a cord of blue fire, which you wear tied around your waist. Its flames are cool to the touch. The loose ends dance around your legs like tongues of flame with wills of their own. When you are exposed to fire, the flames of your belt flare brightly, as if feeding on the fire around you.

When you shape flame cincture, you gain resistance to fire 10. 

Essentia: Every point of essentia invested in your flame cincture increases your resistance to fire by 5. 

Chakra Bind (Waist) 

Energy attacks are not simply absorbed and dispersed, but instead the energy is bound within the belt, eagerly awaiting release.

You can release a blast of fire from your flame cincture equal 1d6 plus 1d6 per point of essentia invested in the meld. A successful Reflex save reduces the damage by half.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper);
    int nResist = 10 + (nEssentia * 5);

    effect eLink = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResist);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_FLAME_CINCTURE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_WAIST) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_FLAME_CINCTURE_WAIST), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}