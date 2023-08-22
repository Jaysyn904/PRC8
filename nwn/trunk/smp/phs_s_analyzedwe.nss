/*:://////////////////////////////////////////////
//:: Spell Name Analyze Dweomer
//:: Spell FileName PHS_S_AnalyzeDwe
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Brd 6, Sor/Wiz 6
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Close (8M)
    Targets: One creature per caster level
    Duration: 1 round/level; or until target limit reached
    Saving Throw: None
    Spell Resistance: No

    You discern all spells and magical properties present in a number of
    creatures or objects. Starting with the targeted creature, this will decern
    each spell, and its caster level. Subsequent rounds will target nearby seen
    creatures within 8M range of the caster, but not the same one twice, until
    none are left or the duration runs out.

    Focus: A tiny lens of ruby or sapphire set in a small golden loop. The
    gemstone must be worth at least 1,500 gp.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This only works on creatures. Easier, I mean, what can we do with looking
    at objects, unless they, for example, are equipped by a creature?

    To check for spell effects, it does this:

    - Loop effects
    - If from a spell, and a valid creator (else set to caster level -1) then
      it'll get caster level, set that into integer.
    - Then, loops the integers, and gets the valid ones, and sends them to
      the caster.

    It shouldn't TMI, and is not really "CPU intensive" so should be fine.

    Oh, and the targets are chosen to be within 8M. They are set in a local
    integer, on the target (deleted after a while) if they are done already, too.

    While the HB is running for the duration (only one at once, see
    acid arrow) it'll check for sight of these targets, in order of the array
    they are stored in, with an integer saying if they are done or not (so
    if one becomes visible, they are done).

    Note: 1500 focus needed (not a MC though, so not removed).
    Cannot be extended.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Analyze oTarget.
void AnalyzePerson(object oTarget);

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_ANALYZE_DWEOMER)) return;

    // Focus component check
    if(!PHS_ComponentFocusItem(PHS_ITEM_RUBY_IN_LOOP_1500, "Ruby set in a golden loop", "Analyze Dweomer")) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();

    // Projectile timing.
    float fDelay = GetDistanceToObject(oTarget)/25.0;

    // Duration can be up to 7 rounds.
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, FALSE);

    // Delcare Effects
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);

    // Fire spell cast at event for target
    PHS_SignalSpellCastAt(oTarget, 1);
}
