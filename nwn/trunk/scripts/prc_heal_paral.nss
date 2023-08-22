/*
    Healer's Remove Paralysis
*/
#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    // This is all it does.
    DoRacialSLA(SPELL_REMOVE_PARALYSIS, GetHitDice(OBJECT_SELF));
}