//::////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//::///////////////////////////////////////////////////////
//::  
/*
	Impactscript for Shadow Servant.  
	(this is handled in the Familiar script)
	
	Shadow Servant (Su): At 1st level, your shadow familiar permanently
	transforms into a Medium shadow elemental. It loses all familiar 
	traits, but gains new abilities as your shadow servant.

	Should your shadow servant die, you can summon a replacement after
	24 hours pass. Your shadow servant cannot travel farther from you 
	than 30 feet + 10 feet for each of your master of shadow levels 
	(40 feet at 1st level and a maximum of 130 feet at 10th level). If 
	it is forcibly separated from you by more than this distance, the 
	servant dissipates instantly, and you must wait 24 hours to summon 
	a new one.	
	
	
	
*/
//::  
//::////////////////////////////////////////////// 
//::	Script:     mshadw_shadserv.nss
//::	Author:     Jaysyn
//::	Created:    2025-11-11 19:25:58
//:://////////////////////////////////////////////
#include "prc_inc_json"
#include "prc_inc_spells"

const string SHADOW_SERVANT_RESREF = "prc_shadow_serv";

// Watch function: despawns Shadow Servant if master is dead or out of range
void ShadowServantWatch(object oShadow, object oPC)
{
    if(DEBUG) DoDebug("mshadw_shadserv >> ShadowServantWatch: Starting function.");
	
	int nMaster = GetLevelByClass(CLASS_TYPE_MASTER_OF_SHADOW, oPC);
	
	float fRange  = 30.0 + (nMaster * 10);
	
	if (!GetIsObjectValid(oShadow) || !GetIsObjectValid(oPC)) return;

    if (GetIsDead(oPC) ||
        GetDistanceBetween(oShadow, oPC) > FeetToMeters(fRange))
    {
        DestroyObject(oShadow);
        return;
    }

    DelayCommand(1.0, ShadowServantWatch(oShadow, oPC));
}

void main()
{
    object oPC = OBJECT_SELF;
	
    int nMaster = GetLevelByClass(CLASS_TYPE_MASTER_OF_SHADOW, oPC);
	
	int nDexBonus = (nMaster >= 5 && (nMaster % 2)) ? (nMaster - 3) : 0;
	
	float fRange  = 30.0 + (nMaster * 10);

    // Target location
    location lTarget = GetSpellTargetLocation();

    // Distance check
    if (GetDistanceBetweenLocations(GetLocation(oPC), lTarget) > FeetToMeters(fRange))
    {
        SendMessageToPC(oPC, "That location is too far away.");
        return;
    }

    // Load template
    json jShadow = TemplateToJson(SHADOW_SERVANT_RESREF, RESTYPE_UTC);
    if (jShadow == JSON_NULL)
    {
        SendMessageToPC(oPC, "mshdw_shadserv: TemplateToJson failed — bad resref or resource missing.");
        return;
    }

    // Original HD
    int nOriginalHD = json_GetCreatureHD(jShadow);
    if (nOriginalHD <= 0)
    {
        SendMessageToPC(oPC, "mshdw_shadserv: json_GetCreatureHD failed — template missing HD data.");
        return;
    }

    //:: Add Hit Dice
	int nHDToAdd  = nMaster -1;
	
	if (nHDToAdd < 0) nHDToAdd = 0;
	
    jShadow = json_AddHitDice(jShadow, nHDToAdd);
	
    if (jShadow == JSON_NULL)
    {
        SendMessageToPC(oPC, "mshdw_shadserv: json_AddHitDice failed - JSON became invalid.");
        return;
    }

	//:: Update feats
	jShadow = json_AddFeatsFromCreatureVars(jShadow, nOriginalHD);
	if (jShadow == JSON_NULL)
	{
		SendMessageToPC(oPC, "mshdw_shadserv: json_AddFeatsFromCreatureVars failed — JSON became invalid.");
		return;
	}

    //:: Update stats
    jShadow = json_ApplyAbilityBoostFromHD(jShadow, nOriginalHD);
    if (jShadow == JSON_NULL)
    {
        SendMessageToPC(oPC, "mshdw_shadserv: json_ApplyAbilityBoostFromHD failed — JSON became invalid.");
        return;
    }

	//:: Bonus DEX from Shadow Servant class ability
	jShadow = json_UpdateTemplateStats(jShadow, 0, nDexBonus);

    // Size increase
    if (nMaster > 2)
    {
        jShadow = json_AdjustCreatureSize(jShadow, 1, TRUE);
        if (jShadow == JSON_NULL)
        {
			SendMessageToPC(oPC, "mshdw_shadserv: json_AdjustCreatureSize failed - JSON became invalid.");
            return;
        }
    }
	
	object oShadow = JsonToObject(jShadow, lTarget);
            effect eSummon = ExtraordinaryEffect(EffectSummonCreature("", VFX_FNF_SUMMON_UNDEAD, 0.0, 0, VFX_IMP_UNSUMMON, oShadow));
			
	ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSummon, lTarget);
	
	if (!GetIsObjectValid(oShadow))
    {
        SendMessageToPC(oPC, "mshdw_shadserv: JsonToObject failed - could not create creature from edited template.");
        return;
    }
	
    // Set faction to caster’s
    ChangeFaction(oShadow, oPC);
    SetLocalObject(oShadow, "ANIMATOR", oPC);
	
	SetCurrentHitPoints(oShadow, GetMaxPossibleHP(oShadow));

	effect eGhost = EffectVisualEffect(VFX_DUR_GHOST_TRANSPARENT);
	eGhost = UnyieldingEffect(eGhost);
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oShadow);	


    // Start watch loop
    DelayCommand(6.1, ShadowServantWatch(oShadow, oPC));
}