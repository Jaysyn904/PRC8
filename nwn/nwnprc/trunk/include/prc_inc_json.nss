//:://////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//:://////////////////////////////////////////////
//::  
/*
	Library for json related functions.
	
*/
//::  
//::////////////////////////////////////////////// 
//::	Script:     prc_inc_json.nss
//::	Author:     Jaysyn
//::	Created:    2025-08-14 12:52:32
//:://////////////////////////////////////////////
#include "nw_inc_gff"
#include "inc_debug"


//::---------------------------------------------|
//:: Helper functions                            |
//::---------------------------------------------|

//:: Function to calculate the maximum possible hitpoints for oCreature
int GetMaxPossibleHP(object oCreature)
{
    int nMaxHP = 0;  // Stores the total maximum hitpoints
    int i = 1;       // Initialize position for class index
	int nConb	= GetAbilityModifier(ABILITY_CONSTITUTION, oCreature);
    
    // Loop through each class position the creature may have, checking each class in turn
    while (TRUE)
    {
        // Get the class ID at position i
        int nClassID = GetClassByPosition(i, oCreature);

        // If class is invalid (no more classes to check), break out of loop
        if (nClassID == CLASS_TYPE_INVALID)
            break;

        // Get the number of levels in this class
        int nClassLevels = GetLevelByClass(nClassID, oCreature);
        
        // Get the row index of the class in classes.2da by using class ID as the row index
        int nHitDie = StringToInt(Get2DAString("classes", "HitDie", nClassID));
        
        // Add maximum HP for this class (Hit Die * number of levels in this class)
        nMaxHP += nClassLevels * nHitDie;
		
        // Move to the next class position
        i++;
    }
    
	nMaxHP += nConb * GetHitDice(oCreature);
	
    return nMaxHP;
}

// Returns how many feats a creature should gain when its HD increases
int CalculateFeatsFromHD(int nOriginalHD, int nNewHD)
{
    // HD increase
    int nHDIncrease = nNewHD - nOriginalHD;

    if (nHDIncrease <= 0)
        return 0; // No new feats if HD did not increase

    // D&D 3E: 1 feat per 3 HD
    int nBonusFeats = nHDIncrease / 3;

    return nBonusFeats;
}

// Returns how many stat boosts a creature needs based on its HD
int GetStatBoostsFromHD(int nCreatureHD, int nModiferCap)
{
    // Make sure we don't get negative boosts
    int nBoosts = (40 - nCreatureHD) / 4;
    if (nBoosts < 0)
    {
        nBoosts = 0;
    }
    return nBoosts;
}

// Struct to hold size modifiers
struct SizeModifiers
{
    int strMod;
    int dexMod;
    int conMod;
    int naturalAC;
    int attackBonus;
    int dexSkillMod;
};

//:: Returns ability mod for score
int GetAbilityModFromValue(int nAbilityValue)
{
    int nMod = (nAbilityValue - 10) / 2;

    // Adjust if below 10 and odd
    if (nAbilityValue < 10 && (nAbilityValue % 2) != 0)
    {
        nMod = nMod - 1;
    }
    return nMod;
}


//::---------------------------------------------|
//:: JSON functions                              |
//::---------------------------------------------|

//:: Returns the Constitution value from a GFF creature UTC
int json_GetCONValue(json jCreature)
{
    int nCon = 0; // default if missing

    // Check if the Con field exists
    if (GffGetFieldExists(jCreature, "Con"))
    {
        nCon = JsonGetInt(GffGetByte(jCreature, "Con"));
    }

    return nCon;
}

//:: Returns the integer value of a VarTable entry named sVarName, or 0 if not found.
int json_GetLocalIntFromVarTable(json jCreature, string sVarName)
{
    json jVarTable = GffGetList(jCreature, "VarTable");
    if (jVarTable == JsonNull())
        return 0;

    int nCount = JsonGetLength(jVarTable);
    int i;
    for (i = 0; i < nCount; i++)
    {
        json jEntry = JsonArrayGet(jVarTable, i);
        if (jEntry == JsonNull()) continue;

        // Get the Name field using GFF functions
        json jName = GffGetString(jEntry, "Name");
        if (jName == JsonNull()) continue;
        string sName = JsonGetString(jName);

        if (sName == sVarName)
        {
            // Get the Type field to verify it's an integer
            json jType = GffGetDword(jEntry, "Type");
            if (jType != JsonNull())
            {
                int nType = JsonGetInt(jType);
                if (nType == 1) // Type 1 = integer
                {
                    // Get the Value field using GFF functions
                    json jValue = GffGetInt(jEntry, "Value");
                    if (jValue == JsonNull()) return 0;
                    return JsonGetInt(jValue);
                }
            }
        }
    }

    return 0;
}

