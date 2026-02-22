/*
1/1/20 by Stratovarius

Displacer Mantle

Descriptors: None 
Classes: Totemist 
Chakra: Shoulders (totem)
Saving Throw: None

This cloak of blue-black fur wraps around your shoulders and hangs down your back to the waist. The fur bends and catches light strangely, actually creating a slight blurring effect around your entire body..

You gain a +2 bonus on Hide checks. 

Essentia: Every point of essentia you invest in your displacer mantle increases the bonus by 2. 

Chakra Bind (Shoulders) 

As you bind the mantle to your shoulders, its midnight hue spreads into the skin of your shoulders and upper arms. A light-bending glamer surrounds you, shifting and wavering your outline.

Your displacer mantle surrounds you with a glamer similar to a blur spell, granting you concealment (20% miss chance). 

Chakra Bind (Totem) 

A pair of tentacles extends from your shoulder blades. They end in pads ridged with sharp horn, allowing you to lash out even at distant foes to batter and tear them.

As a full-round action, you can make two tentacle attacks using your full base attack bonus. Each tentacle deals 1d4 points of damage plus your Strength modifier. Every point of essentia invested in the displacer mantle grants you a +1 enhancement bonus on damage rolls made with the tentacle attacks. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 15:12:25
//::
//:: Double Totem Bind support added
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectSkillIncrease(SKILL_HIDE, 2 + (nEssentia*2));
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_CROWN || GetIsMeldBound(oMeldshaper) == CHAKRA_DOUBLE_CROWN) eLink = EffectLinkEffects(eLink, EffectConcealment(20));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DISPLACER_MANTLE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM || GetIsMeldBound(oMeldshaper) == CHAKRA_DOUBLE_TOTEM) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DISPLACER_MANTLE_TOTEM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}