//::///////////////////////////////////////////////
//:: Name Vow of Poverty
//:: FileName ft_vowofpoverty.nss
//:: Created By: Fencas
//:: Created On: 2024-12-02
//:: Based On: Stratovarius' Forsaker
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "inc_dynconv"
#include "prc_class_const"
#include "prc_inc_clsfunc"
#include "prc_alterations"
#include "NW_I0_GENERIC"
#include "nw_i0_spells"
#include "inc_persist_loca"
#include "inc_nwnx_funcs"

effect VoPDamage(int nTotalEnhancement) 
{
	effect eDamage;
	if      (nTotalEnhancement>=15) eDamage = EffectDamageIncrease(DAMAGE_BONUS_15,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=14) eDamage = EffectDamageIncrease(DAMAGE_BONUS_14,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=13) eDamage = EffectDamageIncrease(DAMAGE_BONUS_13,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=12) eDamage = EffectDamageIncrease(DAMAGE_BONUS_12,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=11) eDamage = EffectDamageIncrease(DAMAGE_BONUS_11,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=10) eDamage = EffectDamageIncrease(DAMAGE_BONUS_10,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=9) eDamage = EffectDamageIncrease(DAMAGE_BONUS_9,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=8) eDamage = EffectDamageIncrease(DAMAGE_BONUS_8,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=7) eDamage = EffectDamageIncrease(DAMAGE_BONUS_7,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=6) eDamage = EffectDamageIncrease(DAMAGE_BONUS_6,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=5) eDamage = EffectDamageIncrease(DAMAGE_BONUS_5,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=4) eDamage = EffectDamageIncrease(DAMAGE_BONUS_4,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=3) eDamage = EffectDamageIncrease(DAMAGE_BONUS_3,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=2) eDamage = EffectDamageIncrease(DAMAGE_BONUS_2,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=1) eDamage = EffectDamageIncrease(DAMAGE_BONUS_1,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	
	return eDamage;
}

void ConvertVoPFeatsToNWNxEE(object oPC)  
{  
    if (GetPersistantLocalInt(oPC, "VoP_NWNxEE_Feats_Converted")) return;  
    if (!GetHasFeat(FEAT_VOWOFPOVERTY, oPC)) return;  
  
    // Remove any lingering VoP feat effects  
    effect eLoop = GetFirstEffect(oPC);  
    while (GetIsEffectValid(eLoop))  
    {  
        string sTag = GetEffectTag(eLoop);  
        if (GetStringLeft(sTag, 7) == "VoPFeat")  
            RemoveEffect(oPC, eLoop);  
        eLoop = GetNextEffect(oPC);  
    }  
  
    // Reapply intrinsic feats for each stored VoPFeatID entry  
    int i = 1;  
    string sKey;  
    while (GetPersistantLocalInt(oPC, "VoPFeatID" + IntToString(i)))  
    {  
        int nFeatID = StringToInt(Get2DAString("prc_vop_feats", "FeatIndex", i - 1));  
        if (nFeatID > 0)  
        {  
            PRC_Funcs_AddFeat(oPC, nFeatID);  
        }  
        i++;  
    }  
  
    SetPersistantLocalInt(oPC, "VoP_NWNxEE_Feats_Converted", TRUE);  
}

	
void ConvertVoPToNWNxEE(object oPC)  
{  
    if (GetPersistantLocalInt(oPC, "VoP_NWNxEE_Converted")) return;  
    if (!GetHasFeat(FEAT_VOWOFPOVERTY, oPC)) return;  
  
    int nLevel = GetCharacterLevel(oPC) - GetPersistantLocalInt(oPC, "VoPLevel1") + 1;  
    object oSkin = GetPCSkin(oPC);  
    int i;  
  
    // Remove existing VoP ability item properties  
    for (i = 0; i < 6; i++)  
    {  
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_ABILITY_BONUS, i, -1, 1, "VoPBoostStat"+IntToString(i), -1, DURATION_TYPE_PERMANENT);  
    }  
  
    // Reapply intrinsic bonuses for each stored VoPBoost  
    for (i = 1; i <= nLevel; i++)  
    {  
        int nStored = GetPersistantLocalInt(oPC, "VoPBoost"+IntToString(i));  
        if (nStored >= 10)  
        {  
            int stat = nStored - 10;  
            int value = 2 * (1 + (nLevel - i) / 4);  
            PRC_Funcs_ModAbilityScore(oPC, stat, value);  
        }  
    }  
  
    SetPersistantLocalInt(oPC, "VoP_NWNxEE_Converted", TRUE);  
}

