//::///////////////////////////////////////////////
//:: [Knight of the Chalice Feats]
//:: [prc_knghtch.nss]
//:://////////////////////////////////////////////
//:: Check to see which Knight of the Chalice feats
//:: a creature has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    // Everything is handled by the spell's script.
    ActionCastSpellOnSelf(SPELL_KNIGHTCHALICE_DAMAGE); //prc_knight_dam.nss, Applies attack and damage bonus.
}
