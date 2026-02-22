/*
12/1/20 by Stratovarius

Totem Avatar

Descriptors: None 
Classes: Totemist 
Chakra: Arms, feet, heart, or shoulders (totem) 
Saving Throw: None

You shape incarnum into an imposing avatar of bestial power. This corporeal shape fits over your clothing and armor, but it makes you seem like a hulking gray render in outline and features. Your actual body is only barely visible within the gray, hairless form. The render’s broad shoulders and sinewy arms encompass yours and extend beyond them to translucent clawed hands scraping the ground.

The totem avatar grants you temporary hit points equal to your meldshaper level. 

Essentia: You gain an enhancement bonus to your natural armor bonus equal to the number of points of essentia you invest in your totem avatar. 

Chakra Bind (Arms) 

Your totem avatar resembles an owlbear—no less hulking and stooped than the gray render form, but covered in a shaggy coat of feathers and fur.

You gain the benefit of the Improved Grapple feat. 

Chakra Bind (Feet) 

Your totem avatar resembles a rampager, with four elephantine legs, two muscular arms with hooked claws, a headless body with a gaping maw planted on the forward part of the torso, and a thick tail dragging behind.

You gain stability as if you were a four-legged creature, giving you a +4 bonus on checks to resist a bull rush, overrun, or trip attack. You are also treated as if you were one size category larger than normal when making a check to resist a bull rush, grapple, overrun, or trip attack (effectively granting you an additional +4 on such checks). 

Chakra Bind (Heart) 

Your totem avatar resembles the legendary tarrasque, though on a much smaller scale. Its hulking form leans forward of your own, its back covered with a thick, spiny carapace. Two mighty horns sprout from its head, and its jaw opens wide to reveal dozens of knifelike teeth.

You gain damage reduction 5/+1. The amount of this damage reduction increases by 1 for every point of essentia you invest in the soulmeld. 

Chakra Bind (Shoulders) 

Your totem avatar resembles a blood ape, taking on the appearance of a red-furred gorilla.

Your natural weapons (whether from soulmelds or other sources) deal an extra 2 damage. 

Chakra Bind (Totem) When you bind your totem avatar to your totem chakra, you become a little more like the gray render it represents. In particular, your body alters to better fill the musculature of the mighty beast avatar, lending you strength to smite your foes.

Your totem avatar grants you a morale bonus on damage rolls made with natural weapons (whether from soulmelds or other natural sources) equal to the number of points of essentia you invest in it.
 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 01:12:00
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
	int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_TOTEM_AVATAR);
    effect eLink       = EffectTemporaryHitpoints(nMeldshaperLvl);
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_HEART || GetIsMeldBound(oMeldshaper) == CHAKRA_DOUBLE_HEART) 
		eLink = EffectLinkEffects(eLink, EffectDamageReduction(5 + nEssentia, DAMAGE_POWER_PLUS_ONE));
	
	PRCRemoveSpellEffects(MELD_TOTEM_AVATAR, oMeldshaper, oMeldshaper);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_TOTEM_AVATAR), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
	
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_ARMS || GetIsMeldBound(oMeldshaper) == CHAKRA_DOUBLE_ARMS) 
		IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_GRAPPLE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
}