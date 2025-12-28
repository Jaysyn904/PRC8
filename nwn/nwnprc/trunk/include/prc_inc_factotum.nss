/*
 * Factotum general functions handling.
 *
 * @author Stratovarius - 2019.12.21
 */

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

/**
 * Stores SpellIds for Arcane Dilettante 
 *
 * @param oPC         PC to target
 * @param nSpell      SpellID to store                     
 */
void PrepareArcDilSpell(object oPC, int nSpell);

/**
 * Returns TRUE if there are more spells to learn
 *
 * @param oPC         PC to target                     
 */
void PrepareArcDilSpell(object oPC, int nSpell);

//////////////////////////////////////////////////
/* Constants                                    */
//////////////////////////////////////////////////

const int FACTOTUM_SLOT_1 = 3887;
const int FACTOTUM_SLOT_2 = 3888;
const int FACTOTUM_SLOT_3 = 3889;
const int FACTOTUM_SLOT_4 = 3890;
const int FACTOTUM_SLOT_5 = 3891;
const int FACTOTUM_SLOT_6 = 3892;
const int FACTOTUM_SLOT_7 = 3893;
const int FACTOTUM_SLOT_8 = 3894;

const int BRILLIANCE_SLOT_1 = 3917;
const int BRILLIANCE_SLOT_2 = 3918;
const int BRILLIANCE_SLOT_3 = 3919;

//////////////////////////////////////////////////
/* Include section                              */
//////////////////////////////////////////////////

#include "prc_inc_function"

//////////////////////////////////////////////////
/* Function definitions                         */
//////////////////////////////////////////////////
void TriggerInspiration(object oPC, int nCombat);


void PrepareArcDilSpell(object oPC, int nSpell)
{
	if (DEBUG) DoDebug("PrepareArcDilSpell "+IntToString(nSpell));
	int nClass = GetLevelByClass(CLASS_TYPE_FACTOTUM, oPC);
	
	// Done like this because you can only have a certain amount at a given level
	if (!GetLocalInt(oPC, "ArcDilSpell1") && nClass >= 2) SetLocalInt(oPC, "ArcDilSpell1", nSpell);
	else if (!GetLocalInt(oPC, "ArcDilSpell2") && nClass >= 4) SetLocalInt(oPC, "ArcDilSpell2", nSpell);
	else if (!GetLocalInt(oPC, "ArcDilSpell3") && nClass >= 7) SetLocalInt(oPC, "ArcDilSpell3", nSpell);
	else if (!GetLocalInt(oPC, "ArcDilSpell4") && nClass >= 9) SetLocalInt(oPC, "ArcDilSpell4", nSpell);
	else if (!GetLocalInt(oPC, "ArcDilSpell5") && nClass >= 12) SetLocalInt(oPC, "ArcDilSpell5", nSpell);
	else if (!GetLocalInt(oPC, "ArcDilSpell6") && nClass >= 14) SetLocalInt(oPC, "ArcDilSpell6", nSpell);
	else if (!GetLocalInt(oPC, "ArcDilSpell7") && nClass >= 17) SetLocalInt(oPC, "ArcDilSpell7", nSpell);
	else if (!GetLocalInt(oPC, "ArcDilSpell8") && nClass >= 20) SetLocalInt(oPC, "ArcDilSpell8", nSpell);
}

int GetMaxLearnedArcDil(object oPC)
{
	int nClass = GetLevelByClass(CLASS_TYPE_FACTOTUM, oPC);
	int nCount, nMax;
	if (GetLocalInt(oPC, "ArcDilSpell1")) nCount++;
	if (GetLocalInt(oPC, "ArcDilSpell2")) nCount++;
	if (GetLocalInt(oPC, "ArcDilSpell3")) nCount++;
	if (GetLocalInt(oPC, "ArcDilSpell4")) nCount++;
	if (GetLocalInt(oPC, "ArcDilSpell5")) nCount++;
	if (GetLocalInt(oPC, "ArcDilSpell6")) nCount++;
	if (GetLocalInt(oPC, "ArcDilSpell7")) nCount++;
	if (GetLocalInt(oPC, "ArcDilSpell8")) nCount++;	
	
	if(nClass >= 2) nMax++;
	if(nClass >= 4) nMax++;
	if(nClass >= 7) nMax++;
	if(nClass >= 9) nMax++;
	if(nClass >= 12) nMax++;
	if(nClass >= 14) nMax++;
	if(nClass >= 17) nMax++;
	if(nClass >= 20) nMax++;
	
	int nReturn = FALSE;
	if (nMax > nCount) nReturn = TRUE;
	
	return nReturn;
}