//:: Returns the total Hit Dice from a JSON'd creature GFF.
int json_GetCreatureHD(json jCreature)
{
    int nHD = 0;

    json jClasses = GffGetList(jCreature, "ClassList");
    if (jClasses == JsonNull())
        return 0;

    int nCount = JsonGetLength(jClasses);
    int i;
    for (i = 0; i < nCount; i = i + 1)
    {
        json jClass = JsonArrayGet(jClasses, i);
        if (jClass == JsonNull())
            continue;
            
        json jLevel = GffGetShort(jClass, "ClassLevel"); // Use GffGetShort, not GffGetField
        if (jLevel != JsonNull())
        {
            int nLevel = JsonGetInt(jLevel);
            nHD += nLevel;
        }
    }

    if (nHD <= 0) nHD = 1;
    return nHD;
}


json json_RecalcMaxHP(json jCreature, int iHitDieValue)
{
    int iHD  = json_GetCreatureHD(jCreature);
    int iCON = json_GetCONValue(jCreature);
    int iMod = GetAbilityModFromValue(iCON);

    int nConBonusHP = iMod * iHD;
    int iNewMaxHP   = (iHitDieValue * iHD); /* nConBonusHP */

    //jCreature = GffReplaceShort(jCreature, "MaxHitPoints", iNewMaxHP);
    jCreature = GffReplaceShort(jCreature, "CurrentHitPoints", iNewMaxHP);
    jCreature = GffReplaceShort(jCreature, "HitPoints", iNewMaxHP);

/* 	SendMessageToPC(GetFirstPC(), "HD = " + IntToString(iHD));
	SendMessageToPC(GetFirstPC(), "HitDieValue = " + IntToString(iHitDieValue));
	SendMessageToPC(GetFirstPC(), "CON = " + IntToString(iCON));
	SendMessageToPC(GetFirstPC(), "Mod = " + IntToString(iMod));
	SendMessageToPC(GetFirstPC(), "New HP = " + IntToString(iNewMaxHP)); */

    return jCreature;
}

	
//:: Reads ABILITY_TO_INCREASE from creature's VarTable and applies stat boosts based on increased HD

