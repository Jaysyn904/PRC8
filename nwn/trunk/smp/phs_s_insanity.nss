/*:://////////////////////////////////////////////
//:: Spell Name Insanity
//:: Spell FileName PHS_S_Insanity
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    20M range, Will and SR negates. Mind affecting. Permament confusion effect.

    Remove curse does not remove insanity. Greater restoration, heal, limited
    wish, miracle, or wish can restore the creature.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Supernatural confusion, permament!

    This is deadly :-)

    Anyway, can be removed with some spells.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_INSANITY)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget= GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Declare effects - Confusion
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_INSANITY);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eConfusion = EffectConfused();
    effect eLink = EffectLinkEffects(eConfusion, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Make it a supernatural effect
    // - Cannot be dispelled
    // - Cannot be removed VIA sleep
    eLink = SupernaturalEffect(eLink);

    // Check to see if the target is mindless and PvP check
    if(!PHS_SpellsIsMindless(oTarget) &&
       !GetIsReactionTypeFriendly(oTarget))
    {
        // Fire cast spell at event for the specified target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_INSANITY);

        // Check spell reistance and immunity
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Saving throw VS mind and will
            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                // Apply permament confusion
                PHS_ApplyPermanentAndVFX(oTarget, eVis, eLink);
            }
        }
    }
}
