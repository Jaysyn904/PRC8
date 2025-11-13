//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

#include "inc_dynconv"
//#include "inc_dispel"
#include "prc_inc_assoc"
#include "prc_inc_template"
#include "prc_inc_json"

const int PACKAGE_ELEMENTAL_STR = PACKAGE_ELEMENTAL;
const int PACKAGE_ELEMENTAL_DEX = PACKAGE_FEY;

void BondedSummoner(object oPC);
void SummonPnPFamiliar(object oPC, int nType);
void SummonPRCFamiliar(object oPC);
void DreadNecro(object oPC);
void MasterShadow(object oPC);

void main()
{
    object oPC = OBJECT_SELF;
    
    if(GetLevelByClass(CLASS_TYPE_MASTER_OF_SHADOW, oPC))
    {
        //handles summoning of shadow familiar
        DelayCommand(0.0f, MasterShadow(oPC));
    }
    else if(GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oPC))
    {
        //handles summoning of elemental familiar
        BondedSummoner(oPC);
    }
    else if(GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oPC) > 6)
    {
        //handles dread necromancer familiar
        DreadNecro(oPC);
    }
    else if(GetLevelByClass(CLASS_TYPE_CELEBRANT_SHARESS, oPC))
    {
        //It's a PnP Cat familiar
        SummonPnPFamiliar(oPC, 6);
    }    
    else if(GetPRCSwitch(PRC_PNP_FAMILIARS))
    {
        //handles summoning of pnp familiar
        SummonPnPFamiliar(oPC, -1);
    }
    else if(GetPRCSwitch(PRC_FAMILIARS)//the switch is set
    || (!GetLevelByClass(CLASS_TYPE_WIZARD, oPC)
    &&  !GetLevelByClass(CLASS_TYPE_SORCERER, oPC)))//or no bio-ware familiar
    {
        //handles summoning of familiars for PRC classes (witch, hexblade)
        SummonPRCFamiliar(oPC);
    }
    else
        //summon bio-ware familiar
        SummonFamiliar();

    object oFam;
    int i;
    int bDiabol = GetLevelByClass(CLASS_TYPE_DIABOLIST, oPC) >= 2;
    int bPseudonat = GetHasFeat(FEAT_PSEUDONATURAL_FAMILIAR, oPC);
    for(i = 1; i <= 5; i++)
    {
        oFam = GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR, oPC, i);

        if(bDiabol && GetAppearanceType(oFam) != APPEARANCE_TYPE_IMP)
            DestroyAssociate(oFam);

        if(bPseudonat)
        {
            object oFamSkin = GetPCSkin(oFam);
            ApplyPseudonatural(oFam, oFamSkin);
        }
    }
}

void BondedSummoner(object oPC)
{
    object oFam = GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR, oPC, NPC_BONDED_FAMILIAR);

    //remove previously summoned familiar
    if(GetIsObjectValid(oFam))
        DestroyAssociate(oFam);

    string sResRef, sElem;
    int nPackage;
    if(GetHasFeat(FEAT_BONDED_AIR, oPC))
    {
        sElem = "air";
        nPackage = PACKAGE_ELEMENTAL_DEX;
    }
    else if(GetHasFeat(FEAT_BONDED_EARTH, oPC))
    {
        sElem = "earth";
        nPackage = PACKAGE_ELEMENTAL_STR;
    }
    else if(GetHasFeat(FEAT_BONDED_FIRE, oPC))
    {
        sElem = "fire";
        nPackage = PACKAGE_ELEMENTAL_DEX;
    }
    else if(GetHasFeat(FEAT_BONDED_WATER, oPC))
    {
        sElem = "water";
        nPackage = PACKAGE_ELEMENTAL_STR;
    }

    int nLevel = GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oPC);

    switch(nLevel)
    {
        case 1:
        case 2: sResRef = "x1_s_"+sElem+"small"; break;		//this is the 4HD version in the SRD, which is medium
        case 3:
        case 4: sResRef = "prc_s_"+sElem+"large"; break;
        case 5:
        case 6: sResRef = "nw_s_"+sElem+"huge"; break;
        case 7:
        case 8: sResRef = "nw_s_"+sElem+"great"; break;
        case 9:
        default: sResRef = "nw_s_"+sElem+"elder"; break;
    }
	
	if(DEBUG) DoDebug("nw_s2_familiar >> Elemental resref is: "+sResRef+".");

    oFam = CreateLocalNPC(oPC, ASSOCIATE_TYPE_FAMILIAR, sResRef, PRCGetSpellTargetLocation(), NPC_BONDED_FAMILIAR);
    AddAssociate(oPC, oFam);

    //set its name
    string sName = GetFamiliarName(oPC);
    if(sName == "")
        sName = GetName(oPC)+ "'s Familiar";
    SetName(oFam, sName);
    //apply bonus based on level
    int nArcaneLevel = GetPrCAdjustedCasterLevelByType(TYPE_ARCANE) + nLevel/2;
    object oSkin = GetPCSkin(oFam);
    //in all cases
    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(ITEM_PROPERTY_IMPROVED_EVASION));
    //9+ levels
    if(nArcaneLevel >= 9)
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusSpellResistance(GetSRByValue(nArcaneLevel+5)));
    //11+ levels
    if(nArcaneLevel >= 11)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedIncrease(30)), oFam);
    //add their ondeath special
    AddEventScript(oFam, EVENT_NPC_ONDEATH, "prc_bond_death");

    /*int nAdjustLevel = nArcaneLevel - GetHitDice(oFam);
    int n;
    for(n = 1; nAdjustLevel >= n; n++)
        LevelUpHenchman(oFam, CLASS_TYPE_INVALID, TRUE, nPackage);*/

    //set it so the spell-share detects it
    SetLocalObject(oPC, "Familiar", oFam);
}

