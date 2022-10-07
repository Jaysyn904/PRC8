//::///////////////////////////////////////////////
//:: Thrallherd
//:: psi_thrallherd.nss
//:://////////////////////////////////////////////
//:: Adds the powers to the Thrallherd
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: March 6, 2006
//:://////////////////////////////////////////////

#include "psi_inc_powknown"

void main()
{
    object oPC = OBJECT_SELF;
    int nClass = POWER_LIST_PSION;
    int nPowerTotal = GetKnownPowersModifier(oPC, nClass);

    // Determine why this script is running
    if(GetRunningEvent() != EVENT_ONPLAYERLEVELDOWN)
    {
        // Adding Charm Person if the Thrallherd is level 3 in the class or greater
        if (GetLevelByClass(CLASS_TYPE_THRALLHERD,oPC) >= 3 &&
           !GetPersistantLocalInt(oPC, "PRC_Thrallherd_CharmGained")
            )
        {
            if(DEBUG) DoDebug("psi_thrallherd: Adding Psionic Charm");
            AddPowerKnown(oPC, nClass, 11, TRUE, GetHitDice(oPC));
            SetKnownPowersModifier(oPC, nClass, ++nPowerTotal);
            SetPersistantLocalInt(oPC, "PRC_Thrallherd_CharmGained", TRUE);
        }
        // Adding Dominate if the Thrallherd is level 5 in the class or greater
        if (GetLevelByClass(CLASS_TYPE_THRALLHERD,oPC) >= 5 &&
            !GetPersistantLocalInt(oPC, "PRC_Thrallherd_DominateGained")
            )
        {
            if(DEBUG) DoDebug("psi_thrallherd: Adding Psionic Dominate");
            AddPowerKnown(oPC, nClass, 167, TRUE, GetHitDice(oPC));
            SetKnownPowersModifier(oPC, nClass, ++nPowerTotal);
            SetPersistantLocalInt(oPC, "PRC_Thrallherd_DominateGained", TRUE);
        }

        // Hook to OnLevelDown to remove the power slots granted here
        AddEventScript(oPC, EVENT_ONPLAYERLEVELDOWN, "psi_thrallherd", TRUE, FALSE);
    }
    else
    {
        // Has lost Charm, but the slot is still present
        if(GetPersistantLocalInt(oPC, "PRC_Thrallherd_CharmGained") &&
           GetLevelByClass(CLASS_TYPE_THRALLHERD,oPC) < 3
           )
        {
            DeletePersistantLocalInt(oPC, "PRC_Thrallherd_CharmGained");
            SetKnownPowersModifier(oPC, nClass, --nPowerTotal);
        }
        // Has lost Dominate, but the slot is still present
        if(GetPersistantLocalInt(oPC, "PRC_Thrallherd_DominateGained") &&
           GetLevelByClass(CLASS_TYPE_THRALLHERD,oPC) < 5
           )
        {
            DeletePersistantLocalInt(oPC, "PRC_Thrallherd_DominateGained");
            SetKnownPowersModifier(oPC, nClass, --nPowerTotal);
        }

        // Remove eventhook if the character no longer has levels in Thrallherd
        if(GetLevelByClass(CLASS_TYPE_THRALLHERD,oPC) == 0)
            RemoveEventScript(oPC, EVENT_ONPLAYERLEVELDOWN, "psi_thrallherd", TRUE, FALSE);
    }
}