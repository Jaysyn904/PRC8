//::///////////////////////////////////////////////
//:: Soulknife: Mindblade Enhancement
//:: psi_sk_mbldenhan
//::///////////////////////////////////////////////
/*
    Starts the conversation to change mindblade
    enhancements.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.04.2005
//:://////////////////////////////////////////////

void main()
{
    AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
    AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF, "psi_sk_mbld_conv", TRUE, FALSE));
}