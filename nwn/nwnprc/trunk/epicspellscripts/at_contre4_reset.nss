//:://////////////////////////////////////////////
//:: FileName: "at_contre4_reset"
/*   Purpose: Dispels any active Contingent Reunion Four's cast by oPC.
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
      
    // Restore the spell slot used by this contingency  
    RestoreSpellSlotForCaster(oPC);  
      
    DeleteLocalInt(oPC, "nContingentReunion4");  
}
