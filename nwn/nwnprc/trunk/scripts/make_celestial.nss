/* Celestial Creature Template  
  
	make_celestial.nss  
  
	By: Jaysyn   
	Created: 2026-08-03  
  
	Celestial creatures dwell in the upper planes, realms of  
	good, although they resemble beings found on the Material  
	Plane. They are more regal and more beautiful than their  
	earthly counterparts.  
  
	Celestial creatures often come in metallic colors (usually  
	silver, gold, or platinum). They can be mistaken for  
	half-celestials, more powerful creatures that are created  
	when a celestial mates with a non-celestial creature.  
  
/*///////////////////////////////////////////////////////////  
  
#include "nw_inc_gff"  
#include "prc_inc_spells"  
#include "prc_inc_util"  
#include "inc_debug"  
#include "prc_inc_json"  

//:: Build and return all effects for the Celestial Template 
effect ApplyCelestialTemplateEffects(int nHD)  
{  
    int nResist;  
    int nDRAmount;  
    int nDRBypass;  
  
    // -------------------------  
    // Acid/Cold/Electricity Resistance  
    // -------------------------  
    // 1-3 HD  = 5  
    // 4-7 HD  = 10  
    // 8-11 HD = 15  
    // 12+ HD  = 20  
    if (nHD >= 12)      nResist = 20;  
    else if (nHD >= 8)  nResist = 15;  
    else if (nHD >= 4)  nResist = 10;  
    else                nResist = 5;  
  
    // -------------------------  
    // Damage Reduction  
    // -------------------------  
    // 1-3 HD  = none  
    // 4-7 HD  = 5/+1  
    // 8-11 HD = 5/+2  
    // 12+ HD  = 10/+3  
    if (nHD >= 12)  
    {  
        nDRAmount = 10;  
        nDRBypass = DAMAGE_POWER_PLUS_THREE;  
    }  
    else if (nHD >= 8)  
    {  
        nDRAmount = 5;  
        nDRBypass = DAMAGE_POWER_PLUS_TWO;  
    }  
    else if (nHD >= 4)  
    {  
        nDRAmount = 5;  
        nDRBypass = DAMAGE_POWER_PLUS_ONE;  
    }  
    else  
    {  
        nDRAmount = 0;  
        nDRBypass = 0;  
    }  
  
    // -------------------------  
    // Build Effects  
    // -------------------------  
    effect eEffects;  
    effect eRes;  
  
    eRes = EffectDamageResistance(DAMAGE_TYPE_ACID, nResist, 0);  
    eEffects = eRes;  
  
    eRes = EffectDamageResistance(DAMAGE_TYPE_COLD, nResist, 0);  
    eEffects = EffectLinkEffects(eEffects, eRes);  
  
    eRes = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResist, 0);  
    eEffects = EffectLinkEffects(eEffects, eRes);  
  
    if (nDRAmount > 0)  
    {  
        effect eDR = EffectDamageReduction(nDRAmount, nDRBypass, 0);  
        eEffects = EffectLinkEffects(eEffects, eDR);  
    }  
  
    eEffects = UnyieldingEffect(eEffects);  
    return eEffects;  
}
  
//:: Apply Celestial non-json effects  
void ApplyCelestialEffects(object oCreature, int nBaseHD)  
{  
//:: Declare major variables  
	effect eCelestial;  
  
//:: Set maximum hit points for each HD (unchanged HD, but keep consistent w/ other templates)  
	int nMaxHP = GetMaxPossibleHP(oCreature);  
	SetCurrentHitPoints(oCreature, nMaxHP);  
  
	if(DEBUG) DoDebug("nMaxHP is: "+IntToString(nMaxHP)+",");  
  
//:: Darkvision (Ex): 60 feet.  
	eCelestial = EffectLinkEffects(eCelestial, EffectBonusFeat(FEAT_DARKVISION));  
  
//:: Make *really* permanent  
	eCelestial = UnyieldingEffect(eCelestial);  
  
//:: Apply the darkvision bundle  
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCelestial, oCreature);  
  
