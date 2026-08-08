/* Corpse Creature Template  [Book of Vile Darkness]
  
	make_corpse_cre.nss  
  
	By: Jaysyn   
	Created: 2026-08-02  
  
	Not all corpses risen as undead are shambling, slow-moving  
	zombies. Some retain their intellect and abilities. Surrounded  
	by the stench of death, the flesh of these creatures hardens  
	and becomes brittle but retains great strength. Corpse clerics  
	still pay homage to their dark gods. Corpse warriors heft  
	mighty weapons with skill. Corpse beholders still spray deadly  
	rays from shriveled eyestalks.  
  
	They cannot be the result of a simple animate dead spell, but  
	could arise from a create undead or create greater undead  
	spell, as undead of their equivalent Hit Dice.  
  
/*///////////////////////////////////////////////////////////  
  
#include "nw_inc_gff"  
#include "prc_inc_spells"  
#include "prc_inc_util"  
#include "inc_debug"  
#include "prc_inc_json"  
  
//:: Returns the Corpse template's natural AC bonus based on size.  
int json_GetCorpseACBonus(int nSize)  
{  
    if (nSize <= CREATURE_SIZE_TINY)       return 0;  
    if (nSize == CREATURE_SIZE_SMALL)      return 1;  
    if (nSize == CREATURE_SIZE_MEDIUM)     return 2;  
    if (nSize == CREATURE_SIZE_LARGE)      return 3;  
    if (nSize == CREATURE_SIZE_HUGE)       return 4;  
    if (nSize == CREATURE_SIZE_GARGANTUAN) return 6;  
    if (nSize == CREATURE_SIZE_COLOSSAL)   return 11;  
    return 0;  
}  
  
//:: Sets jCreature's NaturalAC to the Corpse template value for its size,  
//:: but only if it's better than the base creature's existing NaturalAC.  
json json_ApplyCorpseAC(json jCreature)  
{  
    json jAppearanceField = JsonObjectGet(jCreature, "Appearance_Type");  
    int nAppearance = JsonGetInt(jAppearanceField);  
    int nSize = StringToInt(Get2DAString("appearance", "SizeCategory", nAppearance));  
  
    int nNewAC = json_GetCorpseACBonus(nSize);  
  
    //:: Keep base creature's natural AC if it's better  
    json jBaseAC = GffGetByte(jCreature, "NaturalAC");  
    if (jBaseAC != JsonNull() && JsonGetInt(jBaseAC) > nNewAC)  
        return jCreature;  
  
    jCreature = GffReplaceByte(jCreature, "NaturalAC", nNewAC);  
    return jCreature;  
}  
  
//:: Apply Corpse effects  
void ApplyCorpseEffects(object oCreature, int nBaseHD)   
{  
//:: Declare major variables	  
	object oSkin	= GetPCSkin(oCreature);  
	  
	itemproperty ipIP;  
	  
	effect eCorpse;  
	  
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
	  
//:: Darkvision (Ex): Corpse creatures gain darkvision with a range of 60 feet.  
	eCorpse = EffectLinkEffects(eCorpse, EffectBonusFeat(FEAT_DARKVISION));  
  
//:: Undead Traits (Ex)  
	eCorpse = EffectLinkEffects(eCorpse, EffectBonusFeat(3585));	//:: Immunity to Critical Hits  
	eCorpse = EffectLinkEffects(eCorpse, EffectBonusFeat(3591));	//:: Immunity to Sneak Attack  
	eCorpse = EffectLinkEffects(eCorpse, EffectBonusFeat(3590));	//:: Immunity to Poison  
	eCorpse = EffectLinkEffects(eCorpse, EffectBonusFeat(3588));	//:: Immunity to Mind Effects  
	  
//:: Make *really* permanent	  
	eCorpse = UnyieldingEffect(eCorpse);  
	  
//:: Apply everything	  
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCorpse, oCreature);	  
	  
//:: Add slam attack (Attacks: A corpse creature also gains a slam attack.  
//:: The base creature's base attack bonus does not change.)  
	string sResRef;  
	int nSize = PRCGetCreatureSize(oCreature)+1;  
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
//:: Declare major variables  
	object oBaseCreature = OBJECT_SELF;  
	object oNewCreature;  
	  
	string sBaseName = GetName(oBaseCreature);  
	  
	GetObjectUUID(oBaseCreature);  
	  
	int nRacial = MyPRCGetRacialType(oBaseCreature);  
		  
	//:: No Template Stacking  
	if(GetLocalInt(oBaseCreature, "TEMPLATE_CORPSE") > 0)  
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
  
	"Corpse" is a template that can be added to any non-undead,   
	non-construct, non-plant corporeal creature.  
  
*/  
	if(nRacial == RACIAL_TYPE_UNDEAD || nRacial == RACIAL_TYPE_CONSTRUCT || nRacial == RACIAL_TYPE_PLANT)  
	{  
		DoDebug("make_corpse_cre: Invalid racial type for template.");  
		return;  
	}			  
  
	//:: Corporeal creatures only  
	if(GetIsIncorporeal(oBaseCreature))  
	{  
		DoDebug("make_corpse_cre: Incorporeal creatures cannot receive the Corpse template.");  
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
  
//:: AC: Natural armor bonus based on size (keep base creature's if better).  
	jNewCreature = json_ApplyCorpseAC(jNewCreature);  
  
//:: Abilities: Str +4, Dex -2, Con -, Int +0, Wis +0, Cha +0.  
	jNewCreature = json_UpdateTemplateStats(jNewCreature, 4, -2, 0, 0, 0, 0);  
	  
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
  
//:: Challenge Rating: Same as the base creature +1.  
	jFinalCreature = json_UpdateCR(jNewCreature, nBaseCR, 1);  
  
//:: Update the creature  
    oNewCreature = JsonToObject(jFinalCreature, lSpawnLoc);  
  
//:: Apply the non-json effects  
	ApplyCorpseEffects(oNewCreature, nBaseHD);  
  
//:: Update creature's name  
	SetName(oNewCreature, "Corpse "+ sBaseName);  
  
//:: Update race field  
	SetSubRace(oNewCreature, "Undead (Augmented)");  
  
//:: Alignment: Always evil.  
	SetLocalInt(oNewCreature, "TEMPLATE_CORPSE_ALIGN_LOCK", 1);  
	object oNewCreatureAlignFix = oNewCreature;  
	AdjustAlignment(oNewCreatureAlignFix, ALIGNMENT_EVIL, 100, FALSE);  
	AdjustAlignment(oNewCreatureAlignFix, ALIGNMENT_LAWFUL, 0, FALSE);  
  
//:: Freshen Up  
	DelayCommand(0.1f, PRCForceRest(oNewCreature));  
  
//:: Set variables  
	SetLocalInt(oNewCreature, "TEMPLATE_CORPSE", 1);  
}