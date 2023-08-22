//:://////////////////////////////////////////////
//:: FileName: "sc_contreu3_yes"
/*   Purpose: Returns TRUE if GetPCSpeaker() has a Contingent Reunion Three
        active.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetLocalInt(oPC, "nContingentReunion3") > 0)
        return TRUE;
    return FALSE;
}
