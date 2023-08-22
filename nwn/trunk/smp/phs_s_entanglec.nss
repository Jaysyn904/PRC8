/*:://////////////////////////////////////////////
//:: Spell Name Entangle: On Heartbeat
//:: Spell FileName PHS_S_EntangleC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    No SR, noting that.

    On Heartbeat will do reflex saves to apply EffectEntangle, for a permament
    duration.
    On Heartbeat will do a STR check if they are already entangled, to remove it.

    On Enter applies slow effect. On Exit should remove all effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();

    // Declare effects
    effect eDur = EffectVisualEffect(VFX_DUR_ENTANGLE);
    effect eEntangle = EffectEntangle();
    effect eLink = EffectLinkEffects(eDur, eEntangle);

    // Start cycling through the AOE Object for viable targets
    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster))
        {
            // Fire cast spell at event for the affected target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ENTANGLE);

            // Make sure they are not immune to spells
            if(!PHS_TotalSpellImmunity(oTarget))
            {
                // Check if they even have slow
                if(GetHasSpellEffect(PHS_SPELL_ENTANGLE, oTarget))
                {
                    // If we don't have entangle, we try and apply it
                    if(!PHS_GetHasEffectFromCaster(EFFECT_TYPE_ENTANGLE, oTarget, oCaster))
                    {
                        // Not got it from this caster, apply it if they fail
                        // a reflex save
                        if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster))
                        {
                            PHS_ApplyPermanent(oTarget, eLink);
                        }
                    }
                    else
                    {
                        // Strength check to remove
                        if(PHS_AbilityCheck(oTarget, ABILITY_STRENGTH, 20))
                        {
                            // Remove the entangles
                            PHS_RemoveSpecificEffectFromSpell(EFFECT_TYPE_ENTANGLE, PHS_SPELL_ENTANGLE, oTarget, SUBTYPE_MAGICAL);
                        }
                    }
                }
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
}