#include "prc_feat_const"  
#include "prc_inc_function"  
  
const string VOP_TAG = "VoP";  
  
// Helper: add a VoP-tagged property to the skin  
void AddVoPProperty(object oSkin, itemproperty ip)  
{  
    ip = TagItemProperty(ip, VOP_TAG);  
    IPSafeAddItemProperty(oSkin, ip, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);  
}  
  
// Remove all VoP-tagged properties from an item  
void RemoveVoPProperties(object oItem)  
{  
    itemproperty ip = GetFirstItemProperty(oItem);  
    while (GetIsItemPropertyValid(ip))  
    {  
        if (GetItemPropertyTag(ip) == VOP_TAG)  
            RemoveItemProperty(oItem, ip);  
        ip = GetNextItemProperty(oItem);  
    }  
}  
  
void main()  
{  
    int nEvent = GetRunningEvent();  
    if (DEBUG) DoDebug("ft_vowofpoverty running, event: " + IntToString(nEvent));  
  
    object oPC;  
    switch (nEvent)  
    {  
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;  
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;  
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;  
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;  
        default:                        oPC = OBJECT_SELF;  
    }  
  
    object oItem;  
    object oSkin = GetPCSkin(oPC);  
    int nLevel = GetCharacterLevel(oPC) - GetPersistantLocalInt(oPC, "VoPLevel1") + 1;  
    int nACArmor = 4 + nLevel / 3;  
    int nACDeflection = nLevel / 6;  
    int nACNatural = nLevel / 8;  
    int nRegen = 1 + (nLevel - 17) / 7;  
    int nDR = 5 * (1 + (nLevel - 10) / 9);  
    int nER = (10 * (1 + (nLevel - 13) / 7)) - 5;  
    int nResist = 0;  
    if (nLevel >= 17) nResist = 1 + (nLevel - 7) / 5;  
    else if (nLevel >= 13) nResist = 2;  
    else if (nLevel >= 7) nResist = 1;  
  
    int nForsakerBonus = GetLevelByClass(CLASS_TYPE_FORSAKER, oPC) / 2;  
    int nSlot, nLevelCheck, nExaltedStrike, nTotalEnhancement;  
  
    if (nLevel >= 10) nExaltedStrike = 1 + (nLevel - 7) / 3;  
    else if (nLevel >= 4) nExaltedStrike = 1;  
    if (nForsakerBonus >= nExaltedStrike) nTotalEnhancement = nForsakerBonus;  
    else nTotalEnhancement = nExaltedStrike;  
  
    // EvalPRCFeats pass  
    if (nEvent == FALSE)  
    {  
        if (GetPRCSwitch("PRC_NWNXEE_ENABLED") && GetPRCSwitch("PRC_PRCX_ENABLED"))  
            ConvertVoPToNWNxEE(oPC);  
        if (GetPRCSwitch("PRC_NWNXEE_ENABLED") && GetPRCSwitch("PRC_PRCX_ENABLED"))  
            ConvertVoPFeatsToNWNxEE(oPC);  
  
        for (nLevelCheck = 1; nLevelCheck <= nLevel; nLevelCheck++)  
        {  
            if (!GetPersistantLocalInt(oPC, "VoPBoost" + IntToString(nLevelCheck)) && (nLevelCheck - (nLevelCheck / 4) * 4 == 3) && (nLevelCheck >= 7) && (nLevelCheck <= 27))  
            {  
                AssignCommand(oPC, ClearAllActions(TRUE));  
                SetPersistantLocalInt(oPC, "VoPBoostCheck", nLevelCheck);  
                StartDynamicConversation("ft_vowpoverty_ab", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);  
            }  
            if (GetPersistantLocalInt(oPC, "VoPBoost" + IntToString(nLevelCheck)) >= 10)  
            {  
                int stat = GetPersistantLocalInt(oPC, "VoPBoost" + IntToString(nLevelCheck)) - 10;  
                int value = 2 * (1 + (nLevel - nLevelCheck) / 4);  
                if (GetPRCSwitch("PRC_NWNXEE_ENABLED") && GetPRCSwitch("PRC_PRCX_ENABLED"))  
                {  
                    string sKey = "VoP_EE_Boost_" + IntToString(stat);  
                    int nLastApplied = GetPersistantLocalInt(oPC, sKey);  
                    int nDelta = value - nLastApplied;  
                    if (nDelta > 0)  
                    {  
                        PRC_Funcs_ModAbilityScore(oPC, stat, nDelta);  
                        SetPersistantLocalInt(oPC, sKey, value);  
                    }  
                }  
                else  
                {  
                    // Fallback: add tagged ability bonus to skin  
                    itemproperty ip = ItemPropertyAbilityBonus(stat, value);  
                    AddVoPProperty(oSkin, ip);  
                }  
            }  
            if (!GetPersistantLocalInt(oPC, "VoPFeat" + IntToString(nLevelCheck)) && (nLevelCheck - (nLevelCheck / 2) * 2 == 0))  
            {  
                AssignCommand(oPC, ClearAllActions(TRUE));  
                SetPersistantLocalInt(oPC, "VoPFeatCheck", nLevelCheck);  
                StartDynamicConversation("ft_vowpoverty_ft", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);  
            }  
        }  
  
        // AC Armor (effect)  
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nACArmor, AC_ARMOUR_ENCHANTMENT_BONUS)), oPC);  
        // Deflection (effect)  
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nACDeflection, AC_DEFLECTION_BONUS)), oPC);  
        // Resistance (itemproperty, tagged)  
        if (nLevel >= 7)  
        {  
            itemproperty ip = ItemPropertyBonusSavingThrow(SAVING_THROW_ALL, nResist);  
            AddVoPProperty(oSkin, ip);  
        }  
        // Natural Armor (effect)  
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectACIncrease(nACNatural, AC_NATURAL_BONUS)), oPC);  
        // DR (effect)  
        if (nLevel >= 10) ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageReduction(nDR, nTotalEnhancement)), oPC);  
        // Energy resistances (effects)  
        if (nLevel >= 13)  
        {  
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_ACID, nER, 0, FALSE), oPC);  
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_COLD, nER, 0, FALSE), oPC);  
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nER, 0, FALSE), oPC);  
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_FIRE, nER, 0, FALSE), oPC);  
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_SONIC, nER, 0, FALSE), oPC);  
        }  
        // Freedom of Movement (tagged)  
        if (nLevel >= 14)  
        {  
            itemproperty ip = ItemPropertyFreeAction();  
            AddVoPProperty(oSkin, ip);  
        }  
        // Regeneration (tagged)  
        if (nLevel >= 17)  
        {  
            itemproperty ip = ItemPropertyRegeneration(nRegen);  
            AddVoPProperty(oSkin, ip);  
        }  
        // True Seeing (tagged)  
        if (nLevel >= 18)  
        {  
            itemproperty ip = ItemPropertyTrueSeeing();  
            AddVoPProperty(oSkin, ip);  
        }  
        // Exalted Strike (effect, already tagged)  
        effect eEffect1 = EffectAttackIncrease(nTotalEnhancement);  
        effect eEffect2 = VoPDamage(nTotalEnhancement);  
        effect eLink = EffectLinkEffects(eEffect1, eEffect2);  
        eLink = SupernaturalEffect(eLink);  
        eLink = TagEffect(eLink, "EffectExaltedStrike");  
        effect eCheckEffect = GetFirstEffect(oPC);  
        while (GetIsEffectValid(eCheckEffect))  
        {  
            if (GetEffectTag(eCheckEffect) == "EffectExaltedStrike") RemoveEffect(oPC, eCheckEffect);  
            eCheckEffect = GetNextEffect(oPC);  
        }  
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);  
  
        // Enforce vow: unequip prohibited items  
        for (nSlot = 0; nSlot < 13; nSlot++)  
        {  
            int nRace = GetRacialType(oPC);  
			if(nRace == RACIAL_TYPE_WARFORGED   
			|| nRace == RACIAL_TYPE_WARFORGED_SCOUT   
			|| nRace == RACIAL_TYPE_WARFORGED_CHARGER)  
			{  
				string sResRef = GetResRef(oItem);  
				if(sResRef == "prc_wf_admtbody"   
				|| sResRef == "prc_wf_compbody"  
				|| sResRef == "prc_wf_woodbody"  
				|| sResRef == "prc_wf_mithbody"   
				|| sResRef == "prc_wf_helmhead"   
				|| sResRef == "prc_wf_helmadmt"  
				|| sResRef == "prc_wf_helmwood"  
				|| sResRef == "prc_wf_helmmith")  
				{  
					return; // Skip VoP check for Warforged body armor  
				}  
			}
			
			oItem = GetItemInSlot(nSlot, oPC);  
            if (!(GetTag(oItem) == "xp1_mystrashand")  
                && !(GetTag(oItem) == "H2_SenseiAmulet")  
                && !(GetResRef(oItem) == "prc_sk_mblade_bs")  
                && !(GetResRef(oItem) == "prc_sk_mblade_th")  
                && !(GetResRef(oItem) == "prc_sk_mblade_ss") 
				&& !(GetResRef(oItem) == "psi_sk_tshield_0") 				
                && !(GetResRef(oItem) == "prc_sk_mblade_ls"))  
            {  
                if ((GetIsItemPropertyValid(GetFirstItemProperty(oItem)) && !(GetItemPropertyTag(GetFirstItemProperty(oItem)) == "Tag_PRC_OnHitKeeper")  
                    && !(nSlot == 4 || nSlot == 5))  
                    || (nSlot == 1 && GetBaseAC(oItem) >= 1)  
                    || (nSlot == 5 && (GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD  
                        || GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD  
                        || GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD)))  
                {  
                    AssignCommand(oPC, ClearAllActions(TRUE));  
                    AssignCommand(oPC, ActionUnequipItem(oItem));  
                    FloatingTextStringOnCreature(GetName(oItem) + " would break your vow!", oPC, FALSE);  
                }  
            }  
        }  
  
        // Register unequip hook  
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "ft_vowofpoverty", TRUE, FALSE);  
    }  
    // OnEquip: enforce vow for equipped weapons  
    else if (nEvent == EVENT_ONPLAYEREQUIPITEM)  
    {  
        int nRace = GetRacialType(oPC);  
		if(nRace == RACIAL_TYPE_WARFORGED   
		|| nRace == RACIAL_TYPE_WARFORGED_SCOUT   
		|| nRace == RACIAL_TYPE_WARFORGED_CHARGER)  
		{  
			string sResRef = GetResRef(oItem);  
			if(sResRef == "prc_wf_admtbody"   
			|| sResRef == "prc_wf_compbody"  
			|| sResRef == "prc_wf_woodbody"  
			|| sResRef == "prc_wf_mithbody"   
			|| sResRef == "prc_wf_helmhead"   
			|| sResRef == "prc_wf_helmadmt"  
			|| sResRef == "prc_wf_helmwood"  
			|| sResRef == "prc_wf_helmmith")  
			{  
				return; // Skip VoP check for Warforged body armor  
			}  
		}

		oItem = GetPCItemLastEquipped();  
        int iWeaponAllowed = (GetBaseItemType(oItem) == BASE_ITEM_CLUB  
            || GetBaseItemType(oItem) == BASE_ITEM_DAGGER  
            || GetBaseItemType(oItem) == BASE_ITEM_DART  
            || GetBaseItemType(oItem) == BASE_ITEM_HEAVYCROSSBOW  
            || GetBaseItemType(oItem) == BASE_ITEM_LIGHTCROSSBOW  
            || GetBaseItemType(oItem) == BASE_ITEM_LIGHTMACE  
            || GetBaseItemType(oItem) == BASE_ITEM_MORNINGSTAR  
            || GetBaseItemType(oItem) == BASE_ITEM_QUARTERSTAFF  
            || GetBaseItemType(oItem) == BASE_ITEM_SICKLE  
            || GetBaseItemType(oItem) == BASE_ITEM_SLING  
            || GetBaseItemType(oItem) == BASE_ITEM_SHORTSPEAR  
            || GetBaseItemType(oItem) == BASE_ITEM_BOLT  
            || GetBaseItemType(oItem) == BASE_ITEM_GOAD  
            || GetBaseItemType(oItem) == BASE_ITEM_KATAR  
            || GetBaseItemType(oItem) == BASE_ITEM_HEAVY_MACE  
            || GetBaseItemType(oItem) == BASE_ITEM_BULLET);  
  
        int iMagic = 0;  
        itemproperty eCheckIP = GetFirstItemProperty(oItem);  
        while (GetIsItemPropertyValid(eCheckIP))  
        {  
            if (!(GetItemPropertyTag(eCheckIP) == "Sanctify1")  
                && !(GetItemPropertyTag(eCheckIP) == "Sanctify2")  
                && !(GetItemPropertyTag(eCheckIP) == "Sanctify3")  
                && !(GetItemPropertyTag(eCheckIP) == "Sanctify4"))  
                iMagic = 1;  
            eCheckIP = GetNextItemProperty(oItem);  
        }  
        if (!(GetTag(oItem) == "xp1_mystrashand")  
            && !(GetTag(oItem) == "H2_SenseiAmulet")  
            && !(GetResRef(oItem) == "prc_sk_mblade_bs")  
            && !(GetResRef(oItem) == "prc_sk_mblade_th")  
            && !(GetResRef(oItem) == "prc_sk_mblade_ss")
			&& !(GetResRef(oItem) == "psi_sk_tshield_0")
            && !(GetResRef(oItem) == "prc_sk_mblade_ls"))  
        {  
            if ((IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem)) && (iMagic || !iWeaponAllowed))  
            {  
                if (!(GetBaseItemType(oItem) == BASE_ITEM_SLING && GetItemPropertyType(GetFirstItemProperty(oItem)) == ITEM_PROPERTY_MIGHTY))  
                {  
                    AssignCommand(oPC, ClearAllActions(TRUE));  
                    AssignCommand(oPC, ActionUnequipItem(oItem));  
                    FloatingTextStringOnCreature(GetName(oItem) + " would break your vow!", oPC, FALSE);  
                }  
            }  
        }  
    }  
    // OnUnequip: remove VoP-tagged properties from the unequipped item  
    else if (nEvent == EVENT_ONPLAYERUNEQUIPITEM)  
    {  
        oItem = GetPCItemLastUnequipped();  
        if (IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))  
            RemoveVoPProperties(oItem);  
    }  
}

