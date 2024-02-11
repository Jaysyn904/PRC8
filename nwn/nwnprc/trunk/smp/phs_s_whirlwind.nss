/*:://////////////////////////////////////////////
//:: Spell Name Whirlwind
//:: Spell FileName PHS_S_Whirlwind
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Air]
    Level: Air 8, Drd 8
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Long (40M)
    Effect: Cyclone 3.33M. wide at base, 10M. wide at top, and 10M. tall
    Duration: 1 round/level (D)
    Saving Throw: Reflex negates; see text
    Spell Resistance: Yes

    This spell creates a powerful cyclone of raging wind that moves through the
    air touching the ground at a speed of 20 meters per round. You can direct
    the movement of the cyclone by using your caster item. It moves to that
    points and then moves around the point randomly until told to do otherwise.
    If the cyclone exceeds the spell’s range, it moves in a random,
    uncontrolled fashion for 1d3 rounds and then dissipates. (You can’t regain
    control of the cyclone, even if comes back within range.)

    Any Large or smaller creature that comes in contact with the spell effect
    must succeed on a Reflex save or take 3d6 points of damage. A Medium or
    smaller creature that fails its first save must succeed on a second one or
    be knocked down for 6 seconds.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Hmmm....

    A creature moves around directed by the PC.

    The creature of course can be one of many, but I will impliment it so only
    one can be summoned at once.

    THIS SCRIPT DOESN'T MOVE THE WHIRLWINDS. IT IS A SEPERATE SPECIAL SPELL.

    Any uncontrolled whirlwinds go under thier own AI scripts, unless it already
    was dispelled - via. a normal way. The creature has an AOE and a visual
    from that AOE on it, and thats all.

    If it loses the VFX, the local object saying what is its master, or if its
    master is ever out of range, it goes.

    Using the caster item will make any whirlwind in place move to that point,
    the whirlwind will, if not moving, randomly walk around thier location (set
    on them to move to).

    The AOE has On Enter effects, and On Heartbeat too, both doing the same
    things (if they havn't got the spell's effects)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_WHIRLWIND)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // Destroy any exsisting whirlwinds
    object oExsisting = GetLocalObject(oCaster, "PHS_SPELL_WHIRLWIND_CURRENT");

    if(GetIsObjectValid(oExsisting))
    {
        // Message the caster
        FloatingTextStringOnCreature("*You can only have one whirlwind to control at once. Your current one has been destroyed*", oCaster, FALSE);
        PHS_CompletelyDestroyObject(oExsisting);
    }

    // Signal spell cast at
    PHS_SignalSpellCastAt(oCaster, PHS_SPELL_WHIRLWIND, FALSE);

    // Duration is 1 round/level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Delcare Effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_MOB_WHIRLWIND);
    effect eGhost = EffectCutsceneGhost();
    effect eLink = EffectLinkEffects(eAOE, eGhost);

    // We create the "creature whirlwind" at the target location
    object oWhirlwind = CreateObject(OBJECT_TYPE_CREATURE, PHS_CREATURE_RESREF_WHIRLWIND, lTarget);

    // Apply effects
    PHS_ApplyDuration(oWhirlwind, eLink, fDuration);

    // No need to set the master, it can be checked by looping effects.
    // We do, however, set the whirlwind's location to move to, and the actual
    // whirlwind is set onto the caster to not have more then one.
    SetLocalLocation(oWhirlwind, "PHS_SPELL_WHIRLWIND_LOCATION", lTarget);
    SetLocalObject(oCaster, "PHS_SPELL_WHIRLWIND_CURRENT", oWhirlwind);
}
