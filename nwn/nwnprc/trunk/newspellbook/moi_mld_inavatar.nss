/*
5/1/20 by Stratovarius

Incarnate Avatar

Descriptors: Chaotic, evil, good, or lawful  
Classes: Incarnate 
Chakra: Soul 
Saving Throw: None

You gather incarnum around you to form a second body encasing your own, a physical form superimposed over your body, clothing, and armor. In form, it resembles one of the most powerful champions of your alignment: a slaad, inevitable, angel, or yugoloth. Its movements—even its facial expressions—are in perfect synchronization with your own, so that in every way you appear to be the imposing avatar of your alignment’s ideals.

Unlike other soulmelds, the incarnate avatar provides no benefit without the investment of essentia. 

Essentia: Investing essentia in your incarnate avatar gives you a specific benefit depending on your alignment. 
Chaos: You gain a +1 insight bonus on ranged attack rolls for every point of essentia that you invest in this soulmeld. 
Evil: You gain a +2 insight bonus on melee damage rolls for every point of essentia that you invest in this soulmeld. 
Good: You gain a +1 insight bonus to your Armor Class for every point of essentia that you invest in this soulmeld. 
Law: You gain a +1 insight bonus on melee attack rolls for every point of essentia that you invest in this soulmeld.

Chakra Bind (Soul) 

Your body transforms into the appearance of your incarnate avatar. There is no longer any distinction between its hands and yours, its feet and yours, its heart and yours. You are imbued with the purest essence of your alignment—it fills your soul and spurs you to action. At the same time, it grants you greater power to help you live out your convictions.

You gain an ability based on your alignment. 
Chaos: You gain an enhancement bonus of +30 feet to your base land speed. 
Evil: You gain an enhancement bonus of +30 feet to your base land speed. 
Good: You gain an enhancement bonus of +30 feet to your base land speed. 
Law: You gain immunity to daze, paralysis, and stun, as well as to any magical effect that would slow you. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-21 15:21:51
//::
//:: Double Totem Bind support added
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"
#include "prc_inc_combmove"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
    if (!IncarnateAlignment(oMeldshaper)) return;
    
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);
    int nBonus = IPGetWeaponEnhancementBonus(oItem);
    
    if(IPGetIsMeleeWeapon(oItem))
    {        
   		if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL)
   			IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL)
			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(DamageTypeToIPConst(GetWeaponDamageType(oItem)), IPDamageConstant((nEssentia*2) + nBonus)), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        				
	}    
    if(GetWeaponRanged(oItem))
    {        
   		if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC)
   			IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);      				
    }
    // In case of dual wielding
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oMeldshaper);
        nBonus = IPGetWeaponEnhancementBonus(oItem);

    if(IPGetIsMeleeWeapon(oItem))
    {        
   		if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL)
   			IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL)
			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(DamageTypeToIPConst(GetWeaponDamageType(oItem)), IPDamageConstant((nEssentia*2) + nBonus)), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        				
	}    
	if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD)
		eLink = EffectLinkEffects(eLink, EffectACIncrease(nEssentia));
    
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_SOUL || GetIsMeldBound(oMeldshaper) == CHAKRA_DOUBLE_SOUL) 
    {
    	if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL)
    	{
    		eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DAZED));
    		eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
    		eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_STUN));
    		eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
    	}	
    	else
    	{
    		SetLocalInt(oMeldshaper, "IncarnateAvatarSpeed", TRUE);
    		DelayCommand(0.25, ExecuteScript("prc_speed", oMeldshaper));
    	}	
    }	

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_INCARNATE_AVATAR), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
}