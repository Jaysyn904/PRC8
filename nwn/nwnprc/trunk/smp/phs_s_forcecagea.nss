/*:://////////////////////////////////////////////
//:: Spell Name Forcecage: On Enter
//:: Spell FileName PHS_S_ForcecageA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Needs 4 placeables for the bars, and an AOE within the centre of it. If
    any of the bars are destroyed (via. disintegration ETC), it means the entire
    spell collapses.

    The AOE is plotted too, and does the correct 50% vs ranged attack consealment
    as they will have to shoot through the bars.

    On Enter: Only apply a 50% concealment versus ranged attacks.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Heartbeat checks the caster, not here. Here doesn't need the caster!

    // Declare major variables
    object oTarget = GetEnteringObject();

    // Declare effects
    effect eDur = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);

    // Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FORCECAGE);

    // Apply effects
    PHS_AOE_OnEnterEffects(eDur, oTarget, PHS_SPELL_FORCECAGE);
}
