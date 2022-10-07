/*:://////////////////////////////////////////////
//:: Spell Name Resilient Sphere
//:: Spell FileName PHS_S_ResilientS
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Force]
    Level: Sor/Wiz 4
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: A sphere, centered around a creature
    Duration: 1 min./level (D)
    Saving Throw: Reflex negates
    Spell Resistance: Yes

    A globe of shimmering force encloses a creature, which diameter is
    0.33M/level (1ft), provided the creature is small enough to fit within the
    diameter of the sphere, which is based on each creature individually.

    The sphere contains its subject for the spell’s duration. The sphere is not
    subject to damage of any sort except from a rod of cancellation, a rod of
    negation, a disintegrate spell, or a targeted dispel magic spell. These
    effects destroy the sphere without harm to the subject. Nothing can pass
    through the sphere, inside or out, though the subject can breathe normally.

    The subject may struggle, but is stuck fast, and the sphere cannot be
    physically moved either by people outside it or by the struggles of those
    within.

    Material Component: A hemispherical piece of clear crystal and a matching
    hemispherical piece of gum arabic.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This will encase creatures. Each one has a seperate size, well, of course
    all of a similar type (all orgres, all dragons...all hobgoblins).

    Each level means 0.33M more radius. Hmm, that translates to 0.33 per 2 levels,
    at level 10, it'd be 3.33M radius, big enough for many creatures.

    Reflex save negates, SR applies.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Returns the diameter needed for oTarget to be encased. Usually it is the
// height of the creature, but sometimes they are wider then tall, so it
// returns that.
float GetCasterSize(object oTarget);

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_RESILIENT_SPHERE)) return;

    // Delcare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    float fSize = GetCasterSize(oTarget);
    float fCasterSize = 0.33 * IntToFloat(nCasterLevel);

    // Check sizes
    // * If fCasterSize is, say, 3.33, but the target is 3.66 or over, we
    //   fail.
    if(fCasterSize < fSize)
    {
        // Report failure
        FloatingTextStringOnCreature("*Resilient sphere failed, target too large*", oCaster, FALSE);
        return;
    }

    // Get duration
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eStop = EffectCutsceneImmobilize();
    effect eStopDur = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
    effect eDur = EffectVisualEffect(PHS_VFX_DUR_RESILIENT_SPHERE);
    effect eImmunities = PHS_AllImmunitiesLink();

    // Link effects
    effect eLink = EffectLinkEffects(eStop, eStopDur);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eImmunities);

    // Fire spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_RESILIENT_SPHERE, TRUE);

    // PvP and plot/immortal check
    if(!GetIsReactionTypeFriendly(oTarget) && PHS_CanCreatureBeDestroyed(oTarget))
    {
        // We don't check turning but DO check spell resistance + immunity.
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Reflex save negates
            if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_SPELL))
            {
                // Apply effects and visuals. "Plot" is a case of them having lots
                // of immunities.
                PHS_ApplyDuration(oTarget, eLink, fDuration);
            }
        }
    }
}

// Returns the diameter needed for oTarget to be encased. Usually it is the
// height of the creature, but sometimes they are wider then tall, so it
// returns that.
float GetCasterSize(object oTarget)
{
    /*
    Lev = Diam | Radius
    1   = 0.33 |
    2   = 0.66 | 0.33
    3   = 1.00 | 0.5
    4   = 1.33 |
    5   = 1.66 |
    6   = 2.00 | 1
    7   = 2.33 |
    8   = 2.66 |
    9   = 3.00 | 1.5
    10  = 3.33 |
    11  = 3.66 |
    12  = 4.00 | 2
    13  = 4.33 |
    14  = 4.66 |
    15  = 5.00 | 2.5
    16  = 5.33 |
    17  = 5.66 |
    18  = 6.00 | 3
    19  = 6.33 |
    20  = 6.66 |
    */

    // NOTE:
    // CAN FINISH SOMETIME, AND I NEED TO REALLY (Dragons are not the
    // same size as all Huge creatures).

    // Check appearance first
    switch(GetAppearanceType(oTarget))
    {
        // Do PC races first
        // Human, the "Medium of medium".
        // * Need 2.33M max, for the height really.
        // "Medium: As Medium creatures, humans have no special bonuses or
        //  penalties due to their size."
        case APPEARANCE_TYPE_HUMAN:
        case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_01:
        case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_02:
        case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_03:
        case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_04:
        case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_05:
        case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_06:
        case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_07:
        case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_08:
        case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_09:
        case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_10:
        case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_11:
        case APPEARANCE_TYPE_HUMAN_NPC_FEMALE_12:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_01:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_02:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_03:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_04:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_05:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_06:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_07:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_08:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_09:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_10:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_11:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_12:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_13:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_14:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_15:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_16:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_17:
        case APPEARANCE_TYPE_HUMAN_NPC_MALE_18:
        {
            return 2.33;
        }
        break;
        // Dwarves
        // "Medium: As Medium creatures, dwarves have no special bonuses or
        //  penalties due to their size."
        case APPEARANCE_TYPE_DWARF:
        case APPEARANCE_TYPE_DWARF_NPC_FEMALE:
        case APPEARANCE_TYPE_DWARF_NPC_MALE:
        {
            return 2.33;
        }
        break;
        // Half orcs are classed as medium too.
        case APPEARANCE_TYPE_HALF_ORC:
        case APPEARANCE_TYPE_HALF_ORC_NPC_FEMALE:
        case APPEARANCE_TYPE_HALF_ORC_NPC_MALE_01:
        case APPEARANCE_TYPE_HALF_ORC_NPC_MALE_02:
        {
            return 2.33;
        }
        break;
        // Elves, they are slightly taller then humans, return the same value though.
        // "Medium: As Medium creatures, elves have no special bonuses or
        //  penalties due to their size."
        // Half elves too.
        case APPEARANCE_TYPE_ELF:
        case APPEARANCE_TYPE_HALF_ELF:// Have these in here too.
        case APPEARANCE_TYPE_ELF_NPC_FEMALE:
        case APPEARANCE_TYPE_ELF_NPC_MALE_01:
        case APPEARANCE_TYPE_ELF_NPC_MALE_02:
        {
            return 2.33;
        }
        break;
        // Halflings are dead tiny, like gnomes
        // "Halflings stand about 3 feet tall and usually weigh between
        //  30 and 35 pounds."
        // Return 1.33M diameter (thier hands ETC). By default, the caster
        // should be the right level anyway (level 4 spell)
        case APPEARANCE_TYPE_HALFLING:
        case APPEARANCE_TYPE_HALFLING_NPC_FEMALE:
        case APPEARANCE_TYPE_HALFLING_NPC_MALE:
        {
            return 1.33;
        }
        break;
        // Gnomes are the same as halflings
        case APPEARANCE_TYPE_GNOME:
        case APPEARANCE_TYPE_GNOME_NPC_FEMALE:
        case APPEARANCE_TYPE_GNOME_NPC_MALE:
        {
            return 1.33;
        }
        break;
        // Default: Default to size check.
        default:
        {
            switch(GetCreatureSize(oTarget))
            {
                case CREATURE_SIZE_HUGE:
                {
                    return 9.33;
                }
                break;
                case CREATURE_SIZE_LARGE:
                {
                    return 5.0;
                }
                break;
                case CREATURE_SIZE_MEDIUM:
                {
                    return 2.33;
                }
                break;
                case CREATURE_SIZE_SMALL:
                {
                    return 1.33;
                }
                break;
                case CREATURE_SIZE_TINY:
                {
                    return 0.66;
                }
                break;
            }
        }
        break;
    }
    // Return a default of 3.33M (level 10)
    return 3.33;
}
