/*
    Healer's Remove Disease
*/
#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    // This is all it does.
    DoRacialSLA(SPELL_REMOVE_DISEASE, GetHitDice(OBJECT_SELF));
}