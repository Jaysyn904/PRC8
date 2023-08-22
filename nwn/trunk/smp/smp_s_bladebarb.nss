/*:://////////////////////////////////////////////
//:: Spell Name Blade Barrier : On Exit
//:: Spell FileName SMP_S_BladeBarB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Here, apply the right one.

    Can be a circle, or a wall.

    Either way, it provides cover to those who stay in it, and does damage
    every heartbeat, and on enter.

    HB:
    - Damage (Up to 15d6) piercing, reflex save
    Enter:
    - Apply (if not already got) Blade Barrier +4AC, +2 Reflex saves
    Exit:
    - Remove (if couter at 0) all blade barrier effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Exit - remove effects
    SMP_AOE_OnExitEffects(SMP_SPELL_BLADE_BARRIER);
}
