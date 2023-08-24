//::///////////////////////////////////////////////
//:: Soulknife: Conversation - Toggle Soulbreaker
//:: psi_sk_conv_so_a
//::///////////////////////////////////////////////
/*
    Adds or removes Soulbreaker from the mindblade
    flags.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 06.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"


void main()
{
    SetLocalInt(GetPCSpeaker(), MBLADE_FLAGS + "_T",
                GetLocalInt(GetPCSpeaker(), MBLADE_FLAGS + "_T") ^ MBLADE_FLAG_SOULBREAKER
               );
}
