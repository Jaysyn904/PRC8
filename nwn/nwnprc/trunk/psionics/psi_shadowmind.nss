//::///////////////////////////////////////////////
//:: Shadowmind
//:: psi_shadowmind.nss
//:://////////////////////////////////////////////
//:: Adds the powers to the Shadowmind
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: March 6, 2006
//:://////////////////////////////////////////////

#include "psi_inc_powknown"

int GetPowerRowID(int nClass, int nPower)
{
	string sPowerFile = GetAMSDefinitionFileName(nClass);
	int nCheck = -1;
	int i;
	for(i = 0; i < GetPRCSwitch(FILE_END_CLASS_POWER) ; i++)
	{
		nCheck = StringToInt(Get2DACache(sPowerFile, "RealSpellID", i));
		
		// Find the row ID of the power we need and return it
		if(nCheck == nPower)
		{
		    return i;
		}

	}
	// this should never trigger
	return -1;
}

void main()
{
    object oPC = OBJECT_SELF;
    int nClass = GetPrimaryPsionicClass(oPC);
    int nPowerTotal = GetKnownPowersModifier(oPC, nClass);

    // Determine why this script is running
    if(GetRunningEvent() != EVENT_ONPLAYERLEVELDOWN)
    {
        // Adding Distract if the Shadowmind is level 1 in the class or greater
        if (GetLevelByClass(CLASS_TYPE_SHADOWMIND,oPC) >= 1 &&
           !GetPersistantLocalInt(oPC, "PRC_Shadowmind_DistractGained")
            )
        {
            if(DEBUG) DoDebug("psi_shadowmind: Adding Distract");
            AddPowerKnown(oPC, nClass, GetPowerRowID(nClass, POWER_DISTRACT), TRUE, GetHitDice(oPC));
            SetKnownPowersModifier(oPC, nClass, ++nPowerTotal);
            SetPersistantLocalInt(oPC, "PRC_Shadowmind_DistractGained", TRUE);
        }
        // Adding Cloud Mind if the Shadowmind is level 3 in the class or greater
        if (GetLevelByClass(CLASS_TYPE_SHADOWMIND,oPC) >= 3 &&
            !GetPersistantLocalInt(oPC, "PRC_Shadowmind_CloudMindGained")
            )
        {
            if(DEBUG) DoDebug("psi_shadowmind: Adding Cloud Mind");
            AddPowerKnown(oPC, nClass, GetPowerRowID(nClass, POWER_CLOUD_MIND), TRUE, GetHitDice(oPC));
            SetKnownPowersModifier(oPC, nClass, ++nPowerTotal);
            SetPersistantLocalInt(oPC, "PRC_Shadowmind_CloudMindGained", TRUE);
        }
        // Adding Cloud Mind, Mass if the Shadowmind is level 3 in the class or greater
        if (GetLevelByClass(CLASS_TYPE_SHADOWMIND,oPC) >= 9 &&
            !GetPersistantLocalInt(oPC, "PRC_Shadowmind_CloudMindMassGained")
            )
        {
            if(DEBUG) DoDebug("psi_shadowmind: Adding Cloud Mind, Mass");
            AddPowerKnown(oPC, nClass, GetPowerRowID(nClass, POWER_CLOUD_MIND_MASS), TRUE, GetHitDice(oPC));
            SetKnownPowersModifier(oPC, nClass, ++nPowerTotal);
            SetPersistantLocalInt(oPC, "PRC_Shadowmind_CloudMindMassGained", TRUE);
        }        

        // Hook to OnLevelDown to remove the power slots granted here
        AddEventScript(oPC, EVENT_ONPLAYERLEVELDOWN, "psi_shadowmind", TRUE, FALSE);
    }
    else
    {
        // Has lost Distract, but the slot is still present
        if(GetPersistantLocalInt(oPC, "PRC_Shadowmind_DistractGained") &&
           GetLevelByClass(CLASS_TYPE_SHADOWMIND,oPC) < 1
           )
        {
            DeletePersistantLocalInt(oPC, "PRC_Shadowmind_DistractGained");
            SetKnownPowersModifier(oPC, nClass, --nPowerTotal);
        }
        // Has lost Cloud Mind, but the slot is still present
        if(GetPersistantLocalInt(oPC, "PRC_Shadowmind_CloudMindGained") &&
           GetLevelByClass(CLASS_TYPE_SHADOWMIND,oPC) < 3
           )
        {
            DeletePersistantLocalInt(oPC, "PRC_Shadowmind_CloudMindGained");
            SetKnownPowersModifier(oPC, nClass, --nPowerTotal);
        }
        // Has lost Cloud Mind, Mass, but the slot is still present
        if(GetPersistantLocalInt(oPC, "PRC_Shadowmind_CloudMindMassGained") &&
           GetLevelByClass(CLASS_TYPE_SHADOWMIND,oPC) < 9
           )
        {
            DeletePersistantLocalInt(oPC, "PRC_Shadowmind_CloudMindMassGained");
            SetKnownPowersModifier(oPC, nClass, --nPowerTotal);
        }        

        // Remove eventhook if the character no longer has levels in Shadowmind
        if(GetLevelByClass(CLASS_TYPE_SHADOWMIND,oPC) == 0)
            RemoveEventScript(oPC, EVENT_ONPLAYERLEVELDOWN, "psi_shadowmind", TRUE, FALSE);
    }
}