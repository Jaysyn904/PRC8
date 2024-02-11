//::///////////////////////////////////////////////
//:: Soulknife: Conversation - Show Wounding
//:: psi_sk_conv_wo_s
//::///////////////////////////////////////////////
/*
    Checks whether to show Wounding and whether
    it is to be added or removed.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 06.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"


int StartingConditional()
{
    int nReturn; // Implicit init to FALSE
    // Check if the flag is already present
    if(GetLocalInt(GetPCSpeaker(), MBLADE_FLAGS + "_T") & MBLADE_FLAG_WOUNDING)
    {
        SetCustomToken(112, GetStringByStrRef(7654)); // Remove
        nReturn = TRUE;
    }
    // It isn't, so see if there is enough bonus left to add it
    else if(GetTotalEnhancementCost(GetLocalInt(GetPCSpeaker(), MBLADE_FLAGS + "_T")) + GetFlagCost(MBLADE_FLAG_WOUNDING) <= GetMaxEnhancementCost(GetPCSpeaker()))
    {
        SetCustomToken(112, GetStringByStrRef(62476)); // Add
        nReturn = TRUE;
    }
    
    return nReturn;
}
