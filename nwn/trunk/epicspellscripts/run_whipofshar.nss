//:://////////////////////////////////////////////
//:: FileName: "run_whipofshar"
/*   Purpose: This is the OnItemActivated script for the Whip of Shar item
        greanted to a player who casts the spell of the same name. It starts a
        conversation where the player can choose to destroy the whip, since
        it has lost its bonuses.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank, with credits to Nron Ksr for the spell itself.
//:: Last Updated On: March 17, 2004
//:://////////////////////////////////////////////
void main()
{
    SetLocalObject(OBJECT_SELF, "oWhip", GetItemActivated());
    AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF,
        "whipofshar", TRUE, FALSE));
}
