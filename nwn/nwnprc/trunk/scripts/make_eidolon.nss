/* Elder Eidolon Template  
  
	make_eidolon.nss  
  
	By: Jaysyn   
	Created: 2026-08-03  
  
	Constructs from previous epochs still exist in the darkest,  
	most secluded regions of the world. Known collectively as  
	elder eidolons, these ageless creatures guard sites that have  
	long since been abandoned, the races that built them having  
	faded into obscurity. Eidolons are mindless, and do only what  
	they are ordered to do by their creators.  
  
/*///////////////////////////////////////////////////////////  
#include "nw_inc_gff"  
#include "prc_inc_spells"  
#include "prc_inc_util"  
#include "inc_debug"  
#include "prc_inc_json"  

//:: Returns the Eidolon's bonus HP based on size 
int GetEidolonBonusHP(int nSize)  
{  
    if (nSize == CREATURE_SIZE_SMALL)      return 10;  
    if (nSize == CREATURE_SIZE_MEDIUM)     return 20;  
    if (nSize == CREATURE_SIZE_LARGE)      return 30;  
    if (nSize == CREATURE_SIZE_HUGE)       return 40;  
    if (nSize == CREATURE_SIZE_GARGANTUAN) return 60;  
    if (nSize == CREATURE_SIZE_COLOSSAL)   return 80;  
    return 0; //:: Tiny or smaller  
}  
  
//:: Apply Eidolon effects 
void ApplyEidolonEffects(object oCreature, int nBaseHD)  
{  
	object oSkin = GetPCSkin(oCreature); 
	int nSize = GetCreatureSize(oCreature);
	itemproperty ipIP;  
	effect eEidolon;  
	effect eVFX;
	effect eLink;
  
//:: Construct Traits: immunities  
	ipIP = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
	ipIP = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
	ipIP = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
	ipIP = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DEATH_MAGIC);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
	ipIP = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
	ipIP = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
	ipIP = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
	ipIP = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);	
  
//:: Darkvision + Low-light vision  
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_DARKVISION);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_LOWLIGHT_VISION);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
  
//:: Damage Reduction (adamantine) by HD - itemproperty based  
	itemproperty ipDR;  
	if(nBaseHD >= 16)      ipDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_10_HP);  
	else if(nBaseHD >= 11) ipDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_7_HP);  
	else if(nBaseHD >= 7)  ipDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_5_HP);  
	else if(nBaseHD >= 4)  ipDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_3_HP);  
	else                   ipDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_1_HP);  
  
	ipDR = TagItemProperty(ipDR, "Eidolon_DR");
	
	IPSafeAddItemProperty(oSkin, ipDR, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
  
//:: Otherworldly Geometry: +4 deflection AC
	effect eAC = EffectACIncrease(4, AC_DEFLECTION_BONUS);  
	eAC = TagEffect(eAC, "Eidolon_AC");
	eAC = UnyieldingEffect(eAC);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oCreature);  
  
//:: Immunity to Magic (Ex): immune to spells/SLAs that allow SR
	effect eSR = EffectSpellResistanceIncrease(100);
	eSR = TagEffect(eSR, "Eidolon_SR");
	eSR = UnyieldingEffect(eSR);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSR, oCreature);
  
//:: Fast Repair (Ex): 5 HP/round while above 0 HP 
	int nVFX = VFX_DUR_PETRIFY;
/* 	if (nSize > CREATURE_SIZE_LARGE)
	{
		nVFX = VFX_DUR_PROT_GREATER_STONESKIN;
	} */
	eEidolon = EffectLinkEffects(eEidolon, EffectRegenerate(5, 6.0));
	eVFX = EffectVisualEffect(nVFX);	
	eLink = EffectLinkEffects(eEidolon, eVFX);
	eLink = TagEffect(eLink, "Eidolon_Regen");
	eLink = UnyieldingEffect(eLink);   
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCreature);  
  
//:: Slam attack if no natural attacks (size-based)  
	string sResRef;  
	nSize = PRCGetCreatureSize(oCreature)+1;  
	sResRef = "prc_cent_hoof_";  
	sResRef += GetAffixForSize(nSize); 
	object oCreWLeft  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature);  
	object oCreWRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCreature); 
	object oCreWSpecial = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCreature); 	
	  
	if(!GetIsObjectValid(oCreWLeft))  
	{  
		object oClaw = CreateItemOnObject(sResRef, oCreature);  
		SetIdentified(oClaw, TRUE);  
		ForceEquip(oCreature, oClaw, INVENTORY_SLOT_CWEAPON_L);  
	}  
	else if(!GetIsObjectValid(oCreWRight))  
	{  
		object oClaw = CreateItemOnObject(sResRef, oCreature);  
		SetIdentified(oClaw, TRUE);  
		ForceEquip(oCreature, oClaw, INVENTORY_SLOT_CWEAPON_R);  
	} 
	else if(!GetIsObjectValid(oCreWSpecial))  
	{  
		object oClaw = CreateItemOnObject(sResRef, oCreature);  
		SetIdentified(oClaw, TRUE);  
		ForceEquip(oCreature, oClaw, INVENTORY_SLOT_CWEAPON_B);  
	} 
	
}


