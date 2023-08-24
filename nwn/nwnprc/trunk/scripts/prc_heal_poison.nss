/*
    Healer's Remove Poison
*/
#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    // This is all it does.
    DoRacialSLA(SPELL_NEUTRALIZE_POISON, GetHitDice(OBJECT_SELF));
}