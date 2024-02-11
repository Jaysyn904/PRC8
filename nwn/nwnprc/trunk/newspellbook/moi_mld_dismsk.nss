/*
1/1/20 by Stratovarius

Disenchanter Mask

Descriptors: Light 
Classes: Totemist
Chakra: Brow (Totem)
Saving Throw: None

You shape incarnum into a silvery mask with a long snout, clubbed protrusions at the crown, and a long, forked tongue. The silver scales of the mask glint and gleam in the light, and the tongue seems to sway of its own accord.

You can use a detect magic effect as the spell, with a range of 10 feet.

Essentia: Every point of essentia invested in this soulmeld increases the range by 10 feet.

Chakra Bind (Brow)

Your disenchanter mask binds to your forehead, and your eyes replace the glassy black eyes in the mask’s sockets. Colors seem somehow more alive to your sight—particularly the colors of spell effects and items that you know to be magical.

When using this soulmeld’s detect magic ability, you can instantly determine the number, strength, and location of each magical aura present as if you had been concentrating for 3 rounds. 

Chakra Bind (Totem) 

Your face lengthens and shapes into the mask you wear, and the dangling tongue of the mask becomes your own tongue. As you extend it, you can practically taste magic in the air, and when you use the tongue to drain magic, it tastes strong and sweet, almost like a liqueur.

You can use the long tongue of your disenchanter mask to make a melee touch attack as a standard action. If it hits, you suppress the opponent's primary weapon, if any, for ten rounds.
*/

#include "moi_inc_moifunc" 

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
	effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DISENCHANTER_MASK), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DISENCHANTER_MASK_DETECT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DISENCHANTER_MASK_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}