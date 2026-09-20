//::///////////////////////////////////////////////
//:: PRC Maneuver Readying NUI View
//:: prc_nui_mr_view
//:://////////////////////////////////////////////

#include "prc_nui_mr_inc"

json MRHeader(string sText)
{
    json jLabel = NuiLabel(
        JsonString(sText),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jLabel = NuiHeight(jLabel, 28.0f);
    jLabel = NuiStyleForegroundColor(jLabel, NuiColor(220, 185, 105));
    return jLabel;
}

json MRMessage(string sText, float fHeight)
{
    json jText = NuiText(JsonString(sText), FALSE, NUI_SCROLLBARS_NONE);
    jText = NuiHeight(jText, fHeight);
    return jText;
}

json MRCreateLevelButtons(object oPC, int nClass)
{
    json jChildren = JsonArray();
    int nSelected = GetLocalInt(oPC, PRC_MANEUVER_READY_LEVEL_VAR);
    int nMaxLevel = ManeuverReadyMaxLevel(oPC, nClass);
    int nLevel;
    for (nLevel = 1; nLevel <= nMaxLevel; nLevel++)
    {
        int bKnown = ManeuverReadyHasKnownAtLevel(oPC, nClass, nLevel);
        json jButton = NuiId(
            NuiButtonImage(JsonString(GetSpellLevelIcon(nLevel))),
            PRC_MANEUVER_READY_LEVEL_BUTTON + IntToString(nLevel)
        );
        jButton = NuiWidth(jButton, 40.0f);
        jButton = NuiHeight(jButton, 40.0f);
        jButton = NuiMargin(jButton, 1.0f);
        jButton = NuiTooltip(jButton, JsonString(
            "Maneuver level " + IntToString(nLevel)
        ));
        if (!bKnown)
            jButton = NuiEnabled(jButton, JsonBool(FALSE));
        else if (nSelected != nLevel)
            jButton = GreyOutButton(jButton, 40.0f, 40.0f);
        jChildren = JsonArrayInsert(jChildren, jButton);
    }

    json jRow = NuiRow(jChildren);
    jRow = NuiHeight(jRow, 44.0f);
    return jRow;
}

void MRBuildKnownListData(object oPC, int nClass, int nLevel)
{
    json jMap = JsonArray();
    json jNames = JsonArray();
    json jSeen = JsonObject();
    string sFile = GetAMSDefinitionFileName(nClass);
    int nRows = Get2DARowCount(sFile);
    int i;
    for (i = 1; i < nRows; i++)
    {
        if (Get2DACache(sFile, "Type", i) == "1"
            || StringToInt(Get2DACache(sFile, "Level", i)) != nLevel)
            continue;

        int nManeuver = StringToInt(Get2DACache(sFile, "RealSpellID", i));
        string sKey = IntToString(nManeuver);
        if (nManeuver <= 0
            || JsonObjectGet(jSeen, sKey) != JsonNull()
            || !GetHasManeuver(nManeuver, nClass, oPC))
            continue;
        jSeen = JsonObjectSet(jSeen, sKey, JsonBool(TRUE));

        if (ManeuverReadyDraftContains(oPC, nManeuver))
            continue;
        jMap = JsonArrayInsert(jMap, JsonInt(nManeuver));
        jNames = JsonArrayInsert(jNames, JsonString(GetManeuverName(nManeuver)));
    }

    SetLocalJson(oPC, PRC_MANEUVER_READY_KNOWN_MAP_VAR, jMap);
    SetLocalJson(oPC, PRC_MANEUVER_READY_KNOWN_NAMES_VAR, jNames);
}

void MRBuildPlanListData(object oPC, int nClass)
{
    json jDraft = ManeuverReadyGetDraft(oPC);
    json jMap = JsonArray();
    json jNames = JsonArray();
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        int nManeuver = JsonGetInt(JsonArrayGet(jDraft, i));
        int nLevel = ManeuverReadyGetLevel(nClass, nManeuver);
        if (nLevel <= 0)
            continue;
        jMap = JsonArrayInsert(jMap, JsonInt(nManeuver));
        jNames = JsonArrayInsert(
            jNames,
            JsonString("L" + IntToString(nLevel) + "  " + GetManeuverName(nManeuver))
        );
    }

    SetLocalJson(oPC, PRC_MANEUVER_READY_PLAN_MAP_VAR, jMap);
    SetLocalJson(oPC, PRC_MANEUVER_READY_PLAN_NAMES_VAR, jNames);
}

