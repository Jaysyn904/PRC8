/*:://////////////////////////////////////////////
//:: Spell Name Pyrotechnics: Smoke: On Exit
//:: Spell FileName PHS_S_PyrotechB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses Darkness invisibility for the ineffective through the cloud part.

    Defaults to fireworks. No sub-dial.

    The impact is easy - 1d4 + 1 rounds of blindness, SR + Will negates.

    The smoke cloud (1 round/level) applies the Darkness, and Darkness
    invisibility.

    Every HB may apply the -4 penalties to strength and dexterity.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_PYROTECHNICS);

    // Check if they have the ability decreases applied
    object oTarget = GetExitingObject();
    string sId = PHS_SPELL_AOE_AMOUNT + IntToString(PHS_SPELL_PYROTECHNICS);
    // If we have got some, but NONE from supernatural ones, we remove these
    // and apply 1d4 tempoary rounds worth of this loss.
    if(PHS_GetHasEffectFromSpell(EFFECT_TYPE_ABILITY_DECREASE, oTarget, PHS_SPELL_PYROTECHNICS, DURATION_TYPE_PERMANENT) &&
       GetLocalInt(oTarget, sId) == FALSE)
    {
        // Remove everything from that spell, might as well...
        PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_PYROTECHNICS, oTarget);

        // Declare effects
        effect eStrength = EffectAbilityDecrease(ABILITY_STRENGTH, 4);
        effect eDexterity = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
        effect eAbility = EffectLinkEffects(eStrength, eDexterity);

        // Fire cast spell at event for the target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PYROTECHNICS);

        // Duration - 1d4 rounds
        float fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, PHS_GetAOEMetaMagic());

        // Apply it for the duration above
        PHS_ApplyDuration(oTarget, eAbility, fDuration);
    }
}