void main ()  
{  
	object oBaseCreature = OBJECT_SELF;  
	object oNewCreature;  
  
	string sBaseName = GetName(oBaseCreature);  
	GetObjectUUID(oBaseCreature);  
  
	int nRacial = MyPRCGetRacialType(oBaseCreature);  
  
	if(GetLocalInt(oBaseCreature, "TEMPLATE_EIDOLON") > 0)  
	{  
		DoDebug("No Template Stacking");  
		return;  
	}  
  
	if ((GetObjectType(oBaseCreature) != OBJECT_TYPE_CREATURE) || (GetIsPC(oBaseCreature) == TRUE))  
	{  
		DoDebug("make_eidolon >> Not a creature");  
		return;  
	}  
  
	if(GetIsIncorporeal(oBaseCreature))  
	{  
		DoDebug("make_eidolon >> Incorporeal creatures cannot receive the Eidolon template.");  
		return;  
	}  

	//:: Oozes, undead, elementals, constructs, fey, and outsiders cannot become eidolons  
	if(nRacial == RACIAL_TYPE_OOZE || nRacial == RACIAL_TYPE_UNDEAD || nRacial == RACIAL_TYPE_FEY ||
		nRacial == RACIAL_TYPE_ELEMENTAL || nRacial == RACIAL_TYPE_CONSTRUCT ||  
		nRacial == RACIAL_TYPE_OUTSIDER)  
	{  
		DoDebug("make_eidolon >> Invalid racial type for Eidolon template.");  
		return;  
	}
	
	int nBaseHD = GetHitDice(oBaseCreature);  
	int nBaseCR = FloatToInt(GetChallengeRating(oBaseCreature));  
  
	location lSpawnLoc = GetLocation(oBaseCreature);  
  
	json jBaseCreature = ObjectToJson(oBaseCreature, TRUE);  
	json jNewCreature;  
	json jFinalCreature;  
  
//:: Change type to construct  
	jNewCreature = json_ModifyRacialType(jBaseCreature, RACIAL_TYPE_CONSTRUCT);  
  
//:: Abilities: Str +8, Dex +4, Wis -> 11, Cha -> 1, Con/Int none  
	jNewCreature = json_UpdateTemplateStats(jNewCreature, 8, 4, 0, 0, 0, 0);  
	jNewCreature = GffReplaceByte(jNewCreature, "Wis", 11);  
	jNewCreature = GffReplaceByte(jNewCreature, "Cha", 3);  
	jNewCreature = GffReplaceByte(jNewCreature, "Con", 10);
	jNewCreature = GffReplaceByte(jNewCreature, "Int", 10);
  
	int nSize = PRCGetCreatureSize(oBaseCreature); 

//;: Remove all non-racial hit dice.
	jNewCreature = json_TrimAllClassHD(jNewCreature);	

//:: Change remaining class to construct
	jNewCreature = json_SetClassType(jNewCreature, CLASS_TYPE_CONSTRUCT, 1);
	
//:: Construct base creature uses d10 Hit Dice  
	jNewCreature = json_RecalcMaxHP(jNewCreature, 10);

//:: Remove all magical feats
	jNewCreature =  json_RemoveFeatsByToolsCategory(jNewCreature);

//:: Remove all skill ranks	
	jNewCreature =  json_ZeroAllSkillRanks(jNewCreature);  	
  
//:: Add Eidolon's size-based bonus HP on top  
	int nCurrentMaxHP = JsonGetInt(GffGetShort(jNewCreature, "MaxHitPoints"));  
	int nBonusHP = GetEidolonBonusHP(nSize);  
	jNewCreature = GffReplaceShort(jNewCreature, "MaxHitPoints", nCurrentMaxHP + nBonusHP);  
	jNewCreature = GffReplaceShort(jNewCreature, "CurrentHitPoints", nCurrentMaxHP + nBonusHP);  
	jNewCreature = GffReplaceShort(jNewCreature, "HitPoints", nCurrentMaxHP + nBonusHP);
	
	if (GetIsObjectValid(oBaseCreature))  
	{  
		AssignCommand(oBaseCreature, ClearAllActions(TRUE));  
		effect eBlank = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);  
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlank, oBaseCreature, 6.0f);  
		DestroyObject(oBaseCreature, 0.1f);  
	}  
  
//:: Challenge Rating: base +3  
	jFinalCreature = json_UpdateCR(jNewCreature, nBaseCR, 3);  
  
	oNewCreature = JsonToObject(jFinalCreature, lSpawnLoc);  
  
//:: Alignment: Always neutral  
	AdjustAlignment(oNewCreature, ALIGNMENT_NEUTRAL, 100, FALSE);  
	  
	ApplyEidolonEffects(oNewCreature, nBaseHD); 

	SetEventScript(oNewCreature, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT, "eidolon_spellsat");
	SetEventScript(oNewCreature, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "eidolon_hb");
  
	SetName(oNewCreature, "Elder Eidolon "+ sBaseName);  
	SetSubRace(oNewCreature, "Construct (Augmented)");  
  
	SetLocalInt(oNewCreature, "TEMPLATE_EIDOLON", 1);  

	//:: Insanity Aura (Su): permanent AOE confusion  
	ExecuteScript("eidolon_insane", oNewCreature);	
}