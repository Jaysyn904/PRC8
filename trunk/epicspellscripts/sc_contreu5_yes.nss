//:://////////////////////////////////////////////
//:: FileName: "sc_contreu5_yes"
/*   Purpose: Returns TRUE if GetPCSpeaker() has a Contingent Reunion Five
        active.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetLocalInt(oPC, "nContingentReunion5") > 0)
        return TRUE;
    return FALSE;
}
