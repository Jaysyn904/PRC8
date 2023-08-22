/*:://////////////////////////////////////////////
//:: Spell Name Grease
//:: Spell FileName PHS_S_Grease
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation)
    Level: Brd 1, Sor/Wiz 1
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Close (8M)
    Target or Area: A 3.33-M. square
    Duration: 1 round/level (D)
    Saving Throw: See text
    Spell Resistance: No

    A grease spell covers a solid surface with a layer of slippery grease. Any
    creature in the area when the spell is cast must make a successful Reflex
    save or fall. This save is repeated each round that the creature remains
    within the area. A creature can walk within or through the area of grease at
    half normal speed with a DC10 dexterity check. A failure of the dexterity
    check means they cannot move that round (and may still slip) a failure of 5
    or more will mean they automatically fall.

    Material Component: A bit of pork rind or butter.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Grease will knockdown creatures (falling them) each round.

    The dexterity check replaces this text:

    A creature can walk within or through the area of grease at half normal speed
    with a DC 10 Balance check. Failure means it can’t move that round (and must
    then make a Reflex save or fall), while failure by 5 or more means it falls
    (see the Balance skill for details).

    Which only applies if they are doing ACTION_MOVETOPOINT.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_GREASE)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_GREASE);
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);

    // Apply effects
    PHS_ApplyLocationDurationAndVFX(lTarget, eImpact, eAOE, fDuration);
}
