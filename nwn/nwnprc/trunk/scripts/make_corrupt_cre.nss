/* Corrupted Creature Template  [Book of Vile Darkness]
  
	make_corrupt_cre.nss  
  
	By: Jaysyn   
	Created: 2026-08-02  
  
	Powerful evil, unchecked and rampant, can horribly alter  
	any aspect of the physical world, and creatures are no  
	exception. Twisted by malevolence, corrupted creatures  
	take on a hideous appearance and gain evil powers and  
	dire intent.  
  
/*///////////////////////////////////////////////////////////  
  
#include "nw_inc_gff"  
#include "prc_inc_spells"  
#include "prc_inc_util"  
#include "inc_debug"  
#include "prc_inc_json"  
  
//:: Returns the Corrupted template's natural AC bonus based on size.  
int json_GetCorruptACBonus(int nSize)  
{  
    if (nSize <= CREATURE_SIZE_LARGE) return 4;  
    return 8; //:: Huge or larger  
}  
  
//:: Adds the Corrupted AC bonus to jCreature's existing NaturalAC.  
json json_ApplyCorruptAC(json jCreature)  
{  
    json jAppearanceField = JsonObjectGet(jCreature, "Appearance_Type");  
    int nAppearance = JsonGetInt(jAppearanceField);  
    int nSize = StringToInt(Get2DAString("appearance", "SizeCategory", nAppearance));  
  
    int nAddAC = json_GetCorruptACBonus(nSize);  
  
    jCreature = json_IncreaseBaseAC(jCreature, nAddAC);  
    return jCreature;  
}  
  
//:: Apply Corrupted effects  
void ApplyCorruptedEffects(object oCreature, int nBaseHD)   
{  
//:: Declare major variables	  
	object oSkin	= GetPCSkin(oCreature);  
	  
	itemproperty ipIP;  
	  
	effect eCorrupt;  
	  
//:: Special Qualities: darkvision 60 ft. plus acid immunity.  
	eCorrupt = EffectLinkEffects(eCorrupt, EffectBonusFeat(FEAT_DARKVISION));  
	eCorrupt = EffectLinkEffects(eCorrupt, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 100));  
  
//:: Damage Reduction (Ex): based on HD.  
	int nDR;  
	int nDRPower;  
	if(nBaseHD >= 12)      { nDR = 10; nDRPower = DAMAGE_POWER_PLUS_THREE; }  
	else if(nBaseHD >= 8)  { nDR = 5;  nDRPower = DAMAGE_POWER_PLUS_TWO;   }  
	else if(nBaseHD >= 4)  { nDR = 5;  nDRPower = DAMAGE_POWER_PLUS_ONE;   }  
	  
	if(nDR > 0)  
	{  
		eCorrupt = EffectLinkEffects(eCorrupt, EffectDamageReduction(nDR, nDRPower));  
	}  
  
//:: Fast Healing (Ex): half HD, max 10.  
	int nFastHeal = nBaseHD / 2;  
	if(nFastHeal > 10) nFastHeal = 10;  
	if(nFastHeal > 0)  
	{  
		eCorrupt = EffectLinkEffects(eCorrupt, EffectRegenerate(nFastHeal, 6.0f));  
	}  
	  
//:: Make *really* permanent	  
	eCorrupt = UnyieldingEffect(eCorrupt);  
	  
//:: Apply everything	  
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCorrupt, oCreature);	  
  
//:: Disruptive Attack (Su): deals additional vile damage on hit to  
//:: uncorrupted, living, corporeal nonoutsiders. Half HD, max 20.  
	int nVileDamage = nBaseHD / 2;  
	if(nVileDamage > 20) nVileDamage = 20;  
  
	object oCreBite		= GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCreature);  
	object oCreWLeft	= GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature);  
	object oCreWRight	= GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCreature);  
  
	itemproperty ipVileDamage = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_VILE, nVileDamage);  
	IPSafeAddItemProperty(oCreBite, ipVileDamage);  
	IPSafeAddItemProperty(oCreWLeft, ipVileDamage);  
	IPSafeAddItemProperty(oCreWRight, ipVileDamage);
	  
//:: Enhanced Power (Su): +4 to save DCs of special attacks - stored for   
//:: spell/ability DC calculation hooks to read.  
	SetLocalInt(oCreature, "TEMPLATE_CORRUPT_DC_BONUS", 4);  
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
	if(GetLocalInt(oBaseCreature, "TEMPLATE_CORRUPT") > 0)  
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
  
	"Corrupted" is a template that can be added to any corporeal   
	creature that is not an outsider.  
  
*/  
	if(nRacial == RACIAL_TYPE_OUTSIDER)  
	{  
		DoDebug("make_corrupt_cre: Invalid racial type for template.");  
		return;  
	}			  
  
	//:: Corporeal creatures only  
	if(GetIsIncorporeal(oBaseCreature))  
	{  
		DoDebug("make_corrupt_cre: Incorporeal creatures cannot receive the Corrupted template.");  
		return;  
	}  
	  
	int nBaseHD = GetHitDice(oBaseCreature);  
	int nBaseCR = FloatToInt(GetChallengeRating(oBaseCreature));  
	  
	location lSpawnLoc = GetLocation(oBaseCreature);  
	  
	json jBaseCreature = ObjectToJson(oBaseCreature, TRUE);  
	json jNewCreature;  
	json jFinalCreature;  
  
//:: Creatures that gain this template change their type to aberration.  
	jNewCreature = json_ModifyRacialType(jBaseCreature, RACIAL_TYPE_ABERRATION);  
  
//:: AC: +4 if Large or smaller, +8 if Huge or larger.  
	jNewCreature = json_ApplyCorruptAC(jNewCreature);  
  
//:: Abilities: Str +4, Dex -2, Con +4, Int +0, Wis -2, Cha -2.  
	jNewCreature = json_UpdateTemplateStats(jNewCreature, 4, -2, 4, 0, -2, -2);  
	  
	if (GetIsObjectValid(oBaseCreature))  
	{  
		AssignCommand(oBaseCreature, ClearAllActions(TRUE));  
  
		// optional fade / vanish visuals  
		effect eBlank = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);  
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlank, oBaseCreature, 6.0f);  
  
		DestroyObject(oBaseCreature, 0.1f);  
	}  
  
//:: Challenge Rating: up to 3 HD +1; 4-7 HD +2; 8+ HD +3.  
	int nCRMod;  
	if(nBaseHD >= 8)      nCRMod = 3;  
	else if(nBaseHD >= 4) nCRMod = 2;  
	else                  nCRMod = 1;  
	  
	jFinalCreature = json_UpdateCR(jNewCreature, nBaseCR, nCRMod);	  
		  
//:: Update the creature  
    oNewCreature = JsonToObject(jFinalCreature, lSpawnLoc);	  
	  
//:: Apply the non-json effects	  
	ApplyCorruptedEffects(oNewCreature, nBaseHD);  
	  
//:: Update creature's name  
	SetName(oNewCreature, "Corrupted "+ sBaseName);  
  
//:: Update race field	  
	SetSubRace(oNewCreature, "Aberration (Augmented)");  
  
//:: Alignment: Always evil.  
	AdjustAlignment(oNewCreature, ALIGNMENT_EVIL, 100, FALSE);  
	  
//:: Freshen Up  
	//DelayCommand(0.0f, PRCForceRest(oNewCreature));  
  
//:: Set variables	  
	SetLocalInt(oNewCreature, "TEMPLATE_CORRUPT", 1);	  
}