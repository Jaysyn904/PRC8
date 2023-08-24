//:://////////////////////////////////////////////
//:: FileName: "at_contre5_reset"
/*   Purpose: Dispels any active Contingent Reunion Five's cast by oPC.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();
    DeleteLocalInt(oPC, "nContingentReunion5");
}