json json_ApplyAbilityBoostFromHD(json jCreature, int nOriginalHD)
{
    if (jCreature == JsonNull())
        return jCreature;

    // Get the ability to increase from VarTable
    int nAbilityToIncrease = json_GetLocalIntFromVarTable(jCreature, "ABILITY_TO_INCREASE");
    if (nAbilityToIncrease < 0 || nAbilityToIncrease > 5)
    {
        DoDebug("json_ApplyAbilityBoostFromHD: Invalid ABILITY_TO_INCREASE value: " + IntToString(nAbilityToIncrease));
        return jCreature; // Invalid ability index
    }

    // Calculate total current HD from ClassList
    json jClassList = GffGetList(jCreature, "ClassList");
    if (jClassList == JsonNull())
    {
        DoDebug("json_ApplyAbilityBoostFromHD: Failed to get ClassList");
        return jCreature;
    }

    int nCurrentTotalHD = 0;
    int nClassCount = JsonGetLength(jClassList);
    int i;
    
    for (i = 0; i < nClassCount; i++)
    {
        json jClass = JsonArrayGet(jClassList, i);
        if (jClass != JsonNull())
        {
            json jClassLevel = GffGetShort(jClass, "ClassLevel");
            if (jClassLevel != JsonNull())
            {
                nCurrentTotalHD += JsonGetInt(jClassLevel);
            }
        }
    }

    if (nCurrentTotalHD <= 0)
    {
        DoDebug("json_ApplyAbilityBoostFromHD: No valid Hit Dice found");
        return jCreature;
    }

    // Calculate stat boosts based on crossing level thresholds
    // Characters get stat boosts at levels 4, 8, 12, 16, 20, etc.
    int nOriginalBoosts = nOriginalHD / 4;  // How many boosts they already had
    int nCurrentBoosts = nCurrentTotalHD / 4;  // How many they should have now
    int nBoosts = nCurrentBoosts - nOriginalBoosts;  // Additional boosts to apply
    
    if (nBoosts <= 0)
    {
        if(DEBUG) DoDebug("json_ApplyAbilityBoostFromHD: No boosts needed (Original boosts: " + IntToString(nOriginalBoosts) + ", Current boosts: " + IntToString(nCurrentBoosts) + ")");
        return jCreature;
    }

    if(DEBUG) DoDebug("json_ApplyAbilityBoostFromHD: Applying " + IntToString(nBoosts) + " boosts to ability " + IntToString(nAbilityToIncrease) + " for HD increase from " + IntToString(nOriginalHD) + " to " + IntToString(nCurrentTotalHD));

    // Determine which ability to boost and apply the increases
    string sAbilityField;
    switch (nAbilityToIncrease)
    {
        case 0: sAbilityField = "Str"; break;
        case 1: sAbilityField = "Dex"; break;
        case 2: sAbilityField = "Con"; break;
        case 3: sAbilityField = "Int"; break;
        case 4: sAbilityField = "Wis"; break;
        case 5: sAbilityField = "Cha"; break;
        default:
            if(DEBUG) DoDebug("json_ApplyAbilityBoostFromHD: Unknown ability index: " + IntToString(nAbilityToIncrease));
            return jCreature;
    }

    // Get current ability score
    json jCurrentAbility = GffGetByte(jCreature, sAbilityField);
    if (jCurrentAbility == JsonNull())
    {
        if(DEBUG) DoDebug("json_ApplyAbilityBoostFromHD: Failed to get " + sAbilityField + " score");
        return jCreature;
    }

    int nCurrentScore = JsonGetInt(jCurrentAbility);
    int nNewScore = nCurrentScore + nBoosts;

    // Clamp to valid byte range
    if (nNewScore < 1) nNewScore = 1;
    if (nNewScore > 250) nNewScore = 250;

    if(DEBUG) DoDebug("json_ApplyAbilityBoostFromHD: Increasing " + sAbilityField + " from " + IntToString(nCurrentScore) + " to " + IntToString(nNewScore));

    // Apply the ability score increase
    jCreature = GffReplaceByte(jCreature, sAbilityField, nNewScore);
    if (jCreature == JsonNull())
    {
        if(DEBUG) DoDebug("json_ApplyAbilityBoostFromHD: Failed to update " + sAbilityField);
        return JsonNull();
    }

    if(DEBUG) DoDebug("json_ApplyAbilityBoostFromHD: Successfully applied ability boosts");
    return jCreature;
}

//:: Adjust a skill by its ID
json json_AdjustCreatureSkillByID(json jCreature, int nSkillID, int nMod)
{
    // Get the SkillList
    json jSkillList = GffGetList(jCreature, "SkillList");
    if (jSkillList == JsonNull())
    {
        if(DEBUG) DoDebug("json_AdjustCreatureSkillByID: Failed to get SkillList");
        return jCreature;
    }
    
    // Check if we have enough skills in the list
    int nSkillCount = JsonGetLength(jSkillList);
    if (nSkillID >= nSkillCount)
    {
        if(DEBUG) DoDebug("json_AdjustCreatureSkillByID: Skill ID " + IntToString(nSkillID) + " exceeds skill list length " + IntToString(nSkillCount));
        return jCreature;
    }
    
    // Get the skill struct at the correct index
    json jSkill = JsonArrayGet(jSkillList, nSkillID);
    if (jSkill == JsonNull())
    {
        if(DEBUG) DoDebug("json_AdjustCreatureSkillByID: Failed to get skill at index " + IntToString(nSkillID));
        return jCreature;
    }
    
    // Get current rank
    json jRank = GffGetByte(jSkill, "Rank");
    if (jRank == JsonNull())
    {
        if(DEBUG) DoDebug("json_AdjustCreatureSkillByID: Failed to get Rank for skill ID " + IntToString(nSkillID));
        return jCreature;
    }
    
    int nCurrentRank = JsonGetInt(jRank);
    int nNewRank = nCurrentRank + nMod;
    
    // Clamp to valid range
    if (nNewRank < 0) nNewRank = 0;
    if (nNewRank > 127) nNewRank = 127;
    
    // Update the rank in the skill struct
    jSkill = GffReplaceByte(jSkill, "Rank", nNewRank);
    if (jSkill == JsonNull())
    {
        if(DEBUG) DoDebug("json_AdjustCreatureSkillByID: Failed to replace Rank for skill ID " + IntToString(nSkillID));
        return JsonNull();
    }
    
    // Replace the skill in the array
    jSkillList = JsonArraySet(jSkillList, nSkillID, jSkill);
    
    // Replace the SkillList in the creature
    jCreature = GffReplaceList(jCreature, "SkillList", jSkillList);
    
    return jCreature;
}

