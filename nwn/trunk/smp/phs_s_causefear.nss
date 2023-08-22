/*:://////////////////////////////////////////////
//:: Spell Name Cause Fear
//:: Spell FileName PHS_S_CauseFear
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy [Fear, Mind-Affecting]
    Level: Brd 1, Clr 1, Death 1, Sor/Wiz 1
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One living creature with 5 or fewer HD
    Duration: 1d4 rounds or 1 round; see text
    Saving Throw: Will partial
    Spell Resistance: Yes

    The affected creature becomes frightened. If the subject succeeds on a Will
    save, it is shaken for 1 round. Creatures with 6 or more Hit Dice are
    immune to this effect.

    Cause fear counters and dispels remove fear.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell description.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck()) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Duration is 1d4 rounds, or 1 round.
    float f1Round = 6.0;
    float fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic);

    // Declare effects
    effect eFear = EffectFrightened();
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDispelVis = EffectVisualEffect(VFX_IMP_DISPEL);

    // Link effects
    effect eLink = EffectLinkEffects(eFear, eDur);

    // Check PvP settings
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Signal event
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_CAUSE_FEAR);

        // Check hit dice
        if(GetHitDice(oTarget) <= 5)
        {
            // Check spell resistance
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Check against mind spells
                if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
                {
                    // If they have Remove Fear, remove that instead
                    if(PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_REMOVE_FEAR, oTarget))
                    {
                        // Apply dispel VFX if we remove any.
                        PHS_ApplyVFX(oTarget, eDispelVis);
                    }
                    else
                    {
                        // Will Saving throw versus fear negates
                        if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FEAR))
                        {
                            // Impact and duration effects applied
                            SetLocalInt(oTarget, "PHS_SPELL_CAUSE_FEAR_FEAR", TRUE);
                            PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
                        }
                        else
                        {
                            // Pass, do shaken
                            SetLocalInt(oTarget, "PHS_SPELL_CAUSE_FEAR_FEAR", FALSE);
                            PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, f1Round);
                        }
                    }
                }
            }
        }
    }
}
