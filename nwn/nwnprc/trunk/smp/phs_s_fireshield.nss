/*:://////////////////////////////////////////////
//:: Spell Name Fire Shield
//:: Spell FileName PHS_S_FireShield
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Personal, 1 round/level. Cold or fire based flames - 5M light, and
    1d6 + 1 per caster level in appropriate damage. Also, half damage versus
    the opposite colour chosen (choose fire shield, get 50% cold immunity).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    No Evasion thing here,  at the moment.

    May add later, if we split up GetReflexAdjustedDamage

    Anyway, 2 shields, subdial choice. One spell.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FIRE_SHIELD)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellID = GetSpellId();

    // Duration is 1 round/level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // The damage done back is 1d6 + caster level 1-15.
    int nBonus = PHS_LimitInteger(nCasterLevel, 15);

    // Declare effects
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur;
    effect eImmunityIncrease;
    effect eShield;
    effect eLight;
    effect eLink;

    // Is it a chill shield or warm shield?
    if(nSpellID == PHS_SPELL_FIRE_SHIELD_CHILL)
    {
        eDur = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);// Cold shield
        eImmunityIncrease = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50);
        eLight = EffectVisualEffect(VFX_DUR_LIGHT_BLUE_10);
        eShield = EffectDamageShield(nBonus, DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD);
    }
    // Default to warm
    else //if(nSpellID == PHS_SPELL_FIRE_SHIELD_WARM)
    {
        eDur = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);// Fire shield
        eImmunityIncrease = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50);
        eLight = EffectVisualEffect(VFX_DUR_LIGHT_RED_10);
        eShield = EffectDamageShield(nBonus, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
    }

    // Link effects
    eLink = EffectLinkEffects(eShield, eImmunityIncrease);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eLight);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove previous castings
    PHS_RemoveMultipleSpellEffectsFromTarget(oTarget, PHS_SPELL_FIRE_SHIELD_CHILL, PHS_SPELL_FIRE_SHIELD_CHILL, PHS_SPELL_FIRE_SHIELD);

    //Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FIRE_SHIELD, FALSE);

    // Apply the VFX impact and effects
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
