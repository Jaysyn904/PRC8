//;:
//:: sp_lw_spellpick
//::
#include "inc_dynconv"
#include "inc_cache_setup"
 
const int STAGE_CLASS   = 0;
const int STAGE_SPELL   = 1;
const int SPELL_ROW_MAX = 539;
 
const int CLASS_WIZ_SORC = 1;
const int CLASS_BARD     = 2;
const int CLASS_CLERIC   = 3;
const int CLASS_DRUID    = 4;
const int CLASS_PALADIN  = 5;
const int CLASS_RANGER   = 6;
 
string GetClassColumn(int nClass)
{
    switch (nClass)
    {
        case CLASS_WIZ_SORC: return "Wiz_Sorc";
        case CLASS_BARD:     return "Bard";
        case CLASS_CLERIC:   return "Cleric";
        case CLASS_DRUID:    return "Druid";
        case CLASS_PALADIN:  return "Paladin";
        case CLASS_RANGER:   return "Ranger";
    }
    return "";
}
 
int GetMaxLevel(int nWishType)
{
    switch (nWishType)
    {
        case 1: return 6;
        case 2: return 5;
        case 3: return 5;
        case 4: return 4;
    }
    return 0;
}
 
void BuildClassMenu(object oPC)
{
    int nWishType = GetLocalInt(oPC, "LW_WishType");
    SetHeader("Which class spell list would you like to draw from?", oPC);
    switch (nWishType)
    {
        case 1:
        case 3:
            AddChoice("Sorcerer / Wizard", CLASS_WIZ_SORC, oPC);
            break;
        case 2:
        case 4:
            AddChoice("Bard",    CLASS_BARD,    oPC);
            AddChoice("Cleric",  CLASS_CLERIC,  oPC);
            AddChoice("Druid",   CLASS_DRUID,   oPC);
            AddChoice("Paladin", CLASS_PALADIN, oPC);
            AddChoice("Ranger",  CLASS_RANGER,  oPC);
            break;
    }
}
 
void BuildSpellList(object oPC)
{
    string sColumn       = GetLocalString(oPC, "LW_ClassColumn");
    int    nMaxLevel     = GetMaxLevel(GetLocalInt(oPC, "LW_WishType"));
    int    nWishType     = GetLocalInt(oPC, "LW_WishType");
    int    bFilterSchool = (nWishType == 1 || nWishType == 2);
    int    nRow;
 
    // Determine prohibited school — only relevant for allowed-school wish types
    // spellschools.2da maps specialist school -> opposition school
    int nProhibited = SPELL_SCHOOL_GENERAL;
    if (bFilterSchool)
    {
        int nSpecialist = GetSpecialization(oPC);
        if (nSpecialist != SPELL_SCHOOL_GENERAL)
            nProhibited = StringToInt(Get2DACache("spellschools", "Opposition", nSpecialist));
    }
 
    SetHeader("Choose a spell:", oPC);
 
    for (nRow = 0; nRow <= SPELL_ROW_MAX; nRow++)
    {
        string sLevel = Get2DACache("spells", sColumn, nRow);
        if (sLevel == "" || sLevel == "****") continue;
 
        int nSpellLevel = StringToInt(sLevel);
        if (nSpellLevel > nMaxLevel) continue;
 
        if (nProhibited != SPELL_SCHOOL_GENERAL)
        {
            int nSchool = StringToInt(Get2DACache("spells", "School", nRow));
            if (nSchool == nProhibited) continue;
        }
 
        // Check if this is a radial master — if so add sub-spells instead
        string sSub1 = Get2DACache("spells", "SubRadSpell1", nRow);
        if (sSub1 != "" && sSub1 != "****")
        {
            int i;
            for (i = 1; i <= 8; i++)
            {
                string sSub = Get2DACache("spells", "SubRadSpell" + IntToString(i), nRow);
                if (sSub == "" || sSub == "****") break;
 
                int nSubID = StringToInt(sSub);
                int nStrRef = StringToInt(Get2DACache("spells", "Name", nSubID));
                string sDisplay = (nStrRef > 0)
                    ? GetStringByStrRef(nStrRef) + " (Lvl " + IntToString(nSpellLevel) + ")"
                    : Get2DACache("spells", "Label", nSubID) + " (Lvl " + IntToString(nSpellLevel) + ")";
 
                AddChoice(sDisplay, nSubID, oPC);
            }
        }
        else
        {
            int nStrRef = StringToInt(Get2DACache("spells", "Name", nRow));
            string sDisplay = (nStrRef > 0)
                ? GetStringByStrRef(nStrRef) + " (Lvl " + IntToString(nSpellLevel) + ")"
                : Get2DACache("spells", "Label", nRow) + " (Lvl " + IntToString(nSpellLevel) + ")";
 
            AddChoice(sDisplay, nRow, oPC);
        }
    }
}

void main()
{
    object oPC    = GetPCSpeaker();
    int    nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int    nStage = GetStage(oPC);
 
    if (nValue == 0) return;
 
    if (nValue == DYNCONV_SETUP_STAGE)
    {
        if (!GetIsStageSetUp(nStage, oPC))
        {
            if (nStage == STAGE_CLASS)
            {
                BuildClassMenu(oPC);
                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_SPELL)
            {
                // Spell already chosen — fire cast and force-exit
				if (GetLocalInt(oPC, "LW_SpellWasCast"))
				{
					SetLocalObject(GetModule(), "LW_CastingPC", oPC);
					ExecuteScript("sp_lw_castchosen", GetModule());
					DeleteLocalInt(oPC, "LW_SpellWasCast");
					return;
				}
                BuildSpellList(oPC);
                MarkStageSetUp(nStage, oPC);
            }
 
            SetDefaultTokens(); // handles Next/Previous automatically
        }
        SetupTokens(oPC);
        return;
    }
 
    if (nValue == DYNCONV_EXITED || nValue == DYNCONV_ABORTED) return;
 
    // Player made a choice
    int nChoice = GetChoice(oPC);
 
    if (nStage == STAGE_CLASS)
    {
        SetLocalString(oPC, "LW_ClassColumn", GetClassColumn(nChoice));
        MarkStageNotSetUp(STAGE_CLASS, oPC);
        SetStage(STAGE_SPELL, oPC);
        return;
    }
 
    if (nStage == STAGE_SPELL)
    {
        // Spell chosen — store with +1 offset to avoid row 0 being treated as unset
        SetLocalInt(oPC, "LW_ChosenSpell", nChoice + 1);
        SetLocalInt(oPC, "LW_SpellWasCast", 1);
        MarkStageNotSetUp(STAGE_SPELL, oPC);
        SetStage(STAGE_SPELL, oPC);
        return;
    }
}