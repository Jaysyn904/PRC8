/*:://////////////////////////////////////////////
//:: Spell Name Blade Barrier
//:: Spell FileName SMP_S_BladeBar
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Blade Barrier
    Evocation [Force]
    Level: Clr 6, Good 6, War 6
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Wall of whirling blades 10x1M, or a ringed wall  of whirling blades
            with a radius 5M radius, 3M thick.
    Duration: 1 min./level (D)
    Saving Throw: Reflex half or Reflex negates; see text
    Spell Resistance: Yes

    An immobile, vertical curtain of whirling blades shaped of pure force
    springs into existence. Any creature passing through the wall takes 1d6
    points of damage per caster level (maximum 15d6), with a Reflex save for
    half damage.

    A blade barrier provides cover (+4 bonus to AC, +2 bonus on Reflex saves)
    against attacks made to creatures inside it.
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
    // Spell hook check.
    if(!SMP_SpellHookCheck()) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nSpellId = GetSpellId();

    // Duration in minutes
    float fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

    effect eAOE;
    // Declare effects
    // - Based on spell user choice
    if(nSpellId == SMP_SPELL_BLADE_BARRIER_ROUND)
    {
        eAOE = EffectAreaOfEffect(SMP_AOE_PER_BLADE_BARRIER_ROUND);
    }
    else //if( == SMP_SPELL_BLADE_BARRIER_SQUARE)
    {
        eAOE = EffectAreaOfEffect(SMP_AOE_PER_BLADE_BARRIER_RECTANGLE);
    }
    // Apply effects
    SMP_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
