/*
1/2/21 by Stratovarius

Claws of the Wyrm

Descriptors: Draconic
Classes: Soulborn, totemist
Chakra: Arms, hands (totem)
Saving Throw: None

A pair of dragonlike units, wreathed in blue fire, hover above your own arms and mimic your actions. The arms have long, sharp talons of cerulean light.

This soulmeld draws on the most basic of draconic attack forms, granting you claws that deal damage of 1d6 points if you are Medium. 1d4 if you are Small, or 1d8 if you are Large.

Essentia: For every point of essentia invested in your claws of the wyrm, you gain a +1 enhancement bonus on attack rolls and damage rolls made with the claws.

Chakra Bind (Arms)

The dragon arms settle onto your forearms, though the claws remain loose from your hands. The fire of the arms is reduced, but they glow with a dull inner light.

The threat range of your claws of the wyrm doubles (to 19-20).

Chakra Bind (Hands)

The dragon claws bind to your hands, lengthening and growing serrated spines.

The damage dealt by your claws of the wyrm improves by one step (from 1d6 to 1d8, if you are Medium).

Chakra Bind (Totem) 

The dragon arms become more fleshlike and animated, growing up toward your buck and linking with your shoulder blades. Hard, bright scales spread over your shoulders, upper chest, and upper arms.

You gain a +8 bonus to Climb checks.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper);
    
    string sResRef = "prc_claw_1d6m_";
    int nSize = PRCGetCreatureSize(oMeldshaper);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_HANDS) nSize += 1;
    sResRef += GetAffixForSize(nSize);
    AddNaturalPrimaryWeapon(oMeldshaper, sResRef, 2); 
    SetLocalString(oMeldshaper, "IncarnumPrimaryAttackL", sResRef);
    
    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
    // All natural attacks end up here
    if (nEssentia)
    {
    	DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyEnhancementBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
    	DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oMeldshaper), ItemPropertyEnhancementBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
    }	
     
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_ARMS) 
    {
    	DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyKeen(), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
    	DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oMeldshaper), ItemPropertyKeen(), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
    }    
	if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_CLIMB, 8));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_CLAW_OF_THE_WYRM), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}