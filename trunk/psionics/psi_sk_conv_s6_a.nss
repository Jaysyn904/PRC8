//::///////////////////////////////////////////////
//:: Soulknife: Conversation - Toggle Shield +6
//:: psi_sk_conv_s6_a
//::///////////////////////////////////////////////
/*
    Adds or removes Shield of Thought +6 from the 
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
                GetLocalInt(GetPCSpeaker(), MBLADE_FLAGS + "_T") ^ MBLADE_FLAG_SHIELD_6
               );
}
