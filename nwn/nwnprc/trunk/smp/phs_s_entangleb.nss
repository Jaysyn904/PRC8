/*:://////////////////////////////////////////////
//:: Spell Name Entangle: On Exit
//:: Spell FileName PHS_S_EntangleB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    No SR, noting that.

    On Heartbeat will do reflex saves to apply EffectEntangle, for a permament
    duration.
    On Heartbeat will do a STR check if they are already entangled, to remove it.

    On Enter applies slow effect. On Exit should remove all effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_ENTANGLE);
}