//:: Reads FutureFeat1..FutureFeatN from the template's VarTable and appends them to FeatList if missing.
json json_AddFeatsFromCreatureVars(json jCreature, int nOriginalHD)
{
    if (jCreature == JsonNull())
        return jCreature;

    // Calculate current total HD
    int nCurrentHD = json_GetCreatureHD(jCreature);
    int nAddedHD = nCurrentHD - nOriginalHD;
    
    if (nAddedHD <= 0)
    {
        if(DEBUG) DoDebug("json_AddFeatsFromCreatureVars: No additional HD to process (Current: " + IntToString(nCurrentHD) + ", Original: " + IntToString(nOriginalHD) + ")");
        return jCreature;
    }

    // Calculate how many feats the creature should get based on added HD
    // Characters get a feat at levels 1, 3, 6, 9, 12, 15, 18, etc.
    // For added levels, we need to check what feat levels they cross
    int nOriginalFeats = (nOriginalHD + 2) / 3; // Feats from original HD
    int nCurrentFeats = (nCurrentHD + 2) / 3;   // Feats from current HD
    int nNumFeats = nCurrentFeats - nOriginalFeats; // Additional feats earned
    
    if (nNumFeats <= 0)
    {
        if(DEBUG) DoDebug("json_AddFeatsFromCreatureVars: No additional feats earned from " + IntToString(nAddedHD) + " added HD");
        return jCreature;
    }

    if(DEBUG) DoDebug("json_AddFeatsFromCreatureVars: Processing " + IntToString(nNumFeats) + " feats for " + IntToString(nAddedHD) + " added HD (Original: " + IntToString(nOriginalHD) + ", Current: " + IntToString(nCurrentHD) + ")");

    // Get or create FeatList
    json jFeatArray = GffGetList(jCreature, "FeatList");
    if (jFeatArray == JsonNull())
        jFeatArray = JsonArray();

    int nOriginalFeatCount = JsonGetLength(jFeatArray);
    if(DEBUG) DoDebug("json_AddFeatsFromCreatureVars: Original feat count: " + IntToString(nOriginalFeatCount));

    int nAdded = 0;
    int i = 1;
    int nMaxIterations = 100; // Safety valve
    int nIterations = 0;

    while (nAdded < nNumFeats && nIterations < nMaxIterations)
    {
        nIterations++;
        string sVarName = "FutureFeat" + IntToString(i);
        
        if(DEBUG) DoDebug("json_AddFeatsFromCreatureVars: Checking " + sVarName);
        
        int nFeat = json_GetLocalIntFromVarTable(jCreature, sVarName);

        if (nFeat <= 0)
        {
            if(DEBUG) DoDebug("json_AddFeatsFromCreatureVars: " + sVarName + " not found or invalid");
            i++;
            continue;
        }

        if(DEBUG) DoDebug("json_AddFeatsFromCreatureVars: Found " + sVarName + " = " + IntToString(nFeat));

        // Check if feat already exists
        int bHasFeat = FALSE;
        int nFeatCount = JsonGetLength(jFeatArray);
        int j;
        
        for (j = 0; j < nFeatCount; j++)
        {
            json jFeatStruct = JsonArrayGet(jFeatArray, j);
            if (jFeatStruct != JsonNull())
            {
                json jFeatValue = GffGetWord(jFeatStruct, "Feat");
                if (jFeatValue != JsonNull() && JsonGetInt(jFeatValue) == nFeat)
                {
                    bHasFeat = TRUE;
                    if(DEBUG) DoDebug("json_AddFeatsFromCreatureVars: Feat " + IntToString(nFeat) + " already exists");
                    break;
                }
            }
        }

        // Insert if missing
        if (!bHasFeat)
        {
            json jNewFeat = JsonObject();
            jNewFeat = JsonObjectSet(jNewFeat, "__struct_id", JsonInt(1));
            jNewFeat = GffAddWord(jNewFeat, "Feat", nFeat);
            
            if (jNewFeat == JsonNull())
            {
                if(DEBUG) DoDebug("json_AddFeatsFromCreatureVars: Failed to create feat struct for feat " + IntToString(nFeat));
                break;
            }
            
            jFeatArray = JsonArrayInsert(jFeatArray, jNewFeat);
            nAdded++;
            
            if(DEBUG) DoDebug("json_AddFeatsFromCreatureVars: Added feat " + IntToString(nFeat) + " (" + IntToString(nAdded) + "/" + IntToString(nNumFeats) + ")");
        }

        i++;
        
        // Safety break if we've checked too many variables
        if (i > 100)
        {
            if(DEBUG) DoDebug("json_AddFeatsFromCreatureVars: Safety break - checked too many FutureFeat variables");
            break;
        }
    }

    if(DEBUG) DoDebug("json_AddFeatsFromCreatureVars: Completed. Added " + IntToString(nAdded) + " feats in " + IntToString(nIterations) + " iterations");

    // Save back the modified FeatList only if we added something
    if (nAdded > 0)
    {
        jCreature = GffReplaceList(jCreature, "FeatList", jFeatArray);
        if (jCreature == JsonNull())
        {
            if(DEBUG) DoDebug("json_AddFeatsFromCreatureVars: Failed to replace FeatList");
            return JsonNull();
        }
    }

    return jCreature;
}

