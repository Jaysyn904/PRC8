/*
    Healer's Regenerate
*/
#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    // This is all it does.
    DoRacialSLA(SPELL_REGENERATE, GetHitDice(OBJECT_SELF));
}