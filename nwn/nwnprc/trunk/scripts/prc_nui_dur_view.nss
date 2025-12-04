//::///////////////////////////////////////////////
//:: PRC Spell Duration NUI View
//:: prc_nui_dur_view
//:://////////////////////////////////////////////
/*
    This is the logic for the Spell Duration NUI
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 28.11.2025
//:://////////////////////////////////////////////

#include "nw_inc_nui"
#include "prc_nui_consts"
#include "prc_nui_com_inc"

int IsAllowedToRemoveSpell(effect selectedEffect)
{
    object creator = GetEffectCreator(selectedEffect);
    if (GetPRCSwitch(PRC_ALLOWED_TO_REMOVE_FRIENDLY_SPELLS))
    {
        int spellId = GetEffectSpellId(selectedEffect);
        int hostileSetting = StringToInt(Get2DACache("spells", "HostileSetting", spellId));
        if (!hostileSetting && !GetIsEnemy(creator))
            return TRUE;
    }
    else if (creator == OBJECT_SELF)
            return TRUE;

    return FALSE;
}

string ConvertDurationToString(int duration)
{
    if (duration == -1)
    {
        return "--:--:--";
    }
    int seconds = duration % 60;
    int minutes = duration / 60;
    int hours = minutes / 60;
    minutes = (minutes % 60);

    string totalTime;
    if ((hours / 10) == 0)
    {
        totalTime += "0";
    }
    totalTime += IntToString(hours);
    totalTime += ":";
    if ((minutes / 10) == 0)
    {
        totalTime += "0";
    }
    totalTime += IntToString(minutes);
    totalTime += ":";
    if ((seconds / 10) == 0)
    {
        totalTime += "0";
    }
    totalTime += IntToString(seconds);

    return totalTime;
}

int UpdateBindsAndCheckRefresh(int nuiToken)
{
    json spellList = GetLocalJson(OBJECT_SELF, NUI_DURATION_TRACKED_SPELLS);
    int totalEffects = JsonGetLength(spellList);
    effect selectedEffect = GetFirstEffect(OBJECT_SELF);
    json updatedSpells = JsonObject();

    while (GetIsEffectValid(selectedEffect))
    {
        int spellId = GetEffectSpellId(selectedEffect);
        json spellFound = JsonObjectGet(spellList, IntToString(spellId));
        if (spellFound != JsonNull())
        {
            json hasBeenUpdated = JsonObjectGet(updatedSpells, IntToString(spellId));
            if (hasBeenUpdated == JsonNull())
            {
                int durationRem = GetEffectDurationRemaining(selectedEffect);
                int durationType = GetEffectDurationType(selectedEffect);
                string duration;
                if (durationType == DURATION_TYPE_PERMANENT)
                    durationRem = -1;
                duration = ConvertDurationToString(durationRem);

                NuiSetBind(OBJECT_SELF, nuiToken, NUI_SPELL_DURATION_BASE_BIND + IntToString(spellId), JsonString(duration));
                spellList = JsonObjectSet(spellList, IntToString(spellId), JsonInt(durationRem));
                updatedSpells = JsonObjectSet(updatedSpells, IntToString(spellId), JsonInt(TRUE));
            }

        }
        else
        {
            string effectCreator = GetName(GetEffectCreator(selectedEffect));
            if (effectCreator != "prc_2da_cache" && effectCreator != "base_prc_skin")
            {
                updatedSpells = JsonObjectSet(updatedSpells, IntToString(spellId), JsonInt(TRUE));
            }
        }
        selectedEffect = GetNextEffect(OBJECT_SELF);
    }
    if (JsonGetLength(updatedSpells) == totalEffects)
        return FALSE;
    return TRUE;
}

string GetSpellNameFromEffect(effect selectedEffect)
{
    int spellId = GetEffectSpellId(selectedEffect);
    int featId = StringToInt(Get2DACache("spells", "FeatID", spellId));
    return GetSpellName(spellId, 0, featId);
}

json CreateEffectEntry(effect selectedEffect)
{
    json jRow = JsonArray();
    json jTitle;

    int spellId;
    int remainingDur;

    // Spell Icon
    json spellIcon = JsonNull();
    if (GetIsEffectValid(selectedEffect))
    {
        spellId = GetEffectSpellId(selectedEffect);
        int featId = StringToInt(Get2DACache("spells", "FeatID", spellId));
        spellIcon = GetSpellIcon(spellId, featId);
    }
    if (spellIcon == JsonNull())
    {
        jTitle = NuiText(JsonString(""), FALSE, NUI_SCROLLBARS_NONE);
    }
    else
    {
        jTitle = NuiImage(spellIcon, JsonInt(NUI_ASPECT_FIT), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_TOP));
    }
    jTitle = NuiWidth(jTitle, 32.0f);
    jTitle = NuiHeight(jTitle, 32.0f);
    jRow = JsonArrayInsert(jRow, jTitle);

    // Get Name of Spell
    string spellName;
    if (GetIsEffectValid(selectedEffect))
    {
        spellId = GetEffectSpellId(selectedEffect);
        spellName = GetSpellNameFromEffect(selectedEffect);
        if (spellName == "Bad Strref")
            spellName = ("SpellID: " + IntToString(spellId));
        json spellList = GetLocalJson(OBJECT_SELF, NUI_DURATION_TRACKED_SPELLS);
        if (spellList == JsonNull())
            spellList = JsonObject();

        remainingDur = GetEffectDurationRemaining(selectedEffect);
        spellList = JsonObjectSet(spellList, IntToString(spellId), JsonInt(remainingDur));
        SetLocalJson(OBJECT_SELF, NUI_DURATION_TRACKED_SPELLS, spellList);

        if (DEBUG) DoDebug("Tracked spellIds for duration NUI");
        if (DEBUG) DoDebug(JsonDump(spellList, 2));
    }
    else
    {
        spellName = "Name";
    }
    jTitle = NuiText(JsonString(spellName), FALSE, NUI_SCROLLBARS_NONE);
    jRow = JsonArrayInsert(jRow, jTitle);

    // Get Creator of Spell
    string creator;
    if (GetIsEffectValid(selectedEffect))
    {
        creator = GetName(GetEffectCreator(selectedEffect));
    }
    else
    {
        creator = "Creator";
    }
    jTitle = NuiText(JsonString(creator), FALSE, NUI_SCROLLBARS_NONE);
    jRow = JsonArrayInsert(jRow, jTitle);

    // Get Duration
    if (GetIsEffectValid(selectedEffect))
    {
        jTitle = NuiText(NuiBind(NUI_SPELL_DURATION_BASE_BIND + IntToString(spellId)), FALSE, NUI_SCROLLBARS_NONE);
    }
    else
    {
        jTitle = NuiText(JsonString("Duration"), FALSE, NUI_SCROLLBARS_NONE);
    }


    jRow = JsonArrayInsert(jRow, jTitle);

    if (GetIsEffectValid(selectedEffect))
    {
        jTitle = NuiId(NuiButtonImage(JsonString("nui_close")), NUI_SPELL_DURATION_SPELLID_BASE_CANCEL_BUTTON + IntToString(spellId));
        jTitle = NuiEnabled(jTitle, JsonInt(IsAllowedToRemoveSpell(selectedEffect)));
        jTitle = NuiWidth(jTitle, 32.0f);
        jTitle = NuiHeight(jTitle, 32.0f);
        jRow = JsonArrayInsert(jRow, jTitle);
    }

    return NuiRow(jRow);
}

int ShouldCreateEffectEntry(effect selectedEffect)
{
    string effectCreator = GetName(GetEffectCreator(selectedEffect));
    if (effectCreator == "prc_2da_cache" || effectCreator == "base_prc_skin")
        return FALSE;

    json spellList = GetLocalJson(OBJECT_SELF, NUI_DURATION_TRACKED_SPELLS);
    if (spellList == JsonNull())
        return TRUE;
    int spellId = GetEffectSpellId(selectedEffect);
    if (spellId == -1)
        return FALSE;

    if (!GetPRCSwitch(PRC_ALLOWED_TO_SEE_HOSTILE_SPELLS))
    {
        int hostileSpell = StringToInt(Get2DACache("spells", "HostileSetting", spellId));
        if (hostileSpell)
            return FALSE;
    }

    json spellExists = JsonObjectGet(spellList, IntToString(spellId));

    if (spellExists != JsonNull())
        return FALSE;


    return TRUE;
}

void main()
{

    int recreate = FALSE;
    int windowId = NuiFindWindow(OBJECT_SELF, DURATION_NUI_WINDOW_ID);
    if (windowId)
    {
        if (UpdateBindsAndCheckRefresh(windowId))
        {
            if (DEBUG) DoDebug("Spell added/removed, updating duration NUI.");
            DeleteLocalJson(OBJECT_SELF, NUI_DURATION_TRACKED_SPELLS);
            NuiDestroy(OBJECT_SELF, windowId);
            recreate = TRUE;
        }
    }
    else
    {
        int manualOpen = StringToInt(GetScriptParam(NUI_DURATION_MANUALLY_OPENED_PARAM));
        if (!manualOpen)
        {
            DeleteLocalJson(OBJECT_SELF, NUI_DURATION_TRACKED_SPELLS);
            return;
        }
        else
            recreate = TRUE;
    }

    if (recreate)
    {
        json jRoot = JsonArray();
        effect eNull;
        jRoot = JsonArrayInsert(jRoot, CreateEffectEntry(eNull));

        effect selectedEffect = GetFirstEffect(OBJECT_SELF);
        while (GetIsEffectValid(selectedEffect))
        {
            if (ShouldCreateEffectEntry(selectedEffect))
                jRoot = JsonArrayInsert(jRoot, CreateEffectEntry(selectedEffect));
            selectedEffect = GetNextEffect(OBJECT_SELF);
        }

        jRoot = NuiCol(jRoot);
        string title = "Spell Duration";

        // This is the main window with jRoot as the main pane.  It includes titles and parameters (more on those later)
        json nui = NuiWindow(jRoot, JsonString(title), NuiBind("geometry"), NuiBind("resizable"), JsonBool(FALSE), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));

        // finally create it and it'll return us a non-zero token.
        int nToken = NuiCreate(OBJECT_SELF, nui, DURATION_NUI_WINDOW_ID);
        UpdateBindsAndCheckRefresh(nToken);

        // get the geometry of the window in case we opened this before and have a
        // preference for location
        json geometry = NuiRect(-1.0f,-1.0f, 748.0f, 535.0f);

        // Set the binds to their default values
        NuiSetBind(OBJECT_SELF, nToken, "geometry", geometry);
        NuiSetBind(OBJECT_SELF, nToken, "resizable", JsonBool(FALSE));
        NuiSetBind(OBJECT_SELF, nToken, "closable", JsonBool(TRUE));
        NuiSetBind(OBJECT_SELF, nToken, "transparent", JsonBool(FALSE));
        NuiSetBind(OBJECT_SELF, nToken, "border", JsonBool(TRUE));
    }

    int dontLoop = StringToInt(GetScriptParam(NUI_DURATION_NO_LOOP_PARAM));
    if (!dontLoop)
        DelayCommand(1.0f, ExecuteScript("prc_nui_dur_view"));
}



