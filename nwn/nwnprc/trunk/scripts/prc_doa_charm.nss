//::///////////////////////////////////////////////
//:: Disciple of Asmodeus Charm Person
//:: prc_doa_charm.nss
//::///////////////////////////////////////////////
/*
    Charm Person as the spell, 1/Day
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 27.2.2006
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    object oPC = OBJECT_SELF;
    // That was easy
    ActionCastSpell(SPELL_CHARM_PERSON);
}