//:://////////////////////////////////////////////
//:: FileName: "at_contre1_reset"
/*   Purpose: Dispels any active Contingent Reunion One's cast by oPC.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();
    DeleteLocalInt(oPC, "nContingentReunion1");
}
