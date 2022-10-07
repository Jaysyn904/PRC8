/*:://////////////////////////////////////////////
//:: Spell Name Energy Field
//:: Spell FileName XXX_S_EnergyFld
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Also known as: Draconis’s Energy Field
    Level: Sor/Wiz 7
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Medium (20M)
    Area: Fog Spreads to 6.67M radius (20 ft.)
    Duration: 1 round/level
    Saving Throw: None
    Spell Resistance: Yes
    Source: Various (Kevmann)

    This spell creates a caustic fog made of pure negative energy. All living
    creatures within the fog take 2d6 points of negative energy damage for as
    long as they are within the cloud with no save. Undead are healed by negative
    energy, and thusly are healed 2d6 points of damage as long as they stay
    within the cloud.

    The cloud is similar to the solid fog spell when it comes to sight and
    movement, The fog obscures sight, and therefore provides consealment of 20%
    against melee attacks, and 50% against ranged attacks, movement is slowed
    by 80%, and anyone inside the fog has a -2 penalty to all melee attack rolls.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Similar to Acid Fog.

    Higher level:
    - It does negative damage (harder, much harder, to prevent)
    - It heals undead

    Only one level higher. The solid fog effects of course are present as normal.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck(SMP_SPELL_ACID_FOG)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    // Duration in rounds
    float fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(SMP_AOE_PER_ENERGY_FIELD);
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL);

    // Apply effects
    SMP_ApplyLocationDurationAndVFX(lTarget, eImpact, eAOE, fDuration);
}
