/*:://////////////////////////////////////////////
//:: Spell Name Slow Target
//:: Spell FileName XXX_S_SlowTarget
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Sor/Wiz 2
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: One creature
    Duration: 1 round/level
    Saving Throw: Will negates
    Spell Resistance: Yes
    Source: Various (Israfel666)

    The subject is slowed as the spell (A slowed creature takes a -1 penalty on
    attack rolls, AC, and Reflex saves. A slowed creature moves at half its
    normal speed.).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Slow, as the spell, woo, lower level (one target though).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_SLOW_TARGET)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nSpellSaveDC = SMP_GetSpellSaveDC();

    // Duration - rounds
    float fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eSlow = EffectSlow();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_SLOW);

    // Link
    effect eLink = EffectLinkEffects(eSlow, eCessate);

    // Check if an enemy and no PvP
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Signal spell cast at event
        SMP_SignalSpellCastAt(oTarget, SMP_SPELL_SLOW_TARGET);

        // Spell resistance
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            // Will save
            if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
            {
                // Apply slow
                SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
            }
        }
    }
}
