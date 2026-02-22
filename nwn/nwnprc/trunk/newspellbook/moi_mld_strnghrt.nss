/*
12/1/20 by Stratovarius

Strongheart Vest

Descriptors: None 
Classes: Incarnate, Soulborn 
Chakra: Heart or waist
Saving Throw: None

A heavy web belt of cyan energy wraps around your torso. When you wear it, you feel energized and revitalized. When you are struck by an attack that would damage your ability scores, a wave of incarnum energy passes through you, blunting the effectiveness of the attack.

The strongheart vest protects you from attacks that would reduce your ability scores. Any time you would take ability damage from a spell, such as Constitution damage or Strength damage, the amount of the damage is reduced by 1 point, to a minimum of 0.

Essentia: Every point of essentia you invest in your strongheart vest further reduces ability damage by an additional point.

Chakra Bind (Heart) 

Tendrils of blue-black webbing snake out from the vest, merging with your flesh. When you are struck by an attack that would drain your life force, you feel the energy of the strongheart vest surge through you, and you suffer no ill effect from the attack.

You gain immunity to energy drain attacks and death effects.

Chakra Bind (Waist) 

The energy of the vest extends down into your legs, becoming more solid as it spreads.

Your strongheart vest also reduces ability drain
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 13:25:42
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_HEART || GetIsMeldBound(oMeldshaper) == CHAKRA_DOUBLE_HEART) 
    {
    	EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEATH));
    	EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
    }	

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_STRONGHEART_VEST), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
}