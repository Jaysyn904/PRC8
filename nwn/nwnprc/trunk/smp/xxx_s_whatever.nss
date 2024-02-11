/*:://////////////////////////////////////////////
//:: Spell Name Whatever
//:: Spell FileName XXX_S_Whatever
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Brd 3
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Area: 5M-radius spread (15ft.)
    Duration: 1 round/level
    Saving Throw: Will Negates; see text
    Spell Resistance: Yes
    Source: Various (Josh_Kablack)

    Creatures affected by this spell become apathetic to everything around them
    and cannot muster the emotion to do anything. Initially and each round a
    creature remains in the area of effect it must make a saving throw or be
    unable to take any action for one round (treat as Dazed for 6 seconds).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is simple, and is an AOE which dazes (as the Bioware stinking cloud
    spell, kinda).

    Will negates, and SR applies. Nothing is applied On Enter. Only needs
    an On Heartbeat effect.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck(SMP_SPELL_WHATEVER)) return;


    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();

    // Duration in rounds
    float fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(SMP_AOE_PER_WHATEVER);

    // Apply effects
    SMP_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
