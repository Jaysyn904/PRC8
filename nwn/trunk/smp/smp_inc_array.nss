/*:://////////////////////////////////////////////
//:: Name Array functions
//:: FileName SMP_INC_ARRAY
//:://////////////////////////////////////////////
    All array things.

    2da files are now cached in 1.64 - we can loop them sucessfully! this is
    great news, and is much better (or likely will be) then using module load
    to cache them as locals!

    See backups of the module from pre-16th october to see older functions, just
    in case.

    This file is still needed to wrapper all the Get2daString() calls, and
    have constants for column and 2da names.

    Informations got from spells.2da:

    - Spell Name (By Integer)
    - Spell Level (Integer, By seperate classes)
    - Spell Hostility (Integer)
    - Spell Range (as float }
    - Spell valid targets   }- Needed at least for Wish
    - Spell School          }

    Thanks to Axe Murderer, I've added proper TargetType and MetaMagic checks
    in the file SMP_INC_METATARG
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_METATARG"

// Name of the different 2da files used.
const string SMP_2DA_NAME_SPELLS = "spells";
//const string SMP_2DA_NAME_DOMAINS = "domains"; // Currently not used
const string SMP_2DA_NAME_ADDITIONAL = "SMP_2da_addit";
const string SMP_2DA_NAME_IPRP_SPELLS = "iprp_spells";

// Special component 2da
const string SMP_2DA_NAME_SMP_COMPONENTS = "SMP_components";

// 2da column names
const string SMP_2DA_COLUMN_SPELLS_NAME     = "Name";
const string SMP_2DA_COLUMN_SPELLS_BARD     = "Bard";
const string SMP_2DA_COLUMN_SPELLS_CLERIC   = "Cleric";
const string SMP_2DA_COLUMN_SPELLS_DRUID    = "Druid";
const string SMP_2DA_COLUMN_SPELLS_PALADIN  = "Paladin";
const string SMP_2DA_COLUMN_SPELLS_RANGER   = "Ranger";
const string SMP_2DA_COLUMN_SPELLS_WIZ_SORC = "Wiz_Sorc";
const string SMP_2DA_COLUMN_SPELLS_INNATE   = "Innate";
const string SMP_2DA_COLUMN_SPELLS_HOSTILE_SETTING = "HostileSetting";
// 2da for extra information - alignments of spells etc.
const string SMP_2DA_COLUMN_ADDITIONAL_GOODEVIL = "GoodEvil";
const string SMP_2DA_COLUMN_ADDITIONAL_LAWCHAOS = "LawChaos";
// This is in the spells.2da, but we use this as an integer value!
const string SMP_2DA_COLUMN_SPELLS_SPELL_SCHOOL = "School";
// These is required at least for wish
const string SMP_2DA_COLUMN_SPELLS_RANGE       = "Range";
const string SMP_2DA_COLUMN_SPELLS_TARGET_TYPE = "TargetType";
const string SMP_2DA_COLUMN_SPELLS_META_MAGIC = "MetaMagic";

// Special "column" for immunity constants and names:
// - This is NOT set On Module Load, but directly onto the placable via. the
//   local variables. Each local is a number, got just by GetLocalString(oThing, "1");
const string SMP_GLOBAL_IMMUNITY_NAME = "SMP_GLOBAL_IMMUNITY_NAME";

// Max entries in the 2da file to load up at start.
const int SMP_SPELLS_2DA_MAX_ENTRY          = 2000;
// Minimum "Actual spells" entries, useful for smaller loops! SMP starts quite high!
const int SMP_SPELLS_2DA_MIN_SPELL_ENTRY    = 1000;

// These 3 are the main 3 callers of any 2da functions.

// SMP_INC_ARRAY. Gets the integer 2da value at nRow.
// * Uses s2da to get the 2da to use.
// * Uses StringToInt() to return the value.
// * As all functions, can be used multiple times now.
int SMP_ArrayGetInteger(string s2da, string sColumn, int nRow);
// SMP_INC_ARRAY. Gets the string 2da value at nRow, for sColumn
// (Note: This will not convert the column to Integer, and get the string reference)
// * Uses s2da to get the 2da to use.
// * As all functions, can be used multiple times now.
// Ok, it is just a wrapper for Get2daString, so there.
string SMP_ArrayGetString(string s2da, string sColumn, int nRow);
// SMP_INC_ARRAY. Gets the string 2da value at nRow, for sColumn, using a string reference from the .tlk
// This will convert the column to Integer, and get the string reference
// * Uses s2da to get the 2da to use.
string SMP_ArrayGetStringFromInt(string s2da, string sColumn, int nRow);

// These others use the above ones, but make it more english and wraps common lookups.

// SMP_INC_ARRAY. Get the spell level associated with who cast the spell
// (EG: Mage level of Magic missile = 1)
// * nCasterClass - any of the CLASS_ constants.
//   - Use CLASS_TYPE_INVALID to get a "general" level, or mean of them, used for
//     creature spells and anything not cast by a default class.
// * Returns -1 on error.
int SMP_ArrayGetSpellLevel(int nSpellId, int nCasterClass);
// SMP_INC_ARRAY. By using oCreator, it gets the most approprate spell level to use.
// * IE: It will check the columns of the spell, and which valid ones (level of spell
//   is >= 0) will be checked in class. Highest class' spell level is returned.
// * Defaults to the Invalid class - Innate level
int SMP_ArrayGetSpellLevelGeneral(int nSpellId, object oCreator);
// SMP_INC_ARRAY. By checking all the values of nSpellId's row, we will check to see if *any*
// class can cast nSpellId normally, or if it is just a creature ability.
// * TRUE if it can be cast by any PC class
int SMP_ArrayGetSpellIsPCCastable(int nSpellId);

// SMP_INC_ARRAY. Returns TRUE if nSpellId is a hostile spell/ability
int SMP_ArrayGetIsHostile(int nSpellId);
// SMP_INC_ARRAY. Get the Spell School nSpellId is from.
// * Returns 0 (SPELL_SCHOOL_GENERAL) by default.
int SMP_ArrayGetSpellSchool(int nSpellId);
// SMP_INC_ARRAY. Get the spell name for nSpellId.
string SMP_ArrayGetSpellName(int nSpellId);

// SMP_INC_ARRAY. Get the Good/Evil alignment of nSpellId.
// * Used to dispel specfically good or evil based spells, or for use to increase
//   the caster level of such spells.
int SMP_ArrayGetSpellGoodEvilAlignment(int nSpellId);
// SMP_INC_ARRAY. Get the Law/Chaos alignment of nSpellId.
// * Used to dispel specfically Law or Chaos based spells, or for use to increase
//   the caster level of such spells.
int SMP_ArrayGetSpellLawChaosAlignment(int nSpellId);

// SMP_INC_ARRAY. Get the Range, as a float, of nSpellId.
// * Will return 40.0, 20.0, 8.0, 2.25 (special set case, only if statement)
//   and 0. If 0, normally means personal, of course, or invalid.
float SMP_ArrayGetSpellRange(int nSpellId);

// SMP_INC_ARRAY. Will get the hex (integer) value of the TargetType column in the spells.2da.
int SMP_ArrayGetSpellTargetType(int nSpellId);
// SMP_INC_ARRAY. Will get the hex (integer) value of the MetaMagic column in the spells.2da.
int SMP_ArrayGetSpellMetaMagic(int nSpellId);

// SMP_INC_ARRAY. This gets the minimum level nClass can cast nSpellLevel spells at.
// * Returns 0 (FALSE) on error.
int SMP_ArrayMinimumLevelCastAt(int nSpellLevel, int nClass);

// SMP_INC_ARRAY. Gets the caster level of the spell from a item property: Cast spell.
// Uses iprp_spells.2da file. Uses the CasterLvl column.
// * nItempPropertySpellId are The IP_CONST_CASTSPELL_* constants.
int SMP_ArrayItemCasterLevel(int nItemPropertySpellId);

// FUNCTIONS START

// SMP_INC_ARRAY. Gets the integer 2da value at nRow.
// * Uses s2da to get the 2da to use.
// * Uses StringToInt() to return the value.
// * As all functions, can be used multiple times now.
int SMP_ArrayGetInteger(string s2da, string sColumn, int nRow)
{
    // This needs to have caching stuff here

    return StringToInt(Get2DAString(s2da, sColumn, nRow));
}
// SMP_INC_ARRAY. Gets the string 2da value at nRow, for sColumn
// (Note: This will not convert the column to Integer, and get the string reference)
// * Uses s2da to get the 2da to use.
// * As all functions, can be used multiple times now.
string SMP_ArrayGetString(string s2da, string sColumn, int nRow)
{
    // This needs to have caching stuff here

    return Get2DAString(s2da, sColumn, nRow);
}
// SMP_INC_ARRAY. Gets the string 2da value at nRow, for sColumn, using a string reference from the .tlk
// This will convert the column to Integer, and get the string reference
// * Uses s2da to get the 2da to use.
string SMP_ArrayGetStringFromInt(string s2da, string sColumn, int nRow)
{
    return GetStringByStrRef(StringToInt(Get2DAString(s2da, sColumn, nRow)));
}
// SMP_INC_ARRAY. Get the spell level associated with who cast the spell
// (EG: Mage level of Magic missile = 1)
// * nCasterClass - any of the CLASS_ constants.
//   - Use CLASS_TYPE_INVALID to get a "general" level, or mean of them, used for
//     creature spells and anything not cast by a default class.
// * Returns -1 on error.
int SMP_ArrayGetSpellLevel(int nSpellId, int nCasterClass)
{
    string sColumnName;
    switch(nCasterClass)
    {
        case CLASS_TYPE_BARD:       sColumnName = SMP_2DA_COLUMN_SPELLS_BARD; break;
        case CLASS_TYPE_CLERIC:     sColumnName = SMP_2DA_COLUMN_SPELLS_CLERIC; break;
        case CLASS_TYPE_DRUID:      sColumnName = SMP_2DA_COLUMN_SPELLS_DRUID; break;
        case CLASS_TYPE_PALADIN:    sColumnName = SMP_2DA_COLUMN_SPELLS_PALADIN; break;
        case CLASS_TYPE_RANGER:     sColumnName = SMP_2DA_COLUMN_SPELLS_RANGER; break;
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_WIZARD:
        {
            sColumnName = SMP_2DA_COLUMN_SPELLS_WIZ_SORC; break;
        }
        break;
        default: sColumnName = SMP_2DA_COLUMN_SPELLS_INNATE; break;
    }
    // Get value to return
    string sReturn = Get2DAString(SMP_2DA_NAME_SPELLS, sColumnName, nSpellId);
    int nLevel;
    // Will return -1 on a **** entry
    if(sReturn == "")
    {
        nLevel = -1;
    }
    else
    {
        nLevel = StringToInt(sReturn);
    }
    // Return value
    return nLevel;
}

// SMP_INC_ARRAY. By using oCreator, it gets the most approprate spell level to use.
// * IE: It will check the columns of the spell, and which valid ones (level of spell
//   is >= 0) will be checked in class. Highest class' spell level is returned.
// * Defaults to the Invalid class - Innate level
int SMP_ArrayGetSpellLevelGeneral(int nSpellId, object oCreator)
{
    if(!GetIsObjectValid(oCreator))
    {
        // Return the innate spell level.
        return SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_INVALID);
    }
    // Get the different levels and see what is higher. Defaults to 0.
    int nOld, nNew, nClass;

    // Default nClass
    nClass = CLASS_TYPE_INVALID;

    // Bard - is it a valid level?
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_BARD) >= 0)
    {
        nOld = GetLevelByClass(CLASS_TYPE_BARD, oCreator);
        nClass = CLASS_TYPE_BARD;
    }
    // Cleric - it a valid level?
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_CLERIC) >= 0)
    {
        nNew = GetLevelByClass(CLASS_TYPE_CLERIC, oCreator);
        // If higher then the bard, use this!
        if(nNew > nOld)
        {
            nClass = CLASS_TYPE_CLERIC;
            nOld = nNew;
        }
    }
    // Druid - it a valid level?
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_DRUID) >= 0)
    {
        nNew = GetLevelByClass(CLASS_TYPE_DRUID, oCreator);
        // If higher then the others, use this!
        if(nNew > nOld)
        {
            nClass = CLASS_TYPE_DRUID;
            nOld = nNew;
        }
    }
    // Paladin - it a valid level?
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_PALADIN) >= 0)
    {
        nNew = GetLevelByClass(CLASS_TYPE_PALADIN, oCreator);
        // If higher then the others, use this!
        if(nNew > nOld)
        {
            nClass = CLASS_TYPE_PALADIN;
            nOld = nNew;
        }
    }
    // Ranger - it a valid level?
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_RANGER) >= 0)
    {
        nNew = GetLevelByClass(CLASS_TYPE_RANGER, oCreator);
        // If higher then the others, use this!
        if(nNew > nOld)
        {
            nClass = CLASS_TYPE_RANGER;
            nOld = nNew;
        }
    }
    // Wizard - it a valid level?
    // * Note: Could use CLASS_TYPE_SORCEROR for same effect.
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_WIZARD) >= 0)
    {
        nNew = GetLevelByClass(CLASS_TYPE_SORCERER, oCreator);
        // If higher then the others, use this!
        if(nNew > nOld)
        {
            nClass = CLASS_TYPE_SORCERER;
            nOld = nNew;
        }
        else // Check wizard
        {
            nNew = GetLevelByClass(CLASS_TYPE_WIZARD, oCreator);
            // If higher then the others, use this!
            if(nNew > nOld)
            {
                nClass = CLASS_TYPE_WIZARD;
                nOld = nNew;
            }
        }
    }
    // Return the relivant (or even invalid - thus Innate) spell level.
    return SMP_ArrayGetSpellLevel(nSpellId, nClass);
}
// SMP_INC_ARRAY. By checking all the values of nSpellId's row, we will check to see if *any*
// class can cast nSpellId normally, or if it is just a creature ability.
// * TRUE if it can be cast by any PC class
int SMP_ArrayGetSpellIsPCCastable(int nSpellId)
{
    // We run through each class, until one is valid, or, of course, none are.
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_WIZARD) != -1)
    {
        return TRUE;
    }
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_CLERIC) != -1)
    {
        return TRUE;
    }
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_DRUID) != -1)
    {
        return TRUE;
    }
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_BARD) != -1)
    {
        return TRUE;
    }
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_RANGER) != -1)
    {
        return TRUE;
    }
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_PALADIN) != -1)
    {
        return TRUE;
    }
    // Cannot be cast by a PC normally (feat/ability)
    return FALSE;
}
// SMP_INC_ARRAY. Returns TRUE if nSpellId is a hostile spell/ability
int SMP_ArrayGetIsHostile(int nSpellId)
{
    return SMP_ArrayGetInteger(SMP_2DA_NAME_SPELLS, SMP_2DA_COLUMN_SPELLS_HOSTILE_SETTING, nSpellId);
}

// SMP_INC_ARRAY. Get the Spell School nSpellId is from.
// * Returns 0 (SPELL_SCHOOL_GENERAL) by default.
int SMP_ArrayGetSpellSchool(int nSpellId)
{
    // 0          General         G // We just don't set this.
    // 1          Abjuration      A
    // 2          Conjuration     C
    // 3          Divination      D
    // 4          Enchantment     E
    // 5          Evocation       V
    // 6          Illusion        I
    // 7          Necromancy      N
    // 8          Transmutation   T
    string sValue = SMP_ArrayGetString(SMP_2DA_NAME_SPELLS, SMP_2DA_COLUMN_SPELLS_SPELL_SCHOOL, nSpellId);
    if(sValue == "A")
    {
        return 1;
    }
    else if(sValue == "C")
    {
        return 2;
    }
    else if(sValue == "D")
    {
        return 3;
    }
    else if(sValue == "E")
    {
        return 4;
    }
    else if(sValue == "V")
    {
        return 5;
    }
    else if(sValue == "I")
    {
        return 6;
    }
    else if(sValue == "N")
    {
        return 7;
    }
    else if(sValue == "T")
    {
        return 8;
    }
    // General is 0, we return that by default.
    return 0;
}

// SMP_INC_ARRAY. Get the spell name for nSpellId.
string SMP_ArrayGetSpellName(int nSpellId)
{
    return SMP_ArrayGetStringFromInt(SMP_2DA_NAME_SPELLS, SMP_2DA_COLUMN_SPELLS_NAME, nSpellId);
}

// SMP_INC_ARRAY. Get the Good/Evil alignment of nSpellId.
// * Used to dispel specfically good or evil based spells, or for use to increase
//   the caster level of such spells.
int SMP_ArrayGetSpellGoodEvilAlignment(int nSpellId)
{
    return SMP_ArrayGetInteger(SMP_2DA_NAME_ADDITIONAL, SMP_2DA_COLUMN_ADDITIONAL_GOODEVIL, nSpellId);
}
// SMP_INC_ARRAY. Get the Law/Chaos alignment of nSpellId.
// * Used to dispel specfically Law or Chaos based spells, or for use to increase
//   the caster level of such spells.
int SMP_ArrayGetSpellLawChaosAlignment(int nSpellId)
{
    return SMP_ArrayGetInteger(SMP_2DA_NAME_ADDITIONAL, SMP_2DA_COLUMN_ADDITIONAL_LAWCHAOS, nSpellId);
}
// SMP_INC_ARRAY. Get the Range, as a float, of nSpellId.
// * Will return 40.0, 20.0, 8.0, 2.25 (special set case, only if statement)
//   and 0. If 0, normally means personal, of course, or invalid.
// * Use one time
float SMP_ArrayGetSpellRange(int nSpellId)
{
    // Get 2da entry
    string sValue = SMP_ArrayGetString(SMP_2DA_NAME_SPELLS, SMP_2DA_COLUMN_SPELLS_RANGE, nSpellId);

    // L = Long range = 40
    // M = Medium Range = 20
    // S = Short Range = 8
    // T = Touch Range = 2.25 (Mark as 2)
    // P = Personal Range = 0
    if(sValue == "L")
    {
        return 40.0;
    }
    else if(sValue == "M")
    {
        return 20.0;
    }
    else if(sValue == "S")
    {
        return 8.0;
    }
    else if(sValue == "T")
    {
        return 2.25;
    }
    // Default to P(ersonal)'s range of 0.0
    return 0.0;
    //else if(sValue == "P")
    //{
    //}
}
// SMP_INC_ARRAY. Will get the hex (integer) value of the TargetType column in the spells.2da.
int SMP_ArrayGetSpellTargetType(int nSpellId)
{
    return SMP_ArrayGetInteger(SMP_2DA_NAME_SPELLS, SMP_2DA_COLUMN_SPELLS_TARGET_TYPE, nSpellId);
}
// SMP_INC_ARRAY. Will get the hex (integer) value of the MetaMagic column in the spells.2da.
int SMP_ArrayGetSpellMetaMagic(int nSpellId)
{
    return SMP_ArrayGetInteger(SMP_2DA_NAME_SPELLS, SMP_2DA_COLUMN_SPELLS_META_MAGIC, nSpellId);
}

// SMP_INC_ARRAY. This gets the minimum level nClass can cast nSpellLevel spells at.
// * Returns 0 (FALSE) on error.
int SMP_ArrayMinimumLevelCastAt(int nSpellLevel, int nClass)
{
    // Get the right 2da file.
    string s2da;
    switch(nClass)
    {
        case CLASS_TYPE_BARD:     s2da = "cls_spgn_bard"; break;
        case CLASS_TYPE_CLERIC:   s2da = "cls_spgn_cler"; break;
        case CLASS_TYPE_DRUID:    s2da = "cls_spgn_dru"; break;
        case CLASS_TYPE_PALADIN:  s2da = "cls_spgn_pal"; break;
        case CLASS_TYPE_RANGER:   s2da = "cls_spgn_rang"; break;
        case CLASS_TYPE_SORCERER: s2da = "cls_spgn_sorc"; break;
        case CLASS_TYPE_WIZARD:   s2da = "cls_spgn_wiz"; break;
        default: return FALSE; break;
    }

    // Get the column name: SpellLevel0 to SpellLevel9
    // Not all classes have all columns.
    string sColumn = "SpellLevel" + IntToString(nSpellLevel);

    // Work from row 0. Get if there is an entry of 1 or more at the colum entry.
    // Yes, it is a loop.

    // Firstly, however, we must check if at level 60 we could cast the spell.
    // Level 60 is the highest. Else, it could do 18 rows at once if not found!
    if(SMP_ArrayGetInteger(s2da, sColumn, 59) == FALSE)
    {
        // Not applicable to this class.
        return FALSE;
    }

    // Loop from level 1 (row 0) to level 18 (row 17) - which is the lowest
    // level for when sorcerors get thier level 9 spells.
    int nCnt;
    for(nCnt = 0; nCnt <= 17; nCnt++)
    {
        // Check if we can get one of these spells at this level or not...
        if(SMP_ArrayGetInteger(s2da, sColumn, nCnt) >= 1)
        {
            // Return the level if we can get this level of spells now.
            // When we get the index number, we add one to it to get the level (it
            // starts are row 0, which is level 1)
            return nCnt + 1;
        }
    }
    // Return FALSE if not found in those 18 rows
    return FALSE;
}

// SMP_INC_ARRAY. Gets the caster level of the spell from a item property: Cast spell.
// Uses iprp_spells.2da file. Uses the CasterLvl column.
// * nItempPropertySpellId are The IP_CONST_CASTSPELL_* constants.
int SMP_ArrayItemCasterLevel(int nItemPropertySpellId)
{
    // Get and return the integer (Obviously, default of 0)
    return SMP_ArrayGetInteger(SMP_2DA_NAME_IPRP_SPELLS, "CasterLvl", nItemPropertySpellId);
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
