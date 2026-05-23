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
  
    // Set to 0 to deactivate the contingency  
    SetLocalInt(oPC, "nContingentRez", 0);  
}


/* void main()
{
    object oPC = GetPCSpeaker();
    int nSlotsUsed = GetLocalInt(oPC, "nContingentRez");

    // Restore all used slots
    while(nSlotsUsed-- > 0)
        RestoreSpellSlotForCaster(oPC);

    SetLocalInt(oPC, "nContingentRez", 0);
}
 */