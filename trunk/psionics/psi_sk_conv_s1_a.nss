//::///////////////////////////////////////////////
//:: Soulknife: Conversation - Toggle Shield +1
//:: psi_sk_conv_s1_a
//::///////////////////////////////////////////////
/*
    Adds or removes Shield of Thought +1 from the 
    mindblade flags.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 15, 2008
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"


void main()
{
    SetLocalInt(GetPCSpeaker(), MBLADE_FLAGS + "_T",
                GetLocalInt(GetPCSpeaker(), MBLADE_FLAGS + "_T") ^ MBLADE_FLAG_SHIELD_1
               );
}
