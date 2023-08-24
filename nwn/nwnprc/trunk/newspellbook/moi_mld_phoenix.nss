/*
10/1/20 by Stratovarius

Phoenix Belt

Descriptors: Fire
Classes: Totemist
Chakra: Waist (totem)
Saving Throw: See text

You shape a belt made of feathers the color of flame—various reds, oranges, and yellows. The feathers seem to shift in color, pulsing softly, like the embers of a dying fire.

While wearing a frost helm, you gain the Heat Endurance feat.

Essentia: If you invest essentia in your phoenix belt, it also protects you from fire damage. You gain resistance to fire equal to 5 times the number of points of essentia you invest in this soulmeld. 

Chakra Bind (Waist) 

Your frost helm fuses to the top of your head, actually opening a breathing channel in the strange nodule at the helm’s crown.

You can turn fire damage into fast healing. Whenever your resistance to fire reduces the damage dealt to you by a fire-based spell, you gain fast healing 1 for a number of rounds equal to the amount of damage negated by your resistance. For example, if you were hit with a fireball for 22 points of damage and had resistance to fire 10, you would gain fast healing 1 for 10 rounds (since your resistance negated 10 points of damage). If instead you were hit with burning hands for 6 points of damage, you would gain fast healing 1 for only 6 rounds (since your resistance negated only 6 points of damage). 

Chakra Bind (Totem) 

Your frost helm fuses to your head and seems to spread downward, changing the appearance of your upper face to resemble the head of a frost worm. Your eyes meld into the helm’s strange nodule, your cheeks twist into lumpy protrusions, and the skin of your face grows thick and blue-white.

As a standard action, you can create a momentary ring of fire that surrounds you. Creatures adjacent to you take 1d6 points of fire damage per point of essentia you invest in your phoenix belt. A successful Reflex save reduces this damage by half. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper);
    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE, nEssentia * 5));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_HEAT_ENDURANCE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PHOENIX_BELT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_PHOENIX_BELT_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}