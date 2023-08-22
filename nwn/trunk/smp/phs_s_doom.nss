/*:://////////////////////////////////////////////
//:: Spell Name Doom
//:: Spell FileName PHS_S_Doom
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy [Fear, Mind-Affecting]
    Level: Clr 1
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Medium (20M)
    Target: One living creature
    Duration: 1 min./level
    Saving Throw: Will negates
    Spell Resistance: Yes

    This spell fills a single subject with a feeling of horrible dread that causes it to become shaken.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell description.

    The fear script applies the shaken effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DOOM)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Get duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eFear = EffectFrightened();
    effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);

    // Link effects
    effect eLink = EffectLinkEffects(eFear, eDur);

    // Check PvP settings
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Signal event
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DOOM);

        // Check spell resistance
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Check against mind spells and fear
            if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS) &&
               !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_FEAR))
            {
                // Will Saving throw versus fear negates
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FEAR))
                {
                    // Impact and duration effects applied
                    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
                }
            }
        }
    }
}
