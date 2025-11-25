//::////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//::////////////////////////////////////////////////////////
//:: FileName: "ss_ep_summonaber"
//:: Epic Spell: Summon Aberration
//:: Created By: Boneshank (Don Armstrong)
//:: Last Updated On: March 12, 2004
//:: Updated By: Jaysyn
//:: Updated on: 2025-11-21 19:40:26
//::
//::////////////////////////////////////////////////////////
/*
	School: Conjuration (Summoning)
	Components: V,S
	Range: Short
	Effect: Summons advanced aberration(s)
	Duration: 1 Turn / Caster level
	Saving Throw: None
	Spell Resistance: No

	You summon one or more advanced psuedonatural aberrations
	from the Far Realms to do your bidding. The aberration 
	receives one bonus hit die for every 2 caster levels of 
	the summoner, up to the maximum hit dice for the creature, 
	and maximum hit points per die. The aberration follows 
	your orders to the best of its ability, for the duration
	of the spell.
	
*/
//::////////////////////////////////////////////////////////
#include "prc_inc_json"
#include "prc_alterations"
#include "inc_epicspells"
#include "nw_i0_generic"
#include "inc_ecl"



void SpawnIntDevourer(object oCaster, json jAberration, location lTarget, float fDuration, string sNewName = "")
{
	MultisummonPreSummon();
	
	object oAberration = JsonToObject(jAberration, lTarget);
	
	int nHD = GetHitDice(oAberration);
	
	SetLocalInt(oAberration, "PRC_CASTERLEVEL_OVERRIDE", nHD);
	
	int nCasterLvl = GetTotalCastingLevel(oCaster);
	
	if (!GetIsObjectValid(oAberration))
	{
		DoDebug("ss_ep_summonaber | SpawnIntDevourer() >> oAberration not passed to function.");
		return;
	}
	
	string sSummon = "ep_sum_aberrat05";
	
	//:: effect eSummon;
	effect eSummon = EffectSummonCreature("", VFX_FNF_SUMMON_EPIC_UNDEAD, 0.0, 0, VFX_IMP_UNSUMMON, oAberration);
	
	//:: Set faction to caster’s
	ChangeFaction(oAberration, oCaster);
	SetLocalObject(oAberration, "SUMMONER", oCaster);
	
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);
	
	if (!GetIsObjectValid(oAberration))
	{
		DoDebug("ss_ep_summonaber | SpawnIntDevourer() >> JsonToObject failed - could not create creature from edited template.");
		return;
	}	

	AugmentSummonedCreature(sSummon);
	
	ApplyPseudonaturalEffects(oAberration);

	SetObjectVisualTransform(oAberration, OBJECT_VISUAL_TRANSFORM_SCALE, 3.5f);	
	
	SetName(oAberration, sNewName);
}