//:: Get the size of a JSON array
int json_GetArraySize(json jArray)
{
    int iSize = 0;
    while (JsonArrayGet(jArray, iSize) != JsonNull())
    {
        iSize++;
    }
    return iSize;
}

//:: Directly updates oCreature's Base Natural AC if iNewAC is higher.
//::
json json_UpdateBaseAC(json jCreature, int iNewAC)
{
    //json jBaseAC = GffGetByte(jCreature, "Creature/value/NaturalAC/value");
	json jBaseAC = GffGetByte(jCreature, "NaturalAC");

    if (jBaseAC == JsonNull())
    {
        return JsonNull();
    }
    else if (JsonGetInt(jBaseAC) > iNewAC)
    {
        return jCreature;
    }
	else
	{
		jCreature = GffReplaceByte(jCreature, "NaturalAC", iNewAC);
		
		return jCreature;
	}
}

//:: Increases jCreature's Natural AC by iAddAC.
//::
json json_IncreaseBaseAC(json jCreature, int iAddAC)
{
    json jBaseAC = GffGetByte(jCreature, "NaturalAC");

    if (jBaseAC == JsonNull())
    {
        return JsonNull();
    }
    else
    {
        int nBaseAC = JsonGetInt(jBaseAC);          // convert JSON number -> int
        int nNewAC  = nBaseAC + iAddAC;

        jCreature = GffReplaceByte(jCreature, "NaturalAC", nNewAC);
        return jCreature;
    }
}

//:: Directly modifies jCreature's Challenge Rating.
//:: This is useful for most XP calculations.
json json_UpdateCR(json jCreature, int nBaseCR, int nCRMod)
{
	int nNewCR;
	
//:: Add CRMod to current CR
	nNewCR = nBaseCR + nCRMod;
	
//:: Modify Challenge Rating
	jCreature = GffReplaceFloat(jCreature, "ChallengeRating", IntToFloat(nNewCR));
	
	return jCreature;
}

