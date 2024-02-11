/*
5/1/20 by Stratovarius

Lammasu Mantle

Descriptors: Good  
Classes: Incarnate, Totemist  
Chakra: Arms, shoulders (totem) 
Saving Throw: See text

You form incarnum into a mantle of fur and feathers, shining golden brown around your shoulders and back. The cloak hangs down to your knees in back and wraps comfortably around your body to close in the front, if you wish. It is quite warm in cold weather, but not too hot in warmer temperatures. Wearing it makes you feel noble and righteous.

Your lammasu mantle protects you against the attacks of evil creatures. You gain a +2 deflection bonus to your Armor Class against attacks made or effects created by evil creatures. 

Essentia: For every point of essentia you invest in your lammasu mantle, you gain a +1 resistance bonus on saving throws against the spells and effects used by evil creatures. 
 
Chakra Bind (Arms)

The golden-brown fur of your mantle spreads down to your upper arms. At the same time, a palpable aura of goodness and power extends around you, cloaking your allies in the same protection the mantle gives you.

The deflection and resistance bonuses granted by the lammasu mantle apply to all allies within 10 feet of you.

Chakra Bind (Shoulders) 

Your lammasu mantle becomes one with your shoulders, and its feathers separate from its fur to form small, nonfunctional wings that spread behind you as if to ward off attackers.

No summoned creatures except those of good alignment can approach you.

Chakra Bind (Totem) 

The golden-brown fur around your shoulders extends upward into an impressive mane around your head. There is a sensation in your mouth as if you were savoring a warm, sweet drink.

You can breathe a 15-foot cone of fire as a standard action. Creatures within the area take 1d4 points of fire damage, plus 1d4 points of fire damage per point of invested essentia (Reflex half). 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectACIncrease(2, AC_DEFLECTION_BONUS);
    
    if (nEssentia) eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nEssentia));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(VersusAlignmentEffect(eLink, ALIGNMENT_ALL, ALIGNMENT_EVIL)), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LAMMASU_MANTLE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
         
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_LAMMASU_MANTLE_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}