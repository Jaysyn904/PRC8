/*:://////////////////////////////////////////////
//:: Spell Name Delayed Blast Fireball
//:: Spell FileName PHS_S_DelayedBF
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Fire]
    Level: Sor/Wiz 7
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Long (40M)
    Area: 6.67-M.-radius spread
    Duration: 5 rounds or less; see text
    Saving Throw: Reflex half
    Spell Resistance: Yes

    This spell functions like fireball, except that it is more powerful and can
    detonate up to 5 rounds after the spell is cast. The burst of flame deals 1d6
    points of fire damage per caster level (maximum 20d6). Unattended objects
    also take this damage. The explosion creates almost no pressure.

    The glowing bead created by delayed blast fireball can detonate immediately
    if you desire, or you can choose to delay the burst for as many as 5 rounds.
    You select the amount of delay in the spell menu, and that time cannot change
    once it has been set unless comes near the bead. If you choose a delay, the
    glowing bead sits at its destination until it detonates, or until a creature
    passes nearby the spot. Either at the end of its duration, or when someone
    enters by, it will explode.

    Material Component: A tiny ball of bat guano and sulfur.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses the Bioware AOE.

    This, if moved nearby to, will auto-explode.

    The caster can of course choose the duration - be it 1 heartbeat (or instant)
    to 5 heartbeats (or 5 rounds).

    The heartbeat script and OnEnter scripts do the stuff.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_DELAYED_BLAST_FIREBALL)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();

    // We let it run for 7 or 8 heartbeats. A counter does the real stuff, this is
    // just backup to let it runout if nessissary.
    float fDuration = RoundsToSeconds(7);

    // Note: The caster (OBJECT_SELF here, and GetAreaOfEffectCreator() in the
    // AOE scripts, is the person with the integer for "rounds until blow day".

    // Note 2: The heartbeat ALWAYS does the blowing. The On Enter mearly
    // sets a local to say "blow next time".

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_DELAYED_FIREBALL);

    // Apply effects
    PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
