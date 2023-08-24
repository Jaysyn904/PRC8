/*:://////////////////////////////////////////////
//:: Spell Name Black Tentacles: On Enter
//:: Spell FileName PHS_S_EvardBlacA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Grapple check uses the functions created for this, and other spells-which-grapple
    things.

    The tentacles will only attack (using a proper attack thing) On Enter.

    If they have the entanglement of tentacles, the HB will continue to grapple.

    Always applies 50% movement speed decrease. Removes all effects On Exit. Will
    not grapple someone with the spells effects already.
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
    int nCasterLevel = PHS_GetAOECasterLevel();

    // Get opposed grapple roll
    int nOpposedGrappleRoll = d20() + GetBaseAttackBonus(oTarget) +
                                      GetAbilityModifier(ABILITY_STRENGTH, oTarget) +
                                      PHS_GrappleSizeBonus(oTarget);

    // We always apply the slow for the spell, as a supernatural effect, using
    // the standard On Enter things.
    effect eSlow = EffectMovementSpeedDecrease(50);

    // We may also entangle them (and later do damage) and sucessfully grapple
    // with a tentacle
    effect eEntangle = EffectEntangle();
    effect eDur = EffectVisualEffect(PHS_VFX_DUR_BLACK_TENTACLE);
    effect eLink = EffectLinkEffects(eEntangle, eDur);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Fire cast spell at event for the target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_EVARDS_BLACK_TENTACLES);

        // Now we make an attack to hold them, if we can
        if(!GetHasSpellEffect(PHS_SPELL_EVARDS_BLACK_TENTACLES, oTarget))
        {
            // Check grapple roll
            if(PHS_GrappleCheck(oTarget, nCasterLevel, 4, 4, nOpposedGrappleRoll, oCaster))
            {
                // Now we entangle, later rounds do damage.
                // * Can be dispelled as normal, not supernatural.
                PHS_ApplyPermanent(oTarget, eLink);
            }
        }
    }

    // Apply slow effects always
    PHS_AOE_OnEnterEffects(eLink, oTarget, PHS_SPELL_EVARDS_BLACK_TENTACLES);
}
