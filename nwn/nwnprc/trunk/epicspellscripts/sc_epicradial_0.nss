//:://////////////////////////////////////////////
//:: FileName: "sc_epicradial_0"
/*   Purpose: Starting conditional that returns FALSE if no spells are on radial
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"

int StartingConditional()
{
    if (GetCastableFeatCount(GetPCSpeaker()) != 0)
        return TRUE;
    return FALSE;
}