int GetFactotumSlot(object oPC)
{
	int nSlot = PRCGetSpellId();
	if (nSlot == FACTOTUM_SLOT_1) return GetLocalInt(oPC, "ArcDilSpell1");
	if (nSlot == FACTOTUM_SLOT_2) return GetLocalInt(oPC, "ArcDilSpell2");
	if (nSlot == FACTOTUM_SLOT_3) return GetLocalInt(oPC, "ArcDilSpell3");
	if (nSlot == FACTOTUM_SLOT_4) return GetLocalInt(oPC, "ArcDilSpell4");
	if (nSlot == FACTOTUM_SLOT_5) return GetLocalInt(oPC, "ArcDilSpell5");
	if (nSlot == FACTOTUM_SLOT_6) return GetLocalInt(oPC, "ArcDilSpell6");
	if (nSlot == FACTOTUM_SLOT_7) return GetLocalInt(oPC, "ArcDilSpell7");
	if (nSlot == FACTOTUM_SLOT_8) return GetLocalInt(oPC, "ArcDilSpell8");
	
	if (nSlot == BRILLIANCE_SLOT_1) return GetLocalInt(oPC, "CunningAbility1");
	if (nSlot == BRILLIANCE_SLOT_2) return GetLocalInt(oPC, "CunningAbility2");
	if (nSlot == BRILLIANCE_SLOT_3) return GetLocalInt(oPC, "CunningAbility3");	
	
	return -1;
}

void CheckFactotumSlots(object oPC)
{
	int i;
    for (i = 1; i <= 8; i++)
    {
    	string sSpell = "ArcDilSpell";
		int nSpell = GetLocalInt(oPC, sSpell+IntToString(i));
		sSpell = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpell)));
		
		if (nSpell > 0) FloatingTextStringOnCreature("Arcane Dilettante Slot "+IntToString(i)+" is "+sSpell, oPC, FALSE);
    }
}  

void CheckBrillianceSlots(object oPC)
{
	int i;
    for (i = 1; i <= 3; i++)
    {
    	string sSpell = "CunningAbility";
		int nSpell = GetLocalInt(oPC, sSpell+IntToString(i));
		sSpell = GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nSpell)));
		
		if (nSpell > 0) FloatingTextStringOnCreature("Cunning Brilliance Slot "+IntToString(i)+" is "+sSpell, oPC, FALSE);
    }
} 

void ClearFactotumSlots(object oPC)
{
	int i;
    for (i = 1; i <= 50; i++)
    {
		DeleteLocalInt(oPC, "ArcDilSpell"+IntToString(i));
		DeleteLocalInt(oPC, "CunningKnowledge"+IntToString(i));
		DeleteLocalInt(oPC, "CunningAbility"+IntToString(i));
    }
    DeleteLocalInt(oPC, "CunningBrillianceCount");
    DeleteLocalInt(oPC, "CunningBrilliance");
} 

int GetMaxArcDilSpellLevel(object oPC)
{
	int nClass = GetLevelByClass(CLASS_TYPE_FACTOTUM, oPC);
	int nMax = -1;
	
	if(nClass >= 18) nMax = 7;
	else if(nClass >= 15) nMax = 6;
	else if(nClass >= 13) nMax = 5;
	else if(nClass >= 10) nMax = 4;
	else if(nClass >= 8) nMax = 3;
	else if(nClass >= 5) nMax = 2;
	else if(nClass >= 3) nMax = 1;
	else if(nClass >= 2) nMax = 0;
	
	if (DEBUG) DoDebug("GetMaxArcDilSpellLevel "+IntToString(nMax));
	
	return nMax;
}

void SetInspiration(object oPC)
{
	int nInspiration = 2;
	int nClass = GetLevelByClass(CLASS_TYPE_FACTOTUM, oPC);
	
	if(nClass >= 20) nInspiration = 10;
	else if(nClass >= 17) nInspiration = 8;
	else if(nClass >= 14) nInspiration = 7;
	else if(nClass >= 11) nInspiration = 6;
	else if(nClass >= 8) nInspiration = 5;
	else if(nClass >= 5) nInspiration = 4;
	else if(nClass >= 2) nInspiration = 3;	

    int i, nFont;
    for(i = FEAT_FONT_INSPIRATION_1; i <= FEAT_FONT_INSPIRATION_10; i++)
        if(GetHasFeat(i, oPC)) nFont++;

    //nInspiration += nFont * (1 + nFont + 1) / 2;	
	nInspiration += nFont * (nFont + 1) / 2;
	SetLocalInt(oPC, "InspirationPool", nInspiration);
	FloatingTextStringOnCreature("Encounter begins with "+IntToString(nInspiration)+" inspiration", oPC, FALSE);
}	