//:: Directly modifies ability scores in a creature's JSON GFF.
//::
json json_UpdateTemplateStats(json jCreature, int iModStr = 0, int iModDex = 0, int iModCon = 0, int iModInt = 0, int iModWis = 0, int iModCha = 0)
{
    int iCurrent;

    // STR
    if (!GffGetFieldExists(jCreature, "Str", GFF_FIELD_TYPE_BYTE))
        jCreature = GffAddByte(jCreature, "Str", 10);
    iCurrent = JsonGetInt(GffGetByte(jCreature, "Str"));
    jCreature = GffReplaceByte(jCreature, "Str", iCurrent + iModStr);

    // DEX
    if (!GffGetFieldExists(jCreature, "Dex", GFF_FIELD_TYPE_BYTE))
        jCreature = GffAddByte(jCreature, "Dex", 10);
    iCurrent = JsonGetInt(GffGetByte(jCreature, "Dex"));
    jCreature = GffReplaceByte(jCreature, "Dex", iCurrent + iModDex);

    // CON
    if (!GffGetFieldExists(jCreature, "Con", GFF_FIELD_TYPE_BYTE))
        jCreature = GffAddByte(jCreature, "Con", 10);
    iCurrent = JsonGetInt(GffGetByte(jCreature, "Con"));
    jCreature = GffReplaceByte(jCreature, "Con", iCurrent + iModCon);

    // INT
    if (!GffGetFieldExists(jCreature, "Int", GFF_FIELD_TYPE_BYTE))
        jCreature = GffAddByte(jCreature, "Int", 10);
    iCurrent = JsonGetInt(GffGetByte(jCreature, "Int"));
    jCreature = GffReplaceByte(jCreature, "Int", iCurrent + iModInt);

    // WIS
    if (!GffGetFieldExists(jCreature, "Wis", GFF_FIELD_TYPE_BYTE))
        jCreature = GffAddByte(jCreature, "Wis", 10);
    iCurrent = JsonGetInt(GffGetByte(jCreature, "Wis"));
    jCreature = GffReplaceByte(jCreature, "Wis", iCurrent + iModWis);

    // CHA
    if (!GffGetFieldExists(jCreature, "Cha", GFF_FIELD_TYPE_BYTE))
        jCreature = GffAddByte(jCreature, "Cha", 10);
    iCurrent = JsonGetInt(GffGetByte(jCreature, "Cha"));
    jCreature = GffReplaceByte(jCreature, "Cha", iCurrent + iModCha);

    return jCreature;
}

//:: Directly modifies oCreature's ability scores.
//::
json json_UpdateCreatureStats(json jCreature, object oBaseCreature, int iModStr = 0, int iModDex = 0, int iModCon = 0, int iModInt = 0, int iModWis = 0, int iModCha = 0)
{
//:: Retrieve and modify ability scores
	int iCurrentStr = GetAbilityScore(oBaseCreature, ABILITY_STRENGTH);
	int iCurrentDex = GetAbilityScore(oBaseCreature, ABILITY_DEXTERITY);
	int iCurrentCon = GetAbilityScore(oBaseCreature, ABILITY_CONSTITUTION);
	int iCurrentInt = GetAbilityScore(oBaseCreature, ABILITY_INTELLIGENCE);
	int iCurrentWis = GetAbilityScore(oBaseCreature, ABILITY_WISDOM);
	int iCurrentCha = GetAbilityScore(oBaseCreature, ABILITY_CHARISMA);

	jCreature = GffReplaceByte(jCreature, "Str", iCurrentStr + iModStr);
	jCreature = GffReplaceByte(jCreature, "Dex", iCurrentDex + iModDex);
	jCreature = GffReplaceByte(jCreature, "Con", iCurrentCon + iModCon);
	jCreature = GffReplaceByte(jCreature, "Int", iCurrentInt + iModInt);
	jCreature = GffReplaceByte(jCreature, "Wis", iCurrentWis + iModWis);
	jCreature = GffReplaceByte(jCreature, "Cha", iCurrentCha + iModCha); 

	return jCreature;
}

