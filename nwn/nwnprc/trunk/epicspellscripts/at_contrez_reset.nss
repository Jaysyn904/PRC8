//:://////////////////////////////////////////////
//:: FileName: "at_contrez_reset"
/*   Purpose: Dispels any active Contingent Resurrections cast by oPC.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_epicspells"


void main()
{
    object oPC = GetPCSpeaker();
    int nSlotsUsed = GetLocalInt(oPC, "nContingentRez");

    // Restore all used slots
    while(nSlotsUsed-- > 0)
        RestoreSpellSlotForCaster(oPC);

    SetLocalInt(oPC, "nContingentRez", 0);
}
