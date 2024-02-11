/*:://////////////////////////////////////////////
//:: Spell Name Dominate Person
//:: Spell FileName PHS_S_DomPerson
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Brd 4, Sor/Wiz 5
    Components: V, S
    Casting Time: 1 round
    Range: Close (8M)
    Target: One humanoid
    Duration: One day/level
    Saving Throw: Will negates
    Spell Resistance: Yes

    Description.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    NO DOMINATION UNTIL I KNOW HOW EffectDomination/CutseenDomination WORKS

    Placeholder script.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DOMINATE_PERSON)) return;

}
