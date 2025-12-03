//::////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//::////////////////////////////////////////////////////////
//;:
//:: Epic Spell: Twinfiend
//:: Author: Boneshank (Don Armstrong)
//:: Updated By: Jaysyn
//:: Updated on: 2025-11-18 18:18:09
//::
//::////////////////////////////////////////////////////////
/*
	School: Conjuration (Summoning, Evil)
	Components: V,S
	Range: Short
	Effect: Summons two advanced pit fiends
	Duration: 1 Turn / Caster level
	Saving Throw: None
	Spell Resistance: No

	You summon two advanced pit fiends from the Nine Hells
	to do your bidding. These devils recieve one bonus hit 
	die for every 2 caster levels of the summoner & maximum 
	hit points per die. The pit fiends follow your orders to
	the best of their abilities, for the duration of the spell.
*/
//::////////////////////////////////////////////////////////
//#include "x2_inc_toollib"
#include "prc_alterations"
#include "inc_epicspells"
//#include "x2_inc_spellhook"
#include "nw_i0_generic"
#include "prc_inc_json"
#include "inc_ecl"

void SpawnTwinFiend(object oPC, json jDevil, location lTarget, float fDuration)
{
	MultisummonPreSummon();
	
	object oFiend = JsonToObject(jDevil, lTarget);
	
	int nHD = GetHitDice(oFiend);
	
	SetLocalInt(oFiend, "PRC_CASTERLEVEL_OVERRIDE", nHD);
	
	int nCasterLvl = GetTotalCastingLevel(oPC);
	
	if (!GetIsObjectValid(oFiend))
	{
		SendMessageToPC(oPC, "ss_ep_twinfiend | SpawnTwinFiend() >> oFiend not passed to function.");
		return;
	}
	
	string sSummon = "twinfiend_demon";
	
	// effect eSummon;
	effect eVis = EffectVisualEffect(460);
	effect eVis2 = EffectVisualEffect(VFX_IMP_UNSUMMON);
	
	effect eSummon = EffectSummonCreature("", 460, 0.0, 0, VFX_IMP_UNSUMMON, oFiend);
	
	//:: Set faction to caster’s
	ChangeFaction(oFiend, oPC);
	SetLocalObject(oFiend, "SUMMONER", oPC);
	
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);
	
	if (!GetIsObjectValid(oFiend))
	{
		SendMessageToPC(oPC, "ss_ep_twinfiend | SpawnTwinFiend() >> JsonToObject failed - could not create creature from edited template.");
		return;
	}	

	//:: Update creature weapons for Size increase
	if (nCasterLvl > 14)
	{
		if(DEBUG) DoDebug("ss_ep_twinfiend | SpawnTwinFiend() >> Updating Creature weapons for size increase.");
							
		object oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oFiend);
		MyDestroyObject(oWeapCR);
		object oWeapCL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oFiend);
		MyDestroyObject(oWeapCL);
		object oWeapCB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oFiend);
		MyDestroyObject(oWeapCB);
		
		oWeapCR = CreateItemOnObject("nw_it_crewpsp010", oFiend);
		ForceEquip(oFiend, oWeapCR, INVENTORY_SLOT_CWEAPON_R);

		oWeapCL = CreateItemOnObject("bite_pitfiend002", oFiend);
		ForceEquip(oFiend, oWeapCL, INVENTORY_SLOT_CWEAPON_L);

		oWeapCB = CreateItemOnObject("prc_2d6_slamgrab", oFiend);
		ForceEquip(oFiend, oWeapCB, INVENTORY_SLOT_CWEAPON_B);
		
		SetObjectVisualTransform(oFiend, OBJECT_VISUAL_TRANSFORM_SCALE, 1.1);
	}

	AugmentSummonedCreature(sSummon);
	
	
}

