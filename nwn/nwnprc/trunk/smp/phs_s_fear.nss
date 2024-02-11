/*:://////////////////////////////////////////////
//:: Spell Name Fear
//:: Spell FileName PHS_S_Fear
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    [Fear, Mind-Affecting] Range: 10M. Area: Cone-shaped burst
    Duration: 1 round/level or 1 round; see text
    Saving Throw: Will partial Spell Resistance: Yes

    An invisible cone of terror causes each living creature in the area to become
    panicked unless it succeeds on a Will save. If cornered, a panicked creature
    begins cowering. If the Will save succeeds, the creature is shaken for 1 round.

    Material Component: Either the heart of a hen or a white feather.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell description.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FEAR)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    float fDelay;

    // Get duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);
    float f1Round = 6.0;

    // Declare effects
    effect eFear = EffectFrightened();
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);

    // Link effects
    effect eLink = EffectLinkEffects(eFear, eDur);

    // Get all in a 10.0M cone
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        // Reaction type check
        if(!GetIsReactionTypeFriendly(oTarget) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Signal Spell cast at event.
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FEAR);

            // Get delay
            fDelay = GetDistanceBetween(oCaster, oTarget)/20;

            // Spell Resistance and immunity check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Check against mind spells
                if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS, fDelay))
                {
                    // Will Saving throw versus fear, for panic else shaken.
                    if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FEAR, oCaster, fDelay))
                    {
                        // Impact and duration effects applied
                        DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eVis));
                        SetLocalInt(oTarget, "PHS_SPELL_FEAR_FEAR", TRUE);
                        PHS_ApplyDuration(oTarget, eLink, fDuration);
                    }
                    else // Shaken only
                    {
                        // Impact and duration effects applied
                        DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eVis));
                        SetLocalInt(oTarget, "PHS_SPELL_FEAR_FEAR", FALSE);
                        PHS_ApplyDuration(oTarget, eLink, fDuration);
                    }
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE);
    }
}