void DreadNecro(object oPC)
{
    object oFam = GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR, oPC, NPC_DN_FAMILIAR);

    //remove previously summoned familiar
    if(GetIsObjectValid(oFam))
        DestroyAssociate(oFam);

    int bPnP = GetPRCSwitch(PRC_PNP_FAMILIARS);
    int nAlign = GetAlignmentLawChaos(oPC);
    string sResRef;
    if(bPnP)
    {
        sResRef = nAlign == ALIGNMENT_LAWFUL ? "prc_pnpfam_imp" : nAlign == ALIGNMENT_CHAOTIC ? "prc_pnpfam_qust" : "prc_pnpfam_varg";
    }
    else
    {
        int nDNLevel = GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oPC);
        string sTemp = nDNLevel < 10 ? "0"+IntToString(nDNLevel) : IntToString(nDNLevel);
        sResRef = nAlign == ALIGNMENT_LAWFUL ? "NW_FM_IMP"+sTemp : nAlign == ALIGNMENT_CHAOTIC ? "NW_FM_QUAS"+sTemp : "X2_FM_EYE0"+sTemp;
    }

    oFam = CreateLocalNPC(oPC, ASSOCIATE_TYPE_FAMILIAR, sResRef, PRCGetSpellTargetLocation(), NPC_DN_FAMILIAR);

    //add the familiar as a henchman
    AddAssociate(oPC, oFam);

    //set its name
    string sName = GetFamiliarName(oPC);
    if(sName == "")
        sName = GetName(oPC)+ "'s Familiar";
    SetName(oFam, sName);

    if(bPnP) ApplyPnPFamiliarProperties(oPC, oFam);
}

void SummonPnPFamiliar(object oPC, int nType)
{
    IncrementRemainingFeatUses(oPC, FEAT_SUMMON_FAMILIAR);

    //check if already has a familiar
    object oFam = GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR, oPC, NPC_PNP_FAMILIAR);
    object oFamToken = GetItemPossessedBy(oPC, "prc_pnp_familiar");

    int nFamiliarType;
    
    if (nType > 0)
    	nFamiliarType = nType;
    else
    	nFamiliarType = GetPersistantLocalInt(oPC, "PnPFamiliarType");
    if(!nFamiliarType)
    {
        StartDynamicConversation("prc_pnp_fam_conv", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, TRUE, oPC);
        return;
    }

    if(GetIsObjectValid(oFam))
    {
        //reapply familiar bonuses
        PRCRemoveEffectsFromSpell(oFam, 318);//318 = summon familiar
    }
    else
    {
        if(GetIsObjectValid(oFamToken))
        {
            DestroyObject(oFamToken, 0.1f);
        }
        //spawn the familiar
        string sResRef = Get2DACache("prc_familiar", "BASERESREF", nFamiliarType);
        oFam = CreateLocalNPC(oPC, ASSOCIATE_TYPE_FAMILIAR, sResRef, PRCGetSpellTargetLocation(), NPC_PNP_FAMILIAR);

        //set its name
        string sName = GetFamiliarName(oPC);
        if(sName == "")
            sName = GetName(oPC)+ "'s Familiar";
        SetName(oFam, sName);

        //add the familiar as a henchman
        AddAssociate(oPC, oFam);
    }

    //this is the masters bonus
    effect eBonus = GetMasterBonus(nFamiliarType);
    eBonus = SupernaturalEffect(eBonus);
    if(!GetHasFeatEffect(FEAT_SUMMON_FAMILIAR, oPC))
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oPC);
        CheckIsValidFamiliar(oPC, eBonus);
    }

    ApplyPnPFamiliarProperties(oPC, oFam);
    if (GetHasFeat(FEAT_SHADOW_FAMILIAR, oPC)) ApplyTemplateToObject(TEMPLATE_DARK, oFam);
}

