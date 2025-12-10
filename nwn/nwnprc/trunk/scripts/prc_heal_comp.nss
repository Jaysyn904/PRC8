/*
Type of Feat: Class
Prerequisite: Healer 8
Specifics: Gain a companion
Use: Selected.
*/

void SummonCelestialCompanion(object oPC, string sResRef, int nHD, int nHealerLvl, location lTarget, float fDuration);

const int HEALER_COMP_UNICORN = 1845;
const int HEALER_COMP_LAMMASU = 1846;
const int HEALER_COMP_ANDRO   = 1847;

#include "prc_inc_assoc"
#include "prc_inc_json"

void main()
{
    object oCaster = OBJECT_SELF;
    object oComp = GetAssociateNPC(ASSOCIATE_TYPE_CELESTIALCOMPANION, oCaster);
    int nSpellId = GetSpellId();
    int nHealerLvl = GetLevelByClass(CLASS_TYPE_HEALER, oCaster);
	
	float fDuration = HoursToSeconds(nHealerLvl*2);

    if((HEALER_COMP_LAMMASU == nSpellId && nHealerLvl < 12) || (HEALER_COMP_ANDRO == nSpellId && nHealerLvl < 16))
    {
        FloatingTextStringOnCreature("You are too low level to summon this companion", oCaster, FALSE);
        IncrementRemainingFeatUses(oCaster, FEAT_CELESTIAL_COMPANION);
        return;
    }

    vector vloc = GetPositionFromLocation(GetLocation(oCaster));
    vector vLoc = Vector( vloc.x + (Random(6) - 2.5f), vloc.y + (Random(6) - 2.5f), vloc.z );
    location lTarget = Location(GetArea(oCaster), vLoc, IntToFloat(Random(361) - 180));

    string sSummon;
	string sNewName;
    int nHD;
	
    if(HEALER_COMP_UNICORN == nSpellId)
    {
		sSummon = "prc_sum_unicrn01";
        nHD = 4;
    }
    else if(HEALER_COMP_LAMMASU == nSpellId)
    {
        sSummon = "prc_sum_lamasu01";
        nHD = 7;
    }
    else if(HEALER_COMP_ANDRO == nSpellId)
    {
        sSummon = "prc_sum_andro01";
        nHD = 12;
    }

	//remove previously summoned companion
    if(GetIsObjectValid(oComp))
        DestroyAssociate(oComp);
	
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_CELESTIAL);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
    DelayCommand(2.0f, SummonCelestialCompanion(oCaster, sSummon, nHD, nHealerLvl, lTarget, fDuration));
}

