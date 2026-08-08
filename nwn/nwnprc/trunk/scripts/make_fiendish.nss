/* Fiendish Creature Template  
  
	make_fiendish.nss  
  
	By: Jaysyn  
	Created: 2026-08-05  
  
	Fiendish creatures dwell in the infernal planes, realms of  
	evil, although they resemble beings found on the Material  
	Plane. They are more fearsome in appearance than their  
	earthly counterparts.  
  
	Fiendish creatures are often mistaken for half-fiends, more  
	powerful creatures that are created when a fiend mates with  
	a non-celestial creature, or through some foul infernal  
	breeding project.  
  
/*///////////////////////////////////////////////////////////  
#include "nw_inc_gff"  
#include "prc_inc_spells"  
#include "prc_inc_util"  
#include "inc_debug"  
#include "prc_inc_json"  

//:: Updates CR for Fiendish template  
json json_UpdateFiendishCR(json jCreature, int nBaseCR, int nHD)  
{  
    int nNewCR;  
  
    if (nHD <= 3)  
        nNewCR = nBaseCR;  
    else if (nHD <= 7)  
        nNewCR = nBaseCR + 1;  
    else  
        nNewCR = nBaseCR + 2;  
  
    jCreature = GffReplaceFloat(jCreature, "ChallengeRating", IntToFloat(nNewCR));  
    return jCreature;  
}  
  
//:: Apply Fiendish template to a creature JSON template  
json json_MakeFiendish(json jCreature, int nBaseHD, int nBaseCR)  
{  
    if (jCreature == JsonNull())  
        return JsonNull();  
  
    int nHD = json_GetCreatureHD(jCreature);  
    if (nHD <= 0)  
    {  
        DoDebug("prc_inc_json >> json_MakeFiendish: Invalid HD");  
        return JsonNull();  
    }  
  
    float fCR = json_GetChallengeRating(jCreature);  
    jCreature = json_UpdateFiendishCR(jCreature, FloatToInt(fCR), nHD);  
    if (jCreature == JsonNull())  
    {  
        DoDebug("prc_inc_json >> json_MakeFiendish: json_UpdateFiendishCR failed");  
        return JsonNull();  
    }  
  
    //:: Ensure Intelligence is at least 3  
    json jInt = GffGetByte(jCreature, "Int");  
    if (jInt != JsonNull() && JsonGetInt(jInt) < 3)  
    {  
        jCreature = GffReplaceByte(jCreature, "Int", 3);  
    }  
  
    //:: Change creature type if animal/beast/vermin to magical beast  
    int nRacialType = JsonGetInt(GffGetByte(jCreature, "Race"));  
    if (nRacialType == RACIAL_TYPE_ANIMAL || nRacialType == RACIAL_TYPE_VERMIN || nRacialType == RACIAL_TYPE_BEAST)  
    {  
        jCreature = json_ModifyRacialType(jCreature, RACIAL_TYPE_MAGICAL_BEAST);  
    }  
  
    jCreature = json_UpdateFiendishCR(jCreature, nBaseCR, nHD);  
    if (jCreature == JsonNull())  
    {  
        DoDebug("prc_inc_json >> json_MakeFiendish: json_UpdateFiendishCR failed");  
        return JsonNull();  
    }  
  
    return jCreature;  
}
  
//:: Build and return all effects for the Fiendish Template  
effect ApplyFiendishTemplateEffects(int nHD)  
{  
    int nResist;  
    int nDRAmount;  
    int nDRBypass;  
  
    // -------------------------  
    // Cold/Fire Resistance  
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
  
    eRes = EffectDamageResistance(DAMAGE_TYPE_COLD, nResist, 0);  
    eEffects = eRes;  
  
    eRes = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResist, 0);  
    eEffects = EffectLinkEffects(eEffects, eRes);  
  
    if (nDRAmount > 0)  
    {  
        effect eDR = EffectDamageReduction(nDRAmount, nDRBypass, 0);  
        eEffects = EffectLinkEffects(eEffects, eDR);  
    }  
  
    eEffects = UnyieldingEffect(eEffects);  
    return eEffects;  
}  
  
//:: Apply Fiendish non-json effects  
void ApplyFiendishEffects(object oCreature, int nBaseHD)  
{  
//:: Declare major variables  
	effect eFiendish;  
  
//:: Set maximum hit points for each HD (unchanged HD, keep consistent w/ other templates)  
	int nMaxHP = GetMaxPossibleHP(oCreature);  
	SetCurrentHitPoints(oCreature, nMaxHP);  
  
	if(DEBUG) DoDebug("nMaxHP is: "+IntToString(nMaxHP)+",");  
  
//:: Darkvision (Ex): 60 feet.  
	eFiendish = EffectLinkEffects(eFiendish, EffectBonusFeat(FEAT_DARKVISION));  
  
//:: Make *really* permanent  
	eFiendish = UnyieldingEffect(eFiendish);  
  
//:: Apply the darkvision bundle  
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFiendish, oCreature);  
  
//:: Cold/Fire Resistance + Damage Reduction (per-HD table)  
	effect eResistDR = ApplyFiendishTemplateEffects(nBaseHD);  
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
	if(GetLocalInt(oBaseCreature, "TEMPLATE_FIENDISH") > 0)  
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
  
	"Fiendish" is a template that can be added to any corporeal  
	creature of non-good alignment.  
  
*/  
	int nAlignGE = GetAlignmentGoodEvil(oBaseCreature);  
	if(nAlignGE == ALIGNMENT_GOOD)  
	{  
		DoDebug("make_fiendish: Invalid alignment (good) for template.");  
		return;  
	}  
  
	//:: Corporeal creatures only  
	if(GetIsIncorporeal(oBaseCreature))  
	{  
		DoDebug("make_fiendish: Incorporeal creatures cannot receive the Fiendish template.");  
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
  
	if (GetIsObjectValid(oBaseCreature))  
	{  
		AssignCommand(oBaseCreature, ClearAllActions(TRUE));  
  
		// optional fade / vanish visuals  
		effect eBlank = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);  
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlank, oBaseCreature, 6.0f);  
  
		DestroyObject(oBaseCreature, 0.1f);  
	}  
  
//:: Challenge Rating: Up to 3 HD, same as base; 4-7 HD +1; 8+ HD +2.  
	jFinalCreature = json_UpdateFiendishCR(jNewCreature, nBaseCR, nBaseHD);  
  
//:: Update the creature  
	oNewCreature = JsonToObject(jFinalCreature, lSpawnLoc);  
  
//:: Apply the non-json effects (darkvision, resistances, DR, SR)  
	ApplyFiendishEffects(oNewCreature, nBaseHD);  

//:: Special Attacks: Smite Good 1x/day
	object oSkin = GetPCSkin(oNewCreature);
	
    itemproperty ipIP = PRCItemPropertyBonusFeat(FEAT_TEMPLATE_FIENDISH_SMITE_GOOD);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
	
//:: Update creature's name  
	SetName(oNewCreature, "Fiendish "+ sBaseName);  
  
//:: Alignment: Always evil (any) — force evil if not already.  
	int nAlignGE2 = GetAlignmentGoodEvil(oNewCreature);  
	if(nAlignGE2 != ALIGNMENT_EVIL)  
	{  
		AdjustAlignment(oNewCreature, ALIGNMENT_EVIL, 100, FALSE);  
	}  
  
//:: Freshen Up  
	//DelayCommand(0.1f, PRCForceRest(oNewCreature));  <-- was stripping hide itemprops?
  
//:: Set variables  
	SetLocalInt(oNewCreature, "TEMPLATE_FIENDISH", 1);  
}


