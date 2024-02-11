/*:://////////////////////////////////////////////
//:: Spell Name Forcecage: On Exit
//:: Spell FileName PHS_S_ForcecageB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Needs 4 placeables for the bars, and an AOE within the centre of it. If
    any of the bars are destroyed (via. disintegration ETC), it means the entire
    spell collapses.

    The AOE is plotted too, and does the correct 50% vs ranged attack consealment
    as they will have to shoot through the bars.

    On Exit: Removes all effects, the 50% concealment versus ranged attacks.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_FORCECAGE);
}
