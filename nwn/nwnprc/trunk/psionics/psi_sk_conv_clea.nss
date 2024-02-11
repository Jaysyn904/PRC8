//::///////////////////////////////////////////////
//:: Soulknife: Conversation - Cleanup
//:: psi_sk_conv_clean
//::///////////////////////////////////////////////
/*
    Removes the temporary locals used during
    mindblade enhancement convo.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 06.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"


void main()
{
    DeleteLocalInt(GetPCSpeaker(), MBLADE_FLAGS + "_T");
}