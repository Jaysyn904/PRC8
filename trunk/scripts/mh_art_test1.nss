//::///////////////////////////////////////////////
//:: mh_con_test1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks to see if you have enough gold
    to create the potion (Soin Leger).
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "nw_i0_plot"
int StartingConditional()
{
    if ( GetGold(GetPCSpeaker()) >= 10 && plotCanRemoveXP(GetPCSpeaker(), 1) == TRUE )
        return TRUE ;
    return FALSE;
}
