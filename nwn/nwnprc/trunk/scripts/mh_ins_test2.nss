#include "nw_i0_plot"
int StartingConditional()
{
    if ( GetGold(GetPCSpeaker()) >= 7500 && plotCanRemoveXP(GetPCSpeaker(), 600) == TRUE )
        return TRUE ;
    return FALSE;
}
