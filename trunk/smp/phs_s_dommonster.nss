/*:://////////////////////////////////////////////
//:: Spell Name Dominate Monster
//:: Spell FileName PHS_S_DomMonster
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Sor/Wiz 9
    Target: One creature

    This spell functions like dominate person, except that the spell is not
    restricted by creature type.
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
    if(!PHS_SpellHookCheck(PHS_SPELL_DOMINATE_MONSTER)) return;

}
