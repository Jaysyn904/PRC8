//:://////////////////////////////////////////////
//:: FileName: "sc_contreu1_yes"
/*   Purpose: Returns TRUE if GetPCSpeaker() has a Contingent Reunion One
        active.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetLocalInt(oPC, "nContingentReunion1") > 0)
        return TRUE;
    return FALSE;
}
