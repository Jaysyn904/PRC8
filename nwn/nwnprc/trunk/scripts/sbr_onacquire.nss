//::///////////////////////////////////////////////
//:: Name       Demetrious' Supply Based Rest
//:: FileName   SBR_onacquire
//:://////////////////////////////////////////////
// http://nwvault.ign.com/Files/scripts/data/1055903555000.shtml

// This script should be executed by your module OnAcquireItem event.
#include "prc_alterations"
#include "sbr_include"

void main()
{
    object oItem = GetModuleItemAcquired();
    //object oGiver = GetModuleItemAcquiredFrom();
    object oPC = GetItemPossessor(oItem);
    string sItemTag = GetTag(oItem);

    if(sItemTag == SBR_DM_WIDGET)
    {
        if(!(GetIsDM(oPC) || GetIsDMPossessed(oPC)))
        {
            LogMessage(LOG_PC, oPC, GetName(oItem)+" is a DM only item! Automatically destroying.");
            LogMessage(LOG_FILE_DM_ALL, oPC, GetName(oPC)+" acquired an SBR DM Widget and it was destroyed.");
            DestroyObject(oItem);
        }
    }
    else if (sItemTag == SBR_KIT_WOODLAND)
    {
        int nRang = FALSE;
        // Woodland kits can only be possessed by ranger/druids and DMs.
        if (GetLevelByClass(CLASS_TYPE_RANGER, oPC)>=1)
            nRang = TRUE;
        if (GetLevelByClass(CLASS_TYPE_DRUID, oPC)>=1)
            nRang = TRUE;
        if (GetIsDM(oPC) || GetIsDMPossessed(oPC))
            nRang = TRUE;

        if (!nRang)
        {
            LogMessage(LOG_PC, oPC, "You don't have the skills to use this item.");
            LogMessage(LOG_PC_SERVER, oPC, "OOC: Woodland kits can only be carried by rangers/druids.");
            DestroyObject(oItem);
            CreateKit(oPC, sItemTag, TRUE);
        }
    }
}

