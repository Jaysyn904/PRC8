//:://////////////////////////////////////////////
//:: FileName: "at_contre2_reset"
/*   Purpose: Dispels any active Contingent Reunion Two's cast by oPC.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();
    DeleteLocalInt(oPC, "nContingentReunion2");
}
