//::///////////////////////////////////////////////
//:: Fist of Hextor
//:: prc_hextor.nss
//:://////////////////////////////////////////////
//:: Applies Fist of Hextor Bonuses
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: April 20, 2004
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    // Clean up, then do attack and damage added as effects by SPELL_HEXTOR_DAMAGE
    PRCRemoveEffectsFromSpell(OBJECT_SELF, SPELL_HEXTOR_DAMAGE);
    ActionCastSpellOnSelf(SPELL_HEXTOR_DAMAGE);
}