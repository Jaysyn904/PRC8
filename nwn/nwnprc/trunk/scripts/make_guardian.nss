//::///////////////////////////////////////////////  
//:: Name           Guardian creature template  
//:: FileName       make_guardian  
//:://////////////////////////////////////////////  
/*  
"Guardian" is an inherited template that can be added to any living  
corporeal aberration, animal, magical beast, or vermin with an  
Intelligence of 3 or lower (referred to hereafter as the base creature).  
  
Size and Type: If the base creature is an animal, its type changes to  
magical beast (augmented animal).  
  
Special Qualities:  
    - Blindsense out to 60 feet.  
    - Darkvision out to 120 feet.  
    - Low-light vision.  
    - Illuminated Eyes (Ex): 60-ft radius light while eyes are open.  
    - Immunity to magical sleep effects; guardians don't need to sleep.  
    - +2 racial bonus on saves against mind-affecting spells/abilities.  
  
Abilities: Wis +4, Cha -2.  
Skills: +6 racial bonus on Listen and Spot checks (stacks).  
Feats: Bonus Blind-Fight (or another feat if already known).  
Challenge Rating: as base creature +1.  
*/  
//:://////////////////////////////////////////////  
#include "nw_inc_gff"  
#include "inc_debug"  
#include "prc_inc_json"  
  
//:: Directly modifies jCreature's Challenge Rating (base creature + 1, flat).  
json json_UpdateGuardianCR(json jCreature, int nBaseCR)  
{  
    int nNewCR = nBaseCR + 1;  
    jCreature = GffReplaceFloat(jCreature, "ChallengeRating", IntToFloat(nNewCR));  
    return jCreature;  
}  
  
//:: Apply Guardian template to a creature JSON template  
json json_MakeGuardian(json jCreature, int nBaseCR)  
{  
    if (jCreature == JsonNull())  
        return JsonNull();  
  
    int nHD = json_GetCreatureHD(jCreature);  
    if (nHD <= 0)  
    {  
        DoDebug("prc_inc_json >> json_MakeGuardian: Invalid HD");  
        return JsonNull();  
    }  
  
    //:: Precondition: base creature Int must be 3 or lower.  
    json jInt = GffGetByte(jCreature, "Int");  
    if (jInt != JsonNull() && JsonGetInt(jInt) > 3)  
    {  
        DoDebug("prc_inc_json >> json_MakeGuardian: base creature Int > 3, template invalid.");  
        return JsonNull();  
    }  
  
    //:: Change creature type if animal/beast/vermin to magical beast  
    int nRacialType = JsonGetInt(GffGetByte(jCreature, "Race"));  
    if (nRacialType == RACIAL_TYPE_ANIMAL || nRacialType == RACIAL_TYPE_VERMIN || nRacialType == RACIAL_TYPE_BEAST)  
    {  
        jCreature = json_ModifyRacialType(jCreature, RACIAL_TYPE_MAGICAL_BEAST);  
    }  
  
    //:: Abilities: Wis +4, Cha -2  
    json jWis = GffGetByte(jCreature, "Wis");  
    if (jWis != JsonNull())  
        jCreature = GffReplaceByte(jCreature, "Wis", JsonGetInt(jWis) + 4);  
  
    json jCha = GffGetByte(jCreature, "Cha");  
    if (jCha != JsonNull())  
    {  
        int nNewCha = JsonGetInt(jCha) - 2;  
        if (nNewCha < 1) nNewCha = 1;  
        jCreature = GffReplaceByte(jCreature, "Cha", nNewCha);  
    }  
  
    //:: Challenge Rating: base creature + 1  
    jCreature = json_UpdateGuardianCR(jCreature, nBaseCR);  
    if (jCreature == JsonNull())  
    {  
        DoDebug("prc_inc_json >> json_MakeGuardian: json_UpdateGuardianCR failed");  
        return JsonNull();  
    }  
  
    return jCreature;  
}  
  
