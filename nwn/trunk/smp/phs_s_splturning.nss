/*:://////////////////////////////////////////////
//:: Spell Name Spell Turning
//:: Spell FileName PHS_S_SplTurning
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Luck 7, Magic 7, Sor/Wiz 7
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: Until expended or 10 min./level

    Spells and spell-like effects targeted on you are turned back upon the
    original caster. The abjuration turns only spells that have you as a target.
    Effect and area spells are not affected. Spell turning also fails to stop
    touch range spells.

    From seven to ten (1d4+6) spell levels are affected by the turning. The
    exact number is rolled secretly.

    When you are targeted by a spell of higher level than the amount of spell
    turning you have left, that spell is partially turned. The subtract the
    amount of spell turning left from the spell level of the incoming spell,
    then divide the result by the spell level of the incoming spell to see what
    fraction of the effect gets through. For damaging spells, you and the caster
    each take a fraction of the damage. For nondamaging spells, each of you has
    a proportional chance to be affected.

    If you and a spellcasting attacker are both warded by spell turning effects
    in operation, a resonating field is created.

    Roll randomly to determine the result.

    d%      Effect
    01-70   Spell drains away without effect.
    71-80   Spell affects both of you equally at full effect.
    81-97   Both turning effects are rendered nonfunctional for 1d4 minutes.
    98-100  Both of you go through a rift into another plane.

    Arcane Material Component: A small silver mirror.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is done on a spell-by-spell basis, although the removal of numbers
    is easy enough (and it always rebounds cantrips if not touch attacks!)


    spell turning only affects spells with a Target: line (and a range greater
    then touch), it never effects spells with a Area: or Effect: line.

    Simplified now. This is how it should work:

    - Each spell will check if the opponent has the effects. If so:
      - Rifts may occur - check if caster also has turning!
      - Else:
        - Check if nullified and sent back to caster. If so, we do NOT assign
          the enemy to do the damage (although Effects such as Magic Missile
          might be). Why? Well, the CASTER casts the spell - thus he is the one
          that created the energy, and thus does the damage.
          - Duration effects apply as stated. Damage is divided as stated, this
            could mean some complicated parts of code - all on a Case by Case
            basis!

      - Note: Spell Resistance, saves ETC applies! Of corse,
        PHS_SpellResistanceCheck(oCaster, oCaster); would be wierd, but oh well!
        - Saves are done AFTER damage is "halved" or whatevered (for the rift)
          and will be delayed appopriatly if there is a projectile, else
          might as well do it instantly.

    Notes on each spell are under:

//:://////////////////////////////////////////////
//:: Spell Turning Notes
//:://////////////////////////////////////////////

    In each spell description.

    Not affected:
    - AOE Spells
    - Touch spells
    - Spells without SR checks (thus nothing can stop it)
    - Spells which don't just affect one target
      (For ease, I'll make even things like AOE Magic Missile
    - NOT "Effect:" or "Area:" spells

    Spells affected ALL (A-Z):
    - Baleful Polymorph
    - Bestow Curse
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SPELL_TURNING)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should always be us.
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // Declare effects
    effect eDur = EffectVisualEffect(VFX_DUR_SPELLTURNING);

    // 10 minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Randomise the amount of levels to bounce - hidden!
    int nLevelsToBounce = PHS_MaximizeOrEmpower(4, 1, nMetaMagic, 6);

    // This will remove the previous ones.
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_SPELL_TURNING, oTarget);

    // Apply the linked effects. And set up local integers.
    SetLocalInt(oTarget, PHS_SPELL_TURNING_AMOUNT, nLevelsToBounce);
    PHS_ApplyDuration(oTarget, eDur, fDuration);
}
