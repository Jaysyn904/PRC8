//::///////////////////////////////////////////////
//:: Standalone psionic configuration NUI view
//:: prc_nui_psi_vw
//:://////////////////////////////////////////////

#include "prc_nui_psi_inc"

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC) || !NUISpellbookPsiHasContent(oPC))
        return;

    int nPrevious = NuiFindWindow(oPC, PRC_NUI_PSI_WINDOW_ID);
    if (nPrevious)
    {
        json jPreviousGeometry = NuiGetBind(oPC, nPrevious, "geometry");
        if (jPreviousGeometry != JsonNull())
            SetLocalJson(oPC, PRC_NUI_PSI_GEOMETRY_VAR, jPreviousGeometry);
        SetLocalInt(oPC, PRC_NUI_PSI_REBUILD_TOKEN_VAR, nPrevious);
        NuiDestroy(oPC, nPrevious);
    }

    int nGeneration = NUISpellbookPsiNextGeneration(oPC);
    float fWindowWidth = 760.0f;
    float fWindowHeight = 650.0f;
    int nGuiWidth = GetPlayerDeviceProperty(
        oPC, PLAYER_DEVICE_PROPERTY_GUI_WIDTH
    );
    int nGuiHeight = GetPlayerDeviceProperty(
        oPC, PLAYER_DEVICE_PROPERTY_GUI_HEIGHT
    );
    int nGuiScale = GetPlayerDeviceProperty(
        oPC, PLAYER_DEVICE_PROPERTY_GUI_SCALE
    );
    if (nGuiWidth > 0 && nGuiHeight > 0 && nGuiScale > 0)
    {
        float fScale = IntToFloat(nGuiScale) / 100.0f;
        float fAvailableWidth = IntToFloat(nGuiWidth) / fScale;
        float fAvailableHeight = IntToFloat(nGuiHeight) / fScale;
        if (fWindowWidth > fAvailableWidth - 24.0f)
            fWindowWidth = fAvailableWidth - 24.0f;
        if (fWindowHeight > fAvailableHeight - 64.0f)
            fWindowHeight = fAvailableHeight - 64.0f;
    }

    json jRoot = JsonArray();
    json jPanel = NUISpellbookPsiCreatePanel(oPC, nGeneration);
    json jPanelGroup = NuiGroup(jPanel, FALSE, NUI_SCROLLBARS_AUTO);
    jPanelGroup = NuiWidth(jPanelGroup, fWindowWidth - 16.0f);
    jRoot = JsonArrayInsert(jRoot, jPanelGroup);

    json jFooter = JsonArray();
    json jClose = NUISpellbookPsiButton(
        "Close",
        PRC_NUI_PSI_CLOSE_BUTTON,
        0,
        nGeneration,
        100.0f,
        TRUE
    );
    jFooter = JsonArrayInsert(jFooter, jClose);
    json jFooterGroup = NuiGroup(
        NuiRow(jFooter), FALSE, NUI_SCROLLBARS_NONE
    );
    jFooterGroup = NuiHeight(jFooterGroup, 46.0f);
    jRoot = JsonArrayInsert(jRoot, jFooterGroup);

    json jWindow = NuiWindow(
        NuiCol(jRoot),
        JsonString("PRC8 Psionic Configuration"),
        NuiBind("geometry"),
        NuiBind("resizable"),
        NuiBind("collapsed"),
        NuiBind("closable"),
        NuiBind("transparent"),
        NuiBind("border"),
        JsonBool(TRUE),
        NuiRect(fWindowWidth, fWindowHeight, fWindowWidth, fWindowHeight),
        NuiRect(8.0f, 8.0f, 8.0f, 48.0f)
    );
    int nToken = NuiCreate(oPC, jWindow, PRC_NUI_PSI_WINDOW_ID);
    if (!nToken)
        return;

    json jGeometry = GetLocalJson(oPC, PRC_NUI_PSI_GEOMETRY_VAR);
    float fX = -1.0f;
    float fY = -1.0f;
    if (jGeometry != JsonNull())
    {
        fX = JsonGetFloat(JsonObjectGet(jGeometry, "x"));
        fY = JsonGetFloat(JsonObjectGet(jGeometry, "y"));
    }
    NuiSetBind(
        oPC, nToken, "geometry",
        NuiRect(fX, fY, fWindowWidth, fWindowHeight)
    );
    NuiSetBind(oPC, nToken, "resizable", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPC, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "border", JsonBool(TRUE));
    NuiSetBindWatch(oPC, nToken, "geometry", TRUE);
}
