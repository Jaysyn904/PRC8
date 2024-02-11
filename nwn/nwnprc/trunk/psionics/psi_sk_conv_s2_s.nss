//::///////////////////////////////////////////////
//:: Soulknife: Conversation - Show Shield of Thought +2
//:: psi_sk_conv_s2_s
//::///////////////////////////////////////////////
/*
    Checks whether to show Shield of Thought +2 and 
    whether it is to be added or removed.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 15, 2008
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"


int StartingConditional()
{
    int nReturn; // Implicit init to FALSE
    // Check if the flag is already present
    if(GetLocalInt(GetPCSpeaker(), MBLADE_FLAGS + "_T") & MBLADE_FLAG_SHIELD_2)
    {
        SetCustomToken(116, GetStringByStrRef(7654)); // Remove
        nReturn = TRUE;
    }
    // It isn't, so see if there is enough bonus left to add it
    else if(GetTotalEnhancementCost(GetLocalInt(GetPCSpeaker(), MBLADE_FLAGS + "_T")) + GetFlagCost(MBLADE_FLAG_SHIELD_2) <= GetMaxEnhancementCost(GetPCSpeaker()))
    {
        SetCustomToken(116, GetStringByStrRef(62476)); // Add
        nReturn = TRUE;
    }
    
    if(!GetHasFeat(FEAT_SHIELD_OF_THOUGHT, GetPCSpeaker()))
    {
        nReturn = FALSE;
    }
    
    return nReturn;
}