void SummonPRCFamiliar(object oPC)
{
    object oFam = GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR, oPC, NPC_HENCHMAN_COMPANION);

    //remove previously summoned familiar
    if(GetIsObjectValid(oFam))
        DestroyAssociate(oFam);

    int nFamiliarType = GetPersistantLocalInt(oPC, "FamiliarType");
    if(!nFamiliarType)
    {
        StartDynamicConversation("prc_pnp_fam_conv", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, TRUE, oPC);
        IncrementRemainingFeatUses(oPC, FEAT_SUMMON_FAMILIAR);
        return;
    }
    else
        nFamiliarType--;

    int nFamLevel = GetLevelByClass(CLASS_TYPE_WIZARD);
    nFamLevel = PRCMax(nFamLevel, GetLevelByClass(CLASS_TYPE_SORCERER));
    nFamLevel = PRCMax(nFamLevel, GetLevelByClass(CLASS_TYPE_WITCH));
    nFamLevel = PRCMax(nFamLevel, GetLevelByClass(CLASS_TYPE_HEXBLADE));
    nFamLevel += GetLevelByClass(CLASS_TYPE_ALIENIST);
    if (GetHasFeat(FEAT_SHADOW_FAMILIAR, oPC)) nFamLevel = GetLevelByTypeArcane(oPC) + GetShadowcasterLevel(oPC); // For the purpose of determining familiar abilities that depend on your arcane caster level, your levels in all classes that allow you to cast mysteries or arcane spells stack
    
    string sTemp = Get2DACache("hen_familiar", "BASERESREF", nFamiliarType);
    string sResRef = nFamLevel < 10 ? sTemp+"0"+IntToString(nFamLevel) : sTemp+IntToString(nFamLevel);

    //spawn the familiar
    oFam = CreateLocalNPC(oPC, ASSOCIATE_TYPE_FAMILIAR, sResRef, PRCGetSpellTargetLocation(), NPC_HENCHMAN_COMPANION);
    AddAssociate(oPC, oFam);
    
    if (GetHasFeat(FEAT_SHADOW_FAMILIAR, oPC)) ApplyTemplateToObject(TEMPLATE_DARK, oFam);

    //set its name
    string sName = GetFamiliarName(oPC);
    if(sName == "")
        sName = GetName(oPC)+ "'s Familiar";
    SetName(oFam, sName);
}

