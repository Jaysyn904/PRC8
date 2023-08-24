/*
    Healer's Greater Restoration
*/
#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    // This is all it does.
    DoRacialSLA(SPELL_GREATER_RESTORATION, GetHitDice(OBJECT_SELF));
}