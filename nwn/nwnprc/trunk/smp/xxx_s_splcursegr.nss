/*:://////////////////////////////////////////////
//:: Spell Name Spell Curse, Greater
//:: Spell FileName XXX_S_SplCurseGr
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation
    Also known as: Israfel's Greater Spell Curse
    Level: Sor/Wiz 6
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: One creature
    Duration: 1 round/level
    Saving Throw: Will negates; see text
    Spell Resistance: Yes
    Source: Various (Israfel666)

    The target of this spell suffers 2d6 points of damage, plus 2 per level of
    the spell cast (cantrips count as level 0 spells), to a maximum of 2d6 + 18
    damage if they cast a level 9 spell, as the energy of the spell backlashes
    on him/her. The spell cast works normally, though, and damage is dealt after
    the spell is cast, so there is no risk of disrupting the spellcasting.
    Spell-like abilities and spells cast from items do not cause damage. When
    the spell is first cast, spell resistance and a will save will negate it.
    Each time a spell is cast by an affected target, they must make an
    additional will save which will half the damage done.

    Only one spell curse of any type can affect a target at any one time. Greater
    Spell Curse will override any Spell Curse on a target, they do not stack.

    Note that unless the target identifies Israfel's Spell Curse (as if he meant
    to counterspell it) he/she cannot know the effect of the spell until he
    suffers backlash damage from spellcasting.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Applies a visual (which doesn't stack, any new one removes an old one)
    for this to catch in the spell hook.

    The greater version *overrides* and doesn't stack with the lesser one.

    The save DC is saved onto the caster, under, of course, the last DC for
    this spell (which is always saved by default).

    - Will save negates it to start with (Might change and remove this)
    - SR applies to negate it to start with

    Then:
    - Will save for half damage, from 1d6 + Spell Level cast, from 1d6, to 1d6 + 9.

    Oh, and might remove the impact visual. It says they will not know about
    its presence until they cast a spell (unless, of course, they identify it)
    therefore, no impact visual means no way of knowing (dispite it being one
    of the few without one, imagine it being cast not in combat).

    No metamagic, such as Empower, yet. Might add in, might not...
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck(SMP_SPELL_SPELL_CURSE_GREATER)) return;

    // Delcare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();

    // Get duration in rounds
    float fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effect to check for
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);

    // Check reaction type
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Signal event
        SMP_SignalSpellCastAt(oTarget, SMP_SPELL_SPELL_CURSE_GREATER);

        // Check spell resistance
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            // Check will save which negates it
            if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
            {
                // Remove previous ones from this spell only (no overlapping casters)
                // Just makes it easier. Its not fully to the rules, but oh well.
                SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_SPELL_CURSE_GREATER, oTarget);

                // Apply the visual
                // - Spell hook does the rest.
                SMP_ApplyDurationAndVFX(oTarget, eVis, eDur, fDuration);
            }
        }
    }
}
