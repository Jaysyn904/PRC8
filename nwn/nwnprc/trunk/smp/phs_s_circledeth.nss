/*:://////////////////////////////////////////////
//:: Spell Name Circle of Death
//:: Spell FileName PHS_S_CircleDeth
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    [Death] Medium (20M) Area: Several living creatures within a 13.33-M.-radius
    burst Fortitude negates. SR applies.

    A circle of death snuffs out the life force of living creatures, killing them
    instantly.

    The spell slays 1d4 HD worth of living creatures per caster level (maximum 20d4).
    Creatures with the fewest HD are affected first; among creatures with equal HD,
    those who are closest to the burst’s point of origin are affected first. No
    creature of 9 or more HD can be affected, and Hit Dice that are not sufficient
    to affect a creature are wasted.

    Material Component: The powder of a crushed black pearl with a minimum value of
    500 gp.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell - Bioware's is almost like this.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_CIRCLE_OF_DEATH)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Limit dice up to 20.
    int nDice = PHS_LimitInteger(nCasterLevel, 20);

    // Get amount of HD we can kill -
    // The spell slays 1d4 HD worth of living creatures per caster level (maximum 20d4).
    int nMaxHD = PHS_MaximizeOrEmpower(4, nDice, nMetaMagic);
}
