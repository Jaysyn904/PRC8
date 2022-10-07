//:://////////////////////////////////////////////
//:: FileName: "sc_contreu0_yes"
/*   Purpose: Returns TRUE if GetPCSpeaker() has a Contingent Reunion Zero
        active.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetLocalInt(oPC, "nContingentReunion0") > 0)
        return TRUE;
    return FALSE;
}
