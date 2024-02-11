//:://////////////////////////////////////////////
//:: FileName: "sc_contrez_yes"
/*   Purpose: Returns TRUE if GetPCSpeaker() has a Contingent Resurrection
        active.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetLocalInt(oPC, "nContingentRez") > 0)
        return TRUE;
    return FALSE;
}
