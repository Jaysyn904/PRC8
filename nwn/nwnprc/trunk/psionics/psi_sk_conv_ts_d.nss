//::///////////////////////////////////////////////
//:: Soulknife: Conversation - Show Shield of Thought desc
//:: psi_sk_conv_ts_d
//::///////////////////////////////////////////////
/*
    Checks whether to show Shield of Thought desc.
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
    if(GetHasFeat(FEAT_SHIELD_OF_THOUGHT, GetPCSpeaker()))
    {
        nReturn = TRUE;
    }
    
    return nReturn;
}
