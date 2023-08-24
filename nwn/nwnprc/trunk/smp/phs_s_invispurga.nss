/*:://////////////////////////////////////////////
//:: Spell Name Invisibility Purge: On Enter
//:: Spell FileName PHS_S_InvisPurgA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    I altered it so people wouldn't be put under a false impression.

    Anyones invsibility is removed!

    The AOE changes per 2 caster levels - not per 1, this makes it more
    manageable for NwN, and is still a huge radius as the spell progresses
    in levels!

    On Enter:
    - Remove ANY invisiblity effects made by magic.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_INVISIBILITY_PURGE, GetIsEnemy(oTarget, oCaster));

    // Remove all invisibility effects
    PHS_RemoveSpecificEffect(EFFECT_TYPE_INVISIBILITY, oTarget);
    PHS_RemoveSpecificEffect(EFFECT_TYPE_IMPROVEDINVISIBILITY, oTarget);
}
