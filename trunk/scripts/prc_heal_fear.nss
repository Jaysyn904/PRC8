/*
    Healer's Remove Fear
*/
#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    // This is all it does.
    DoRacialSLA(SPELL_REMOVE_FEAR, GetHitDice(OBJECT_SELF));
}