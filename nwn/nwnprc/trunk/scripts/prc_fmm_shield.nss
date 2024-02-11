#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    if(!TakeSwiftAction(oPC)) return;
    ActionCastSpell(SPELL_SHIELD);
}