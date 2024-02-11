/*:://////////////////////////////////////////////
//:: Spell Name Call Lightning Storm
//:: Spell FileName PHS_S_CallLghSt
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Electricity]
    Level: Drd 5
    Components: V, S
    Casting Time: 1 round
    Range: Long (40M)
    Effect: One or more vertical lines of lightning
    Duration: 1 min./level
    Saving Throw: Reflex half
    Spell Resistance: Yes

    Immediately upon completion of the spell, and once per round thereafter,
    you may call down a vertical bolt of lightning that deals 5d6 points of
    electricity damage to one target. The bolt of lightning flashes down in a
    vertical stroke at whatever target point you choose within the spell’s
    range (measured from your position at the time).

    You need not call a bolt of lightning immediately; other actions, even
    spellcasting, can be performed. However, each round after the first you
    may use a standard action (concentrating on the spell) to call a bolt. You
    may call a total number of bolts equal to your caster level (maximum 15
    bolts).

    If you are outdoors and in a stormy area - a rain shower, clouds - each
    bolt deals 5d10 points of electricity damage instead of 3d6.

    This spell functions indoors or underground.
//:://////////////////////////////////////////////
//:: 3E Specific Spell desctiption
//:://////////////////////////////////////////////
    Call Lightning Storm
    Evocation [Electricity]
    Level: Drd 5
    Range: Long (400 ft. + 40 ft./level)

    This spell functions like call lightning, except that each bolt deals 5d6
    points of electricity damage (or 5d10 if created outdoors in a stormy area),
    and you may call a maximum of 15 bolts.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Spell is similar, if no exactly the same as Call Lightning.

    2 sets of spell files, for both easier use and easier debug.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck()) return;

    // Delcare major variables.
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// This should be an enemy
    object oArea = GetArea(oCaster);
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nBolts = PHS_LimitInteger(nCasterLevel, 15);
    int nDam;

    // Duration is 1 mintute/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_M); // Large one

    // Add charges for this spell.
    PHS_AddChargesForSpell(PHS_SPELL_CALL_LIGHTNING_STORM, nBolts, fDuration);

    // Apply visual, whatever the effect (PvP and so on)
    // - Kinda a natural effect.
    PHS_ApplyVFX(oTarget, eVis);

    // Check reaction type and equal areas (just in case, for weather stuff)
    if(!GetIsReactionTypeFriendly(oTarget) && oArea == GetArea(oTarget))
    {
        // Signal spell cast at event
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_CALL_LIGHTNING_STORM);

        // Check spell resistance
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Damage!
            // - Is it a stormy area
            if(GetWeather(oArea) == WEATHER_RAIN)
            {
                // 5d10
                nDam = PHS_MaximizeOrEmpower(10, 5, nMetaMagic);
            }
            else
            {
                // 5d6
                nDam = PHS_MaximizeOrEmpower(6, 5, nMetaMagic);
            }

            // Reflex save
            nDam = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_ELECTRICITY, oCaster);

            // Check if we will damage
            if(nDam > 0)
            {
                // Apply damage
                PHS_ApplyDamageToObject(oTarget, nDam, DAMAGE_TYPE_ELECTRICAL);
            }
        }
    }
}
