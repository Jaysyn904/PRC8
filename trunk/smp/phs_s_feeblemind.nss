/*:://////////////////////////////////////////////
//:: Spell Name Feeblemind
//:: Spell FileName PHS_S_Feeblemind
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    20M Range, 1 creature target, will negates, SR applies. Mind affecting.

    If the target creature fails a Will saving throw, its Intelligence and
    Charisma scores each drop to 3 (By taking a -40 penalty in each ability).
    The affected creature is unable to cast spells, understand language,
    or communicate coherently. Still, it knows who its friends are and can
    follow them and even protect them. The subject remains in this state until
    a heal, limited wish, miracle, or wish spell is used to cancel the effect
    of the feeblemind. If the target creature can cast sorceror or wizard spells,
    it takes a -4 penalty on its saving throw.

    Material Component: A handful of clay, crystal, glass, or mineral spheres.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    A will mind save, to negate a -40 ability score for the 2 casting abilities.

    The -4 penalty to saving throw is a +4DC to the save needed.

    Heal, limited wish, miracle, or wish removes it. It is a PERMAMENT effect.
    Cannot be dispeled - it is supernatural.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FEEBLEMIND)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Add 4 to DC if they are a caster
    if(GetLevelByClass(CLASS_TYPE_WIZARD, oTarget) ||
       GetLevelByClass(CLASS_TYPE_SORCERER, oTarget))
    {
        nSpellSaveDC += 4;
    }

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eChaPenalty = EffectAbilityDecrease(ABILITY_CHARISMA, 40);
    effect eIntPenalty = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 40);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    // Link effects
    effect eLink = EffectLinkEffects(eCessate, eChaPenalty);
    eLink = EffectLinkEffects(eIntPenalty, eLink);
    eLink = EffectLinkEffects(eDur, eLink);

    // Make it supernatural to resist all Dispel and Resting
    eLink = SupernaturalEffect(eLink);

    // PvP check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Signal spell cast at
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FEEBLEMIND);

        // Spell resistance check
        if(!PHS_SpellResistanceCheck(oCaster, oTarget) &&
           !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
        {
            // Will save negates
            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                // Remove previous effects
                PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_FEEBLEMIND, oTarget);

                // Apply effects
                PHS_ApplyPermanentAndVFX(oTarget, eVis, eLink);
            }
        }
    }
}
