/*
5/1/20 by Stratovarius

Kruthik Claws

Descriptors: Acid  
Classes: Totemist  
Chakra: Hands, shoulders (totem) 
Saving Throw: None

Incarnum forms chitinous plates that hover over your shoulders and down your arms to your hands. At the backs of your hands, these plates take on long, triangular shapes like the scythe-claws of a kruthik, though these blades extend only barely beyond your fingertips.

With kruthik claws shaped, you gain a +4 competence bonus on Hide and Move Silently checks. 

Essentia: For every point of essentia you invest in your kruthik claws, your competence bonus on Hide and Move Silently checks increases by 2. 
 
Chakra Bind (Hands) 

The chitinous blades merge into the backs of your hands and sprout numerous sharp spines near your wrists. A sense of quickness dances in your fingers.

You gain the benefit of the Weapon Finesse feat when attacking with natural weapons. 

Chakra Bind (Shoulders) 

Chitin plates fuse to your shoulders and grow thick and hard. Additional plates spread across your back, rising in a crest over your shoulders.

You gain resistance to acid 10. Every point of essentia invested in your kruthik claws increases this resistance by 5 points. 

Chakra Bind (Totem) 

Enormous, serrated, scythelike claws extend from your wrists to cover your hands. Vicious spikes emerge from the base of these blades, and a bright blue acidic secretion lines the cutting edge.

You can use your two claws as natural weapons that deal 1d6 points of damage plus your Strength modifier. For every point of essentia you invest in your kruthik claws, you deal an additional 1d4 points of acid damage with each claw attack.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2025-12-02 15:04:22
//::
//:: Hands / Weapon finesse fixed
//:: ItemPropertyTag() support added
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////


#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	object oSkin 		= GetPCSkin(oMeldshaper);
	
	int nMeldId 	= PRCGetSpellId();	
	int nEssentia	= GetEssentiaInvested(oMeldshaper);
	int nBonus		= 4+(nEssentia*2);
    
	effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_HIDE, nBonus), EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus));
    
	// Check if bound to Shoulders chakra
	int nBoundToShoulders = FALSE;
	if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_SHOULDERS)) == nMeldId||
		GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_SHOULDERS)) == nMeldId)
		nBoundToShoulders = TRUE;

	if (nBoundToShoulders)
	{		
		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ACID, 10 + (nBonus * 5)));
	}
	
	// Check if bound to Hands chakra
	int nBoundToHands = FALSE;
	if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_HANDS)) == nMeldId||
		GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_HANDS)) == nMeldId)
		nBoundToHands = TRUE;
	
	if (nBoundToHands)
    {
        // Add the rend IP with a unique tag
        itemproperty ipFinesse = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPFINESSE);
        ipFinesse = TagItemProperty(ipFinesse, "IP_KRUTHIK_CLAWS");
        IPSafeAddItemProperty(oSkin, ipFinesse, 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else
    {
        // Remove the rend IP by tag
        itemproperty ip = GetFirstItemProperty(oSkin);
        while (GetIsItemPropertyValid(ip))
        {
            if (GetItemPropertyTag(ip) == "IP_KRUTHIK_CLAWS")
            {
                RemoveItemProperty(oSkin, ip);
            }
            ip = GetNextItemProperty(oSkin);
        }
    }	

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_KRUTHIK_CLAWS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	
    // Check if bound to Totem chakra
    int nBoundToTotem = FALSE;
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)
        nBoundToTotem = TRUE;
	
    if (nBoundToTotem)		
    {
        string sResRef = "prc_claw_1d6m_";
        // Gets up to the proper size
        int nSize = PRCGetCreatureSize(oMeldshaper);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef, 2); 
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackL", sResRef);
        int nDamage = EssentiaToD4(nEssentia);
        
        // All natural attacks end up here
        if (nEssentia)
        {
        	DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, nDamage), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
        	DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oMeldshaper), ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, nDamage), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
        }	
    }
}

/* void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	object oSkin 		= GetPCSkin(oMeldshaper);
	
	int nMeldId 	= PRCGetSpellId();	
	int nClass 		= GetMeldshapingClass(oMeldshaper);	
	int nEssentia	= GetEssentiaInvested(oMeldshaper);
	int nBonus		= 4+(nEssentia*2);
    
	effect eLink       = EffectLinkEffects(EffectSkillIncrease(SKILL_HIDE, nBonus), EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus));
    
	// Check if bound to Shoulder chakra
	int nBoundToShoulders = FALSE;
	if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_SHOULDERS)) == nMeldId||
		GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_SHOULDERS)) == nMeldId)
		nBoundToShoulders = TRUE;

	if (nBoundToShoulders)
	{		
		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ACID, 10 + (nBonus * 5)));
	}
	
	//if (GetIsMeldBound(oMeldshaper) == CHAKRA_SHOULDERS) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ACID, 10 + (nBonus * 5)));

	//if (GetIsMeldBound(oMeldshaper) == CHAKRA_HANDS) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPFINESSE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	
	// Check if bound to Hands chakra
	int nBoundToHands = FALSE;
	if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_HANDS)) == nMeldId||
		GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_HANDS)) == nMeldId)
		nBoundToHands = TRUE;

	//if (GetIsMeldBound(oMeldshaper) == CHAKRA_HANDS)
	if (nBoundToHands)
    {
        // Add the rend IP with a unique tag
        itemproperty ipFinesse = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPFINESSE);
        ipFinesse = TagItemProperty(ipFinesse, "IP_KRUTHIK_CLAWS");
        IPSafeAddItemProperty(oSkin, ipFinesse, 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }
    else
    {
        // Remove the rend IP by tag
        itemproperty ip = GetFirstItemProperty(oSkin);
        while (GetIsItemPropertyValid(ip))
        {
            if (GetItemPropertyTag(ip) == "IP_KRUTHIK_CLAWS")
            {
                RemoveItemProperty(oSkin, ip);
            }
            ip = GetNextItemProperty(oSkin);
        }
    }	

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_KRUTHIK_CLAWS), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	
	//if (GetIsMeldBound(oMeldshaper) == CHAKRA_TOTEM) 	
	int nBoundChakra = GetIsMeldBound(oMeldshaper);  
	if (nBoundChakra == CHAKRA_TOTEM || nBoundChakra == CHAKRA_DOUBLE_TOTEM) 
	//if (GetIsChakraUsed(oMeldshaper, CHAKRA_TOTEM, nClass) == nMeldId || GetIsChakraUsed(oMeldshaper, CHAKRA_DOUBLE_TOTEM, nClass) == nMeldId)		
    {
        string sResRef = "prc_claw_1d6m_";
        // Gets up to the proper size
        int nSize = PRCGetCreatureSize(oMeldshaper);
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oMeldshaper, sResRef, 2); 
        SetLocalString(oMeldshaper, "IncarnumPrimaryAttackL", sResRef);
        int nDamage = EssentiaToD4(nEssentia);
        
        // All natural attacks end up here
        if (nEssentia)
        {
        	DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oMeldshaper), ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, nDamage), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
        	DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oMeldshaper), ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, nDamage), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
        }	
    }
} */