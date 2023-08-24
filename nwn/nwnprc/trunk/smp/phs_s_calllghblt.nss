/*:://////////////////////////////////////////////
//:: Spell Name Call Lightning: New Bolt
//:: Spell FileName PHS_S_CallLghBlt
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    This spell power calls down one lightning bolt for either Call Lightning
    Storm or Call Lightning, as appropriate. This will do nothing if you have
    neither of the spells active upon you, or you have run out of bolts to fire.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Calls down a lightning bolt, if we have any of the Call Lightning spells
    on us.

    The caster level of this property is modified each time a level is gained for
    the druid class, of course.

    Levels 5-40 needed (urg) but covers 2 spells.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck()) return;

    // What spell do we have on ourselves?
    int nSpellId;
    if(PHS_CheckChargesForSpell(PHS_SPELL_CALL_LIGHTNING_STORM, FALSE))
    {
        nSpellId = PHS_SPELL_CALL_LIGHTNING_STORM;
    }
    else if(PHS_CheckChargesForSpell(PHS_SPELL_CALL_LIGHTNING))
    {
        nSpellId = PHS_SPELL_CALL_LIGHTNING;
    }

    // Delcare major variables.
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// This should be an enemy
    object oArea = GetArea(oCaster);
    int nCasterLevel = PHS_GetCasterLevel();
    // Get stored save DC from the spell.
    int nSpellSaveDC = GetLocalInt(oCaster, "PHS_LAST_SAVE_DC_" + IntToString(nSpellId));
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDam;

    // Declare effects
    effect eVis;

    // Vary bolts according to spell too
    if(nSpellId == PHS_SPELL_CALL_LIGHTNING)
    {
        eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S); // Small one
    }
    else
    {
        eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_M); // Large one
    }

    // Apply visual, whatever the effect (PvP and so on)
    // - Kinda a natural effect.
    PHS_ApplyVFX(oTarget, eVis);

    // Check reaction type and equal areas (just in case, for weather stuff)
    if(!GetIsReactionTypeFriendly(oTarget) && oArea == GetArea(oTarget))
    {
        // Signal spell cast at event
        PHS_SignalSpellCastAt(oTarget, nSpellId);

        // Check spell resistance
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Damage!
            // - Is it a stormy area
            if(GetWeather(oArea) == WEATHER_RAIN)
            {
                // 3d10
                nDam = PHS_MaximizeOrEmpower(10, 3, nMetaMagic);
            }
            else
            {
                // 3d6
                nDam = PHS_MaximizeOrEmpower(6, 3, nMetaMagic);
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
