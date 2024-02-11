/*:://////////////////////////////////////////////
//:: Spell Name Solid Fog: On Exit
//:: Spell FileName PHS_S_SolidFogB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Acid Fog uses this as a template. It applies, on enter (and removes on exit)
    these effects:

    80% slow down in movement.
    20% melee consealment.
    100% ranged consealment.
    100% ranged miss chance
    -2 To Hit (Melee)
    -2 To Damage (Melee)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_SOLID_FOG);
}