//:: Increases a creature's Hit Dice in its JSON GFF data by nAmount
json json_AddHitDice(json jCreature, int nAmount)
{
    if (jCreature == JsonNull() || nAmount <= 0)
        return jCreature;

    // Get the ClassList
    json jClasses = GffGetList(jCreature, "ClassList");
    if (jClasses == JsonNull() || JsonGetLength(jClasses) == 0)
        return jCreature;

    // Grab the first class entry
    json jFirstClass = JsonArrayGet(jClasses, 0);

    // Only touch ClassLevel; do NOT modify Class type
    json jCurrentLevel = GffGetShort(jFirstClass, "ClassLevel");
    int nCurrentLevel = JsonGetInt(jCurrentLevel);
    int nNewLevel = nCurrentLevel + nAmount;

    // Replace ClassLevel only
    jFirstClass = GffReplaceShort(jFirstClass, "ClassLevel", nNewLevel);

    // Put modified class back into the array
    jClasses = JsonArraySet(jClasses, 0, jFirstClass);

    // Replace ClassList in the creature JSON
    jCreature = GffReplaceList(jCreature, "ClassList", jClasses);

    return jCreature;
}

//:: Adjusts a creature's size by nSizeChange (-4 to +4) and updates ability scores accordingly.
json json_AdjustCreatureSize(json jCreature, int nSizeDelta, int nIncorporeal = FALSE)
{
    if(DEBUG) DoDebug("prc_inc_json >> json_AdjustCreatureSize: Entering function. nSizeDelta=" + IntToString(nSizeDelta));

    if (jCreature == JsonNull() || nSizeDelta == 0)
    {
        if(DEBUG) DoDebug("prc_inc_json >> json_AdjustCreatureSize: Exiting: jCreature is null or nSizeDelta is 0");
        return jCreature;
    }

    // Get Appearance_Type using GFF functions
    json jAppearanceType = GffGetWord(jCreature, "Appearance_Type");
    if (jAppearanceType == JsonNull())
    {
        if(DEBUG) DoDebug("prc_inc_json >> json_AdjustCreatureSize: Failed to get Appearance_Type");
        return jCreature;
    }
    
    int nAppearance = JsonGetInt(jAppearanceType);
    int nCurrentSize = StringToInt(Get2DAString("appearances", "Size", nAppearance));

    // Default to Medium (4) if invalid
    if (nCurrentSize < 0 || nCurrentSize > 8) nCurrentSize = 4;

    if(DEBUG) DoDebug("prc_inc_json >> json_AdjustCreatureSize: Appearance_Type =" + IntToString(nAppearance) + ", Size =" + IntToString(nCurrentSize));

    int nSteps = nSizeDelta;
    
    // Calculate modifiers based on size change
    int strMod      = nSteps * 4;
    int dexMod      = nSteps * -1;
    int conMod      = nSteps * 2;
    int naturalAC   = nSteps * 1;
    int dexSkillMod = nSteps * -2;
	
	if(nIncorporeal)
	{
		strMod = 0;
	}

    if(DEBUG) DoDebug("prc_inc_json >> json_AdjustCreatureSize: Applying stat modifiers: STR=" + IntToString(strMod) +
                                 " DEX=" + IntToString(dexMod) +
                                 " CON=" + IntToString(conMod));

    // Update ability scores using GFF functions with error checking
    json jStr = GffGetByte(jCreature, "Str");
    if (jStr != JsonNull())
    {
        int nNewStr = JsonGetInt(jStr) + strMod;
        if (nNewStr < 1) nNewStr = 1;
        if (nNewStr > 255) nNewStr = 255;
        
        jCreature = GffReplaceByte(jCreature, "Str", nNewStr);
        if (jCreature == JsonNull())
        {
            if(DEBUG) DoDebug("prc_inc_json >> json_AdjustCreatureSize: Failed to update Str");
            return JsonNull();
        }
    }

    json jDex = GffGetByte(jCreature, "Dex");
    if (jDex != JsonNull())
    {
        int nNewDex = JsonGetInt(jDex) + dexMod;
        if (nNewDex < 1) nNewDex = 1;
        if (nNewDex > 255) nNewDex = 255;
        
        jCreature = GffReplaceByte(jCreature, "Dex", nNewDex);
        if (jCreature == JsonNull())
        {
            if(DEBUG) DoDebug("prc_inc_json >> json_AdjustCreatureSize: Failed to update Dex");
            return JsonNull();
        }
    }

    json jCon = GffGetByte(jCreature, "Con");
    if (jCon != JsonNull())
    {
        int nNewCon = JsonGetInt(jCon) + conMod;
        if (nNewCon < 1) nNewCon = 1;
        if (nNewCon > 255) nNewCon = 255;
        
        jCreature = GffReplaceByte(jCreature, "Con", nNewCon);
        if (jCreature == JsonNull())
        {
            if(DEBUG) DoDebug("prc_inc_json >> json_AdjustCreatureSize: Failed to update Con");
            return JsonNull();
        }
    }

    // Update Natural AC
    json jNaturalAC = GffGetByte(jCreature, "NaturalAC");
    if (jNaturalAC != JsonNull())
    {
        int nCurrentNA = JsonGetInt(jNaturalAC);
        if(DEBUG) DoDebug("prc_inc_json >> json_AdjustCreatureSize: Current NaturalAC: " + IntToString(nCurrentNA));
        
        int nNewNA = nCurrentNA + naturalAC;
        if (nNewNA < 0) nNewNA = 0;
        if (nNewNA > 255) nNewNA = 255;
        
        jCreature = GffReplaceByte(jCreature, "NaturalAC", nNewNA);
        if (jCreature == JsonNull())
        {
            if(DEBUG) DoDebug("prc_inc_json >> json_AdjustCreatureSize: Failed to update NaturalAC");
            return JsonNull();
        }
    }

    // Adjust all Dexterity-based skills by finding them in skills.2da
    if(DEBUG) DoDebug("prc_inc_json >> json_AdjustCreatureSize: Adjusting DEX-based skills");
    
    int nSkillID = 0;
    while (TRUE)
    {
        string sKeyAbility = Get2DAString("skills", "KeyAbility", nSkillID);
        
        // Break when we've reached the end of skills
        if (sKeyAbility == "")
            break;
        
        // If this skill uses Dexterity, adjust it
        if (sKeyAbility == "DEX")
        {
            string sSkillLabel = Get2DAString("skills", "Label", nSkillID);
            if(DEBUG) DoDebug("prc_inc_json >> json_AdjustCreatureSize: Adjusting DEX skill: " + sSkillLabel + " (ID: " + IntToString(nSkillID) + ")");
            
            jCreature = json_AdjustCreatureSkillByID(jCreature, nSkillID, dexSkillMod);
            if (jCreature == JsonNull())
            {
                if(DEBUG) DoDebug("prc_inc_json >> json_AdjustCreatureSize: Failed adjusting skill ID " + IntToString(nSkillID));
                return JsonNull();
            }
        }
        
        nSkillID++;
    }

    if(DEBUG) DoDebug("json_AdjustCreatureSize completed successfully");
    return jCreature;
}

