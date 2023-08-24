/*:://////////////////////////////////////////////
//:: Spell Name Summon Monster I
//:: Spell FileName PHS_S_SummonMon1
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Summoning) [see text]
    Level: Brd 1, Clr 1, Sor/Wiz 1
    Components: V, S, F/DF
    Casting Time: 1 round
    Range: Close (8M)
    Effect: One summoned creature
    Duration: 1 + 1 round/level (D)
    Saving Throw: None
    Spell Resistance: No

    This spell summons an extraplanar creature (typically an outsider,
    elemental, or magical beast native to another plane). It appears where you
    designate and attacks your opponents to the best of its ability. You can
    communicate with the creature, you can direct it not to attack, to attack
    particular enemies, or to perform other actions.

    The spell conjures one of the creatures from the 1st-level list on the
    accompanying Summon Monster table. You choose which kind of creature to
    summon, and you can change that choice each time you cast the spell.

    A summoned monster cannot summon or otherwise conjure another creature, nor
    can it use any teleportation or planar travel abilities.

    When you use a summoning spell to summon an air, chaotic, earth, evil, fire,
    good, lawful, or water creature, it is a spell of that type.

    Arcane Focus: A tiny bag and a small (not necessarily lit) candle.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Summons a monster from this list:

    1st Level
  1 Celestial dog - LG
  2 Celestial owl - LG
  3 Celestial giant fire beetle - NG
  4 Celestial badger - CG
  5 Celestial monkey - CG

  6 Fiendish dire rat - LE
  7 Fiendish raven - LE
  8 Fiendish monstrous centipede, Medium - NE
  9 Fiendish monstrous scorpion, Small - NE
 10 Fiendish hawk - CE
 11 Fiendish monstrous spider, Small - CE
 12 Fiendish snake, Small viper - CE

    Stored previously on the caster.

    2 spells for each Summon Monster spell provides either a random summon
    (with resulting alignment checks) or a pre-chosen one (one single level
    1 summon, set in conversation. If not set, defaults to random).

    Higher level spells which can summon lower level monsters get more sub-dials,
    as they have more options (and thus need more variety in battle).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellId = GetSpellId();

    // Duration - 1 round, + 1 round/caster level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel + 1, nMetaMagic);

    // Is it a chosen choice?
    int nChoice;
    string sResRef;
    if(nSpellId == PHS_SPELL_SUMMON_MONSTER_I_CHOICE)
    {
        // Check if valid
        nChoice = PHS_SummonMonsterGetChoice(1);
        sResRef = PHS_SummonMonsterChoice(1, nChoice);
        if(sResRef == "")
        {
            // Get a random one.
            sResRef = PHS_SummonMonsterRandom_1(oCaster);
        }
    }
    // Else, get a random one
    else
    {
        sResRef = PHS_SummonMonsterRandom_1(oCaster);
    }

    // Declare effects
    effect eSummon = EffectSummonCreature(sResRef, VFX_FNF_SUMMON_MONSTER_1, 0.5);

    // Apply effects
    PHS_ApplySummonMonster(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);
}