void main()
{
    object oPC = OBJECT_SELF;
	
    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
	
	SetLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

	// Target location
    location lTarget = PRCGetSpellTargetLocation();
	
	int nCasterLvl = GetTotalCastingLevel(oPC);
	
	//:: Load template
    json jDevil = TemplateToJson("twinfiend_demon", RESTYPE_UTC);
    if (jDevil == JSON_NULL)
    {
        SendMessageToPC(oPC, "ss_ep_twinfiend >> TemplateToJson failed — bad resref or resource missing.");
        return;
    }
	
    //:: Get Original HD
    int nOriginalHD = json_GetCreatureHD(jDevil);
    if (nOriginalHD <= 0)
    {
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_GetCreatureHD failed — template missing HD data.");
        return;
    }	
	
	//:: Stat boost calc
    int nStatBoost = GetStatBoostsFromHD(nOriginalHD, nCasterLvl/2);
	
    //:: Add one hit dice per two caster levels
    jDevil = json_AddHitDice(jDevil, nCasterLvl/2);
    if (jDevil == JSON_NULL)
    {
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AddHitDice failed - JSON became invalid.");
        return;
    }	
	
	//:: Recalculate & maximize HP
	int nCurrentHD = json_GetCreatureHD(jDevil);
    if (nCurrentHD <= 0)
    {
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_GetCreatureHD failed — template missing HD data.");
        return;
    }		
	
	if(DEBUG) DoDebug("ss_ep_twinfiend >> nCurrentHD is: "+IntToString(nCurrentHD)+ " entering json_RecalcMaxHP.");
	jDevil = json_RecalcMaxHP(jDevil, 8);	
    if (jDevil == JSON_NULL)
    {
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_RecalcMaxHP failed - JSON became invalid.");
        return;
    }	
	
	//:: Update feats
	jDevil = json_AddFeatsFromCreatureVars(jDevil, nOriginalHD);
	if (jDevil == JSON_NULL)
	{
		SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AddFeatsFromCreatureVars failed — JSON became invalid.");
		return;
	}	
	
    //:: Update stats
    jDevil = json_ApplyAbilityBoostFromHD(jDevil, nOriginalHD);
    if (jDevil == JSON_NULL)
    {
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_ApplyAbilityBoostFromHD failed — JSON became invalid.");
        return;
    }
	
	//:: Pit Fiend w 20 INT gets 13 (8+5) skill points per HD
	jDevil = json_AdjustCreatureSkillByID(jDevil, SKILL_SPOT, nCasterLvl/2);
	if (jDevil == JSON_NULL)
	{
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AdjustCreatureSkillByID failed on SPOT — JSON became invalid.");
        return;
    }	
	jDevil = json_AdjustCreatureSkillByID(jDevil, SKILL_LORE, nCasterLvl/2);
	if (jDevil == JSON_NULL)
	{
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AdjustCreatureSkillByID failed on LORE — JSON became invalid.");
        return;
    }	
	jDevil = json_AdjustCreatureSkillByID(jDevil, SKILL_LISTEN, nCasterLvl/2);
	if (jDevil == JSON_NULL)
	{
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AdjustCreatureSkillByID failed on LISTEN — JSON became invalid.");
        return;
    }		
	jDevil = json_AdjustCreatureSkillByID(jDevil, SKILL_SEARCH, nCasterLvl/2);
	if (jDevil == JSON_NULL)	
	{
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AdjustCreatureSkillByID failed on SEARCH — JSON became invalid.");
        return;
    }		
	jDevil = json_AdjustCreatureSkillByID(jDevil, SKILL_HIDE, nCasterLvl/2);
	if (jDevil == JSON_NULL)
	{
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AdjustCreatureSkillByID failed on HIDE — JSON became invalid.");
        return;
    }	
	jDevil = json_AdjustCreatureSkillByID(jDevil, SKILL_MOVE_SILENTLY, nCasterLvl/2);
	if (jDevil == JSON_NULL)
	{
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AdjustCreatureSkillByID failed on MS — JSON became invalid.");
        return;
    }	
	jDevil = json_AdjustCreatureSkillByID(jDevil, SKILL_CONCENTRATION, nCasterLvl/2);
	if (jDevil == JSON_NULL)
	{
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AdjustCreatureSkillByID failed on CONCENTRATION — JSON became invalid.");
        return;
    }	
	jDevil = json_AdjustCreatureSkillByID(jDevil, SKILL_BLUFF, nCasterLvl/2);
	if (jDevil == JSON_NULL)
	{
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AdjustCreatureSkillByID failed on BLUFF — JSON became invalid.");
        return;
    }	
	jDevil = json_AdjustCreatureSkillByID(jDevil, SKILL_CLIMB, nCasterLvl/2);
	if (jDevil == JSON_NULL)
	{
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AdjustCreatureSkillByID failed on CLIMB — JSON became invalid.");
        return;
    }	
	jDevil = json_AdjustCreatureSkillByID(jDevil, SKILL_SPELLCRAFT, nCasterLvl/2);
	if (jDevil == JSON_NULL)
	{
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AdjustCreatureSkillByID failed on SPELLCRAFT — JSON became invalid.");
        return;
    }	
	jDevil = json_AdjustCreatureSkillByID(jDevil, SKILL_JUMP, nCasterLvl/2);
	if (jDevil == JSON_NULL)
	{
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AdjustCreatureSkillByID failed on JUMP — JSON became invalid.");
        return;
    }	
	jDevil = json_AdjustCreatureSkillByID(jDevil, SKILL_TUMBLE, nCasterLvl/4);
	if (jDevil == JSON_NULL)
	{
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AdjustCreatureSkillByID failed on TUMBLE — JSON became invalid.");
        return;
    }	
	jDevil = json_AdjustCreatureSkillByID(jDevil, SKILL_USE_MAGIC_DEVICE, nCasterLvl/4);
	if (jDevil == JSON_NULL)
	{
        SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AdjustCreatureSkillByID failed on UMD — JSON became invalid.");
        return;
    }
	
    //:: Size increase
    if (nCasterLvl > 14)
    {
        jDevil = json_AdjustCreatureSize(jDevil, 1);
        if (jDevil == JSON_NULL)
        {
			SendMessageToPC(oPC, "ss_ep_twinfiend >> json_AdjustCreatureSize failed - JSON became invalid.");
            return;
        }
    }	
	
	if (GetCanCastSpell(oPC, SPELL_EPIC_TWINF))
    {
	//:: Declare major variables
        float fDuration = TurnsToSeconds(nCasterLvl);
        object oFiend;
		object oFiend2;

        // effect eSummon;
        effect eVis = EffectVisualEffect(460);
        effect eVis2 = EffectVisualEffect(VFX_IMP_UNSUMMON);
		
		string sSummon = "twinfiend_demon";
		
		// Despawn existing Twinfiends
		object oArea = GetArea(oPC);
		object oObj  = GetFirstObjectInArea(oArea);

		while (GetIsObjectValid(oObj))
		{
			if (GetTag(oObj) == "TWINFIEND_DEMON")
			{
				if (GetLocalObject(oObj, "SUMMONER") == oPC)
				{
					DestroyObject(oObj);
				}
			}

			oObj = GetNextObjectInArea(oArea);
		}
		
		if(GetPRCSwitch(PRC_MULTISUMMON))
        {
            SpawnTwinFiend(oPC, jDevil, lTarget, fDuration);
			SpawnTwinFiend(oPC, jDevil, lTarget, fDuration);			
        }
        else
        {
			DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget));
            //oFiend = CreateObject(OBJECT_TYPE_CREATURE, "twinfiend_demon", PRCGetSpellTargetLocation());
			oFiend = JsonToObject(jDevil, lTarget);
			DelayCommand(0.0, AugmentSummonedCreature(sSummon));
			SetCurrentHitPoints(oFiend, GetMaxPossibleHP(oFiend));
			
			//:: Set faction to caster’s
			ChangeFaction(oFiend, oPC);
			SetLocalObject(oFiend, "SUMMONER", oPC);
			
			SetLocalNPC(oPC, oFiend, ASSOCIATE_TYPE_SUMMONED);
			SetAssociateState(NW_ASC_HAVE_MASTER, TRUE, oFiend);
			SetAssociateState(NW_ASC_DISTANCE_2_METERS);
			SetAssociateState(NW_ASC_DISTANCE_4_METERS, FALSE);
			SetAssociateState(NW_ASC_DISTANCE_6_METERS, FALSE);			
			
            //oFiend2 = CreateObject(OBJECT_TYPE_CREATURE, "twinfiend_demon", PRCGetSpellTargetLocation());
			oFiend2 = JsonToObject(jDevil, lTarget);
			DelayCommand(0.0, AugmentSummonedCreature(sSummon));
			SetCurrentHitPoints(oFiend2, GetMaxPossibleHP(oFiend2));
			
			//:: Set faction to caster’s
			ChangeFaction(oFiend2, oPC);
			SetLocalObject(oFiend2, "SUMMONER", oPC);

			SetLocalNPC(oPC, oFiend2, ASSOCIATE_TYPE_SUMMONED);
			SetAssociateState(NW_ASC_HAVE_MASTER, TRUE, oFiend2);
			SetAssociateState(NW_ASC_DISTANCE_2_METERS);
			SetAssociateState(NW_ASC_DISTANCE_4_METERS, FALSE);
			SetAssociateState(NW_ASC_DISTANCE_6_METERS, FALSE);			
			
            SetMaxHenchmen(GetMaxHenchmen() + 2);
            AddHenchman(oPC, oFiend);
            AddHenchman(oPC, oFiend2);
            SetMaxHenchmen(GetMaxHenchmen() - 2);
			
			//:: Update creature weapons for Size increase
			if (nCasterLvl > 14)
			{
				if(DEBUG) DoDebug("ss_ep_twinfiend >> Updating Creature weapons for size increase.");
									
				object oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oFiend);
				MyDestroyObject(oWeapCR);
				object oWeapCL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oFiend);
				MyDestroyObject(oWeapCL);
				object oWeapCB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oFiend);
				MyDestroyObject(oWeapCB);
				
				oWeapCR = CreateItemOnObject("nw_it_crewpsp010", oFiend);
				ForceEquip(oFiend, oWeapCR, INVENTORY_SLOT_CWEAPON_R);

				oWeapCL = CreateItemOnObject("bite_pitfiend002", oFiend);
				ForceEquip(oFiend, oWeapCL, INVENTORY_SLOT_CWEAPON_L);

				oWeapCB = CreateItemOnObject("prc_2d6_slamgrab", oFiend);
				ForceEquip(oFiend, oWeapCB, INVENTORY_SLOT_CWEAPON_B);

				oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oFiend2);
				MyDestroyObject(oWeapCR);
				oWeapCL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oFiend2);
				MyDestroyObject(oWeapCL);
				oWeapCB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oFiend2);
				MyDestroyObject(oWeapCB);
				
				oWeapCR = CreateItemOnObject("nw_it_crewpsp010", oFiend2);
				ForceEquip(oFiend2, oWeapCR, INVENTORY_SLOT_CWEAPON_R);

				oWeapCL = CreateItemOnObject("bite_pitfiend002", oFiend2);
				ForceEquip(oFiend2, oWeapCL, INVENTORY_SLOT_CWEAPON_L);

				oWeapCB = CreateItemOnObject("prc_2d6_slamgrab", oFiend2);
				ForceEquip(oFiend2, oWeapCB, INVENTORY_SLOT_CWEAPON_B);	

				SetObjectVisualTransform(oFiend, OBJECT_VISUAL_TRANSFORM_SCALE, 1.1);
				SetObjectVisualTransform(oFiend2, OBJECT_VISUAL_TRANSFORM_SCALE, 1.1);				
								
			}
			else DoDebug("ss_ep_twinfiend >> No size change detected.");
			
			AssignCommand(oFiend, DetermineCombatRound());
			AssignCommand(oFiend2, DetermineCombatRound());
			
			DestroyObject(oFiend, fDuration);
			DelayCommand(fDuration, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, GetLocation(oFiend)));
			DestroyObject(oFiend2, fDuration);
			DelayCommand(fDuration, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, GetLocation(oFiend2)));
		
        }
    }
	
    DeleteLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR");
}