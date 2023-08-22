/*
    generic maneuver calling function
*/
#include "tob_inc_move"

void main()
{
    UseManeuver(GetPowerFromSpellID(PRCGetSpellId()), MANEUVER_LIST_RETH_DEKALA);
}