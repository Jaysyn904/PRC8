//:://////////////////////////////////////////////
//:: FileName: "sc_epicradial_ok"
/*   Purpose: Starting conditional check to make sure player has 7 or less
        spells assigned to their epic spell radial menu (prevents CRASH)
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"

int StartingConditional()
{
    if (GetCastableFeatCount(GetPCSpeaker()) < 7)
        return TRUE;
    return FALSE;
}