//:: Changes jCreature's creature type.
json JsonModifyRacialType(json jCreature, int nNewRacialType)
{
    if(DEBUG)DoDebug("prc_inc_function >> JsonModifyRacialType: Entering function");
	
	// Retrieve the RacialType field
    json jRacialTypeField = JsonObjectGet(jCreature, "Race");

    if (JsonGetType(jRacialTypeField) == JSON_TYPE_NULL)
    {
        DoDebug("prc_inc_function >> JsonModifyRacialType: JsonGetType error 1: " + JsonGetError(jRacialTypeField));
		//SpeakString("JsonGetType error 1: " + JsonGetError(jRacialTypeField));
        return JsonNull();
    }

    // Retrieve the value to modify
    json jRacialTypeValue = JsonObjectGet(jRacialTypeField, "value");

    if (JsonGetType(jRacialTypeValue) != JSON_TYPE_INTEGER)
    {
        DoDebug("prc_inc_function >> JsonModifyRacialType: JsonGetType error 2: " + JsonGetError(jRacialTypeValue));
		//SpeakString("JsonGetType error 2: " + JsonGetError(jRacialTypeValue));
        return JsonNull();
    }

	jCreature = GffReplaceByte(jCreature, "Race", nNewRacialType);

    // Return the new creature object
    return jCreature;
}


//:: Test void
//:: void main (){}