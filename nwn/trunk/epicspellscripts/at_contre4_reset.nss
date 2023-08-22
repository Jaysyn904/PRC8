//:://////////////////////////////////////////////
//:: FileName: "at_contre4_reset"
/*   Purpose: Dispels any active Contingent Reunion Four's cast by oPC.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();
    DeleteLocalInt(oPC, "nContingentReunion4");
}
