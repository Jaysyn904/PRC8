/*:://////////////////////////////////////////////
//:: Spell Name Consecrate: On Exit
//:: Spell FileName PHS_S_ConsecratB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    It removes the "alter or thingy to thier god for bonuses" and stuff, 'cause
    it is too complicated otherwise (and utterly pointless in most cases).

    Effects applied OnEnter, and removed OnExit.

    On Exit: Remove:
    - Duration effect always
    - -1 attack, damage, saves if undead too.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_CONSECRATE);
}