void main()
{
    if (!X2PreSpellCastCode()) return;
	
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	
	object oCaster = OBJECT_SELF;
	
	int nCasterLvl = GetTotalCastingLevel(oCaster);
	
	int nBonusHD	= nCasterLvl/2;
	int iMinHD;
	int iMaxHD;
	string sNewName;
	
	float fDuration = TurnsToSeconds(nCasterLvl);
	
	effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
	effect eVis2 = EffectVisualEffect(VFX_IMP_UNSUMMON);
	
	//:: Target location
    location lTarget = PRCGetSpellTargetLocation();
    
    if(GetCanCastSpell(oCaster, SPELL_EPIC_SUMABER))
    {
        string sSummon;
		switch(d10())
        {
            case  1:
            case  2:
            case  3:
			{	//:: Summoned Illithid		
				sSummon = "ep_sum_aberrat01"; 	
				sNewName = "Summoned Psuedonatural Illithid";
				break;
			}
            case  4:
            case  5:
            case  6:
			{	//:: Summoned Drider
				sSummon = "ep_sum_aberrat02"; 
				sNewName = "Summoned Psuedonatural Drider";
				break;	
			}
            case  7:
            case  8:
			{	//:: Summoned Beholder
				sSummon = "ep_sum_aberrat03";
				sNewName = "Summoned Psuedonatural Beholder";
				break;	
			}
            case  9:
			{	//:: Summoned Umber Hulk
				sSummon = "ep_sum_aberrat04";
				sNewName = "Summoned Psuedonatural Umberhulk";				
				break;	
			}
            case 10:
			{	//:: Summoned Battle Devourer
				sSummon = "ep_sum_aberrat05";
				sNewName = "Summoned Psuedonatural Battle Devourer";				
				break;	
			}
        }		
		
		//:: Summoned Illithid and Drider have class levels & only get a partial json treatment.
		if(sSummon == "ep_sum_aberrat01" || sSummon == "ep_sum_aberrat02")
		{

			//:: Create the creature
			object oAberration = MakePsuedonaturalCreatureFromTemplate(sSummon, lTarget);

			effect eSummon = ExtraordinaryEffect(EffectSummonCreature("", VFX_FNF_SUMMON_EPIC_UNDEAD, 0.0, 0, VFX_IMP_UNSUMMON, oAberration));
			//Apply the summon visual and summon the aberration.
			MultisummonPreSummon();
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);

			int nOriginalHD 	= GetLocalInt(oAberration, "nOriginalHD");
			int iTargetLvl 		= (nCasterLvl/2) + nOriginalHD;			
			int iMinHD 			= GetLocalInt(oAberration, "iMinHD");
			int iMaxHD 			= GetLocalInt(oAberration, "iMaxHD");
			int iClass2			= GetLocalInt(oAberration, "Class2");
			int iClass2Package	= GetLocalInt(oAberration, "Class2Package");
			int iClass2Start	= GetLocalInt(oAberration, "Class2Start");
			int iMagicUse		= GetLocalInt(oAberration, "X2_L_BEH_MAGIC");
			string sAI			= GetLocalString(oAberration, "X2_SPECIAL_COMBAT_AI_SCRIPT");
			
			if (DEBUG) DoDebug("ss_ep_summonaber >> iMinHD = " +IntToString(iMinHD)+".");
			if (DEBUG) DoDebug("ss_ep_summonaber >> iMaxHD = " +IntToString(iMaxHD)+".");			
			
			//check the ranges so we dont go above max, or below min.
			if(iTargetLvl < iMinHD) iTargetLvl = iMinHD;
			if(iTargetLvl > iMaxHD) iTargetLvl = iMaxHD;	
	
			if (DEBUG) DoDebug("ss_ep_summonaber >> iTargetLvl = " +IntToString(iTargetLvl)+".");			
			
			//:: Set faction to caster’s
			ChangeFaction(oAberration, oCaster);
			SetLocalObject(oAberration, "SUMMONER", oCaster);			

			SetLocalInt(oAberration, "PRC_CASTERLEVEL_OVERRIDE", iTargetLvl);	

			//:: Fires LevelUpSummon for scaling summons using LevelUpHenchman
			LevelUpSummon(oAberration, iTargetLvl);	
			
			DelayCommand(0.5, AugmentSummonedCreature(sSummon));

			//:: Apply effects
			ApplyPseudonaturalEffects(oAberration);		
			
			return;			
		}

		//:: Other Summons are advanced via direct json editing			
		//:: Load template
		json jAberration = TemplateToJson(sSummon, RESTYPE_UTC);
		if (jAberration == JSON_NULL)
		{
			DoDebug("ss_ep_summonaber >> TemplateToJson failed — bad resref or resource missing.");
			return;
		}	
		
		//:: Read HD range from JSON template
		int iMinHD = json_GetLocalIntFromVarTable(jAberration, "iMinHD");
		int iMaxHD = json_GetLocalIntFromVarTable(jAberration, "iMaxHD");
		
		//:: Original HD
		int nOriginalHD = json_GetLocalIntFromVarTable(jAberration, "nOriginalHD");
		int nOffsetHD = json_GetLocalIntFromVarTable(jAberration, "nOffsetHD");
		if (DEBUG) DoDebug("ss_ep_summonaber >> nOffsetHD = " +IntToString(nOffsetHD)+".");
		
		if (nOriginalHD < 1)
		{
			nOriginalHD = json_GetCreatureHD(jAberration);
		}		
		
		if (DEBUG) DoDebug("ss_ep_summonaber >> nOriginalHD = " +IntToString(nOriginalHD)+".");
		
		if (nOriginalHD <= 0)
		{
			DoDebug("ss_ep_summonaber >> json_GetCreatureHD failed — template missing HD data.");
			return;
		}

		float fOriginalCR = json_GetChallengeRating(jAberration);
		if (fOriginalCR <= 0.0)
		{
			DoDebug("ss_ep_summonaber >> json_GetChallengeRating failed — template missing CR data.");
			return;
		}	

		if (DEBUG) DoDebug("ss_ep_summonaber >> iMinHD = " +IntToString(iMinHD)+".");
		if (DEBUG) DoDebug("ss_ep_summonaber >> iMaxHD = " +IntToString(iMaxHD)+".");
		
		//:: Determine target total HD based on caster level bonuses and offset
		int nTargetHD = nOriginalHD + nOffsetHD + (nCasterLvl / 2);


		//:: Clamp to the template's defined range
		if (nTargetHD < iMinHD) nTargetHD = iMinHD;
		if (nTargetHD > iMaxHD) nTargetHD = iMaxHD;


		//:: Calculate how many HD need to be added to reach that target
		nBonusHD = nTargetHD - (nOriginalHD + nOffsetHD);

		if (DEBUG)
		{
			DoDebug("ss_ep_summonaber >> nOffsetHD = " + IntToString(nOffsetHD));
			DoDebug("ss_ep_summonaber >> nTargetHD = " + IntToString(nTargetHD));
			DoDebug("ss_ep_summonaber >> nBonusHD (to add) = " + IntToString(nBonusHD));
		}
		
		if (DEBUG) DoDebug("ss_ep_summonaber >> nBonusHD = " +IntToString(nBonusHD)+".");		
		
		//:: Stat boost calc
		int nStatBoost = GetStatBoostsFromHD(nOriginalHD, nBonusHD);
		
		//:: Add Hit Dice
		jAberration = json_AddHitDice(jAberration, nBonusHD);
		if (jAberration == JSON_NULL)
		{
			DoDebug("ss_ep_summonaber >> json_AddHitDice failed - JSON became invalid.");
			return;
		}
		//:: Update feats
		jAberration = json_AddFeatsFromCreatureVars(jAberration, nOriginalHD+nOffsetHD);
		if (jAberration == JSON_NULL)
		{
			DoDebug("ss_ep_summonaber >> json_AddFeatsFromCreatureVars failed — JSON became invalid.");
			return;
		}
		//:: Update stats
		jAberration = json_ApplyAbilityBoostFromHD(jAberration, nOriginalHD+nOffsetHD);
		if (jAberration == JSON_NULL)
		{
			DoDebug("ss_ep_summonaber >> json_ApplyAbilityBoostFromHD failed — JSON became invalid.");
			return;
		}		
		//:: Modify racial type for Psuedonatural template
		jAberration = json_ModifyRacialType(jAberration, RACIAL_TYPE_OUTSIDER);
		if (jAberration == JSON_NULL)
		{
			DoDebug("ss_ep_summonaber >> json_ModifyRacialType failed — JSON became invalid.");
			return;
		}	
		//:: Add True Strike 1x / day for Psuedonatural template
		jAberration =  json_AddPsuedonaturalPowers(jAberration);
		if (jAberration == JSON_NULL)
		{
			DoDebug("ss_ep_summonaber >> json_AddPsuedonaturalPowers failed — JSON became invalid.");
			return;
		}			
		//:: Update CR for Psuedonatural template
		jAberration =  json_UpdatePsuedonaturalCR(jAberration, FloatToInt(fOriginalCR), json_GetCreatureHD(jAberration));
		if (jAberration == JSON_NULL)
		{
			DoDebug("ss_ep_summonaber >> json_UpdatePsuedonaturalCR failed — JSON became invalid.");
			return;
		}

		//:: Beholder get 5 skills per HD
		if(sSummon == "ep_sum_aberrat03")
		{
			jAberration = json_AdjustCreatureSkillByID(jAberration, SKILL_SPOT, nTargetHD);	
			jAberration = json_AdjustCreatureSkillByID(jAberration, SKILL_LORE, nTargetHD);
			jAberration = json_AdjustCreatureSkillByID(jAberration, SKILL_LISTEN, nTargetHD);	
			jAberration = json_AdjustCreatureSkillByID(jAberration, SKILL_SEARCH, nTargetHD);	
			jAberration = json_AdjustCreatureSkillByID(jAberration, SKILL_HIDE, nTargetHD);	
		}
		else //:: Umber Hulk & Battle Devourer get 2 skills per HD
		{
			jAberration = json_AdjustCreatureSkillByID(jAberration, SKILL_SPOT, nTargetHD);		
			jAberration = json_AdjustCreatureSkillByID(jAberration, SKILL_LISTEN, nTargetHD);	
		}	
		if (jAberration == JSON_NULL)
		{
			DoDebug("ss_ep_summonaber >> json_AdjustCreatureSkillByID failed — JSON became invalid.");
			return;
		}
		
		//:: Beholder and Umber Hulk spawn singlely
		if(sSummon == "ep_sum_aberrat03" || sSummon == "ep_sum_aberrat04")
		{			
			MultisummonPreSummon();			
			object oAberration = JsonToObject(jAberration, lTarget);
				effect eSummon = ExtraordinaryEffect(EffectSummonCreature("", VFX_FNF_SUMMON_EPIC_UNDEAD, 0.0, 0, VFX_IMP_UNSUMMON, oAberration));	

			//:: Apply the summon visual and summon the aberration.
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);
			
			if (!GetIsObjectValid(oAberration))
			{
				DoDebug("ss_ep_summonaber >> JsonToObject failed - could not create creature from edited template.");
				return;
			}
			
			ApplyPseudonaturalEffects(oAberration);
		}			
		//:: Summoned Battle Devourer spawns multiple creatures
		else 
		{
			if(GetPRCSwitch(PRC_MULTISUMMON))
			{
				//:: number of summons: 1d2+1
				int nCount = d2() + 1;

				int i = 0;
				while(i < nCount)
				{
					SpawnIntDevourer(oCaster, jAberration, lTarget, fDuration, sNewName);
					i = i + 1;
				}
				return;
			}
			else
			{
				//:: number of summons: 1d2+1
				int nCount = d2() + 1;
				
				int i = 0;
				while(i < nCount)
				{
					object oAberration = JsonToObject(jAberration, lTarget);
					
					//:: Visual
					DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget));

					//:: Augment Summoning
					DelayCommand(0.5, AugmentSummonedCreature(sSummon));

					//:: Set HP
					//SetCurrentHitPoints(oAberration, GetMaxPossibleHP(oAberration));

					//:: Associate with caster
					SetLocalNPC(oCaster, oAberration, ASSOCIATE_TYPE_SUMMONED);
					SetAssociateState(NW_ASC_HAVE_MASTER, TRUE, oAberration);
					SetAssociateState(NW_ASC_DISTANCE_2_METERS);
					SetAssociateState(NW_ASC_DISTANCE_4_METERS, FALSE);
					SetAssociateState(NW_ASC_DISTANCE_6_METERS, FALSE);

					//:: Temporarily bump henchman limit so AddHenchman works
					SetMaxHenchmen(GetMaxHenchmen() + nCount);
					AddHenchman(oCaster, oAberration);
					SetMaxHenchmen(GetMaxHenchmen() - nCount);

					//:: Start combat AI
					AssignCommand(oAberration, DetermineCombatRound());

					//:: Schedule destruction + end-visual
					DestroyObject(oAberration, fDuration);				
					DelayCommand(fDuration, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, lTarget));
					
					SetObjectVisualTransform(oAberration, OBJECT_VISUAL_TRANSFORM_SCALE, 3.5f);
					
					//:: Set faction to caster’s
					ChangeFaction(oAberration, oCaster);
					SetLocalObject(oAberration, "SUMMONER", oCaster);			
					
					SetLocalInt(oAberration, "PRC_CASTERLEVEL_OVERRIDE", nOriginalHD + nBonusHD);
					
					SetLocalInt(oAberration, "MySummonerCL", nBonusHD);	
					
					ApplyPseudonaturalEffects(oAberration);

					SetName(oAberration, sNewName);					
					
					i = i + 1;
				}
			}				
		}	
	
		PRCSetSchool();
	}
}