// Watch function: despawns Shadow Servant if master is dead or out of range
void ShadowServantWatch(object oShadow, object oPC)
{
    if(DEBUG) DoDebug("nw_s2_familiar >> ShadowServantWatch: Starting function.");
	
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

void MasterShadow(object oPC)
{
    object oShadow = GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR, oPC, NPC_MS_ELEMENTAL);

    //remove previously summoned familiar
    if(GetIsObjectValid(oShadow))
        DestroyAssociate(oShadow);
        
    int nMaster = GetLevelByClass(CLASS_TYPE_MASTER_OF_SHADOW, oPC);
	
	int nDexBonus = (nMaster >= 5 && (nMaster % 2)) ? (nMaster - 3) : 0;
	
	float fRange  = 30.0 + (nMaster * 10);
	
    string SHADOW_SERVANT_RESREF = "prc_shadow_serv";
	
    // Target location
    location lTarget = GetLocation(oPC);	
	
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
        SendMessageToPC(oPC, "nw_s2_familiar: TemplateToJson failed — bad resref or resource missing.");
        return;
    }	

    // Original HD
    int nOriginalHD = json_GetCreatureHD(jShadow);
    if (nOriginalHD <= 0)
    {
        SendMessageToPC(oPC, "nw_s2_familiar: json_GetCreatureHD failed — template missing HD data.");
        return;
    }

    //:: Add Hit Dice
	int nHDToAdd  = nMaster -1;	
	if (nHDToAdd < 0) nHDToAdd = 0;
	
    jShadow = json_AddHitDice(jShadow, nHDToAdd);	
    if (jShadow == JSON_NULL)
    {
        SendMessageToPC(oPC, "nw_s2_familiar: json_AddHitDice failed - JSON became invalid.");
        return;
    }

	//:: Update feats
	jShadow = json_AddFeatsFromCreatureVars(jShadow, nOriginalHD);
	if (jShadow == JSON_NULL)
	{
		SendMessageToPC(oPC, "nw_s2_familiar: json_AddFeatsFromCreatureVars failed — JSON became invalid.");
		return;
	}

	//:: Update Skills
	jShadow = json_AdjustCreatureSkillByID(jShadow, SKILL_LISTEN, nHDToAdd);
	if(jShadow == JSON_NULL)
	{
		SendMessageToPC(oPC, "nw_s2_familiar: json_AdjustCreatureSkillByID failed — JSON became invalid.");
		return;
	}
	
    //:: Update stats
    jShadow = json_ApplyAbilityBoostFromHD(jShadow, nOriginalHD);
    if (jShadow == JSON_NULL)
    {
        SendMessageToPC(oPC, "nw_s2_familiar: json_ApplyAbilityBoostFromHD failed — JSON became invalid.");
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
			SendMessageToPC(oPC, "nw_s2_familiar: json_AdjustCreatureSize failed - JSON became invalid.");
            return;
        }
    }    

	//string sNewResRef = GetPCPublicCDKey(oPC, TRUE)+"SHSERV";
	
	//if(DEBUG) DoDebug("New resref is: "+sNewResRef+".");
	
	//JsonToTemplate(jShadow, "shadowservant", RESTYPE_UTC);	
	
	oShadow = JsonToObject(jShadow, lTarget);
    
	effect eSummon = ExtraordinaryEffect(EffectSummonCreature("", VFX_FNF_SUMMON_UNDEAD, 0.0, 0, VFX_IMP_UNSUMMON, oShadow));
	
	ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSummon, lTarget);
       
    //oShadow = CreateLocalNPC(oPC, ASSOCIATE_TYPE_FAMILIAR, sNewResRef, lTarget, NPC_MS_ELEMENTAL);
	
	//oShadow = CreateObject(OBJECT_TYPE_CREATURE, "shadowservant", GetLocation(oPC));
	
	object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF);
	
	if(GetIsObjectValid(oSummon))
	{
		if(GetResRef(oSummon) == SHADOW_SERVANT_RESREF)		
		{
			SetLocalNPC(oPC, oShadow, ASSOCIATE_TYPE_FAMILIAR, 1);
			SetAssociateState(NW_ASC_HAVE_MASTER, TRUE, oShadow);
			SetAssociateState(NW_ASC_DISTANCE_2_METERS);
			SetAssociateState(NW_ASC_DISTANCE_4_METERS, FALSE);
			SetAssociateState(NW_ASC_DISTANCE_6_METERS, FALSE);

			SetLocalInt(oPC, "FamiliarToTheDeath", 100);

			effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oShadow));	
		}
	}
	
	if(DEBUG) DoDebug("MasterShadow: Creature object created.");
	
    AddAssociate(oPC, oShadow);  
	if(DEBUG) DoDebug("MasterShadow: Associate Added.");
	
    if (nMaster >= 3) // Grow to size large
        SetCreatureAppearanceType(oShadow, APPEARANCE_TYPE_SHADOW_FIEND);	
	
    //set its name
    string sName = GetFamiliarName(oPC);
    if(sName == "")
        sName = GetName(oPC)+ "'s Shadow Servant";
    SetName(oShadow, sName);    

    itemproperty ipIP;
    object oSkin = GetPCSkin(oShadow);
    if (nMaster >= 10)
        ipIP =ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
    else if (nMaster >= 6)
        ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_20); 
    else if (nMaster >= 4)
        ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10);            
    else if (nMaster >= 2)
        ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_5); 
        
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);        
        

}    


/* void MasterShadow(object oPC)
{
    object oFam = GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR, oPC, NPC_MS_ELEMENTAL);

    //remove previously summoned familiar
    if(GetIsObjectValid(oFam))
        DestroyAssociate(oFam);
        
    int nLevel = GetLevelByClass(CLASS_TYPE_MASTER_OF_SHADOW, oPC);
    string sShadow = "shd_shdelem_med";
    if (nLevel >= 10)
        sShadow = "shd_shdelem_med4";
    else if (nLevel >= 7)
        sShadow = "shd_shdelem_med3";
    else if (nLevel >= 4)
        sShadow = "shd_shdelem_med2";        
       
    oFam = CreateLocalNPC(oPC, ASSOCIATE_TYPE_FAMILIAR, sShadow, PRCGetSpellTargetLocation(), NPC_MS_ELEMENTAL);
    AddAssociate(oPC, oFam);  
    //set its name
    string sName = GetFamiliarName(oPC);
    if(sName == "")
        sName = GetName(oPC)+ "'s Shadow Servant";
    SetName(oFam, sName);    

    itemproperty ipIP;
    object oSkin = GetPCSkin(oFam);
    if (nLevel >= 10)
        ipIP =ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
    else if (nLevel >= 6)
        ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_20); 
    else if (nLevel >= 4)
        ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10);            
    else if (nLevel >= 2)
        ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_5); 
        
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);        
        
    if (nLevel >= 3) // Grow to size large
        SetCreatureAppearanceType(oFam, APPEARANCE_TYPE_SHADOW_FIEND);
}    */