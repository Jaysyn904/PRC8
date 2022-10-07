/*
1/2/21 by Stratovarius

Dragonfire Mask

Descriptors: Draconic, Fire
Classes: Totemist
Chakra: Brow, throat (totem)
Saving Throw: See text

Incarnum forms a dragon head of dull blue fire that wreaths your head and floats above your shoulders. It stares straight ahead, its expression unchanging. The eyes and mouth of the dragon head are full of brighter, flickering fire that shoots out light.

You gain low-light vision while this soulmeld is shaped.

Essentia: For every point of essentia invested in your dragonfire mask, you gain a +2 competence bonus on Spot checks.

Chakra Bind (Brow)

Your own eyes flicker with the same flames that burn within your dragon head.

You gain darkvision out to 60 feet (or your existing darkvision extends another 30 feet).

Chakra Bind (Throat)

A seething ring of fire encircles your neck, and wisps of smoke occasionally burst from the dragon head.

You gain the ability to emit a fiery breath weapon as a standard action. The breath weapon is a 30-foot cone that deals 2d6 points of fire damage + an extra 1d6 points of fire damage for every point of essentia invested in your dragonfire mask. Targets are allowed a Reflex save for half damage. After using your breath weapon, you must wait 1d4 rounds before you can use it again.

Chakra Bind (Totem)

The dragon head becomes a solid blue mask, forming a hollow shape that completely encloses your head at a distance. Fire still trails from its eyes and open mouth.

You can emanate an aura of frightful presence once per round as a swift action. All creatures within 10 feet with fewer Hit Dice than you become shaken for 1 round. A successful Will save negates the effect and renders the creature immune to the frightful presence of this soulmeld for 24 hours. For every point of essentia you have invested in your dragonfire mask, the radius of the frightful presence increases by 10 feet, and its duration increases by 1 round. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper);
    
    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	if (nEssentia) eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, 2 * nEssentia));
	IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_LOWLIGHT_VISION), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (GetIsMeldBound(oMeldshaper) == CHAKRA_BROW) eLink = EffectLinkEffects(eLink, EffectUltravision());
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DRAGONFIRE_MASK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DRAGONFIRE_MASK_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_THROAT) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DRAGONFIRE_MASK_THROAT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}