void SummonCelestialCompanion(object oPC, string sResRef, int nHD, int nHealerLvl, location lTarget, float fDuration)
{
	// Calculate effective level based on companion type
    int nEffectiveLevel = nHealerLvl;
    if(sResRef == "prc_sum_lamasu01")
        nEffectiveLevel -= 4;
    else if(sResRef == "prc_sum_andro01")
        nEffectiveLevel -= 8;
		
	string sNewName;
	object oCelestial;
	int iTargetLvl = 0;
	int iBaseCL = 0;
	
	int bMove, bSR, bSave;

	if (nEffectiveLevel >= 18)
	{
		bSave   = TRUE;
		bSR		= TRUE;
		bMove   = TRUE;
	}
	else if(nEffectiveLevel >= 15)
	{
		bSave   = TRUE;
	}	

	if(sResRef == "prc_sum_unicrn01")
    {
		sNewName = "Celestial Unicorn Companion";
		
		oCelestial 			= MakeCelestialCompanionFromTemplate(sResRef, lTarget, nEffectiveLevel);
		int nOriginalHD 	= GetLocalInt(oCelestial, "nOriginalHD");
		int nBonus 			= GetHealerCompanionBonus(nEffectiveLevel);
		if (nBonus < 1) nBonus = 0;
		
		iTargetLvl			= nBonus + nOriginalHD;
		int iMinHD 			= GetLocalInt(oCelestial, "iMinHD");
		int iMaxHD 			= GetLocalInt(oCelestial, "iMaxHD");
		int iClass2			= GetLocalInt(oCelestial, "Class2");
		int iClass2Package	= GetLocalInt(oCelestial, "Class2Package");
		int iClass2Start	= GetLocalInt(oCelestial, "Class2Start");
		int iBaseCL			= GetLocalInt(oCelestial, "iBaseCL");
		int iMagicUse		= GetLocalInt(oCelestial, "X2_L_BEH_MAGIC");
		string sAI			= GetLocalString(oCelestial, "X2_SPECIAL_COMBAT_AI_SCRIPT");
				
		if (DEBUG) DoDebug("prc_heal_comp >> SummonCelestialCompanion: iMinHD = " +IntToString(iMinHD)+".");
		if (DEBUG) DoDebug("prc_heal_comp >> SummonCelestialCompanion: iMaxHD = " +IntToString(iMaxHD)+".");

		//check the ranges so we dont go above max, or below min.
		if(iTargetLvl < iMinHD) iTargetLvl = iMinHD;
		if(iTargetLvl > iMaxHD) iTargetLvl = iMaxHD;

		if (DEBUG) DoDebug("prc_heal_comp >> SummonCelestialCompanion: iTargetLvl = " +IntToString(iTargetLvl)+".");			
		effect eSummon = ExtraordinaryEffect(EffectSummonCreature("", VFX_FNF_SUMMON_CELESTIAL, 0.0, 0, VFX_IMP_UNSUMMON, oCelestial));
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);
		
		//:: Fires LevelUpSummon for scaling summons using LevelUpHenchman
		LevelUpSummon(oCelestial, iTargetLvl);
		SetObjectVisualTransform(oCelestial, OBJECT_VISUAL_TRANSFORM_SCALE, 1.4);
		
/* 		effect eUniboost = EffectACIncrease(nBonus, AC_NATURAL_BONUS);
		
		eUniboost = EffectLinkEffects(eUniboost, EffectAbilityIncrease(ABILITY_STRENGTH,     nBonus));
        eUniboost = EffectLinkEffects(eUniboost, EffectAbilityIncrease(ABILITY_DEXTERITY,    nBonus));
        eUniboost = EffectLinkEffects(eUniboost, EffectAbilityIncrease(ABILITY_INTELLIGENCE, nBonus));

		eUniboost = UnyieldingEffect(eUniboost);

		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUniboost, oCelestial); */		
		
		SetCurrentHitPoints(oCelestial, GetMaxPossibleHP(oCelestial));			
		
	}
	else
	{
		if(sResRef == "prc_sum_lamasu01")
		{
			sNewName = "Celestial Lammasu Companion";
		}
		else if(sResRef == "prc_sum_andro01")
		{
			sNewName = "Celestial Androsphinx Companion";
		}
		
		json jCelestial = TemplateToJson(sResRef, RESTYPE_UTC);  
		if (jCelestial == JSON_NULL)  
		{  
			DoDebug("prc_heal_comp >> TemplateToJson failed — bad resref or resource missing.");  
			return;  
		}  

		//:: Get local vars to transfer over.  
		int iMinHD 			= json_GetLocalIntFromVarTable(jCelestial, "iMinHD");  
		int iMaxHD 			= json_GetLocalIntFromVarTable(jCelestial, "iMaxHD");  
		int nOriginalHD 	= json_GetLocalIntFromVarTable(jCelestial, "nOriginalHD");  
		int iClass2			= json_GetLocalIntFromVarTable(jCelestial, "Class2");  
		int iClass2Package	= json_GetLocalIntFromVarTable(jCelestial, "Class2Package");  
		int iClass2Start	= json_GetLocalIntFromVarTable(jCelestial, "Class2Start"); 
		int iBaseCL			= json_GetLocalIntFromVarTable(jCelestial, "iBaseCL");	
		int iMagicUse		= json_GetLocalIntFromVarTable(jCelestial, "X2_L_BEH_MAGIC");  
		string sAI			= json_GetLocalStringFromVarTable(jCelestial, "X2_SPECIAL_COMBAT_AI_SCRIPT"); 

		if (DEBUG) DoDebug("prc_heal_comp >> SummonCelestialCompanion: iMinHD = " +IntToString(iMinHD)+".");
		if (DEBUG) DoDebug("prc_heal_comp >> SummonCelestialCompanion: iMaxHD = " +IntToString(iMaxHD)+".");

		int nBonus = GetHealerCompanionBonus(nEffectiveLevel);
		if (nBonus < 1) nBonus = 0;	

		// json_AddHitDice ADDS to existing HD, so only pass the bonus
		iTargetLvl = nBonus;

		// Range check should be on total HD (base + bonus), not just bonus
		int nTotalHD = nBonus + nOriginalHD;

		if(nTotalHD < iMinHD)
		{
			iTargetLvl = iMinHD - nOriginalHD;
			if(iTargetLvl < 0) iTargetLvl = 0;
		}
		if(nTotalHD > iMaxHD) 
		{
			iTargetLvl = iMaxHD - nOriginalHD;
		}
		
		//:: Stat boost calc
		int nStatBoost = GetStatBoostsFromHD(nOriginalHD, nBonus);
		
		//:: Get current HD  
		int nCurrentHD = json_GetCreatureHD(jCelestial);  
		if (nCurrentHD <= 0)  
		{  
			DoDebug("prc_heal_comp >> json_GetCreatureHD failed — template missing HD data.");  
			return;  
		}		  
		//:: Get current CR  
		int nBaseCR = 1;  
		nBaseCR = FloatToInt(json_GetChallengeRating(jCelestial));  
		if (nBaseCR <= 0)  
		{  
			DoDebug("prc_heal_comp >> json_GetChallengeRating failed — template missing CR data.");  
			return;  
		}	
		//:: Add Hit Dice
		jCelestial = json_AddHitDice(jCelestial, iTargetLvl);
		if (jCelestial == JSON_NULL)
		{
			SendMessageToPC(oPC, "prc_heal_comp >> json_AddHitDice failed - json became invalid.");
			return;
		}		
		//:: Recalculate & maximize HP
		nCurrentHD = json_GetCreatureHD(jCelestial);
		if (nCurrentHD <= 0)
		{
			SendMessageToPC(oPC, "prc_heal_comp >> json_GetCreatureHD failed — template missing HD data.");
			return;
		}		
		
		if(DEBUG) DoDebug("prc_heal_comp >>  nCurrentHD is: "+IntToString(nCurrentHD)+ " entering json_RecalcMaxHP.");
		jCelestial = json_RecalcMaxHP(jCelestial, 8);	
		if (jCelestial == JSON_NULL)
		{
			SendMessageToPC(oPC, "prc_heal_comp >>  json_RecalcMaxHP failed - JSON became invalid.");
			return;
		}			
		//:: Update CR
		jCelestial = json_UpdateCelestialCR(jCelestial, nBaseCR, nCurrentHD);
		if (jCelestial == JSON_NULL) 
		{  
			DoDebug("prc_heal_comp >> json_UpdateCelestialCR failed — json became invalid.");  
			return;  
		}
			  
		//:: Apply celestial template modifications  
		jCelestial = json_MakeCelestial(jCelestial, nCurrentHD, nBaseCR);  
		if (jCelestial == JSON_NULL)  
		{  
			DoDebug("prc_heal_comp >> MakeCelestialCreatureFromTemplate failed — MakeCelestial returned invalid JSON.");  
			return;  
		}		
		//:: Update feats from bonus HD
		jCelestial = json_AddFeatsFromCreatureVars(jCelestial, nOriginalHD);
		if (jCelestial == JSON_NULL)
		{
			SendMessageToPC(oPC, "prc_heal_comp >> json_AddFeatsFromCreatureVars failed — JSON became invalid.");
			return;
		}		
		//:: Update stats for Bonus HD
		jCelestial = json_ApplyAbilityBoostFromHD(jCelestial, nOriginalHD);
		if (jCelestial == JSON_NULL)
		{
			SendMessageToPC(oPC, "prc_heal_comp >> json_ApplyAbilityBoostFromHD failed — JSON became invalid.");
			return;
		}	
		//:: Bonus stats for Healer Level
		jCelestial = json_UpdateTemplateStats(jCelestial, nBonus, nBonus, 0, nBonus, 0, 0);
		if (jCelestial == JSON_NULL)
		{
			SendMessageToPC(oPC, "prc_heal_comp >> json_UpdateTemplateStats failed — JSON became invalid.");
			return;
		}
		//:: Apply +2 Natural AC bonus per 3 Healer levels	    
		jCelestial = json_IncreaseBaseAC(jCelestial, nBonus);		
		if (jCelestial == JSON_NULL)
		{
			SendMessageToPC(oPC, "prc_heal_comp >> json_IncreaseBaseAC failed — JSON became invalid.");
			return;
		}
		if(sResRef == "prc_sum_lamasu01")
		{	
			//:: Lammasu w/ 16 INT gets 5 (2+3) skill points per HD
			jCelestial = json_AdjustCreatureSkillByID(jCelestial, SKILL_CONCENTRATION, iTargetLvl);
			if (jCelestial == JSON_NULL)
			{
				SendMessageToPC(oPC, "prc_heal_comp >> json_AdjustCreatureSkillByID failed on CONCENTRATION — JSON became invalid.");
				return;
			}			
			jCelestial = json_AdjustCreatureSkillByID(jCelestial, SKILL_LISTEN, iTargetLvl);
			if (jCelestial == JSON_NULL)
			{
				SendMessageToPC(oPC, "prc_heal_comp >> json_AdjustCreatureSkillByID failed on LISTEN — JSON became invalid.");
				return;
			}
			jCelestial = json_AdjustCreatureSkillByID(jCelestial, SKILL_LORE, iTargetLvl);
			if (jCelestial == JSON_NULL)
			{
				SendMessageToPC(oPC, "prc_heal_comp >> json_AdjustCreatureSkillByID failed on LORE — JSON became invalid.");
				return;
			}			
			jCelestial = json_AdjustCreatureSkillByID(jCelestial, SKILL_SPOT, iTargetLvl);
			if (jCelestial == JSON_NULL)
			{
				SendMessageToPC(oPC, "prc_heal_comp >> json_AdjustCreatureSkillByID failed on SPOT — JSON became invalid.");
				return;
			}			
			jCelestial = json_AdjustCreatureSkillByID(jCelestial, SKILL_SENSE_MOTIVE, iTargetLvl);
			if (jCelestial == JSON_NULL)
			{
				SendMessageToPC(oPC, "prc_heal_comp >> json_AdjustCreatureSkillByID failed on SENSE MOTIVE — JSON became invalid.");
				return;
			}			
			//:: Lammasu size increases to huge @ 11 HD / 20 Healer levels
			if (nHealerLvl >= 20)
			{
				jCelestial = json_AdjustCreatureSize(jCelestial, 1);
				if (jCelestial == JSON_NULL)
				{
					SendMessageToPC(oPC, "prc_heal_comp >> json_AdjustCreatureSize failed - JSON became invalid.");
					return;
				}		
			}
		}
		
		if (sResRef == "prc_sum_andro01")
		{
			//:: Androsphinx w/ 16 INT gets 5 (2+3) skill points per HD
			jCelestial = json_AdjustCreatureSkillByID(jCelestial, SKILL_INTIMIDATE, iTargetLvl);
			if (jCelestial == JSON_NULL)
			{
				SendMessageToPC(oPC, "prc_heal_comp >> json_AdjustCreatureSkillByID failed on INTIMIDATE — JSON became invalid.");
				return;
			}			
			jCelestial = json_AdjustCreatureSkillByID(jCelestial, SKILL_LISTEN, iTargetLvl);
			if (jCelestial == JSON_NULL)
			{
				SendMessageToPC(oPC, "prc_heal_comp >> json_AdjustCreatureSkillByID failed on LISTEN — JSON became invalid.");
				return;
			}
			jCelestial = json_AdjustCreatureSkillByID(jCelestial, SKILL_LORE, iTargetLvl);
			if (jCelestial == JSON_NULL)
			{
				SendMessageToPC(oPC, "prc_heal_comp >> json_AdjustCreatureSkillByID failed on LORE — JSON became invalid.");
				return;
			}			
			jCelestial = json_AdjustCreatureSkillByID(jCelestial, SKILL_SPOT, iTargetLvl);
			if (jCelestial == JSON_NULL)
			{
				SendMessageToPC(oPC, "prc_heal_comp >> json_AdjustCreatureSkillByID failed on SPOT — JSON became invalid.");
				return;
			}			
			jCelestial = json_AdjustCreatureSkillByID(jCelestial, SKILL_SENSE_MOTIVE, iTargetLvl);
			if (jCelestial == JSON_NULL)
			{
				SendMessageToPC(oPC, "prc_heal_comp >> json_AdjustCreatureSkillByID failed on SENSE MOTIVE — JSON became invalid.");
				return;
			}

			//:: Androsphinx size increases to huge @ 19 HD / 29 Healer levels
			if (nHealerLvl >= 29)
			{
				jCelestial = json_AdjustCreatureSize(jCelestial, 1);
				if (jCelestial == JSON_NULL)
				{
					SendMessageToPC(oPC, "prc_heal_comp >> json_AdjustCreatureSize failed - JSON became invalid.");
					return;
				}
		
			}			
		}
		  
		//:: Spawn the creature  
		oCelestial 	= JsonToObject(jCelestial, lTarget);  
		  
		//:: Set variables	  
		SetLocalInt(oCelestial, "TEMPLATE_CELESTIAL", 1);	  
		SetLocalInt(oCelestial, "iMinHD", iMinHD);		  
		SetLocalInt(oCelestial, "iMaxHD", iMaxHD);  
		SetLocalInt(oCelestial, "nOriginalHD", nOriginalHD);	  
		SetLocalInt(oCelestial, "Class2", iClass2);  
		SetLocalInt(oCelestial, "Class2Package", iClass2Package);  
		SetLocalInt(oCelestial, "Class2Start", iClass2Start);  
		SetLocalInt(oCelestial, "iBaseCL", iBaseCL); 	
		SetLocalInt(oCelestial, "X2_L_BEH_MAGIC", iMagicUse);  
		SetLocalString(oCelestial, "X2_SPECIAL_COMBAT_AI_SCRIPT", sAI);
		
		effect eSummon = ExtraordinaryEffect(EffectSummonCreature("", VFX_FNF_SUMMON_CELESTIAL, 0.0, 0, VFX_IMP_UNSUMMON, oCelestial));
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);
		
		if (sResRef == "prc_sum_lamasu01")
		{
			if (nHealerLvl >= 20)
			{
				//:: Update creature weapons for Size increase
				if(DEBUG) DoDebug("prc_heal_comp: Updating Lammasu creature weapons for size increase.");

				object oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCelestial);
				MyDestroyObject(oWeapCR);
				object oWeapCL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCelestial);
				MyDestroyObject(oWeapCL);
				
				oWeapCR = CreateItemOnObject("nw_it_crewpsp010", oCelestial);
				ForceEquip(oCelestial, oWeapCR, INVENTORY_SLOT_CWEAPON_R);

				oWeapCL = CreateItemOnObject("nw_it_crewpsp010", oCelestial);
				ForceEquip(oCelestial, oWeapCL, INVENTORY_SLOT_CWEAPON_L);

				SetObjectVisualTransform(oCelestial, OBJECT_VISUAL_TRANSFORM_SCALE, 1.4);
		
			}
			else
			{
				SetObjectVisualTransform(oCelestial, OBJECT_VISUAL_TRANSFORM_SCALE, 1.2);
			}
		}		
		if (sResRef == "prc_sum_andro01")
		{
			if (nHealerLvl >= 29)
			{
				//:: Update creature weapons for Size increase
				if(DEBUG) DoDebug("prc_heal_comp: Updating Androsphinx creature weapons for size increase.");
				
				object oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCelestial);
				MyDestroyObject(oWeapCR);
				object oWeapCL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCelestial);
				MyDestroyObject(oWeapCL);
				
				oWeapCR = CreateItemOnObject("nw_it_crewpsp015", oCelestial);
				ForceEquip(oCelestial, oWeapCR, INVENTORY_SLOT_CWEAPON_R);

				oWeapCL = CreateItemOnObject("nw_it_crewpsp015", oCelestial);
				ForceEquip(oCelestial, oWeapCL, INVENTORY_SLOT_CWEAPON_L);
				
				SetObjectVisualTransform(oCelestial, OBJECT_VISUAL_TRANSFORM_SCALE, 1.3);
			}
			else
			{
				SetObjectVisualTransform(oCelestial, OBJECT_VISUAL_TRANSFORM_SCALE, 1.1);
			}
		}	
		
	}			
	SetCurrentHitPoints(oCelestial, GetMaxPossibleHP(oCelestial));		
	
	SetLocalNPC(oPC, oCelestial, ASSOCIATE_TYPE_CELESTIALCOMPANION, 1);
	SetTag(oCelestial, "prc_heal_comp");
	SetLocalObject(oCelestial, "MASTER", oPC);
	
	AddAssociate(oPC, oCelestial);
	SetLocalObject(oPC, "HealerCompanion", oCelestial);
	SetLocalInt(oCelestial, "X2_JUST_A_DISABLEEQUIP", TRUE);	
	
	effect eBonus = CelestialTemplateEffects(iTargetLvl);

	//:: Spell Resistance equal to Healer's class + 5, or retain existing SR if higher
	int iExSR = GetSpellResistance(oCelestial);
	int nSpellResistance;

	if (iExSR < nHealerLvl + 5) nSpellResistance = nHealerLvl + 5;

	else nSpellResistance = 0;

	SetName(oCelestial, sNewName);

    if (nHealerLvl >= 18)
    {
        bSave   = TRUE;
        bSR		= TRUE;
        bMove   = TRUE;
    }
    else if(nHealerLvl >= 15)
    {
        bSave   = TRUE;
    }
	
	SetLocalInt(oCelestial, PRC_CASTERLEVEL_OVERRIDE, iTargetLvl + iBaseCL);
	
    if(bSave) eBonus = EffectLinkEffects(eBonus, EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_MIND_SPELLS));
    if(bSR)   eBonus = EffectLinkEffects(eBonus, EffectSpellResistanceIncrease(nSpellResistance));
    if(bMove) eBonus = EffectLinkEffects(eBonus, EffectMovementSpeedIncrease(33));
              eBonus = UnyieldingEffect(eBonus);

	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oCelestial);
	
	DelayCommand(0.5F, AugmentSummonedCreature(sResRef));
	
	SetName(oCelestial, sNewName);
}	
	