//:: Apply Guardian non-json effects (senses, sleep immunity, saves, skills, feat)  
void ApplyGuardianEffects(object oCreature, int nBaseHD)  
{  
    effect eGuardian;  
  
    int nMaxHP = GetMaxPossibleHP(oCreature);  
    SetCurrentHitPoints(oCreature, nMaxHP);  
  
    //:: Darkvision (Ex): 120 feet & Low-light vision.  
    eGuardian = EffectLinkEffects(eGuardian, EffectBonusFeat(FEAT_DARKVISION));  
    eGuardian = EffectLinkEffects(eGuardian, EffectBonusFeat(FEAT_LOWLIGHTVISION));  
  
    //:: Blind-Fight bonus feat  
    if(!GetHasFeat(FEAT_BLIND_FIGHT, oCreature))  
    {  
        eGuardian = EffectLinkEffects(eGuardian, EffectBonusFeat(FEAT_BLIND_FIGHT));  
    }  
  
    //:: Skills: +6 Listen/Spot  
    eGuardian = EffectLinkEffects(eGuardian, EffectSkillIncrease(SKILL_LISTEN, 6));  
    eGuardian = EffectLinkEffects(eGuardian, EffectSkillIncrease(SKILL_SPOT, 6));  
  
    //:: +2 save vs mind-affecting  
    eGuardian = EffectLinkEffects(eGuardian, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_MIND_SPELLS));  
  
    //:: Immunity to magical sleep  
    eGuardian = EffectLinkEffects(eGuardian, EffectImmunity(IMMUNITY_TYPE_SLEEP));  
  
    //:: Make permanent, apply once  
    eGuardian = UnyieldingEffect(eGuardian);  
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGuardian, oCreature);  
}
  
void main()  
{  
//:: Declare major variables  
    object oBaseCreature = OBJECT_SELF;  
    object oNewCreature;  
  
    string sBaseName = GetName(oBaseCreature);  
  
    int nRacial = MyPRCGetRacialType(oBaseCreature);  
  
    //:: No Template Stacking  
    if(GetLocalInt(oBaseCreature, "TEMPLATE_GUARDIAN") > 0)  
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
    "Guardian" is an inherited template that can be added to any living  
    corporeal aberration, animal, magical beast, or vermin with an  
    Intelligence of 3 or lower.  
*/  
    //:: Corporeal, living creatures only  
    if(GetIsIncorporeal(oBaseCreature))  
    {  
        DoDebug("make_guardian: Incorporeal creatures cannot receive the Guardian template.");  
        return;  
    }  
  
    if(nRacial != RACIAL_TYPE_ABERRATION && nRacial != RACIAL_TYPE_ANIMAL &&  nRacial != RACIAL_TYPE_BEAST && 
       nRacial != RACIAL_TYPE_MAGICAL_BEAST && nRacial != RACIAL_TYPE_VERMIN)  
    {  
        DoDebug("make_guardian: Invalid racial type for template.");  
        return;  
    }  
  
    if(GetAbilityScore(oBaseCreature, ABILITY_INTELLIGENCE) > 3)  
    {  
        DoDebug("make_guardian: Invalid Intelligence (>3) for template.");  
        return;  
    }  
  
    int nBaseHD = GetHitDice(oBaseCreature);  
    int nBaseCR = FloatToInt(GetChallengeRating(oBaseCreature));  
  
    location lSpawnLoc = GetLocation(oBaseCreature);  
  
    json jBaseCreature = ObjectToJson(oBaseCreature, TRUE);  
    json jFinalCreature;  
  
	//:: Apply Guardian JSON modifications (racial type, abilities, CR)  
	jFinalCreature = json_MakeGuardian(jBaseCreature, nBaseCR);  
	if (jFinalCreature == JsonNull())  
	{  
		DoDebug("make_guardian: json_MakeGuardian failed.");  
		return;  
	}  
  
	if (GetIsObjectValid(oBaseCreature))  
	{  
		AssignCommand(oBaseCreature, ClearAllActions(TRUE));  
  
		// optional fade / vanish visuals  
		effect eBlank = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);  
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlank, oBaseCreature, 6.0f);  
  
		DestroyObject(oBaseCreature, 0.1f);  
	}  
  
	//:: Spawn the new Guardian creature  
		oNewCreature = JsonToObject(jFinalCreature, lSpawnLoc);  
	  
	//:: Apply the non-json effects (senses, sleep immunity, saves, skills, feat)  
		ApplyGuardianEffects(oNewCreature, nBaseHD);  
	  
	//:: Update creature's name  
		SetName(oNewCreature, "Guardian " + sBaseName);  
	  
	//:: Set variables  
		SetLocalInt(oNewCreature, "TEMPLATE_GUARDIAN", 1);  
	}  