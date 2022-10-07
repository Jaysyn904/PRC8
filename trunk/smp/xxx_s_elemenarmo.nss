/*:://////////////////////////////////////////////
//:: Spell Name Elemental Armor
//:: Spell FileName XXX_S_ElemenArmo
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration (see text)
    Level: Drd 7, Clr 8
    Components: V, S
    Casting Time: 1 standard action
    Range: Personal
    Target: Caster
    Duration: 10 rounds/level
    Saving Throw: None
    Spell Resistance: No
    Source: Various (Arilou_skiff)

    The caster enshrouds himself in an elemental armour, the armour can be of
    either Earth, Fire, Water, or Air variety, each having different effects as
    described below.

    Air
    The caster is surrounded by a cloudy, whispy air shield, that provides a +5
    dodge bonus to AC, and 10 points of electricity and cold resistance.

    Earth
    The caster is surrounded by a earthly, stone shield, that provides a 10
    points of acid resistance, and damage reduction 10/+3.

    Fire
    The caster is surrounded by a flaming hot shield, that provides a 10 points
    of fire and cold resistance, and any creature striking the caster in melee
    suffers 2d6 points of fire damage

    Water
    The caster is surrounded by a watery and wet shield, that provides a 10
    points of fire and cold resistance, and +2 regeneration.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    - Might need to change the levels, I had to remove some parts of it.
    - Might also need to lessen the amount of damage resistance - perhaps one
      element each, cold for fire, electricity for air, acid for earth.

    Oh, but it seems fine to add to NwN as it is above.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{

    // Spell hook check.
    if(!SMP_SpellHookCheck(SMP_SPELL_ELEMENTAL_ARMOR)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellId = GetSpellId();

    // Duration - 10 Rounds/level
    float fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel * 10, nMetaMagic);

    // Get the link of duration effects
    effect eLink;

    // Check spell
    if(nSpellId == SMP_SPELL_ELEMENTAL_ARMOR_AIR)
    {
        // +5 dodge, 10 cold/electrical resistance.
        effect eAir1 = EffectACIncrease(5, AC_DODGE_BONUS);
        effect eAir2 = EffectDamageResistance(DAMAGE_TYPE_COLD, 10);
        effect eAir3 = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10);
        effect eAir4 = EffectVisualEffect(SPELL_PROTECTION_FROM_ELEMENTS);
        // Link air
        eLink = EffectLinkEffects(eAir1, eAir2);
        eLink = EffectLinkEffects(eLink, eAir3);
        eLink = EffectLinkEffects(eLink, eAir4);
    }
    else if(nSpellId == SMP_SPELL_ELEMENTAL_ARMOR_EARTH)
    {
        // 10 acid resistance, 10/+3 DR.
        effect eEarth1 = EffectDamageReduction(10, DAMAGE_POWER_PLUS_THREE);
        effect eEarth2 = EffectDamageResistance(DAMAGE_TYPE_ACID, 10);
        effect eEarth3 = EffectVisualEffect(SPELL_PROTECTION_FROM_ELEMENTS);
        // Link earth
        eLink = EffectLinkEffects(eEarth1, eEarth2);
        eLink = EffectLinkEffects(eLink, eEarth3);
    }
    else if(nSpellId == SMP_SPELL_ELEMENTAL_ARMOR_FIRE)
    {
        // 10 cold/fire resistance, 2d6 fire damage on melee hits.
        effect eFire1 = EffectDamageShield(0, DAMAGE_BONUS_2d6, DAMAGE_TYPE_FIRE);
        effect eFire2 = EffectDamageResistance(DAMAGE_TYPE_FIRE, 10);
        effect eFire3 = EffectDamageResistance(DAMAGE_TYPE_COLD, 10);
        effect eFire4 = EffectVisualEffect(SPELL_PROTECTION_FROM_ELEMENTS);
        // Link fire
        eLink = EffectLinkEffects(eFire1, eFire2);
        eLink = EffectLinkEffects(eLink, eFire3);
        eLink = EffectLinkEffects(eLink, eFire4);
    }
    // Default to water
    else // if(nSpellId == SMP_SPELL_ELEMENTAL_ARMOR_WATER)
    {
        // 10 cold/fire resistance, +2 regeneration
        effect eWater1 = EffectRegenerate(2, 6.0);
        effect eWater2 = EffectDamageResistance(DAMAGE_TYPE_FIRE, 10);
        effect eWater3 = EffectDamageResistance(DAMAGE_TYPE_COLD, 10);
        effect eWater4 = EffectVisualEffect(SPELL_PROTECTION_FROM_ELEMENTS);
        // Link air
        eLink = EffectLinkEffects(eWater1, eWater2);
        eLink = EffectLinkEffects(eLink, eWater3);
        eLink = EffectLinkEffects(eLink, eWater4);
    }

    // Oh, we add cessate here
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    eLink = EffectLinkEffects(eLink, eCessate);

    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);

    // We don't remove previous castings except of the same spell.
    SMP_RemoveSpellEffectsFromTarget(nSpellId, oTarget);

    // Signal event
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_ELEMENTAL_ARMOR, FALSE);

    // Apply effects
    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
