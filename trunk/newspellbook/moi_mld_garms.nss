/*
4/1/20 by Stratovarius

Girallon Arms

Descriptors: None
Classes: Totemist
Chakra: Arms (totem)
Saving Throw: None

Incarnum coalesces around your arms and upper torso, forming blue-white fur that seems to enhance your arm and chest muscles. It also extends from your fingers to form ghostly claws that, despite their insubstantial appearance, help you gain purchase while climbing or grappling.

Your girallon arms grant you a +2 competence bonus on Climb checks and grapple checks. 

Essentia: Every point of essentia invested in your girallon arms increases the bonus on Climb checks and grapple checks by 2. 

Chakra Bind (Arms) 

The blue-white fur of your girallon arms grows longer at your forearms, forming tufts of hair near your elbows.

If you hit a single target with at least two claw attacks, you rend for double claw damage, including double your Strength bonus. 

Chakra Bind (Totem) 

Incarnum forms two additional, powerful arms that spring out from your ribs. These spirit arms mirror the movements of your real arms. All four of your arms are tipped with long claws that no longer seem ghostly, but quite real—and quite sharp.

You gain four claws that you can use as natural weapons, dealing 1d4 points of damage with each claw. You can make a single claw attack as a primary attack, using your full attack bonus and adding your Strength bonus on your damage roll. You can make up to three additional claw attacks as secondary attacks, following either a primary claw attack or an attack with a weapon. Every point of essentia you invest in your girallon arms grants you a +1 enhancement bonus on attack rolls and damage rolls with your claw attacks. 
*/

#include "moi_inc_moifunc"

void Argh(object oMeldshaper, int nEssentia)
{
	FloatingTextStringOnCreature("Girallon Arms Essentia Bonus of "+IntToString(nEssentia)+" applying to "+GetName(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper)), oMeldshaper, FALSE);
	//IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyEnhancementBonus(nEssentia), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);	
	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(nEssentia), GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper));
    IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1));
	itemproperty ipTest = GetFirstItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper));
	while(GetIsItemPropertyValid(ipTest))
	{
	    if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
	    {
	        int nEnhance = GetItemPropertyCostTableValue(ipTest);
	        FloatingTextStringOnCreature("Girallon Arms Enhancement Bonus of "+IntToString(nEnhance)+" applying to "+GetName(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper)), oMeldshaper, FALSE);
	    }                  
	    ipTest = GetNextItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper));
	} 
}

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper);
    int nBonus = 2 + (nEssentia * 2);     
    effect eLink = EffectSkillIncrease(SKILL_CLIMB, nBonus);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_GIRALLON_ARMS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_ARMS) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_REND), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 
    {
        string sResRef = "prc_claw_1d6l_"; // For some reason, this is the ResRef of the 1d4 claws. ¯\_(-_-)_/¯
        int nSize = PRCGetCreatureSize(oMeldshaper);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef, 1); 
        AddNaturalSecondaryWeapon(oMeldshaper, sResRef, 3);
        DelayCommand(0.25, Argh(oMeldshaper, nEssentia));
    }
}