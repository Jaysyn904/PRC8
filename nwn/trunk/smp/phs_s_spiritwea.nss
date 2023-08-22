/*:://////////////////////////////////////////////
//:: Spell Name Spiritual Weapon
//:: Spell FileName PHS_S_SpiritWea
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Force]
    Level: Clr 2, War 2
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Magic weapon of force
    Duration: 1 round/level (D)
    Saving Throw: None
    Spell Resistance: Yes

    A weapon made of pure force springs into existence and attacks opponents at
    a distance, as you direct it, dealing 1d8 force damage per hit, +1 point per
    three caster levels (maximum +5 at 15th level). The weapon takes the shape
    of a weapon of your chosen alignment (a weapon with some spiritual
    significance or symbolism to you, see below) and has the same threat range
    and critical multipliers as a real weapon of its form.

    It attempts to strike a single target each round. It will attack the closest
    enemy to the chosen spell location, then subsiquently any nearest enemy,
    until non remain. It uses your base attack bonus (possibly allowing it
    multiple attacks per round in subsequent rounds) plus your Wisdom modifier
    as its attack bonus. It strikes as a spell, not as a weapon, so, for example,
    it can damage creatures that have damage reduction. Your feats or combat
    actions do not affect the weapon. If the weapon goes beyond the spell range
    or if it goes out of your sight, the weapon returns to you and hovers.

    A spiritual weapon cannot be attacked or harmed by physical attacks, but
    dispel magic, disintegrate, a sphere of annihilation, or a rod of
    cancellation affects it. A spiritual weapon’s AC against touch attacks is
    12 (10 + size bonus for Tiny object).

    If an attacked creature has spell resistance, you make a caster level check
    (1d20 + caster level) against that spell resistance the first time the
    spiritual weapon strikes it. If the weapon is successfully resisted, the
    spell is dispelled. If not, the weapon has its normal full effect on that
    creature for the duration of the spell.

    The weapon that you get is dependant upon your alignment. A neutral cleric
    creates a spiritual weapon of a random alignment. The weapons associated
    with each alignment are as follows.

    Chaos: Battleaxe
    Evil: Light flail
    Good: Warhammer
    Law: Longsword
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Creates a spiritual weapon invisible person.

    Then, will create one of the 4 special weapon on them. This weapon, by default,
    has the On Hit property for checking spell resistance on a target. It also
    does magical damage of the amount specified, and does "No Combat Damage" otherwise.

    Base attack bonus is done by leveling the spiritual weapon to the right BAB,
    adding some for wisdom ETC.

    The AI is "Attack nearest enemy with the weapon". If the spell is dispelled,
    or whatever, it goes.

    If it moves out of the spell range (20M), or the caster cannot see it,
    it moves back to the caster.

    No ranged weapons (using the default ones).

    Oh, and the closest weapon is chosen. If more then 1 are appropriate, then
    it will randomise it.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

const string PHS_SPIRIT_BATTLEAXE = "phs_spiritaxe";
const string PHS_SPIRIT_FLAIL     = "phs_spiritflail";
const string PHS_SPIRIT_WARHAMMER = "phs_spirithammer";
const string PHS_SPIRIT_LONGSWORD = "phs_spiritsword";

// Creates and appropriate weapon for oCaster, on oSpirit, and returns it.
//    Chaos: Battleaxe
//    Evil: Light flail
//    Good: Warhammer
//    Law: Longsword
object WeaponToCreate(object oCaster, object oSpirit);

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SPIRITUAL_WEAPON)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration - 1 round/level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare visual effects
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oCaster, PHS_SPELL_SPIRITUAL_WEAPON, FALSE);

    // Create the Spiritual Weapon.
    object oSpiritualWeapon = CreateObject(OBJECT_TYPE_CREATURE, PHS_CREATURE_RESREF_SPIRITUAL_WEAPON, lTarget);

    // Assign its new master, but only to the weapon itself
    SetLocalObject(oSpiritualWeapon, "PHS_MASTER", oCaster);

    // Add the weapon for them to use
    object oWeaponCreated = WeaponToCreate(oCaster, oSpiritualWeapon);

    // Add the correct damage. Does up to an extra +5. 1/3 levels
    int nExtraDamage = PHS_LimitInteger(nCasterLevel/3, 5, 0);
    // Add the damage to the sword
    if(nExtraDamage > 0)
    {
        // Item property.
        itemproperty IP_Damage = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IPGetDamageBonusConstantFromNumber(nExtraDamage));

        // Add it.
        AddItemProperty(DURATION_TYPE_PERMANENT, IP_Damage, oWeaponCreated);
    }

    // And add its appropriate attack bonus via using a duration effect.
    int nStat;
    // Check if it was cast from an item
    if(GetIsObjectValid(GetSpellCastItem()))
    {
        // Minimum bonus stat needed to cast the spell
        nStat = 2;
    }
    else
    {
        // Else normal ability
        nStat = PHS_LimitInteger(PHS_GetAppropriateAbilityBonus(), 20);
    }

    // Apply stat bonus to attack
    if(nStat > 1)
    {
        // Link eDur (visual) and the attack bonus
        effect eAttack = EffectAttackIncrease(nStat);
        effect eLink = EffectLinkEffects(eAttack, eDur);

        // Apply the duration VFX with attack
        PHS_ApplyDurationAndVFX(oSpiritualWeapon, eVis, eLink, fDuration);
    }
    else
    {
        // Apply the duration VFX
        PHS_ApplyDurationAndVFX(oSpiritualWeapon, eVis, eDur, fDuration);
    }

    // Apply level up for the BAB.
    int nBAB = GetBaseAttackBonus(oCaster);
    if(nBAB > 1)
    {
        int nCnt;
        int nPackage = GetCreatureStartingPackage(oSpiritualWeapon);
        for(nCnt = 1; nCnt < nBAB; nCnt++)
        {
            // Always stop if it doesn't work.
            if(LevelUpHenchman(oSpiritualWeapon, CLASS_TYPE_MAGICAL_FORCE, FALSE, nPackage) == 0)
            {
                // Debug
                SendMessageToPC(oCaster, "Debug: Uh-oh, Spiritual weapon didn't level...");
                break;
            }
        }
    }
}

// Creates and appropriate weapon for oCaster, on oSpirit, and returns it.
//    Chaos: Battleaxe
//    Evil: Light flail
//    Good: Warhammer
//    Law: Longsword
object WeaponToCreate(object oCaster, object oSpirit)
{
    object oWeapon;
    string sResRef;
    // Get ALIGNMENT_ constants to check
    int nGoodEvil = GetAlignmentGoodEvil(oCaster);
    int nLawChaos = GetAlignmentLawChaos(oCaster);
    //int nLawChaosValue = Might make less random by checking good/evil/law/chaos
    //int nGoodEvilValue = values for the "Lawful Good" ones.

    // Check the good/evil alignments.
    if(nGoodEvil == ALIGNMENT_NEUTRAL)
    {
        // They are "Neutral" (In good/evil)
        // Check Law/Chaos
        if(nLawChaos == ALIGNMENT_NEUTRAL)
        {
            // * If *totally* neutral, randomise between them all.
            switch(Random(4))
            {
                case 0:  { sResRef = PHS_SPIRIT_BATTLEAXE; } break;
                case 1:  { sResRef = PHS_SPIRIT_FLAIL;     } break;
                case 2:  { sResRef = PHS_SPIRIT_WARHAMMER; } break;
                default: { sResRef = PHS_SPIRIT_LONGSWORD; } break;
            }
        }
        else if(nLawChaos == ALIGNMENT_LAWFUL)
        {
            // If Lawful Neutral, we create a Longsword
            sResRef = PHS_SPIRIT_LONGSWORD;
        }
        else //if(nLawChaos == ALIGNMENT_CHAOTIC)
        {
            // If Chaotic Neutral, we create a Battleaxe
            sResRef = PHS_SPIRIT_BATTLEAXE;
        }
    }
    else if(nGoodEvil == ALIGNMENT_GOOD)
    {
        // They are "Good"
        // Check Law/Chaos
        if(nLawChaos == ALIGNMENT_NEUTRAL)
        {
            // If Neutral Good, create a Warhammer
            sResRef = PHS_SPIRIT_WARHAMMER;
        }
        else if(nLawChaos == ALIGNMENT_LAWFUL)
        {
            // If Lawful Good, we will create either a Longsword or a Warhammer
            // If more lawful then more good, we create a longsword more often.
            if(d2() == 1)
            {
                sResRef = PHS_SPIRIT_LONGSWORD;
            }
            else
            {
                sResRef = PHS_SPIRIT_WARHAMMER;
            }
        }
        else //if(nLawChaos == ALIGNMENT_CHAOTIC)
        {
            // If Chaotic Good, we create a Battleaxe or a Warhammer
            if(d2() == 1)
            {
                sResRef = PHS_SPIRIT_BATTLEAXE;
            }
            else
            {
                sResRef = PHS_SPIRIT_WARHAMMER;
            }
        }
    }
    else if(nGoodEvil == ALIGNMENT_EVIL)
    {
        // They are "Evil"
        // Check Law/Chaos
        if(nLawChaos == ALIGNMENT_NEUTRAL)
        {
            // If Neutral Evil, create a Light Flail
            sResRef = PHS_SPIRIT_FLAIL;
        }
        else if(nLawChaos == ALIGNMENT_LAWFUL)
        {
            // If Lawful Evil, we will create either a Longsword or a Light Flail
            if(d2() == 1)
            {
                sResRef = PHS_SPIRIT_LONGSWORD;
            }
            else
            {
                sResRef = PHS_SPIRIT_FLAIL;
            }
        }
        else //if(nLawChaos == ALIGNMENT_CHAOTIC)
        {
            // If Chaotic Evil, we create a Battleaxe or a Light Flail
            if(d2() == 1)
            {
                sResRef = PHS_SPIRIT_BATTLEAXE;
            }
            else
            {
                sResRef = PHS_SPIRIT_FLAIL;
            }
        }
    }
    // Create oWeapon
    oWeapon = CreateItemOnObject(sResRef, oSpirit, 1);

    return oWeapon;
}
