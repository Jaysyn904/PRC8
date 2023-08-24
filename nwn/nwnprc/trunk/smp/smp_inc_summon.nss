/*:://////////////////////////////////////////////
//:: Name Summoning include
//:: FileName SMP_INC_SUMMON
//:://////////////////////////////////////////////
    This holds the functions to get the correct summoned monster if random,
    or the restrictions on monsters if in conversations.

    Not sure what else really...

    Tips:

    Uses of the summoning spell

    * When you are being attacked by a flying/swimming/ethereal/etc.
      creature and you don't fly/swim/go ethereal/etc.
    * When you need an ally immune to X
    * When you need some cannon fodder to slow down the main bad guys/give
      them something else to aim at.
    * When your bad guys are in a location that you can't get to (across a
      chasm)
    * When you want to help your thief FLANK someone.
    * When facing someone that has DR/x and you need a creature capable of
      attacking them without penalty.
    * When someone is using an Anti-Life shell or similar effect (Outsiders...)
    * To set off traps, etc.
    * Distractions/cons
    * Short kamikaze missions.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_CONSTANT"

// SMP_INC_SUMMON. Returns TRUE if alignment should influence what we will summon.
int SMP_GetIsDivineSpellCastingClass(int nClass);

// SMP_INC_SUMMON. Will return the choice for nLevel, or FALSE if invalid.
int SMP_SummonMonsterGetChoice(int nLevel, object oCaster = OBJECT_SELF);

// SMP_INC_SUMMON. Returns a resref for nSummonLevel, and nChoice.
string SMP_SummonMonsterChoice(int nLevel, int nChoice);

// SMP_INC_SUMMON. Returns a resref for a random monster on the level 1 Summon Monster list.
// Uses alignments, if a cleric, paladin, or druid or ranger, to choose a correctly
// aligned monster.
string SMP_SummonMonsterRandom_1(object oCaster = OBJECT_SELF);

// SMP_INC_SUMMON. Returns TRUE if alignment should influence what we will summon.
int SMP_GetIsDivineSpellCastingClass(int nClass)
{
    // Divine spellcasters
    switch(nClass)
    {
        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_RANGER:
        {
            return TRUE;
        }
        break;
    }
    return FALSE;
}

// SMP_INC_SUMMON. Will return the choice for nLevel, or FALSE if invalid.
int SMP_SummonMonsterGetChoice(int nLevel, object oCaster = OBJECT_SELF)
{
    // Local set on caster (will move to caster item sometime)
    return GetLocalInt(oCaster, "SMP_SUMMON_MONSTER_CHOICE_" + IntToString(nLevel));
}
// SMP_INC_SUMMON. Returns a resref for nSummonLevel, and nChoice.
string SMP_SummonMonsterChoice(int nLevel, int nChoice)
{
    // String is SMP_smX_Y, where nLevel is X and Y is nChoice
    return "SMP_sm" + IntToString(nLevel) + "_" + IntToString(nChoice);
}
// SMP_INC_SUMMON. Returns a resref for a random monster on the level 1 Summon Monster list.
// Uses alignments, if a cleric, paladin, or druid or ranger, to choose a correctly
// aligned monster.
string SMP_SummonMonsterRandom_1(object oCaster = OBJECT_SELF)
{
/*  Monsters:
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

*/
    int nSummon;
    // Does alignment influence it?
    if(SMP_GetIsDivineSpellCastingClass(GetLastSpellCastClass()))
    {
        // Random choice (limited only by alignment)
        int nAlignGoodEvil = GetAlignmentGoodEvil(oCaster);
        int nAlignLawChaos = GetAlignmentLawChaos(oCaster);
        // Netural Good/Evil
        if(nAlignGoodEvil == ALIGNMENT_NEUTRAL)
        {
            // Check law/chaos.
            if(nAlignLawChaos == ALIGNMENT_NEUTRAL)
            {
                // Any choice
                nSummon = Random(12) + 1;
            }
            // Can be any Good/Evil, but must be lawful or chaotic.
            else if(nAlignLawChaos == ALIGNMENT_CHAOTIC)
            {
                // Cannot be lawful, must be chaotic or neutral.
                /* Monsters:
                  3 Celestial giant fire beetle - NG
                  4 Celestial badger - CG
                  5 Celestial monkey - CG
                  8 Fiendish monstrous centipede, Medium - NE
                  9 Fiendish monstrous scorpion, Small - NE
                 10 Fiendish hawk - CE
                 11 Fiendish monstrous spider, Small - CE
                 12 Fiendish snake, Small viper - CE */
                switch(Random(8) + 1)
                {
                    case 1: nSummon = 3; break;
                    case 2: nSummon = 4; break;
                    case 3: nSummon = 5; break;
                    case 4: nSummon = 8; break;
                    case 5: nSummon = 9; break;
                    case 6: nSummon = 10; break;
                    case 7: nSummon = 11; break;
                    case 8: nSummon = 12; break;
                }
            }
            else //if(nAlignLawChaos == nAlignLawChaos)
            {
                // Cannot be chaotic, must be lawful or neutral.
                /* Monsters:
                  1 Celestial dog - LG
                  2 Celestial owl - LG
                  3 Celestial giant fire beetle - NG
                  6 Fiendish dire rat - LE
                  7 Fiendish raven - LE
                  8 Fiendish monstrous centipede, Medium - NE
                  9 Fiendish monstrous scorpion, Small - NE  */
                switch(Random(7) + 1)
                {
                    case 1: nSummon = 1; break;
                    case 2: nSummon = 2; break;
                    case 3: nSummon = 3; break;
                    case 4: nSummon = 6; break;
                    case 5: nSummon = 7; break;
                    case 6: nSummon = 8; break;
                    case 7: nSummon = 9; break;
                }
            }
        }
        else if(nAlignGoodEvil == ALIGNMENT_GOOD)
        {
            // Only non-evil (Good/Neutral) creatures. This means any good ones, unless
            // they are also chaotic ETC.
            if(nAlignLawChaos == ALIGNMENT_NEUTRAL)
            {
                // Any choice which isn't evil
                /*  Monsters:
                  1 Celestial dog - LG
                  2 Celestial owl - LG
                  3 Celestial giant fire beetle - NG
                  4 Celestial badger - CG
                  5 Celestial monkey - CG  */
                nSummon = Random(5) + 1;
            }
            if(nAlignLawChaos == ALIGNMENT_CHAOTIC)
            {
                // Cannot be lawful, or evil, must be chaotic or neutral.
                /* Monsters:
                  3 Celestial giant fire beetle - NG
                  4 Celestial badger - CG
                  5 Celestial monkey - CG */
                switch(Random(3) + 1)
                {
                    case 1: nSummon = 3; break;
                    case 2: nSummon = 4; break;
                    case 3: nSummon = 5; break;
                }
            }
            else //if(nLawChoas == ALIGNMENT_LAWFUL)
            {
                // Cannot be chaotic, or evil, must be lawful or neutral.
                /* Monsters:
                  1 Celestial dog - LG
                  2 Celestial owl - LG
                  3 Celestial giant fire beetle - NG */
                switch(Random(3) + 1)
                {
                    case 1: nSummon = 1; break;
                    case 2: nSummon = 2; break;
                    case 3: nSummon = 3; break;
                }
            }
        }
        // Evil
        else //if(nAlignGoodEvil == ALIGNMENT_EVIL)
        {
            // No good summons.
            if(nAlignLawChaos == ALIGNMENT_NEUTRAL)
            {
                // Any choice which isn't good
                /*  Monsters:
                  6 Fiendish dire rat - LE
                  7 Fiendish raven - LE
                  8 Fiendish monstrous centipede, Medium - NE
                  9 Fiendish monstrous scorpion, Small - NE
                 10 Fiendish hawk - CE
                 11 Fiendish monstrous spider, Small - CE
                 12 Fiendish snake, Small viper - CE */
                nSummon = Random(7) + 5; // (6 to 12)
            }
            else if(nAlignLawChaos == ALIGNMENT_CHAOTIC)
            {
                // Cannot be lawful, or good, must be chaotic or neutral.
                /* Monsters:
                  8 Fiendish monstrous centipede, Medium - NE
                  9 Fiendish monstrous scorpion, Small - NE
                 10 Fiendish hawk - CE
                 11 Fiendish monstrous spider, Small - CE
                 12 Fiendish snake, Small viper - CE */
                switch(Random(5) + 1)
                {
                    case 1: nSummon = 8; break;
                    case 2: nSummon = 9; break;
                    case 3: nSummon = 10; break;
                    case 4: nSummon = 11; break;
                    case 5: nSummon = 12; break;
                }
            }
            else //if(nAlignLawChaos == nAlignLawChaos)
            {
                // Cannot be chaotic, or good, must be lawful or neutral.
                /* Monsters:
                  6 Fiendish dire rat - LE
                  7 Fiendish raven - LE
                  8 Fiendish monstrous centipede, Medium - NE
                  9 Fiendish monstrous scorpion, Small - NE  */
                switch(Random(4) + 1)
                {
                    case 1: nSummon = 6; break;
                    case 2: nSummon = 7; break;
                    case 3: nSummon = 8; break;
                    case 4: nSummon = 9; break;
                }
            }
        }
    }
    else
    {
        // Alignment doesn't matter. Randomise it.
        nSummon = Random(12) + 1;
    }
    // Total resref
    string sResRef = "SMP_sm1_" + IntToString(nSummon);

    return sResRef;
}


