/*:://////////////////////////////////////////////
//:: Spell Name Confusion, Lesser
//:: Spell FileName phs_s_confseless
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    8M. 1 living creature. Mind affecting spell. Duration: 1 round. Will and
    SR negates.
    Makes the target confused for 1 round.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Confusion but for 1 round.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_CONFUSION_LESSER)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eConfuse = EffectConfused();
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    //Link duration VFX and confusion effects
    effect eLink = EffectLinkEffects(eDur, eConfuse);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Get Duration
    float fDuration = PHS_GetDuration(PHS_ROUNDS, 1, nMetaMagic);

    // Check PvP.
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Fire cast spell at event for the specified target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_CONFUSION_LESSER);

        // Check spell resistance and immunity
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Make Will Save against Mind spells
            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster))
            {
                // Apply effecs
                PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
            }
        }
    }
}