/* void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_forsaker running, event: " + IntToString(nEvent));
	
	// Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;

        default:
            oPC = OBJECT_SELF;
    }
	
    object oItem;
	object oArmor;
	object oShield;
    object oSkin = GetPCSkin(oPC);
    int nLevel = GetCharacterLevel(oPC)-GetPersistantLocalInt(oPC,"VoPLevel1")+1;
	int nACArmor = 4+nLevel/3;
	int nACDeflection = nLevel/6;
	int nACNatural = nLevel/8;
	int nRegen = 1+(nLevel-17)/7;
	int nDR = 5*(1+(nLevel-10)/9);
	int nER = (10*(1+(nLevel-13)/7))-5;
	int nResist = 0;//Resistance (Ex): At 7th level, an ascetic gains a +1 resistance bonus on all saving throws. This bonus increases to +2 at 13th level, and to +3 at 17th level.
	if (nLevel >= 17) nResist = 1 + (nLevel - 7) / 5;
	else if (nLevel >= 13) nResist = 2;
	else if (nLevel >= 7) nResist = 1; 
	int nForsakerBonus = GetLevelByClass(CLASS_TYPE_FORSAKER, oPC)/2;
	int nSlot, nLevelCheck, nExaltedStrike, nTotalEnhancement;
	
	//Enhancement bonus for unarmed damage and weapons; consider the bigger, Forsaker or VoP
	if(nLevel>=10)      						nExaltedStrike = 1+(nLevel-7)/3;
	else if(nLevel>=4)  						nExaltedStrike = 1;
	if(nForsakerBonus>=nExaltedStrike)          nTotalEnhancement = nForsakerBonus;
	else 									    nTotalEnhancement = nExaltedStrike;
	
    // We aren't being called from any event, instead from EvalPRCFeats
	
    if(nEvent == FALSE)
	{	
		if (GetPRCSwitch("PRC_NWNXEE_ENABLED") && GetPRCSwitch("PRC_PRCX_ENABLED"))  
        ConvertVoPToNWNxEE(oPC); 
	
	    if (GetPRCSwitch("PRC_NWNXEE_ENABLED") && GetPRCSwitch("PRC_PRCX_ENABLED"))  
        ConvertVoPFeatsToNWNxEE(oPC);  
	
	//Check if level up bonus has already been chosen and given for any of past VoP levels
		for(nLevelCheck=1; nLevelCheck <= nLevel; nLevelCheck++)
		{	
			//Call stat boost dialogue for level 7 and each 4 levels after that
			if (!GetPersistantLocalInt(oPC, "VoPBoost"+IntToString(nLevelCheck)) && (nLevelCheck-(nLevelCheck/4)*4 == 3) && (nLevelCheck >= 7) && (nLevelCheck <= 27)) 
			{
				AssignCommand(oPC, ClearAllActions(TRUE));
				SetPersistantLocalInt(oPC,"VoPBoostCheck",nLevelCheck);
				StartDynamicConversation("ft_vowpoverty_ab", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);	
			}
			//Applying stat boosts  
			if(GetPersistantLocalInt(oPC, "VoPBoost"+IntToString(nLevelCheck)) >= 10)  
			{  
				int stat = GetPersistantLocalInt(oPC, "VoPBoost"+IntToString(nLevelCheck)) - 10;  
				int value = 2 * (1 + (nLevel - nLevelCheck) / 4);  
			  
				if (GetPRCSwitch("PRC_NWNXEE_ENABLED") && GetPRCSwitch("PRC_PRCX_ENABLED"))  
				{  
					// Track last applied intrinsic bonus per ability to avoid stacking  
					string sKey = "VoP_EE_Boost_" + IntToString(stat);  
					int nLastApplied = GetPersistantLocalInt(oPC, sKey);  
					int nDelta = value - nLastApplied;  
					if (nDelta > 0)  
					{  
						PRC_Funcs_ModAbilityScore(oPC, stat, nDelta);  
						SetPersistantLocalInt(oPC, sKey, value);  
					}  
				}  
				else  
				{  
					// Fallback to item property on skin (overwrites, so safe to run each level)  
					SetCompositeBonus(oSkin, "VoPBoostStat"+IntToString(stat), value, ITEM_PROPERTY_ABILITY_BONUS, stat);  
				}  
			}
			//:: Applying stat boosts
			// if(GetPersistantLocalInt(oPC, "VoPBoost"+IntToString(nLevelCheck)) >= 10)
			// {
				// int stat = GetPersistantLocalInt(oPC, "VoPBoost"+IntToString(nLevelCheck)) - 10;
				// int value = 2 * (1 + (nLevel - nLevelCheck) / 4);
				// SetCompositeBonus(oSkin, "VoPBoostStat"+IntToString(stat), value, ITEM_PROPERTY_ABILITY_BONUS, stat);
			// }
		
			//Call exalted feat for each even level
			if (!GetPersistantLocalInt(oPC, "VoPFeat"+IntToString(nLevelCheck)) && (nLevelCheck-(nLevelCheck/2)*2 == 0)) 
			{
				AssignCommand(oPC, ClearAllActions(TRUE));
				SetPersistantLocalInt(oPC,"VoPFeatCheck",nLevelCheck);
				StartDynamicConversation("ft_vowpoverty_ft", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);	
			}
		}
		
		//AC Armor +4 on 1st, then +1 each 3 levels
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nACArmor, AC_ARMOUR_ENCHANTMENT_BONUS)), oPC);
		
		//Deflection Armor +1 each 6 levels
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nACDeflection, AC_DEFLECTION_BONUS)), oPC);
		
		//Resistance (Ex): At 7th level, an ascetic gains a +1 resistance bonus on all saving throws. This bonus increases to +2 at 13th level, and to +3 at 17th level.
		if (nLevel>=7)
		{
			SetCompositeBonus(oSkin, "VoPResist", nResist, ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_ALL);
		}
		
		//Natural Armor +1 each 8 levels
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectACIncrease(nACNatural, AC_NATURAL_BONUS)), oPC);
		
		//DR 5/Enhancement starting 10, +5 each 9 levels
		if (nLevel >= 10) ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageReduction(nDR,nTotalEnhancement)),oPC);
		
		//Energy resistance 5 for acid, cold ,electrical, fire and sonic on 13th, than +10 each 7 levels
		if (nLevel>=13)
		{
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_ACID, nER, 0, FALSE), oPC);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_COLD, nER, 0, FALSE), oPC);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nER, 0, FALSE), oPC);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_FIRE, nER, 0, FALSE), oPC);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_SONIC, nER, 0, FALSE), oPC);
		}
		
		//Freedom of Movement at 14th
		if (nLevel>=14) IPSafeAddItemProperty(oSkin, ItemPropertyFreeAction(), 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
		
		//Regeneration 1 at 17th, +1 at each 7 levels
		if (nLevel>=17) SetCompositeBonus(oSkin, "VoPFH", nRegen, ITEM_PROPERTY_REGENERATION);
		
		//True Seeing at 18th
		if (nLevel>=18) IPSafeAddItemProperty(oSkin, ItemPropertyTrueSeeing(), 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
		
		// Exalted Strike - only applies to weapons or unarmed
		effect eEffect1 = EffectAttackIncrease(nTotalEnhancement);
		effect eEffect2 = VoPDamage(nTotalEnhancement);
		effect eLink = EffectLinkEffects(eEffect1,eEffect2);
			   eLink = SupernaturalEffect(eLink);
			   eLink = TagEffect(eLink, "EffectExaltedStrike");
		
		//Remove any prior bonus to avoid duplication
		effect eCheckEffect = GetFirstEffect(oPC);
		while (GetIsEffectValid(eCheckEffect))
		{
			if(GetEffectTag(eCheckEffect) == "EffectExaltedStrike") RemoveEffect(oPC, eCheckEffect);
			eCheckEffect = GetNextEffect(oPC);
		}
	    
		//Give player the bonus, regardless of the weapon
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC); 	
		
		// For some reason, EVENT_ONPLAYEREQUIPITEM just works with weapons, so it is better to check all other items for magic elsewhere		
		for (nSlot=0; nSlot < 13; nSlot++) //All but creatures slots
		{
			oItem=GetItemInSlot(nSlot, oPC);
			if (!(GetTag(oItem) == "xp1_mystrashand") 
				&& !(GetTag(oItem) == "H2_SenseiAmulet") 
			&& !(GetResRef(oItem) == "prc_sk_mblade_bs") 
			&& !(GetResRef(oItem) == "prc_sk_mblade_th")
			&& !(GetResRef(oItem) == "prc_sk_mblade_ss")
			&& !(GetResRef(oItem) == "prc_sk_mblade_ls"))
			{
				if((GetIsItemPropertyValid(GetFirstItemProperty(oItem)) && !(GetItemPropertyTag(GetFirstItemProperty(oItem)) == "Tag_PRC_OnHitKeeper")
				&& !(nSlot == 4 || nSlot == 5)) 										   //Check if it is magical (all items but on the hands)
				|| (nSlot == 1 && GetBaseAC(oItem) >= 1)                                //Check if it is an armor (AC>0)
				|| (nSlot == 5 && GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD ||    //Check if it is a shield 
									GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD || 
									GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD))
				{
					AssignCommand(oPC, ClearAllActions(TRUE));
					AssignCommand(oPC, ActionUnequipItem(oItem));
					FloatingTextStringOnCreature(GetName(oItem)+" would break your vow!", oPC, FALSE);
				}
			}
		}
		
		//Remove bonus from unequiped weapons
		oItem = GetPCItemLastUnequipped();
		if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))   IPRemoveAllItemProperties(oItem, DURATION_TYPE_TEMPORARY); 
		
        AddEventScript(oPC, EVENT_SCRIPT_MODULE_ON_EQUIP_ITEM, "ft_vowofpoverty", TRUE, FALSE);
    }
	
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_SCRIPT_MODULE_ON_EQUIP_ITEM)
	{
		oItem = GetPCItemLastEquipped();
		int iWeaponAllowed = GetBaseItemType(oItem) == BASE_ITEM_CLUB 
						  || GetBaseItemType(oItem) == BASE_ITEM_DAGGER
						  || GetBaseItemType(oItem) == BASE_ITEM_DART
						  || GetBaseItemType(oItem) == BASE_ITEM_HEAVYCROSSBOW
						  || GetBaseItemType(oItem) == BASE_ITEM_LIGHTCROSSBOW
						  || GetBaseItemType(oItem) == BASE_ITEM_LIGHTMACE
						  || GetBaseItemType(oItem) == BASE_ITEM_MORNINGSTAR
						  || GetBaseItemType(oItem) == BASE_ITEM_QUARTERSTAFF
						  || GetBaseItemType(oItem) == BASE_ITEM_SICKLE
						  || GetBaseItemType(oItem) == BASE_ITEM_SLING
						  || GetBaseItemType(oItem) == BASE_ITEM_SHORTSPEAR
						  || GetBaseItemType(oItem) == BASE_ITEM_BOLT
						  || GetBaseItemType(oItem) == BASE_ITEM_GOAD
						  || GetBaseItemType(oItem) == BASE_ITEM_KATAR
						  || GetBaseItemType(oItem) == BASE_ITEM_HEAVY_MACE
						  || GetBaseItemType(oItem) == BASE_ITEM_BULLET;
		
		//Check if the magic is JUST Sanctify
		int iMagic = 0;
		itemproperty eCheckIP = GetFirstItemProperty(oItem);
		while (GetIsItemPropertyValid(eCheckIP))
		{
			if(!(GetItemPropertyTag(eCheckIP) == "Sanctify1") && !(GetItemPropertyTag(eCheckIP) == "Sanctify2") && !(GetItemPropertyTag(eCheckIP) == "Sanctify3")
			  && !(GetItemPropertyTag(eCheckIP) == "Sanctify4"))   iMagic = 1;
			eCheckIP = GetNextItemProperty(oItem);
		}
		if (!(GetTag(oItem) == "xp1_mystrashand") 
			&& !(GetTag(oItem) == "H2_SenseiAmulet")
			&& !(GetResRef(oItem) == "prc_sk_mblade_bs") 
			&& !(GetResRef(oItem) == "prc_sk_mblade_th")
			&& !(GetResRef(oItem) == "prc_sk_mblade_ss")
			&& !(GetResRef(oItem) == "prc_sk_mblade_ls"))
		{
			if((IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem)) && (iMagic || !iWeaponAllowed)) //Check if weapon is magical or not on allowed list	        
			{
				if(!(GetBaseItemType(oItem) == BASE_ITEM_SLING && GetItemPropertyType(GetFirstItemProperty(oItem)) == ITEM_PROPERTY_MIGHTY)) //Allow Mighty Bonus on Slings
				{
					AssignCommand(oPC, ClearAllActions(TRUE));
					AssignCommand(oPC, ActionUnequipItem(oItem));
					FloatingTextStringOnCreature(GetName(oItem)+" would break your vow!", oPC, FALSE);
				}
			}
		}
	}
} */

