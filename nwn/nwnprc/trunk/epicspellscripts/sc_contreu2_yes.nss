//:://////////////////////////////////////////////
//:: FileName: "sc_contreu2_yes"
/*   Purpose: Returns TRUE if GetPCSpeaker() has a Contingent Reunion Two
        active.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetLocalInt(oPC, "nContingentReunion2") > 0)
        return TRUE;
    return FALSE;
}
