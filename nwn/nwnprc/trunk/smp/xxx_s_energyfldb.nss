/*:://////////////////////////////////////////////
//:: Spell Name Energy Field: On Exit
//:: Spell FileName XXX_S_EnergyFldB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Jasperre:

    On Exit: Remove these effects (from our creators one):
    80% slow down in movement.
    20% melee consealment.
    50% ranged consealment.
    -2 Damage (melee)
    -2 To Hit (melee)

    Damage is handled on heartbeat.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Exit - remove effects
    SMP_AOE_OnExitEffects(SMP_SPELL_ENERGY_FIELD);
}
