//:://////////////////////////////////////////////
//:: FileName: "at_contre0_reset"
/*   Purpose: Dispels any active Contingent Reunion Zero's cast by oPC.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();
    DeleteLocalInt(oPC, "nContingentReunion0");
}
