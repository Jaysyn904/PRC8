//::////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//::///////////////////////////////////////////////////////
//::  
/*
	Impactscript for Animate Tree.
	
	Animate Tree (Sp): At 8th level, a verdant lord	can 
	animate a tree within 180 feet of him once per day. It 
	takes a full round for a tree to uproot itself; 
	thereafter it has a speed of 30 feet and fights as a 
	treant with respect to attacks and damage. The animated 
	tree gains a number of bonus Hit Dice equal to the 
	number of verdant lord levels the character possesses. 
	Though its Intelligence score is only 2 while animated, 
	the tree automatically understands the verdant lord’s 
	commands. The character can return the animated tree to 
	its normal state at will, and it automatically returns 
	to its normal state if it dies or if the verdant lord 
	who animated it is incapacitated or moves out of range. 
	
	Once the tree returns to its normal state by any means, 
	the verdant lord cannot animate another tree for 24 hours.	
	
*/
//::  
//::////////////////////////////////////////////// 
//::	Script:     vl_animate_tree.nss
//::	Author:     Jaysyn
//::	Created:    2025-08-14 11:06:57
//:://////////////////////////////////////////////
#include "prc_inc_json"
#include "prc_inc_spells"

const float TREE_RANGE_FEET = 180.0;
const string TREE_RESREF = "prc_anim_tree01";

// Checks if caster is outside & above ground
int GetIsOutsideAboveGround(object oPC)
{
    if (GetIsAreaInterior(GetArea(oPC))) return FALSE;
    if (GetIsAreaNatural(GetArea(oPC)) == FALSE) return FALSE;
    return TRUE;
}

// Watch function: despawns tree if caster is dead or out of range
void AnimateTreeWatch(object oTree, object oPC)
{
    if(DEBUG) DoDebug("vl_animate_tree >> AnimateTreeWatch: Starting function.");
	
	if (!GetIsObjectValid(oTree) || !GetIsObjectValid(oPC)) return;

    if (GetIsDead(oPC) ||
        GetDistanceBetween(oTree, oPC) > FeetToMeters(TREE_RANGE_FEET))
    {
        DestroyObject(oTree);
        return;
    }

    DelayCommand(1.0, AnimateTreeWatch(oTree, oPC));
}

void main()
{
    object oPC = OBJECT_SELF;
    int nVerdant = GetLevelByClass(CLASS_TYPE_VERDANT_LORD, oPC);

    // Check outdoors & above ground
    if (!GetIsOutsideAboveGround(oPC))
    {
        SendMessageToPC(oPC, "This ability can only be used outdoors and above ground.");
        return;
    }

    // Target location
    location lTarget = PRCGetSpellTargetLocation();

    // Distance check
    if (GetDistanceBetweenLocations(GetLocation(oPC), lTarget) > FeetToMeters(TREE_RANGE_FEET))
    {
        SendMessageToPC(oPC, "That location is too far away.");
        return;
    }

    // Load template
    json jTree = TemplateToJson(TREE_RESREF, RESTYPE_UTC);
    if (jTree == JSON_NULL)
    {
        SendMessageToPC(oPC, "TemplateToJson failed — bad resref or resource missing.");
        return;
    }

    // Original HD
    int nOriginalHD = json_GetCreatureHD(jTree);
    if (nOriginalHD <= 0)
    {
        SendMessageToPC(oPC, "json_GetCreatureHD failed — template missing HD data.");
        return;
    }

    //:: Stat boost calc
    int nStatBoost = GetStatBoostsFromHD(nOriginalHD, nVerdant);
	
    //:: Add Hit Dice
    jTree = json_AddHitDice(jTree, nVerdant);
    if (jTree == JSON_NULL)
    {
        SendMessageToPC(oPC, "json_AddHitDice failed - JSON became invalid.");
        return;
    }

	//:: Update feats
	jTree = json_AddFeatsFromCreatureVars(jTree, nOriginalHD);
	if (jTree == JSON_NULL)
	{
		SendMessageToPC(oPC, "json_AddFeatsFromCreatureVars failed — JSON became invalid.");
		return;
	}

    //:: Update stats
    jTree = json_ApplyAbilityBoostFromHD(jTree, nOriginalHD);
    if (jTree == JSON_NULL)
    {
        SendMessageToPC(oPC, "json_ApplyAbilityBoostFromHD failed — JSON became invalid.");
        return;
    }

    // Size increase
    if (nVerdant > 9)
    {
        jTree = json_AdjustCreatureSize(jTree, 1);
        if (jTree == JSON_NULL)
        {
			SendMessageToPC(oPC, "vl_animate_tree: json_AdjustCreatureSize failed - JSON became invalid.");
            return;
        }
    }
	
    // Spawn Animated Tree from JSON	
    MultisummonPreSummon();
	
	object oTree = JsonToObject(jTree, lTarget);
            effect eSummon = ExtraordinaryEffect(EffectSummonCreature("", VFX_FNF_SUMMON_NATURES_ALLY_1, 0.0, 0, VFX_IMP_UNSUMMON, oTree));
			
	ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSummon, lTarget);
	
	if (!GetIsObjectValid(oTree))
    {
        SendMessageToPC(oPC, "JsonToObject failed - could not create creature from edited template.");
        return;
    }
	
    DelayCommand(0.5, AugmentSummonedCreature(GetResRef(oTree)));

    // Set faction to caster’s
    ChangeFaction(oTree, oPC);
    SetLocalObject(oTree, "ANIMATOR", oPC);
	
	SetCurrentHitPoints(oTree, GetMaxPossibleHP(oTree));

    // Explosion effect during uprooting
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE), oTree, 6.0);
	
	effect eBark = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);
	eBark = UnyieldingEffect(eBark);
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBark, oTree);	

    // Full round wait then move
    AssignCommand(oTree, ClearAllActions());
    AssignCommand(oTree, ActionWait(6.0));
    AssignCommand(oTree, ActionMoveToObject(oPC));

    // Start watch loop
    DelayCommand(6.1, AnimateTreeWatch(oTree, oPC));
}