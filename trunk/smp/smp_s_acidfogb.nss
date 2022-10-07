/*:://////////////////////////////////////////////
//:: Spell Name Acid Fog: On Exit
//:: Spell FileName SMP_S_AcidFogB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Jasperre:

    On Exit: Remove these effects (from our creators one):
    80% slow down in movement.
    20% melee consealment.
    100% ranged consealment.
    100% ranged miss chance
    -2 To Hit (Melee)
    -2 To Damage (Melee)

    Damage is handled on heartbeat.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Exit - remove effects
    SMP_AOE_OnExitEffects(SMP_SPELL_ACID_FOG);
}
