/*:://////////////////////////////////////////////
//:: Spell Name Warding Whip
//:: Spell FileName XXX_S_WardingWhi
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Also known as: Luskaris’ Warding Whip
    Level: Sor/Wiz 8
    Components: V, S
    Casting Time: 1 standard action
    Range: Long (40M)
    Target: A single creature
    Duration: 1 round/5 levels
    Saving Throw: No
    Spell Resistance: No
    Source: Various (rmilsop)

    This spell strips a creature of its magical protections, removing one
    protection of up to 7th level for each round it is active. It always removes
    the highest level protection that it can. Protections removed by this spell
    include spell turning, globe of invulnerability, repulsion, stoneskin, minor
    globe of invulnerability and similar spells.

    Only one whip from one caster can affect a target at once. This spell
    bypasses spell turning and similar effects.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Sort of like Spell Breach.

    It strips effects - 1 per 5 levels, highest first.

    Powerful, because it doesn't dispel bad effects, nor need any kind
    of dispel check.

    Spells "Dispelled" in order:
X 9 - Absolute Immunity (9)
X 8 - Greater Guardian Mantal (8)
X   - Iron Body (8)
X   - Mind Blank (8)
/ 7 - Spell turning (7)
    - Guardian Mantal (7)
    - Repulstion (7)
    - Antilife Shell (6)
  6 - Globe of Invulnerability (6)
  4 - Stoneskin (4)
    - Fire Shield (4)
    - Lesser Globe of Invunrability (4)
  3 - Protection from Energy (3)
  2 - Protection from Arrows (2)
    - Blur (2)
    - Resist Energy (2)
  1 - Shield (1)
    - Mage Armor (1)
    - Protection from Chaos (1)
    - Protection from Evil (1)
    - Protection from Good (1)
    - Protection from Law (1)
  0 - Resistance (0)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

// Delayed for 6 seconds, this runs itself until oTarget is dead,
// or they don't have the spell's effect anymore.
void SMP_RunWhipImpact(object oTarget, object oCaster);
// Get the spell from this list, best to worst, 1 = best.
// * MAX_SPELLS_IN_LIST is the limit of nListNo.
// Returns SPELL_INVALID on none found.
int GetSpellFromList(int nListNo);

const int MAX_SPELLS_IN_LIST = 19;

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck(SMP_SPELL_WARDING_WHIP)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = SMP_GetCasterLevel();

    // Duration is 1 round/5 levels..
    float fDuration = 0.5 + SMP_GetDuration(SMP_ROUNDS, nCasterLevel/5, FALSE);

    // Delcare Effects
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget) &&
    // Make sure they are not immune to spells
       !SMP_TotalSpellImmunity(oTarget))
    {
        //Fire spell cast at event for target
        SMP_SignalSpellCastAt(oTarget, SMP_SPELL_WARDING_WHIP);

        // Duration effect. Cannot stack
        if(!SMP_GetHasSpellEffectFromCaster(SMP_SPELL_WARDING_WHIP, oTarget, oCaster))
        {
            // Apply new one
            SMP_ApplyDuration(oTarget, eDur, fDuration);

            // Run impact now.
            SMP_RunWhipImpact(oTarget, oCaster);
        }
        else
        {
            // Cannot affect again. Only imact is done.
            FloatingTextStringOnCreature("*You cannot have more then one whip on a target at once*", oTarget, FALSE);
            return;
        }
    }
}

// Delayed for 6 seconds, this runs itself until oTarget is dead,
// or they don't have the spell's effect anymore.
void SMP_RunWhipImpact(object oTarget, object oCaster)
{
    // Check if dead or validity of oTarget.
    if(!GetIsDead(oTarget) && GetIsObjectValid(oTarget))
    {
        // Check the caster.
        if(GetIsObjectValid(oCaster))
        {
            // Check if they have the effect
            if(SMP_GetHasSpellEffectFromCaster(SMP_SPELL_WARDING_WHIP, oTarget, oCaster))
            {
                // Fire spell cast at event for target
                SMP_SignalSpellCastAt(oTarget, SMP_SPELL_WARDING_WHIP);

                // Remove the highest spell on the target.
                // List is above.
                int nCnt, nSpellRemove, bBreak;
                for(nCnt = 1; nCnt <= MAX_SPELLS_IN_LIST && bBreak != TRUE; nCnt++)
                {
                    nSpellRemove = GetSpellFromList(nCnt);
                    if(nSpellRemove == SPELL_INVALID)
                    {
                        bBreak = TRUE;
                    }
                    else
                    {
                        // Remove the next one
                        bBreak = SMP_RemoveSpellEffectsFromTarget(GetSpellFromList(nCnt), oTarget);
                    }
                }
                // Run it again in 6 seconds.
                DelayCommand(6.0, SMP_RunWhipImpact(oTarget, oCaster));
            }
        }
        else
        {
            // Remove the spells effects
            SMP_PRCRemoveSpellEffects(SMP_SPELL_WARDING_WHIP, oCaster, oTarget);
        }
    }
}

// Get the spell from this list, best to worst, 1 = best.
// * MAX_SPELLS_IN_LIST is the limit of nListNo.
// Returns SPELL_INVALID on none found.
int GetSpellFromList(int nListNo)
{
    switch(nListNo)
    {
        // Note: These are levels 8 and 9, so not included, but might be useful
        // another time.
        //case 1:  { return SMP_SPELL_ABSOLUTE_IMMUNITY; } break;
        //case 2:  { return SMP_SPELL_GUARDIAN_MANTLE_GREATER; } break;
        //case 3:  { return SMP_SPELL_IRON_BODY; } break;
        //case 4:  { return SMP_SPELL_MIND_BLANK; } break;
        // Start of level 7 and below spells.
        case 1:  { return SMP_SPELL_SPELL_TURNING; } break;
        case 2:  { return SMP_SPELL_GUARDIAN_MANTLE; } break;
        case 3:  { return SMP_SPELL_REPULSION; } break;
        case 4:  { return SMP_SPELL_ANTILIFE_SHELL; } break;
        case 5:  { return SMP_SPELL_GLOBE_OF_INVUNRABILITY; } break;
        case 6:  { return SMP_SPELL_GLOBE_OF_INVUNRABILITY_LESSER; } break;
        case 7: { return SMP_SPELL_STONESKIN; } break;
        case 8: { return SMP_SPELL_FIRE_SHIELD; } break;// Note: Check if it removes any sub-spells.
        case 9: { return SMP_SPELL_PROTECTION_FROM_ENERGY; } break;// Note: Check if it removes any sub-spells.
        case 10: { return SMP_SPELL_RESIST_ENERGY; } break;// Note: Check if it removes any sub-spells.
        case 11: { return SMP_SPELL_PROTECTION_FROM_ARROWS; } break;
        case 12: { return SMP_SPELL_BLUR; } break;
        case 13: { return SMP_SPELL_SHIELD; } break;
        case 14: { return SMP_SPELL_MAGE_ARMOR; } break;
        case 15: { return SMP_SPELL_PROTECTION_FROM_EVIL; } break;// Note: all seperate anyway.
        case 16: { return SMP_SPELL_PROTECTION_FROM_GOOD; } break;
        case 17: { return SMP_SPELL_PROTECTION_FROM_LAW; } break;
        case 18: { return SMP_SPELL_PROTECTION_FROM_CHAOS; } break;
        case 19: { return SMP_SPELL_RESISTANCE; } break;
    }
    return SPELL_INVALID;
}
