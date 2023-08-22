#include "nw_i0_plot"
int StartingConditional()
{
    if ( GetGold(GetPCSpeaker()) >= 250 && plotCanRemoveXP(GetPCSpeaker(), 20) == TRUE )
        return TRUE ;
    return FALSE;
}
