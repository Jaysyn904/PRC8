/*:://////////////////////////////////////////////
//:: Spell Name Symbol of Fear
//:: Spell FileName PHS_S_SymbFear
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Paniked for those in 60feet (20M) of the symbol, 1 round/caster level. Fear/
    mind affecting descriptors. Rogue can search for it. Will negates (level 6)

    Material Component: Mercury and phosphorus, plus powdered diamond and opal
    with a total value of at least 1,000 gp.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Not done yet.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SYMBOL_OF_FEAR)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation(); // Should be OBJECT_SELF's location
    int nCasterLevel = PHS_GetCasterLevel();

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_SYMBOL_OF_FEAR_EFFECT);
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_SYMBOL_OF_FEAR_ENTRY);

    // Apply it at the target location

}
