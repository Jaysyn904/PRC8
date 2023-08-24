/*:://////////////////////////////////////////////
//:: Spell Name Summon Monster II
//:: Spell FileName PHS_S_SummonMon2
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Summoning) [see text]
    Level: Brd 2, Clr 2, Sor/Wiz 2
    Components: V, S, F/DF
    Casting Time: 1 round
    Range: Close (8M)
    Effect: One or more summoned creature
    Duration: 1 + 1 round/level (D)
    Saving Throw: None
    Spell Resistance: No

    This spell summons one or more extraplanar creatures (typically an outsider,
    elemental, or magical beast native to another plane). You can choose 1
    creature from the 2nd level list, or 1d3 creatures of the same type from the
    1st level list. They appears where you designate and attacks your opponents
    to the best of thier abilities. You can communicate with the creatures, you
    can direct them not to attack, to attack particular enemies, or to perform
    other actions.

    You choose which kind of creature to summon, and you can change that choice
    each time you cast the spell if you

    A summoned monster cannot summon or otherwise conjure another creature, nor
    can it use any teleportation or planar travel abilities.

    When you use a summoning spell to summon an air, chaotic, earth, evil, fire,
    good, lawful, or water creature, it is a spell of that type.

    Arcane Focus: A tiny bag and a small (not necessarily lit) candle.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Summons a monster from this list:

    Summon Monster
    2nd Level
  1 Celestial giant bee 	LG
  2 Celestial giant bombardier beetle 	NG
  3 Celestial eagle 	CG

  4 Lemure (devil) 	LE
  5 Fiendish wolf 	LE
  6 Fiendish monstrous centipede, Large 	NE
  7 Fiendish monstrous scorpion, Medium 	NE
  8 Fiendish monstrous spider, Medium 	CE
  9 Fiendish snake, Medium viper 	CE


    Stored previously on the caster.

    Sub-dials:
    Choice 1 II Monster
    Choice 1d3 I Monsters
    Random 1 II Monster
    Random 1d3 I Monsters

    See previous scripts for lists of the summons avalible in them.
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
    int nAlignment = GetAlignmentGoodEvil(oCaster);

    // Duration - 1 round, + 1 round/caster level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel + 1, nMetaMagic);

    const int PHS_SPELL_SUMMON_MONSTER_II_RANDOM_1      = 10000;
const int PHS_SPELL_SUMMON_MONSTER_II_RANDOM_1D3    = 10000;
const int PHS_SPELL_SUMMON_MONSTER_II_CHOICE_1      = 10000;
const int PHS_SPELL_SUMMON_MONSTER_II_CHOICE_1D3    = 10000;

    // Level one summon?
    int nSummon, nChoice;
    if(nSpellId == PHS_SPELL_SUMMON_MONSTER_II_RANDOM_1D3 ||
       nSpellId == PHS_SPELL_SUMMON_MONSTER_II_CHOICE_1D3)
    {
        // Check as for Summon Monster I basically.
        // Is it a chosen choice?
        nChoice = GetLocalInt(OBJECT_SELF, "PHS_SUMMON_MONSTER_CHOICE_1");
        if(nSpellId == PHS_SPELL_SUMMON_MONSTER_II_CHOICE_1D3 && nChoice != 0)
        {
            nSummon = nChoice;
        }
        else // if(nSpellId == PHS_SPELL_SUMMON_MONSTER_II_RANDOM_1D3)
        {

            // Random choice (limited only by alignment)
            if(GetAlignmentGoodEvil(oCaster) != ALIGNMENT_EVIL)
            {
                // Random, 1 to 5.
                nSummon = Random(5) + 1;
            }
            else
            {
                // Else, it'll be number 6-12.
                nSummon = Random(7) + 1;
            }
        }
    }


    // Total resref
    string sResRef = "phs_sm1_" + IntToString(nSummon);

    // Declare effects
    effect eSummon = EffectSummonCreature(sResRef, VFX_FNF_SUMMON_MONSTER_1, 0.5);

    // Apply effects
    PHS_ApplySummonMonster(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);
}