/* 
    int nArmour, nStat, bSR, bMove, bSave;
    effect eBonus;

    if (nClass >= 18)
    {
        nArmour = 6;
        nStat   = 6;
        nHD    += 6;
        bSave   = TRUE;
        bSR     = TRUE;
        bMove   = TRUE;
    }
    else if(nClass >= 15)
    {
        nArmour = 4;
        nStat   = 4;
        nHD    += 4;
        bSave   = TRUE;
    }
    else if(nClass >= 12)
    {
        nArmour = 2;
        nStat   = 2;
        nHD    += 2;
    }
    // Epic bonuses
    int nEpicBonus = (nClass - 20) / 2;
        nArmour += nEpicBonus;
        nHD     += nEpicBonus;
        nStat   += nEpicBonus / 2;

    eBonus = EffectACIncrease(nArmour);
    if(GetPRCSwitch(PRC_NWNX_FUNCS))
    {
        PRC_Funcs_ModAbilityScore(oComp, ABILITY_STRENGTH,     nStat);
        PRC_Funcs_ModAbilityScore(oComp, ABILITY_DEXTERITY,    nStat);
        PRC_Funcs_ModAbilityScore(oComp, ABILITY_INTELLIGENCE, nStat);
    }
    else
    {
        eBonus = EffectLinkEffects(eBonus, EffectAbilityIncrease(ABILITY_STRENGTH,     nStat));
        eBonus = EffectLinkEffects(eBonus, EffectAbilityIncrease(ABILITY_DEXTERITY,    nStat));
        eBonus = EffectLinkEffects(eBonus, EffectAbilityIncrease(ABILITY_INTELLIGENCE, nStat));
    }
    if(bSave) eBonus = EffectLinkEffects(eBonus, EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_MIND_SPELLS));
    if(bSR)   eBonus = EffectLinkEffects(eBonus, EffectSpellResistanceIncrease(nClass));
    if(bMove) eBonus = EffectLinkEffects(eBonus, EffectMovementSpeedIncrease(33));
              eBonus = SupernaturalEffect(eBonus);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oComp);
} */
