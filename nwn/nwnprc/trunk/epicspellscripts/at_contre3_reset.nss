//:://////////////////////////////////////////////
//:: FileName: "at_contre3_reset"
/*   Purpose: Dispels any active Contingent Reunion Three's cast by oPC.
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
      
    DeleteLocalInt(oPC, "nContingentReunion3");  
}