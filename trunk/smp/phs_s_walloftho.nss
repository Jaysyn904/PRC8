/*:://////////////////////////////////////////////
//:: Spell Name Wall of Thorns
//:: Spell FileName PHS_S_WallofThor
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation)
    Level: Drd 5, Plant 5
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Wall of thorny brush up to 15M long, 1M/level
    Duration: 10 min./level (D)
    Saving Throw: None
    Spell Resistance: No

    A wall of thorns spell creates a barrier of very tough, pliable, tangled brush
    bearing needle-sharp thorns as long as a human’s finger. Any creature forced
    into or attempting to move through a wall of thorns takes slashing damage equal
    to 25 minus the creature’s AC, that is, the AC of thier armor and shield added
    together, plus the base 10. (Creatures with an Armor Class of 25 or higher,
    without considering Dexterity and dodge bonuses, take no damage from contact
    with the wall.)

    Normal fire cannot harm the barrier, but magical fire burns if it does enough
    damage.

    Despite its appearance, a wall of thorns is not actually a living plant, and
    thus is unaffected by spells that affect plants.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Damage On Enter only, it'll be a wall of thorns.

    Oh, and do a short delay of slow movement too.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_WALL_OF_THORNS)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration in turns
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    effect eAOE;
    // Get AOE based on caster level
    if(nCasterLevel >= 15)
    {
        // Max, 15x1M
        eAOE = EffectAreaOfEffect(PHS_AOE_PER_WALL_OF_THORNS_LEVEL15);
    }
    else if(nCasterLevel == 14)
    {
        eAOE = EffectAreaOfEffect(PHS_AOE_PER_WALL_OF_THORNS_LEVEL14);
    }
    else if(nCasterLevel == 13)
    {
        eAOE = EffectAreaOfEffect(PHS_AOE_PER_WALL_OF_THORNS_LEVEL13);
    }
    else if(nCasterLevel == 12)
    {
        eAOE = EffectAreaOfEffect(PHS_AOE_PER_WALL_OF_THORNS_LEVEL12);
    }
    else if(nCasterLevel == 11)
    {
        eAOE = EffectAreaOfEffect(PHS_AOE_PER_WALL_OF_THORNS_LEVEL11);
    }
    else if(nCasterLevel == 10)
    {
        eAOE = EffectAreaOfEffect(PHS_AOE_PER_WALL_OF_THORNS_LEVEL10);
    }
    else // if(nCasterLevel <= 9)
    {
        // Least, 9x1M
        eAOE = EffectAreaOfEffect(PHS_AOE_PER_WALL_OF_THORNS_LEVEL09);
    }
    // Apply effects
    PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
