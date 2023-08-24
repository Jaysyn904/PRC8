/*:://////////////////////////////////////////////
//:: Spell Name Seal Magic
//:: Spell FileName XXX_S_SealMagic
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Sor/Wiz 6
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One creature
    Duration: Permanent
    Saving Throw: Will negates
    Spell Resistance: Yes
    Source: Various (Dante Darkstar)

    Upon casting Seal Magic a crimson circle of runes appears on the floor
    around the target for a moment. Afterwards, the spell seals target’s magical
    powers. Affected creature cannot use spells and spell-like abilities until
    this spell removed (it can still use its supernatural abilities and items).

    This spell cannot be dispelled by Dispel Magic. Only Remove Curse cast by
    caster of at least your level or Mordekainen’s Disjunction (regardless of
    its caster level) can remove this spell’s effects. Wish, Limited Wish and
    Miracle also can remove this spell if used for this purpose.

    Note: affected creatures are not automatically aware of thier state (so
    they don’t know they cannot cast spells anymore unless they try, and even
    then they can come up to a wrong conclusions, like your spell creating
    antimagic field where he stands).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Applies it, secretly.

    Of course, saves and things are visiable, oh well.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_SEAL_MAGIC)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();

    // Declare Effects
    effect eSeal = EffectSpellFailure(100, SPELL_SCHOOL_GENERAL);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eSeal, eCessate);

    // Always fire spell cast at event
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_SEAL_MAGIC, TRUE);

    // Must check reaction type for PvP
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Check spell resistance and immunities.
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            //Make Will Save to negate effect
            if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
            {
                // Apply VFX Impact and daze effect
                SMP_ApplyPermanent(oTarget, eLink);
            }
        }
    }
}
