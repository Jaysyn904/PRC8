//:://////////////////////////////////////////////
//:: FileName: "sc_contreu4_yes"
/*   Purpose: Returns TRUE if GetPCSpeaker() has a Contingent Reunion Four
        active.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetLocalInt(oPC, "nContingentReunion4") > 0)
        return TRUE;
    return FALSE;
}
