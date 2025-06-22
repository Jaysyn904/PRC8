//::///////////////////////////////////////////////
//:: PRC Spellbook Description NUI
//:: prc_nui_dsc_view
//:://////////////////////////////////////////////
/*
    This is the view for the Spell Description NUI
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 29.05.2005
//:://////////////////////////////////////////////

#include "nw_inc_nui"
#include "prc_nui_consts"
#include "inc_2dacache"
#include "prc_nui_com_inc"

void main()
{
    int featID = GetLocalInt(OBJECT_SELF, NUI_SPELL_DESCRIPTION_FEATID_VAR);
    int spellId = GetLocalInt(OBJECT_SELF, NUI_SPELL_DESCRIPTION_SPELLID_VAR);
    int realSpellId = GetLocalInt(OBJECT_SELF, NUI_SPELL_DESCRIPTION_REAL_SPELLID_VAR);
    int nClass = GetLocalInt(OBJECT_SELF, NUI_SPELL_DESCRIPTION_CLASSID_VAR);

    // look for existing window and destroy
    int nPreviousToken = NuiFindWindow(OBJECT_SELF, NUI_SPELL_DESCRIPTION_WINDOW_ID);
    if(nPreviousToken != 0)
    {
        NuiDestroy(OBJECT_SELF, nPreviousToken);
    }

    // in order of accuracy for names it goes RealSpellID > SpellID > FeatID
    string spellName = GetSpellName(spellId, realSpellId, featID, nClass);
    // Descriptions and Icons are accuratly stored on the feat
    string spellDesc = GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", featID)));
    string spellIcon = Get2DACache("feat", "ICON", featID);

    json jRoot = JsonArray();
    json jGroup = JsonArray();

    json jRow = JsonArray();

    json jImage = NuiImage(JsonString(spellIcon), JsonInt(NUI_ASPECT_EXACT), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_TOP));
    jImage = NuiWidth(jImage, 32.0f);
    jRow = JsonArrayInsert(jRow, jImage);
    jRow = NuiCol(jRow);
    jGroup = JsonArrayInsert(jGroup, jRow);

    jRow = JsonArray();
    json jText = NuiText(JsonString(spellDesc), FALSE, NUI_SCROLLBARS_AUTO);
    jRow = JsonArrayInsert(jRow, jText);
    jRow = NuiCol(jRow);
    jGroup = JsonArrayInsert(jGroup, jRow);

    jGroup = NuiRow(jGroup);
    jGroup = NuiGroup(jGroup, TRUE, NUI_SCROLLBARS_NONE);
    jRoot = JsonArrayInsert(jRoot, jGroup);

    jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    json jButton = NuiId(NuiButton(JsonString("OK")), NUI_SPELL_DESCRIPTION_OK_BUTTON);
    jButton = NuiWidth(jButton, 175.0f);
    jButton = NuiHeight(jButton, 48.0f);
    jRow = JsonArrayInsert(jRow, jButton);
    jRow = NuiRow(jRow);

    jRoot = JsonArrayInsert(jRoot, jRow);
    jRoot = NuiCol(jRoot);


    // This is the main window with jRoot as the main pane.  It includes titles and parameters (more on those later)
    json nui = NuiWindow(jRoot, JsonString(spellName), NuiBind("geometry"), NuiBind("resizable"), JsonBool(FALSE), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));

    // finally create it and it'll return us a non-zero token.
    int nToken = NuiCreate(OBJECT_SELF, nui, NUI_SPELL_DESCRIPTION_WINDOW_ID);

    // get the geometry of the window in case we opened this before and have a
    // preference for location
    json geometry = NuiRect(-1.0f,-1.0f, 426.0f, 446.0f);

    // Set the binds to their default values
    NuiSetBind(OBJECT_SELF, nToken, "geometry", geometry);
    NuiSetBind(OBJECT_SELF, nToken, "resizable", JsonBool(FALSE));
    NuiSetBind(OBJECT_SELF, nToken, "closable", JsonBool(FALSE));
    NuiSetBind(OBJECT_SELF, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(OBJECT_SELF, nToken, "border", JsonBool(TRUE));

    ClearSpellDescriptionNUI();
}

