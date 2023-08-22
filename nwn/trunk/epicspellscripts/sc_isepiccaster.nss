//:://////////////////////////////////////////////
//:: FileName: "sc_isepiccaster"
/*   Purpose: Starting conditional, returns TRUE if the player is an epic caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetIsEpicSpellcaster(oPC))
        return TRUE;
    return FALSE;
}
