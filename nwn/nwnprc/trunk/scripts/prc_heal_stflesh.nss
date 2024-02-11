/*
    Healer's Stone to Flesh
*/
#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    // This is all it does.
    DoRacialSLA(SPELL_STONE_TO_FLESH, GetHitDice(OBJECT_SELF));
}