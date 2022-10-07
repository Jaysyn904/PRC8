#include "nw_i0_plot"
int StartingConditional()
{
    if ( GetGold(GetPCSpeaker()) >= 25000 && plotCanRemoveXP(GetPCSpeaker(), 2000) == TRUE )
        return TRUE ;
    return FALSE;
}
