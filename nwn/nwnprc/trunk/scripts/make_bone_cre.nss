/* Bone Creature Template  [Book of Vile Darkness]
  
	make_bone_cre.nss  
  
	By: Jaysyn   
	Created: 2026-08-02  
  
	Sometimes creatures that rise as undead skeletons retain  
	their intellect and abilities. Bone fighters wield deadly  
	weapons and clank about in ancient armor. Bone sorcerers  
	cast dreadful spells and are often confused with liches.  
	Bone wyverns darken the skies and threaten with their  
	poisoned, skeletal tails.  
	Bone creatures cannot be the result of a simple animate  
	dead spell, but could arise from a create undead or create greater  
	undead spell, as undead of their equivalent Hit Dice.  
  
/*///////////////////////////////////////////////////////////  
  
#include "nw_inc_gff"  
#include "prc_inc_spells"  
#include "prc_inc_util"  
#include "inc_debug"  
#include "prc_inc_json"  
  
//:: Returns the Bone template's natural AC bonus based on size.  
int json_GetBoneACBonus(int nSize)  
{  
    if (nSize <= CREATURE_SIZE_TINY)       return 0;  
    if (nSize == CREATURE_SIZE_SMALL)      return 1;  
    if (nSize == CREATURE_SIZE_MEDIUM)     return 2;  
    if (nSize == CREATURE_SIZE_LARGE)      return 3;  
    if (nSize == CREATURE_SIZE_HUGE)       return 4;  
    if (nSize == CREATURE_SIZE_GARGANTUAN) return 6;  
    if (nSize == CREATURE_SIZE_COLOSSAL)   return 10;  
    return 0;  
}  
  
//:: Sets jCreature's NaturalAC to the Bone template value for its size  
//:: (replacing, not adding to, the base creature's natural AC).  
json json_ApplyBoneAC(json jCreature)  
{  
    json jAppearanceField = JsonObjectGet(jCreature, "Appearance_Type");  
    int nAppearance = JsonGetInt(jAppearanceField);  
    int nSize = StringToInt(Get2DAString("appearance", "SizeCategory", nAppearance));  
  
    int nNewAC = json_GetBoneACBonus(nSize);  
  
    jCreature = GffReplaceByte(jCreature, "NaturalAC", nNewAC);  
    return jCreature;  
}  
  
//:: Apply Bone effects  
void ApplyBoneEffects(object oCreature, int nBaseHD)   
{  
//:: Declare major variables	  
	object oSkin	= GetPCSkin(oCreature);  
	  
	itemproperty ipIP;  
	  
	effect eBone;  
	  
//:: Undead Traits: immune to mind-affecting, poison, sneak attack, critical hits, paralysis, disease  
	ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);  
  
	ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);  
  
	ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);  
  
	ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);  
	  
	ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);  
	  
	ipIP =ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE);  
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);  
  
//:: Set maximum hit points for each HD  
	int nMaxHP = GetMaxPossibleHP(oCreature);  
    SetCurrentHitPoints(oCreature, nMaxHP);  
	  
	if(DEBUG) DoDebug("nMaxHP is: "+IntToString(nMaxHP)+",");  
	  
//:: Immunities (Ex): Bone creatures have cold immunity.  
    eBone = EffectLinkEffects(eBone, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100));  
  
//:: Because they lack flesh or internal organs, they take only   
//:: half damage from piercing and slashing weapons.  
    eBone = EffectLinkEffects(eBone, EffectDamageResistance(DAMAGE_TYPE_PIERCING, 100, 50));  
	eBone = EffectLinkEffects(eBone, EffectDamageResistance(DAMAGE_TYPE_SLASHING, 100, 50));  
  
//:: Darkvision (Ex): Bone creatures gain darkvision with a range of 60 feet.  
	eBone = EffectLinkEffects(eBone, EffectBonusFeat(FEAT_DARKVISION));  
  
//:: Undead Traits (Ex)  
	eBone = EffectLinkEffects(eBone, EffectBonusFeat(3585));	//:: Immunity to Critical Hits  
	eBone = EffectLinkEffects(eBone, EffectBonusFeat(3591));	//:: Immunity to Sneak Attack  
	eBone = EffectLinkEffects(eBone, EffectBonusFeat(3590));	//:: Immunity to Poison  
	eBone = EffectLinkEffects(eBone, EffectBonusFeat(3588));	//:: Immunity to Mind Effects  
	  
//:: Feats: gets the Weapon Finesse feat with any one weapon for free.  
	eBone = EffectLinkEffects(eBone, EffectBonusFeat(FEAT_WEAPON_FINESSE));  
	  
//:: Make *really* permanent	  
	eBone = UnyieldingEffect(eBone);  
	  
//:: Apply everything	  
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBone, oCreature);	  
	  
