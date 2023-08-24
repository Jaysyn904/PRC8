/*:://////////////////////////////////////////////
//:: Spell Name Call Lightning
//:: Spell FileName SMP_S_CallLgh
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Electricity]
    Level: Drd 3
    Components: V, S
    Casting Time: 1 round
    Range: Medium (20M)
    Effect: One or more vertical lines of lightning
    Duration: 1 min./level
    Saving Throw: Reflex half
    Spell Resistance: Yes

    Immediately upon completion of the spell, and once per round thereafter,
    you may call down a vertical bolt of lightning that deals 3d6 points of
    electricity damage to one target. The bolt of lightning flashes down in a
    vertical stroke at whatever target point you choose within the spell’s
    range (measured from your position at the time).

    You need not call a bolt of lightning immediately; other actions, even
    spellcasting, can be performed. However, each round after the first you
    may use a standard action (concentrating on the spell) to call a bolt.
    You may call a total number of bolts equal to your caster level (maximum
    10 bolts).

    If you are outdoors and in a stormy area - a rain shower, clouds - each bolt
    deals 3d10 points of electricity damage instead of 3d6.

    This spell functions indoors or underground.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    A second spell file calls down the bolts (+ 1 here) as long as they
    have cast not as many as the spell lets you, and got the spell visual
    still applied.

    Call Lightning Bolt power needs caster levels
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck()) return;

    // Delcare major variables.
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// This should be an enemy
    object oArea = GetArea(oCaster);
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nBolts = SMP_LimitInteger(nCasterLevel, 10);
    int nDam;

    // Duration is 1 mintute/level
    float fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S); // Small one

    // Add charges for this spell.
    SMP_AddChargesForSpell(SMP_SPELL_CALL_LIGHTNING, nBolts, fDuration);

    // Apply visual, whatever the effect (PvP and so on)
    // - Kinda a natural effect.
    SMP_ApplyVFX(oTarget, eVis);

    // Check reaction type and equal areas (just in case, for weather stuff)
    if(!GetIsReactionTypeFriendly(oTarget) && oArea == GetArea(oTarget))
    {
        // Signal spell cast at event
        SMP_SignalSpellCastAt(oTarget, SMP_SPELL_CALL_LIGHTNING);

        // Check spell resistance
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            // Damage!
            // - Is it a stormy area
            if(GetWeather(oArea) == WEATHER_RAIN)
            {
                // 3d10
                nDam = SMP_MaximizeOrEmpower(10, 3, nMetaMagic);
            }
            else
            {
                // 3d6
                nDam = SMP_MaximizeOrEmpower(6, 3, nMetaMagic);
            }

            // Reflex save
            nDam = SMP_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_ELECTRICITY, oCaster);

            // Check if we will damage
            if(nDam > 0)
            {
                // Apply damage
                SMP_ApplyDamageToObject(oTarget, nDam, DAMAGE_TYPE_ELECTRICAL);
            }
        }
    }
}
