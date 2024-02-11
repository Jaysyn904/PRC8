//:://////////////////////////////////////////////
//:: FileName: "at_contre3_reset"
/*   Purpose: Dispels any active Contingent Reunion Three's cast by oPC.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();
    DeleteLocalInt(oPC, "nContingentReunion3");
}
