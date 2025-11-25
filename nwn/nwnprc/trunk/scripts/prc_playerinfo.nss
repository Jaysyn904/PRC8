//::////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//::////////////////////////////////////////////////////////
//:: FileName: "prc_playerinfo"
//:: Created By: Jaysyn
//:: Last Updated On: 2025-11-25 08:26:22
//::
//::////////////////////////////////////////////////////////
/*

	Displays a lot of relevant PC info in an NUI window

*/
//::////////////////////////////////////////////////////////
#include "nw_inc_nui"
#include "prc_inc_template"

const string CHAR_SHEET_WINDOW_ID = "char_sheet_window";

void ShowCharacterSheet(object oPC, object oTarget)
{
    //:: Close existing window if open
    int nToken = NuiFindWindow(oPC, CHAR_SHEET_WINDOW_ID);
    if (nToken > 0)
    {
        NuiDestroy(oPC, nToken);
        return;
    }

    //:: Build the layout
    json jCol = JsonArray();

    //:: === CHARACTER NAME & RACE ===
    json jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Name:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_name"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Race:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_race"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Subrace:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_subrace"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Deity:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_deity"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Templates:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiText(NuiBind("char_templates"), TRUE, NUI_SCROLLBARS_AUTO));
    jCol = JsonArrayInsert(jCol, NuiHeight(NuiRow(jRow), 60.0));

    //:: === CLASSES ===
    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Classes:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiText(NuiBind("char_classes"), TRUE, NUI_SCROLLBARS_AUTO));
    jCol = JsonArrayInsert(jCol, NuiHeight(NuiRow(jRow), 120.0));

    //:: === LEVEL & EXPERIENCE ===
    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Total Level:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_level"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //:: Only show XP for PCs
    if (GetIsPC(oTarget))
    {
        jRow = JsonArray();
        jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Experience:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
        jRow = JsonArrayInsert(jRow, NuiSpacer());
        jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_xp"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
        jCol = JsonArrayInsert(jCol, NuiRow(jRow));
    }

    //:: === HIT POINTS ===
    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Hit Points:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_hp"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //:: === ABILITY SCORES - Two columns ===
    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Ability Scores:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //:: STR and DEX
    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("STR:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_str"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("DEX:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_dex"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //:: CON and INT
    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("CON:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_con"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("INT:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_int"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //:: WIS and CHA
    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("WIS:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_wis"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("CHA:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_cha"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //:: === ENCUMBRANCE ===
    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Encumbrance:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_encumbrance"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //:: === SAVING THROWS ===
    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Saving Throws:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //:: Fortitude
    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Fortitude:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_fort"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //:: Reflex
    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Reflex:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_ref"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //:: Will
    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Will:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_will"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //:: === ARMOR CLASS ===
    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Armor Class:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, NuiLabel(NuiBind("char_ac"), JsonInt(NUI_HALIGN_RIGHT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    //:: === ACTIVE EFFECTS ===
    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiLabel(JsonString("Active Spells:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)));
    jCol = JsonArrayInsert(jCol, NuiRow(jRow));

    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiText(NuiBind("char_effects"), TRUE, NUI_SCROLLBARS_AUTO));
    jCol = JsonArrayInsert(jCol, NuiHeight(NuiRow(jRow), 100.0));

    //:: Create window
    json jRoot = NuiCol(jCol);
    
    string sTitle = "Character Sheet: " + GetName(oTarget);
    json jNui = NuiWindow(
        jRoot,
        JsonString(sTitle),
        NuiBind("geometry"),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(FALSE),
        JsonBool(TRUE)
    );

    nToken = NuiCreate(oPC, jNui, CHAR_SHEET_WINDOW_ID);

    //:: Set geometry
    NuiSetBind(oPC, nToken, "geometry", NuiRect(100.0, 100.0, 400.0, 850.0));

    //:: === POPULATE DATA ===

    //:: Name
    NuiSetBind(oPC, nToken, "char_name", JsonString(GetName(oTarget)));

    //:: Race
    string sRace = GetStringByStrRef(StringToInt(Get2DAString("racialtypes", "Name", GetRacialType(oTarget))));
    if (sRace == "") sRace = "Unknown";
    NuiSetBind(oPC, nToken, "char_race", JsonString(sRace));

    //:: Subrace
    string sSubrace = GetSubRace(oTarget);
    if (sSubrace == "") sSubrace = "None";
    NuiSetBind(oPC, nToken, "char_subrace", JsonString(sSubrace));

    //:: Deity
    string sDeity = GetDeity(oTarget);
    if (sDeity == "") sDeity = "None";
    NuiSetBind(oPC, nToken, "char_deity", JsonString(sDeity));

    //:: Templates - Check for persistent local variables named "template_X"
    string sTemplates = "";
    int nTemplateCount = 0;
    int i;
    int nMaxTemplates = 128;
    
    for (i = 0; i <= nMaxTemplates; i++)
    {
        string sVarName = "template_" + IntToString(i);
        
        //:: Check if this persistent local variable exists and is TRUE
        if (GetPersistantLocalInt(oTarget, sVarName))
        {
            string sNameEntry = Get2DAString("templates", "Name", i);
            
            //:: Only process if we got a valid name entry
            if (sNameEntry != "")
            {
                int nNameStrRef = StringToInt(sNameEntry);
                string sTemplateName = GetStringByStrRef(nNameStrRef);
                
                if (sTemplateName == "")
                    sTemplateName = "Template " + IntToString(i);
                
                if (nTemplateCount > 0)
                    sTemplates += "\n";
                    
                sTemplates += sTemplateName;
                nTemplateCount++;
            }
        }
    }
    
    if (nTemplateCount == 0)
        sTemplates = "None";
    
    NuiSetBind(oPC, nToken, "char_templates", JsonString(sTemplates));

    //:: Classes 
    string sClasses = "";
    for (i = 1; i <= 8; i++)
    {
        int nClass = GetClassByPosition(i, oTarget);
        if (nClass != CLASS_TYPE_INVALID)
        {
            string sClassName = GetStringByStrRef(StringToInt(Get2DAString("classes", "Name", nClass)));
            if (sClassName == "") sClassName = "Class " + IntToString(nClass);
            
            int nLevel = GetLevelByClass(nClass, oTarget);
            
            if (sClasses != "")
                sClasses += "\n";
                
            sClasses += sClassName + " " + IntToString(nLevel);
        }
    }
    
    if (sClasses == "")
        sClasses = "No classes found";
        
    NuiSetBind(oPC, nToken, "char_classes", JsonString(sClasses));

    //:: Level
    NuiSetBind(oPC, nToken, "char_level", JsonString(IntToString(GetHitDice(oTarget))));
    
    //:: XP (only for PCs)
    if (GetIsPC(oTarget))
    {
        NuiSetBind(oPC, nToken, "char_xp", JsonString(IntToString(GetXP(oTarget))));
    }

    //:: Hit Points
    string sHP = IntToString(GetCurrentHitPoints(oTarget)) + " / " + IntToString(GetMaxHitPoints(oTarget));
    NuiSetBind(oPC, nToken, "char_hp", JsonString(sHP));

    //:: Ability Scores - Individual binds
    NuiSetBind(oPC, nToken, "char_str", JsonString(IntToString(GetAbilityScore(oTarget, ABILITY_STRENGTH))));
    NuiSetBind(oPC, nToken, "char_dex", JsonString(IntToString(GetAbilityScore(oTarget, ABILITY_DEXTERITY))));
    NuiSetBind(oPC, nToken, "char_con", JsonString(IntToString(GetAbilityScore(oTarget, ABILITY_CONSTITUTION))));
    NuiSetBind(oPC, nToken, "char_int", JsonString(IntToString(GetAbilityScore(oTarget, ABILITY_INTELLIGENCE))));
    NuiSetBind(oPC, nToken, "char_wis", JsonString(IntToString(GetAbilityScore(oTarget, ABILITY_WISDOM))));
    NuiSetBind(oPC, nToken, "char_cha", JsonString(IntToString(GetAbilityScore(oTarget, ABILITY_CHARISMA))));

    //:: Encumbrance
    int nEncumbrance = GetWeight(oTarget) / 10;
    string sEncumbrance = IntToString(nEncumbrance) + " lbs";
    
    //:: Only check for gold bag on PCs
    if (GetIsPC(oTarget) && GetIsObjectValid(GetItemPossessedBy(oTarget, "NW_IT_MNYBAG01")))
    {
        nEncumbrance += GetGold(oTarget) / 50;
        sEncumbrance += " (+" + IntToString(GetGold(oTarget) / 50) + " gold)";
    }
    NuiSetBind(oPC, nToken, "char_encumbrance", JsonString(sEncumbrance));

    //:: Saves - Individual binds
    NuiSetBind(oPC, nToken, "char_fort", JsonString(IntToString(GetFortitudeSavingThrow(oTarget))));
    NuiSetBind(oPC, nToken, "char_ref", JsonString(IntToString(GetReflexSavingThrow(oTarget))));
    NuiSetBind(oPC, nToken, "char_will", JsonString(IntToString(GetWillSavingThrow(oTarget))));

    //:: AC
    NuiSetBind(oPC, nToken, "char_ac", JsonString(IntToString(GetAC(oTarget))));

    //:: Active Spells - Track unique spell IDs to avoid duplicates
    string sEffects = "";
    effect eEffect = GetFirstEffect(oTarget);
    int nEffectCount = 0;
    string sTrackedSpells = "";  //:: Use this to track which spells we've already listed
    
    while (GetIsEffectValid(eEffect))
    {
        int nSpellId = GetEffectSpellId(eEffect);
        
        //:: Only process if this is a valid spell and we haven't already listed it
        if (nSpellId > 0)
        {
            string sSpellIdStr = IntToString(nSpellId);
            
            //:: Check if we've already processed this spell
            if (FindSubString(sTrackedSpells, ":" + sSpellIdStr + ":") == -1)
            {
                //:: Add to tracked list
                sTrackedSpells += ":" + sSpellIdStr + ":";
                
                //:: Get spell name from spells.2da -> TLK
                int nNameStrRef = StringToInt(Get2DAString("spells", "Name", nSpellId));
                string sSpellName = GetStringByStrRef(nNameStrRef);
                
                if (sSpellName == "")
                    sSpellName = "Unknown Spell (ID: " + sSpellIdStr + ")";
                
                //:: Get duration for this spell effect
                float fDuration = IntToFloat(GetEffectDurationRemaining(eEffect));
                string sDuration = "";
                
                if (fDuration > 0.0)
                {
                    int nSeconds = FloatToInt(fDuration);
                    int nMinutes = nSeconds / 60;
                    nSeconds = nSeconds % 60;
                    
                    if (nMinutes > 0)
                        sDuration = IntToString(nMinutes) + "m " + IntToString(nSeconds) + "s";
                    else
                        sDuration = IntToString(nSeconds) + "s";
                }
                else
                {
                    sDuration = "Permanent";
                }
                
                if (nEffectCount > 0)
                    sEffects += "\n";
                    
                sEffects += sSpellName + " (" + sDuration + ")";
                nEffectCount++;
            }
        }
        
        eEffect = GetNextEffect(oTarget);
    }
    
    if (nEffectCount == 0)
        sEffects = "No active spells";
    
    NuiSetBind(oPC, nToken, "char_effects", JsonString(sEffects));
}

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = oPC;
    
    //:: If PC is targeting something else, show that target's sheet instead
    object oTargeted = GetLocalObject(oPC, "EXAMINE_TARGET");
    if (GetIsObjectValid(oTargeted) && GetObjectType(oTargeted) == OBJECT_TYPE_CREATURE)
    {
        oTarget = oTargeted;
    }
    
    //:: Show the window
    ShowCharacterSheet(oPC, oTarget);
}
