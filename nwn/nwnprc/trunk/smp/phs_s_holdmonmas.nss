/*:://////////////////////////////////////////////
//:: Spell Name Hold Monster, Mass
//:: Spell FileName PHS_S_HoldMonMas
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Hold Monster, Mass
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Sor/Wiz 9
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Medium (20M)
    Targets: One or more enemies in a 5M sphere
    Duration: 1 round/level (D); see text
    Saving Throw: Will negates; see text
    Spell Resistance: Yes

    The subjects becomes paralyzed and freezes in place. It is aware and
    breathes normally but cannot take any actions, even speech. Each round on
    its turn, the subject may attempt a new saving throw to end the effect.
    (This is a full-round action that does not provoke attacks of opportunity.)

    Arcane Material Component: One hard metal bar or rod, which can be as small
    as a three-penny nail.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As Hold Monster, but an AOE which only affects enemies.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HOLD_MONSTER_MASS)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
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

    // Get Fist Target, 5M sphere
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // Must check reaction type for PvP, and must be an enemy
        if(GetIsReactionTypeHostile(oTarget) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Must be living
            if(PHS_GetIsAliveCreature(oTarget))
            {
                // Fire spell cast at event
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HOLD_MONSTER_MASS, TRUE);

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
                        PHS_HoldWillSaveStart(oTarget, oCaster, PHS_SPELL_HOLD_MONSTER_MASS, nSpellSaveDC);
                    }
                }
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
