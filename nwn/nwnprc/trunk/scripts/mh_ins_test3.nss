#include "nw_i0_plot"
int StartingConditional()
{
    if ( GetGold(GetPCSpeaker()) >= 2500 && plotCanRemoveXP(GetPCSpeaker(), 200) == TRUE )
        return TRUE ;
    return FALSE;
}
