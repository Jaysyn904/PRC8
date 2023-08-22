/*:://////////////////////////////////////////////
//:: Spell Name Teleportation Circle
//:: Spell FileName PHS_S_TeleportCi
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    10 Mins casting time. 5feet radius AOE, which is 1.67M. 10 min/level duration,
    and will teleport anyone entering the surface to a location specified beforehand.

    Rogues can search and disarm it.
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
    if(!PHS_SpellHookCheck(PHS_SPELL_TELEPORTATION_CIRCLE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();

    // Declare effects
    // invisible is the I one
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_TELEPORTATION_CIRCLEI, "****", "****", "****");

}
