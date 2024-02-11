/*:://////////////////////////////////////////////
//:: Spell Name Distract
//:: Spell FileName XXX_S_Distract
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment [Mind Affecting]
    Level: Sor/Wiz 2, Brd 2
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One living creature
    Duration: 1 round/level
    Saving Throw: Will negates
    Spell Resistance: Yes
    Source: Various (cthulhu)

    When a creature is succesfully targeted by this spell, they are constantly
    seeing things out of the corner of their eyes that are not there, or
    detecting things with their senses that are not really there. This distracts
    the subject, causing all attacks that they make for the duration of the
    spell to have a straight 50% miss chance.

    Focus: A miniature replica of blinders for a horse.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Distract is really easy to do.

    Visuals are "Daze" for now, it is a mind effect after all.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_DISTRACT)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();

    // Duration is 1 round/level.
    float fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eMiss = EffectMissChance(50);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eMind, eMiss);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Always fire spell cast at event
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_DISTRACT, TRUE);

    // Must check reaction type for PvP
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Check spell resistance and immunities.
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            // Check immunity: Mind spells
            if(!SMP_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
            {
                // Make Will Save to negate effect
                if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    // Apply VFX Impact and daze effect
                    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
                }
            }
        }
    }
}
