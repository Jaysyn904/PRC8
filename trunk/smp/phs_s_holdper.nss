/*:://////////////////////////////////////////////
//:: Spell Name Hold Person
//:: Spell FileName PHS_S_HoldPer
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Brd 2, Clr 2, Sor/Wiz 3
    Components: V, S, F/DF
    Casting Time: 1 standard action
    Range: Medium (20M)
    Target: One humanoid creature
    Duration: 1 round/level (D); see text
    Saving Throw: Will negates; see text
    Spell Resistance: Yes

    The subject becomes paralyzed and freezes in place. It is aware and breathes
    normally but cannot take any actions, even speech. Each round on its turn,
    the subject may attempt a new saving throw to end the effect. (This is a
    full-round action that does not provoke attacks of opportunity.)

    Arcane Focus: A small, straight piece of iron.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This does have the correct "Save each round" embedded into the code like
    Acid Arrow does. Its in the include file so it can easily be changed
    for all the Hold XXX scripts.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HOLD_PERSON)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration in rounds.
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare Effects
    effect eParalyze = EffectParalyze();
    effect eDur1 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eParalyze, eDur1);
    eLink = EffectLinkEffects(eLink, eDur2);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Always fire spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HOLD_PERSON, TRUE);

    // Must check reaction type for PvP
    if(!GetIsReactionTypeFriendly(oTarget) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Must be a humaoid and living
        if(PHS_GetIsHumanoid(oTarget) &&
           PHS_GetIsAliveCreature(oTarget))
        {
            // Check spell resistance and immunities.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget) &&
               !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS) &&
               !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_PARALYSIS))
            {
                // Make Will Save to negate effect. Mind spell too.
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    // Apply VFX Impact and daze effect
                    PHS_ApplyDuration(oTarget, eLink, fDuration);

                    // Delay a round-will-save to remove
                    PHS_HoldWillSaveStart(oTarget, oCaster, PHS_SPELL_HOLD_PERSON, nSpellSaveDC);
                }
            }
        }
    }
}