//:: Add claw attacks - one per hand  
	string sResRef;  
	int nSize = PRCGetCreatureSize(oCreature)-1;  
	sResRef = "prc_claw_1d6m_";  
	sResRef += GetAffixForSize(nSize);  
	  
	object oCreWLeft  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature);  
	object oCreWRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCreature);  
	  
	if(!GetIsObjectValid(oCreWLeft))  
	{  
		object oClaw = CreateItemOnObject(sResRef, oCreature);  
		SetIdentified(oClaw, TRUE);  
		ForceEquip(oCreature, oClaw, INVENTORY_SLOT_CWEAPON_L);  
	}  
	if(!GetIsObjectValid(oCreWRight))  
	{  
		object oClaw = CreateItemOnObject(sResRef, oCreature);  
		SetIdentified(oClaw, TRUE);  
		ForceEquip(oCreature, oClaw, INVENTORY_SLOT_CWEAPON_R);  
	} 
}


void main ()  
{  
//:: Declare major variables  
	object oBaseCreature = OBJECT_SELF;  
	object oNewCreature;  
	  
	string sBaseName = GetName(oBaseCreature);  
	  
	GetObjectUUID(oBaseCreature);  
	  
	int nRacial = MyPRCGetRacialType(oBaseCreature);  
		  
	//:: No Template Stacking  
	if(GetLocalInt(oBaseCreature, "TEMPLATE_BONE") > 0)  
	{  
		DoDebug("No Template Stacking");  
		return;  
	}  
	  
	//:: Creatures & NPCs only  
	if ((GetObjectType(oBaseCreature) != OBJECT_TYPE_CREATURE) || (GetIsPC(oBaseCreature) == TRUE))  
	{   
		DoDebug("Not a creature");  
		return;  
	}	  
/* 	  
  
	"Bone" is a template that can be added to any non-undead,   
	corporeal creature that has a skeletal system.  
  
*/  
	if(nRacial == RACIAL_TYPE_UNDEAD || nRacial == RACIAL_TYPE_CONSTRUCT ||   
		nRacial == RACIAL_TYPE_ELEMENTAL || nRacial == RACIAL_TYPE_OOZE)  
	{  
		DoDebug("make_bone_cre: Invalid racial type for template.");  
		return;  
	}

	//:: Corporeal creatures only - Bone template requires a skeletal system  
	if(GetIsIncorporeal(oBaseCreature))  
	{  
		DoDebug("make_bone_cre: Incorporeal creatures cannot receive the Bone template.");  
		return;  
	}	
	  
	int nBaseHD = GetHitDice(oBaseCreature);  
	int nBaseCR = FloatToInt(GetChallengeRating(oBaseCreature));  
	  
	location lSpawnLoc = GetLocation(oBaseCreature);  
	  
	json jBaseCreature = ObjectToJson(oBaseCreature, TRUE);  
	json jNewCreature;  
	json jFinalCreature;  
  
//:: The creature's type changes to undead. It retains all type   
//:: modifiers and subtypes, if applicable.  
	jNewCreature = json_ModifyRacialType(jBaseCreature, RACIAL_TYPE_UNDEAD);  
  
//:: AC: Natural armor bonus changes to a number based on the   
//:: bone creature's size (replaces, not adds to, base creature's).  
	jNewCreature = json_ApplyBoneAC(jNewCreature);  
  
//:: Abilities: Str +0, Dex +4, Con -, Int +0, Wis +0, Cha +0.  
	jNewCreature = json_UpdateTemplateStats(jNewCreature, 0, 4, 0, 0, 0, 0);  
	  
	if (GetIsObjectValid(oBaseCreature))  
	{  
		AssignCommand(oBaseCreature, ClearAllActions(TRUE));  
  
		// optional fade / vanish visuals  
		effect eBlank = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);  
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlank, oBaseCreature, 6.0f);  
  
		DestroyObject(oBaseCreature, 0.1f);  
	}  
  
//:: Hit Dice: Increase to d12.  
	jNewCreature = json_RecalcMaxHP(jNewCreature, 12);  
	  
//:: Challenge Rating: Same as the base creature (Bone template has no   
//:: standard CR modifier listed; keep base CR unchanged).  
	jFinalCreature = json_UpdateCR(jNewCreature, nBaseCR, 0);	  
		  
//:: Update the creature  
    oNewCreature = JsonToObject(jFinalCreature, lSpawnLoc);	  
	  
//:: Apply the non-json effects	  
	ApplyBoneEffects(oNewCreature, nBaseHD);  
	  
//:: Update creature's name  
	SetName(oNewCreature, "Bone "+ sBaseName);  
  
//:: Update race field	  
	SetSubRace(oNewCreature, "Undead (Augmented)");  
	  
//:: Freshen Up  
	DelayCommand(0.1f, PRCForceRest(oNewCreature));  
  
//:: Set variables	  
	SetLocalInt(oNewCreature, "TEMPLATE_BONE", 1);	  
}