json MRCreateKnownPanel(object oPC, int nLevel)
{
    json jChildren = JsonArray();
    jChildren = JsonArrayInsert(
        jChildren,
        MRHeader("Known Maneuvers - Level " + IntToString(nLevel))
    );

    json jTemplate = JsonArray();
    json jButton = NuiId(
        NuiButton(NuiBind(PRC_MANEUVER_READY_KNOWN_NAMES_BIND)),
        PRC_MANEUVER_READY_KNOWN_LIST_BUTTON
    );
    jButton = NuiTooltip(
        jButton,
        JsonString("Left-click to add. Right-click for the maneuver description.")
    );
    jTemplate = JsonArrayInsert(
        jTemplate,
        NuiListTemplateCell(jButton, 0.0f, TRUE)
    );

    json jList = NuiList(
        jTemplate,
        NuiBind(PRC_MANEUVER_READY_KNOWN_COUNT_BIND),
        38.0f,
        TRUE,
        NUI_SCROLLBARS_Y
    );
    jList = NuiHeight(jList, 340.0f);
    jChildren = JsonArrayInsert(jChildren, jList);

    json jGroup = NuiGroup(NuiCol(jChildren), TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiWidth(jGroup, 360.0f);
    jGroup = NuiHeight(jGroup, 385.0f);
    return jGroup;
}

json MRCreatePlanPanel(object oPC, int nClass)
{
    int nSelected = ManeuverReadyDraftCount(oPC);
    int nTarget = ManeuverReadyTargetCount(oPC, nClass);
    json jChildren = JsonArray();
    jChildren = JsonArrayInsert(
        jChildren,
        MRHeader(
            "Readied Plan - " + IntToString(nSelected) + "/" + IntToString(nTarget)
        )
    );

    json jTemplate = JsonArray();
    json jButton = NuiId(
        NuiButton(NuiBind(PRC_MANEUVER_READY_PLAN_NAMES_BIND)),
        PRC_MANEUVER_READY_PLAN_LIST_BUTTON
    );
    jButton = NuiTooltip(
        jButton,
        JsonString("Left-click to remove. Right-click for the maneuver description.")
    );
    jTemplate = JsonArrayInsert(
        jTemplate,
        NuiListTemplateCell(jButton, 0.0f, TRUE)
    );

    json jList = NuiList(
        jTemplate,
        NuiBind(PRC_MANEUVER_READY_PLAN_COUNT_BIND),
        38.0f,
        TRUE,
        NUI_SCROLLBARS_Y
    );
    jList = NuiHeight(jList, 302.0f);
    jChildren = JsonArrayInsert(jChildren, jList);

    json jClear = NuiId(
        NuiButton(JsonString("Clear Plan")),
        PRC_MANEUVER_READY_CLEAR_BUTTON
    );
    jClear = NuiWidth(jClear, 120.0f);
    jClear = NuiHeight(jClear, 30.0f);
    jClear = NuiEnabled(jClear, JsonBool(nSelected > 0));
    jChildren = JsonArrayInsert(jChildren, jClear);

    json jGroup = NuiGroup(NuiCol(jChildren), TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiWidth(jGroup, 360.0f);
    jGroup = NuiHeight(jGroup, 385.0f);
    return jGroup;
}

void main()
{
    object oPC = OBJECT_SELF;
    int nClass = GetLocalInt(oPC, PRC_MANEUVER_READY_CLASS_VAR);
    if (!GetIsPC(oPC)
        || !GetLocalInt(oPC, PRC_MANEUVER_READY_ACTIVE_VAR)
        || !ManeuverReadyIsInitiatorClass(nClass)
        || GetLevelByClass(nClass, oPC) <= 0)
    {
        ManeuverReadyDiscardDraft(oPC);
        return;
    }

    int nPrevious = NuiFindWindow(oPC, PRC_MANEUVER_READY_NUI_WINDOW_ID);
    if (nPrevious)
    {
        json jPreviousGeometry = NuiGetBind(oPC, nPrevious, "geometry");
        if (jPreviousGeometry != JsonNull())
            SetLocalJson(oPC, PRC_MANEUVER_READY_GEOMETRY_VAR, jPreviousGeometry);
        SetLocalInt(oPC, PRC_MANEUVER_READY_REBUILD_TOKEN_VAR, nPrevious);
        NuiDestroy(oPC, nPrevious);
    }

    int nLevel = GetLocalInt(oPC, PRC_MANEUVER_READY_LEVEL_VAR);
    int nMaxLevel = ManeuverReadyMaxLevel(oPC, nClass);
    if (nLevel < 1 || nLevel > nMaxLevel
        || !ManeuverReadyHasKnownAtLevel(oPC, nClass, nLevel))
    {
        nLevel = 1;
        while (nLevel <= nMaxLevel
            && !ManeuverReadyHasKnownAtLevel(oPC, nClass, nLevel))
            nLevel++;
        if (nLevel > nMaxLevel)
            nLevel = 1;
        SetLocalInt(oPC, PRC_MANEUVER_READY_LEVEL_VAR, nLevel);
    }

    MRBuildKnownListData(oPC, nClass, nLevel);
    MRBuildPlanListData(oPC, nClass);

    float fWindowWidth = 760.0f;
    float fWindowHeight = 555.0f;
    int nGuiWidth = GetPlayerDeviceProperty(oPC, PLAYER_DEVICE_PROPERTY_GUI_WIDTH);
    int nGuiHeight = GetPlayerDeviceProperty(oPC, PLAYER_DEVICE_PROPERTY_GUI_HEIGHT);
    int nGuiScale = GetPlayerDeviceProperty(oPC, PLAYER_DEVICE_PROPERTY_GUI_SCALE);
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

    int nTarget = ManeuverReadyTargetCount(oPC, nClass);
    int nSelected = ManeuverReadyDraftCount(oPC);
    string sRules = "Select exactly " + IntToString(nTarget)
                  + " known maneuvers. Saving replaces the current roster immediately and recovers it."
                  + " Normal readying cannot be completed after combat begins.";

    json jRootChildren = JsonArray();
    jRootChildren = JsonArrayInsert(jRootChildren, MRCreateLevelButtons(oPC, nClass));
    jRootChildren = JsonArrayInsert(jRootChildren, MRMessage(sRules, 48.0f));

    json jPanels = JsonArray();
    jPanels = JsonArrayInsert(jPanels, MRCreateKnownPanel(oPC, nLevel));
    jPanels = JsonArrayInsert(jPanels, MRCreatePlanPanel(oPC, nClass));
    json jBody = NuiGroup(NuiRow(jPanels), FALSE, NUI_SCROLLBARS_AUTO);
    jBody = NuiWidth(jBody, fWindowWidth - 16.0f);
    jRootChildren = JsonArrayInsert(jRootChildren, jBody);

    json jBottom = JsonArray();
    json jCancel = NuiId(
        NuiButton(JsonString("Cancel")),
        PRC_MANEUVER_READY_CANCEL_BUTTON
    );
    jCancel = NuiWidth(jCancel, 110.0f);
    jCancel = NuiHeight(jCancel, 34.0f);
    jBottom = JsonArrayInsert(jBottom, jCancel);
    jBottom = JsonArrayInsert(jBottom, NuiSpacer());
    json jSave = NuiId(
        NuiButton(JsonString("Ready Maneuvers")),
        PRC_MANEUVER_READY_SAVE_BUTTON
    );
    jSave = NuiWidth(jSave, 170.0f);
    jSave = NuiHeight(jSave, 34.0f);
    jSave = NuiEnabled(jSave, JsonBool(nSelected == nTarget));
    jSave = NuiEncouraged(jSave, JsonBool(nSelected == nTarget));
    jBottom = JsonArrayInsert(jBottom, jSave);
    jRootChildren = JsonArrayInsert(jRootChildren, NuiRow(jBottom));

    json jRoot = NuiCol(jRootChildren);
    json jSizeConstraint = NuiRect(
        fWindowWidth,
        fWindowHeight,
        fWindowWidth,
        fWindowHeight
    );
    json jEdgeConstraint = NuiRect(8.0f, 8.0f, 8.0f, 48.0f);
    json jWindow = NuiWindow(
        jRoot,
        JsonString("PRC8 Ready Maneuvers: " + ManeuverReadyClassName(nClass)),
        NuiBind("geometry"),
        NuiBind("resizable"),
        NuiBind("collapsed"),
        NuiBind("closable"),
        NuiBind("transparent"),
        NuiBind("border"),
        JsonBool(TRUE),
        jSizeConstraint,
        jEdgeConstraint
    );

    int nToken = NuiCreate(oPC, jWindow, PRC_MANEUVER_READY_NUI_WINDOW_ID);
    if (!nToken)
    {
        ManeuverReadyDiscardDraft(oPC, FALSE);
        return;
    }

    json jGeometry = GetLocalJson(oPC, PRC_MANEUVER_READY_GEOMETRY_VAR);
    float fWindowX = -1.0f;
    float fWindowY = -1.0f;
    if (jGeometry != JsonNull())
    {
        fWindowX = JsonGetFloat(JsonObjectGet(jGeometry, "x"));
        fWindowY = JsonGetFloat(JsonObjectGet(jGeometry, "y"));
    }
    jGeometry = NuiRect(fWindowX, fWindowY, fWindowWidth, fWindowHeight);

    NuiSetBind(oPC, nToken, "geometry", jGeometry);
    NuiSetBind(oPC, nToken, "resizable", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPC, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "border", JsonBool(TRUE));
    NuiSetBind(
        oPC,
        nToken,
        PRC_MANEUVER_READY_KNOWN_NAMES_BIND,
        GetLocalJson(oPC, PRC_MANEUVER_READY_KNOWN_NAMES_VAR)
    );
    NuiSetBind(
        oPC,
        nToken,
        PRC_MANEUVER_READY_KNOWN_COUNT_BIND,
        JsonInt(JsonGetLength(GetLocalJson(oPC, PRC_MANEUVER_READY_KNOWN_MAP_VAR)))
    );
    NuiSetBind(
        oPC,
        nToken,
        PRC_MANEUVER_READY_PLAN_NAMES_BIND,
        GetLocalJson(oPC, PRC_MANEUVER_READY_PLAN_NAMES_VAR)
    );
    NuiSetBind(
        oPC,
        nToken,
        PRC_MANEUVER_READY_PLAN_COUNT_BIND,
        JsonInt(JsonGetLength(GetLocalJson(oPC, PRC_MANEUVER_READY_PLAN_MAP_VAR)))
    );
    NuiSetBindWatch(oPC, nToken, "geometry", TRUE);
}
