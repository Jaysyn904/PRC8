/*:://////////////////////////////////////////////
//:: Spell Name Web: On Heartbeat
//:: Spell FileName PHS_S_WebC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    On Heartbeat:

    Strength check to remove the proper entanglment, and will get the fake
    one applied instead. Only "saves" if got proper entanglement.

    Always keep the 80% speed decrease.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE status
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    int nDC = 20;

    // Declare major effects
    effect eDur = EffectVisualEffect(VFX_DUR_WEB);

    // Fake entangle
    effect eFakeEntangle1 = EffectACDecrease(4);
    effect eFakeEntangle2 = EffectAttackDecrease(2);
    effect eFakeEntangleLink = EffectLinkEffects(eFakeEntangle1, eFakeEntangle2);
    eFakeEntangleLink = EffectLinkEffects(eFakeEntangleLink, eDur);
    eFakeEntangleLink = SupernaturalEffect(eFakeEntangleLink);

    // Get first valid target in the AOE
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        // Check if got entanglement from this spell
        if(PHS_GetHasEffectFromSpell(EFFECT_TYPE_ENTANGLE, oTarget, PHS_SPELL_WEB))
        {
            // Text the roll and bonus
            if(PHS_AbilityCheck(oTarget, ABILITY_STRENGTH, nDC))
            {
                // Pass - Partial entanglement
                // Remove old entanglement
                PHS_RemoveSpecificEffectFromSpell(EFFECT_TYPE_ENTANGLE, PHS_SPELL_WEB, oTarget, SUBTYPE_IGNORE);

                // Do new entanglement
                PHS_ApplyPermanent(oTarget, eFakeEntangleLink);
            }
        }
        // Get next valid target in the AOE
        oTarget = GetNextInPersistentObject();
    }
}
