//::///////////////////////////////////////////////
//:: PRC Unlevel Logic
//:: prc_unlvl_script
//:://////////////////////////////////////////////
/*
    This is the logic for removing spells from a PRC class in case of
    unleveling or for fixing issues
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 22.09.2025
//:://////////////////////////////////////////////

#include "tob_inc_tobfunc"
#include "tob_inc_moveknwn"
#include "inv_inc_invfunc"
#include "shd_inc_mystknwn"
#include "shd_inc_shdfunc"
#include "true_inc_truknwn"
#include "true_inc_trufunc"
#include "prc_nui_com_inc"


////////////////////////////////////////////////////////////////////////////
///                                                                      ///
///  Implementations                                                     ///
///                                                                      ///
////////////////////////////////////////////////////////////////////////////

int FindSpellbookId(int nClass, int spellId)
{
    string sFile = GetClassSpellbookFile(nClass);
    int totalSpells = Get2DARowCount(sFile);

    int i;
    for (i = 0; i < totalSpells; i++)
    {
        int currentSpellId = StringToInt(Get2DACache(sFile, "SpellID", i));
        if (currentSpellId == spellId)
            return i;
    }

    return 0;
}

void RemoveSpellsFromPlayer(object oPC, int nClass, string spellArray, string totalSpellsId, int nType=0)
{
    // if we found the spell, then we remove it.
    int totalRemoved = persistant_array_get_size(oPC, spellArray);
    if (DEBUG) DoDebug("Found " + IntToString(totalRemoved) + " spells in " + spellArray + ", removing them.");
    string sFile = GetClassSpellbookFile(nClass);
    int i;
    for (i = 0; i < totalRemoved; i++)
    {
        int spellId = persistant_array_get_int(oPC, spellArray, i);
        int spellbookId = FindSpellbookId(nClass, spellId);

        if (spellbookId != 0)
        {
            // remove spell from player
            string spellName = Get2DACache(sFile, "Label", spellbookId);
            if (DEBUG) DoDebug( "Removing spell " + spellName);
            int ipFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", spellbookId));
            object oSkin = GetPCSkin(oPC);
            RemoveIPFeat(oPC, ipFeatID);
            if (GetIsBladeMagicClass(nClass))
            {
                string sDisciplineArray = _MANEUVER_LIST_DISCIPLINE + IntToString(nType) + "_" + Get2DACache(sFile, "Discipline", spellbookId);
                int totalDiscSpells = GetPersistantLocalInt(oPC, sDisciplineArray);
                SetPersistantLocalInt(oPC, sDisciplineArray, totalDiscSpells - 1);
                if (DEBUG) DoDebug(sDisciplineArray + " total maneuvers is now " + IntToString(totalDiscSpells-1));
            }
        }
    }
    persistant_array_delete(oPC, spellArray);

       int totalSpellCount = GetPersistantLocalInt(oPC, totalSpellsId);
    // decrement the amount of spells known.
    SetPersistantLocalInt(oPC, totalSpellsId,
        totalSpellCount - totalRemoved
        );
       if (DEBUG) DoDebug(totalSpellsId + " total spells is now " + IntToString(totalSpellCount - totalRemoved));
}

string GetMaxSpellsKnownName(int nClass)
{
    if (GetIsShadowMagicClass(nClass))
    {
        return _MYSTERY_LIST_TOTAL_KNOWN;
    }
    if (GetIsInvocationClass(nClass))
    {
        return _INVOCATION_LIST_TOTAL_KNOWN;
    }
    if (GetIsBladeMagicClass(nClass))
    {
        return _MANEUVER_LIST_TOTAL_KNOWN;
    }
    if (GetIsTruenamingClass(nClass))
    {
        return _UTTERANCE_LIST_TOTAL_KNOWN;
    }
    if (GetIsPsionicClass(nClass))
    {
        return _POWER_LIST_TOTAL_KNOWN;
    }

    return "";
}

string GetGeneralArrayId(int nClass)
{
    if (GetIsShadowMagicClass(nClass))
    {
        return _MYSTERY_LIST_GENERAL_ARRAY;
    }
    if (GetIsInvocationClass(nClass))
    {
        return _INVOCATION_LIST_GENERAL_ARRAY;
    }
    if (GetIsBladeMagicClass(nClass))
    {
        return _MANEUVER_LIST_GENERAL_ARRAY;
    }
    if (GetIsTruenamingClass(nClass))
    {
        return _UTTERANCE_LIST_GENERAL_ARRAY;
    }
    if (GetIsPsionicClass(nClass))
    {
        return _POWER_LIST_GENERAL_ARRAY;
    }

    return "";
}

string GetBaseListName(int nClass)
{
    if (GetIsShadowMagicClass(nClass))
    {
        return _MYSTERY_LIST_NAME_BASE;
    }
    if (GetIsInvocationClass(nClass))
    {
        return _INVOCATION_LIST_NAME_BASE;
    }
    if (GetIsBladeMagicClass(nClass))
    {
        return _MANEUVER_LIST_NAME_BASE;
    }
    if (GetIsTruenamingClass(nClass))
    {
        return _UTTERANCE_LIST_NAME_BASE;
    }
    if (GetIsPsionicClass(nClass))
    {
        return _POWER_LIST_NAME_BASE;
    }

    return "";
}

string GetLevelArrayListName(int nClass)
{
    if (GetIsShadowMagicClass(nClass))
    {
        return _MYSTERY_LIST_LEVEL_ARRAY;
    }
        if (GetIsInvocationClass(nClass))
    {
        return _INVOCATION_LIST_LEVEL_ARRAY;
    }
    if (GetIsBladeMagicClass(nClass))
    {
        return _MANEUVER_LIST_LEVEL_ARRAY;
    }
    if (GetIsTruenamingClass(nClass))
    {
        return _UTTERANCE_LIST_LEVEL_ARRAY;
    }
    if (GetIsPsionicClass(nClass))
    {
        return _POWER_LIST_LEVEL_ARRAY;
    }

    return "";
}

void RemoveSpellsAtLevel(object oPC, int nClass, int level, int nList = 0)
{
    if (GetSpellbookTypeForClass(nClass) == SPELLBOOK_TYPE_SPONTANEOUS)
    {
        string sFile = GetClassSpellbookFile(nClass);
        string spellsAtLevelList = ("SpellsKnown_" + IntToString(nClass) + "_AtLevel" + IntToString(level));
        string spellLevelBook = GetSpellsKnown_Array(nClass);
        if (level == 0)
        {
            spellsAtLevelList = spellLevelBook;
            int totalSpells = Get2DARowCount(sFile);
            int i;
            for (i = 0; i < totalSpells; i++)
            {
                int featID = StringToInt(Get2DACache(sFile, "FeatID", i));
                if (featID && GetHasFeat(featID, oPC, TRUE))
                {
                    string spellName = Get2DACache(sFile, "Label", i);
                    if (DEBUG) DoDebug( "Removing spellID " + IntToString(i) + ", spell name: " + spellName);
                    int ipFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", i));
                    WipeSpellFromHide(ipFeatID, oPC);
                }
            }

            persistant_array_delete(oPC, spellsAtLevelList);

        }
        else if (persistant_array_exists(oPC, spellsAtLevelList))
        {
            if (DEBUG) DoDebug( "Removing spells in " + spellsAtLevelList);
            int knownSpellsCount = persistant_array_get_size(oPC, spellsAtLevelList);

            int i;
            for (i = 0; i < knownSpellsCount; i++)
            {
                int spellId = persistant_array_get_int(oPC, spellsAtLevelList, i);
                int spellbookId = FindSpellbookId(nClass, spellId);

                if (spellbookId)
                {
                    array_extract_int(oPC, spellLevelBook, spellbookId);

                    // wipe the spell from the player
                    string spellName = Get2DACache(sFile, "Label", spellbookId);
                    if (DEBUG) DoDebug( "Removing spellID " + IntToString(spellbookId) + ", spell name: " + spellName);
                    int ipFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", spellbookId));
                    WipeSpellFromHide(ipFeatID, oPC);
                }

            }

            persistant_array_delete(oPC, spellsAtLevelList);

            if (nClass == CLASS_TYPE_BEGUILER
                || nClass == CLASS_TYPE_DREAD_NECROMANCER
                || nClass == CLASS_TYPE_WARMAGE)
            {
                int nAdvLearn = GetPersistantLocalInt(oPC, "AdvancedLearning_"+IntToString(nClass)) - knownSpellsCount;
                SetPersistantLocalInt(oPC, "AdvancedLearning_"+IntToString(nClass), nAdvLearn);
            }
        }
    }
    else
    {
        int chosenList = (nList != 0) ? nList : nClass;
        string baseList = GetBaseListName(nClass);
        string totalCountId = GetMaxSpellsKnownName(nClass);

        if (GetIsBladeMagicClass(nClass))
        {

            // remove maneuvers
            int maneuver;
            for (maneuver = 1; maneuver <= MANEUVER_TYPE_MANEUVER; maneuver++)
            {
                string spellArray = baseList + IntToString(chosenList) + IntToString(maneuver);
                if (level == 0)
                {
                    spellArray += GetGeneralArrayId(nClass);
                }
                else
                {
                   spellArray += GetLevelArrayListName(nClass) + IntToString(level);
                }
                if (persistant_array_exists(oPC, spellArray))
                {
                    string totalSpellsId = baseList + IntToString(chosenList) + IntToString(maneuver) + totalCountId;
                    RemoveSpellsFromPlayer(oPC, nClass, spellArray, totalSpellsId, maneuver);
                }
            }

            return;
        }
        else if (GetIsTruenamingClass(nClass))
        {
            // Lexicon 1
            string spellArray = baseList + IntToString(chosenList) + "1";
            if (level == 0)
            {
                spellArray += GetGeneralArrayId(nClass);
            }
            else
            {
               spellArray += GetLevelArrayListName(nClass) + IntToString(level);
            }
            if (persistant_array_exists(oPC, spellArray))
            {
                string totalSpellsId = baseList + IntToString(chosenList) + totalCountId;
                RemoveSpellsFromPlayer(oPC, nClass, spellArray, totalSpellsId);
            }

            // Lexicon 2
            spellArray = baseList + IntToString(chosenList) + "2";
            if (level == 0)
            {
                spellArray += GetGeneralArrayId(nClass);
            }
            else
            {
               spellArray += GetLevelArrayListName(nClass) + IntToString(level);
            }
            if (persistant_array_exists(oPC, spellArray))
            {
                string totalSpellsId = baseList + IntToString(chosenList) + totalCountId;
                RemoveSpellsFromPlayer(oPC, nClass, spellArray, totalSpellsId);
            }

            // Lexicon 3
            spellArray = baseList + IntToString(chosenList) + "3";
            if (level == 0)
            {
                spellArray += GetGeneralArrayId(nClass);
            }
            else
            {
               spellArray += GetLevelArrayListName(nClass) + IntToString(level);
            }
            if (persistant_array_exists(oPC, spellArray))
            {
                string totalSpellsId = baseList + IntToString(chosenList) + totalCountId;
                RemoveSpellsFromPlayer(oPC, nClass, spellArray, totalSpellsId);
            }

            return;
        }

        string spellArray = (baseList + IntToString(chosenList));
        if (level == 0)
        {
            spellArray += GetGeneralArrayId(nClass);
        }
        else
        {
           spellArray += GetLevelArrayListName(nClass) + IntToString(level);
        }
        if (persistant_array_exists(oPC, spellArray))
        {
            if (DEBUG) DoDebug( "Removing spells from " + spellArray);
            string totalSpellsId = baseList + IntToString(chosenList) + totalCountId;
            RemoveSpellsFromPlayer(oPC, nClass, spellArray, totalSpellsId);
        }
    }
}

int IsClassPRCSpellCaster(int nClass, object oPlayer)
{
    // This controls who can use the Spellbook NUI, if for some reason you don't
    // want a class to be allowed to use this you can comment out their line here

    // Bard and Sorc are allowed if they took a PRC that makes them use the spellbook
    if (GetSpellbookTypeForClass(nClass) == SPELLBOOK_TYPE_SPONTANEOUS
        || GetSpellbookTypeForClass(nClass) == SPELLBOOK_TYPE_PREPARED)
         return TRUE;

    // Arcane Spont
    if (nClass == CLASS_TYPE_ASSASSIN
        || nClass == CLASS_TYPE_BEGUILER
        || nClass == CLASS_TYPE_CELEBRANT_SHARESS
        || nClass == CLASS_TYPE_DREAD_NECROMANCER
        || nClass == CLASS_TYPE_DUSKBLADE
        || nClass == CLASS_TYPE_HARPER
        || nClass == CLASS_TYPE_HEXBLADE
        || nClass == CLASS_TYPE_KNIGHT_WEAVE
        || nClass == CLASS_TYPE_SHADOWLORD
        || nClass == CLASS_TYPE_SUBLIME_CHORD
        || nClass == CLASS_TYPE_SUEL_ARCHANAMACH
        || nClass == CLASS_TYPE_WARMAGE)
        return TRUE;

    // Psionics
    if  (nClass == CLASS_TYPE_FIST_OF_ZUOKEN
        || nClass == CLASS_TYPE_PSION
        || nClass == CLASS_TYPE_PSYWAR
        || nClass == CLASS_TYPE_WILDER
        || nClass == CLASS_TYPE_PSYCHIC_ROGUE
        || nClass == CLASS_TYPE_WARMIND)
        return TRUE;

    // Invokers
    if (nClass == CLASS_TYPE_WARLOCK
        || nClass == CLASS_TYPE_DRAGON_SHAMAN
        || nClass == CLASS_TYPE_DRAGONFIRE_ADEPT)
        return TRUE;

    // Divine Spont
    if (nClass == CLASS_TYPE_ARCHIVIST //while technically prepared, they use the spont system of casting
        || nClass == CLASS_TYPE_FAVOURED_SOUL
        || nClass == CLASS_TYPE_JUSTICEWW)
        return TRUE;

    // ToB Classes
    if (nClass == CLASS_TYPE_WARBLADE
        || nClass == CLASS_TYPE_SWORDSAGE
        || nClass == CLASS_TYPE_CRUSADER)
        return TRUE;

    // Mystery Classes
    if (nClass == CLASS_TYPE_SHADOWCASTER
        || nClass == CLASS_TYPE_SHADOWSMITH)
        return TRUE;

    // Truenamers
    if (nClass == CLASS_TYPE_TRUENAMER)
         return TRUE;

    // RHD Casters
    if ((nClass == CLASS_TYPE_SHAPECHANGER
                && GetRacialType(oPlayer) == RACIAL_TYPE_ARANEA
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_OUTSIDER
                && GetRacialType(oPlayer) == RACIAL_TYPE_RAKSHASA
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_ABERRATION
                && GetRacialType(oPlayer) == RACIAL_TYPE_DRIDER
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_MONSTROUS
                && GetRacialType(oPlayer) == RACIAL_TYPE_ARKAMOI
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_MONSTROUS
                && GetRacialType(oPlayer) == RACIAL_TYPE_HOBGOBLIN_WARSOUL
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_MONSTROUS
                && GetRacialType(oPlayer) == RACIAL_TYPE_REDSPAWN_ARCANISS
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_MONSTROUS
                && GetRacialType(oPlayer) == RACIAL_TYPE_MARRUTACT
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_FEY
                && GetRacialType(oPlayer) == RACIAL_TYPE_GLOURA
                && !GetLevelByClass(CLASS_TYPE_BARD)))
         return TRUE;

    // Binders
    if (nClass == CLASS_TYPE_BINDER)
        return TRUE;

    return FALSE;
}

void CheckAndRemoveSpellsForClassAtLevel(object oPC, int nClass, int level)
{
    if (IsClassPRCSpellCaster(nClass, oPC))
    {
        if (GetIsInvocationClass(nClass))
        {
            RemoveSpellsAtLevel(oPC, nClass, level, INVOCATION_LIST_EXTRA);
            RemoveSpellsAtLevel(oPC, nClass, level, INVOCATION_LIST_EXTRA_EPIC);
        }
        if (GetIsPsionicClass(nClass))
        {
            RemoveSpellsAtLevel(oPC, nClass, level, POWER_LIST_EXP_KNOWLEDGE);
            RemoveSpellsAtLevel(oPC, nClass, level, POWER_LIST_EPIC_EXP_KNOWLEDGE);
        }
        RemoveSpellsAtLevel(oPC, nClass, level);
    }
}

void main()
{
    int nClass = StringToInt(GetScriptParam("UnLevel_ClassChoice"));
    int nLevel = StringToInt(GetScriptParam("UnLevel_LevelChoice"));
    if (nClass)
    {
        CheckAndRemoveSpellsForClassAtLevel(OBJECT_SELF, nClass, nLevel);
    }
}
