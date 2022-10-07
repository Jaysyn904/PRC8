/*
    Healer's Remove Blindness/Deafness
*/
#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    // This is all it does.
    DoRacialSLA(SPELL_REMOVE_BLINDNESS_AND_DEAFNESS, GetHitDice(OBJECT_SELF));
}