void ClearInspiration(object oPC)
{
	DeleteLocalInt(oPC, "InspirationPool");
	FloatingTextStringOnCreature("Encounter ends, inspiration lost", oPC, FALSE);
}	

int ExpendInspiration(object oPC, int nCost)
{
	if (nCost <= 0) return FALSE;
	
	int nInspiration = GetLocalInt(oPC, "InspirationPool");
	if (nInspiration >= nCost)
	{
		SetLocalInt(oPC, "InspirationPool", nInspiration-nCost);
		FloatingTextStringOnCreature("You have "+IntToString(nInspiration-nCost)+" inspiration remaining this encounter", oPC, FALSE);
		return TRUE;
	}

	FloatingTextStringOnCreature("You do not have enough inspiration", oPC, FALSE);
	return FALSE;
}	

void MarkAbilitySaved(object oPC, int nAbil)
{
	if (DEBUG) DoDebug("MarkAbilitySaved nAbil is "+IntToString(nAbil));

	if (!GetLocalInt(oPC, "CunningAbility1")) SetLocalInt(oPC, "CunningAbility1", nAbil);
	else if (!GetLocalInt(oPC, "CunningAbility2")) SetLocalInt(oPC, "CunningAbility2", nAbil);
	else if (!GetLocalInt(oPC, "CunningAbility3")) SetLocalInt(oPC, "CunningAbility3", nAbil);
}

int GetIsAbilitySaved(object oPC, int nAbil)
{
	int i, nCount, nTest;
    for (i = 0; i <= 3; i++)
    {
		nTest = GetLocalInt(oPC, "CunningAbility"+IntToString(i));
		if (nTest == nAbil) 
			nCount = TRUE;	
    }
    if (DEBUG) DoDebug("GetIsAbilitySaved is "+IntToString(nCount));
    return nCount;
}

void FactotumTriggerAbil(object oPC, int nAbil)
{
	object oSkin = GetPCSkin(oPC);
	itemproperty ipIP;
	if (nAbil == FEAT_BARBARIAN_RAGE)
		ExecuteScript("NW_S1_BarbRage", oPC);
	else if (nAbil == FEAT_BARBARIAN_ENDURANCE)
    	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_BarbEndurance);
    else if (nAbil == FEAT_SNEAK_ATTACK)
    {
    	SetLocalInt(oPC, "FactotumSneak", TRUE);
    	DelayCommand(0.1, ExecuteScript("prc_sneak_att", oPC));   
		DelayCommand(59.9, DeleteLocalInt(oPC, "FactotumSneak"));
    	DelayCommand(60.0, ExecuteScript("prc_sneak_att", oPC));    	
    }
    else if (nAbil == 3665) // Mettle
    {
    	SetLocalInt(oPC, "FactotumMettle", TRUE);
    	DelayCommand(60.0, DeleteLocalInt(oPC, "FactotumMettle"));
    }
	else if (nAbil == FEAT_CRUSADER_SMITE)
    	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_CRUSADER_SMITE);
    	
    IPSafeAddItemProperty(oSkin, ipIP, 60.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 	
}

void TriggerInspiration(object oPC, int nCombat)
{
	SetLocalInt(oPC, "InspirationHBRunning", TRUE);
	DelayCommand(0.249, DeleteLocalInt(oPC, "InspirationHBRunning"));
	int nCurrent = GetIsInCombat(oPC);
	// We just entered combat
	if (nCurrent == TRUE && nCombat == FALSE)
		SetInspiration(oPC);
	else if (nCurrent == FALSE && nCombat == TRUE) // Just left combat
		ClearInspiration(oPC);
 
    DelayCommand(0.25, TriggerInspiration(oPC, nCurrent));
}


/*void AddCunningBrillianceAbility(object oPC, int nAbil)
{
	if (DEBUG) DoDebug("AddCunningBrillianceAbility "+IntToString(nAbil));
	
	object oSkin = GetPCSkin(oPC);
	itemproperty ipIP;

	if (nAbil == FEAT_BARBARIAN_ENDURANCE)
    	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_BarbEndurance);
 	else if (nAbil == FEAT_BARBARIAN_RAGE)
    	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_RAGE);   
    
    IPSafeAddItemProperty(oSkin, ipIP, 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
    MarkAbilitySaved(oPC, nAbil);
}
*/
