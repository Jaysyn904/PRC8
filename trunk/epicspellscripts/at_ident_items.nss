//:://////////////////////////////////////////////
//:: FileName: "at_ident_items"
/*   Purpose: This goes into the OnPlayerRest's conversation node in the
        ActionTaken tab for the "I'll try to ID my items." selection.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 13, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"


void main()
{
    object oPC = GetPCSpeaker();
    AssignCommand(oPC, TryToIDItems());
}