//:: Acid/Cold/Electricity Resistance + Damage Reduction (per-HD table)  
//:: CelestialTemplateEffects() already implements the exact resistance/DR  
//:: table for this template and applies it directly.  
	effect eResistDR = ApplyCelestialTemplateEffects(nBaseHD);  
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistDR, oCreature);  
  
//:: SR equal to double the creature's HD (maximum 25).  
	int nSR = nBaseHD * 2;  
	if(nSR > 25) nSR = 25;  
  
	effect eSR = EffectSpellResistanceIncrease(nSR);  
	eSR = EffectLinkEffects(eSR, UnyieldingEffect(eSR));  
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSR, oCreature);  
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
	if(GetLocalInt(oBaseCreature, "TEMPLATE_CELESTIAL") > 0)  
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
  
	"Celestial" is a template that can be added to any corporeal  
	creature of non-evil alignment.  
  
*/  
	int nAlignGE = GetAlignmentGoodEvil(oBaseCreature);  
	if(nAlignGE == ALIGNMENT_EVIL)  
	{  
		DoDebug("make_celestial: Invalid alignment (evil) for template.");  
		return;  
	}  
  
	//:: Corporeal creatures only  
	if(GetIsIncorporeal(oBaseCreature))  
	{  
		DoDebug("make_celestial: Incorporeal creatures cannot receive the Celestial template.");  
		return;  
	}  
  
	int nBaseHD = GetHitDice(oBaseCreature);  
	int nBaseCR = FloatToInt(GetChallengeRating(oBaseCreature));  
  
	location lSpawnLoc = GetLocation(oBaseCreature);  
  
	json jBaseCreature = ObjectToJson(oBaseCreature, TRUE);  
	json jNewCreature;  
	json jFinalCreature;  
  
//:: Animals with this template become magical beasts, but otherwise  
//:: the creature type is unchanged.  
	if(nRacial == RACIAL_TYPE_ANIMAL || nRacial == RACIAL_TYPE_VERMIN || nRacial == RACIAL_TYPE_BEAST)  
	{  
		jNewCreature = json_ModifyRacialType(jBaseCreature, RACIAL_TYPE_MAGICAL_BEAST);  
	}  
	else  
	{  
		jNewCreature = jBaseCreature;  
	}  
  
//:: Abilities: Same as base creature, but Intelligence is at least 3.  
	json jInt = GffGetByte(jNewCreature, "Int");  
	if (jInt != JsonNull() && JsonGetInt(jInt) < 3)  
	{  
		jNewCreature = GffReplaceByte(jNewCreature, "Int", 3);  
	}  
  
//:: Special Attacks: Smite Evil 1x/day  
	jNewCreature = json_AddCelestialPowers(jNewCreature);  
  
	if (GetIsObjectValid(oBaseCreature))  
	{  
		AssignCommand(oBaseCreature, ClearAllActions(TRUE));  
  
		// optional fade / vanish visuals  
		effect eBlank = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);  
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlank, oBaseCreature, 6.0f);  
  
		DestroyObject(oBaseCreature, 0.1f);  
	}  
  
//:: Challenge Rating: Up to 3 HD, same as base; 4-7 HD +1; 8+ HD +2.  
	jFinalCreature = json_UpdateCelestialCR(jNewCreature, nBaseCR, nBaseHD);  
  
//:: Update the creature  
	oNewCreature = JsonToObject(jFinalCreature, lSpawnLoc);  
  
//:: Apply the non-json effects (darkvision, resistances, DR, SR)  
	ApplyCelestialEffects(oNewCreature, nBaseHD);  
  
//:: Update creature's name  
	SetName(oNewCreature, "Celestial "+ sBaseName);  
  
//:: Alignment: Always good (any) — force good if not already.  
	int nAlignGE2 = GetAlignmentGoodEvil(oNewCreature);  
	if(nAlignGE2 != ALIGNMENT_GOOD)  
	{  
		AdjustAlignment(oNewCreature, ALIGNMENT_GOOD, 100, FALSE);  
	}  
  
//:: Freshen Up  
	//DelayCommand(0.1f, PRCForceRest(oNewCreature));  <-- was stripping hide itemprops?
  
//:: Set variables  
	SetLocalInt(oNewCreature, "TEMPLATE_CELESTIAL", 1);  
}