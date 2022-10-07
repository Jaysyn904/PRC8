/*
    Healer's Resurrection
*/
#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    // This is all it does.
    DoRacialSLA(SPELL_TRUE_RESURRECTION, GetHitDice(OBJECT_SELF));
}