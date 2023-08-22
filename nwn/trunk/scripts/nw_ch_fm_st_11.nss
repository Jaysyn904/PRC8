#include "prc_inc_switch"

int StartingConditional()
{
    if(GetCurrentHitPoints() == GetMaxHitPoints()
    || GetPRCSwitch(PRC_PNP_FAMILIAR_FEEDING))
        return TRUE;

    return FALSE;
}