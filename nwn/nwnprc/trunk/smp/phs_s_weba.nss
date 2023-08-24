/*:://////////////////////////////////////////////
//:: Spell Name Web: On Enter
//:: Spell FileName PHS_S_WebA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    On Enter:

    Reflex save, or stuck, if pass, still get -4 AC, -2 attack.

    Always get 80% speed decrease (and consealment).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE status
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();

    // Declare major effects
    effect eDur = EffectVisualEffect(VFX_DUR_WEB);
    effect eSlow = EffectMovementSpeedDecrease(80);
    effect eConceal = EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED);
    effect eAlwaysLink = EffectLinkEffects(eSlow, eConceal);
    eAlwaysLink = SupernaturalEffect(eAlwaysLink);

    // Fake entangle
    effect eFakeEntangle1 = EffectACDecrease(4);
    effect eFakeEntangle2 = EffectAttackDecrease(2);
    effect eFakeEntangleLink = EffectLinkEffects(eFakeEntangle1, eFakeEntangle2);
    eFakeEntangleLink = EffectLinkEffects(eFakeEntangleLink, eDur);
    eFakeEntangleLink = SupernaturalEffect(eFakeEntangleLink);

    // Proper entangle
    effect eEntangle = EffectEntangle();
    effect eLink = EffectLinkEffects(eEntangle, eDur);
    eLink = SupernaturalEffect(eLink);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Fire cast spell at event for the target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_WEB);

        // Always apply the slowing
        PHS_ApplyPermanent(oTarget, eAlwaysLink);

        // Check reflex save
        if(!PHS_SavingThrow(SAVING_THROW_REFLEX, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster))
        {
            // Fail - full stop
            PHS_ApplyPermanent(oTarget, eLink);
        }
        else
        {
            // Pass - Partial entanglement
            PHS_ApplyPermanent(oTarget, eFakeEntangleLink);
        }
    }
}
