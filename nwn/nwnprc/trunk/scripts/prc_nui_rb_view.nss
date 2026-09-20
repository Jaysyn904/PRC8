//::///////////////////////////////////////////////
//:: PRC Runescar Scribing NUI View
//:: prc_nui_rb_view
//:://////////////////////////////////////////////

#include "prc_nui_rb_inc"

json RBHeader(string sText)
{
    json jLabel = NuiLabel(
        JsonString(sText),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jLabel = NuiHeight(jLabel, 27.0f);
    jLabel = NuiStyleForegroundColor(jLabel, NuiColor(220, 185, 105));
    return jLabel;
}

json RBMessage(string sText, float fHeight)
{
    json jText = NuiText(JsonString(sText), FALSE, NUI_SCROLLBARS_NONE);
    jText = NuiHeight(jText, fHeight);
    return jText;
}

string RBShortPositionName(int nPosition)
{
    switch (nPosition)
    {
        case 1: return "Face";
        case 2: return "L Arm";
        case 3: return "L Chest";
        case 4: return "L Hand";
        case 5: return "R Arm";
        case 6: return "R Chest";
        case 7: return "R Hand";
    }
    return "";
}

string RBPositionTooltip(object oPC, int nPosition)
{
    string sName = NUISpellbookGetRunescarPositionName(nPosition);
    int nSpell = NUISpellbookGetRunescarPersistedSpell(oPC, nPosition);
    if (nSpell < 0)
        return sName + " is empty. Left-click to place the new runescar here.";

    int nCasterLevel = NUISpellbookGetRunescarPersistedCasterLevel(
        oPC,
        nPosition
    );
    return sName + " already holds " + GetSpellName(nSpell)
         + " (caster level " + IntToString(nCasterLevel) + ").";
}

json RBCreateLocationRow(object oPC, int nGeneration)
{
    json jChildren = JsonArray();
    int nSelected = GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_LOCATION_VAR);
    int nPosition;
    for (nPosition = 1;
         nPosition <= PRC_RUNESCAR_SCRIBE_POSITION_COUNT;
         nPosition++)
    {
        int bAvailable = RunescarScribePositionIsAvailable(oPC, nPosition);
        string sTooltip = RBPositionTooltip(oPC, nPosition);
        json jButton = NuiId(
            NuiButton(JsonString(RBShortPositionName(nPosition))),
            RunescarScribeStampValueId(
                PRC_RUNESCAR_SCRIBE_LOCATION_BUTTON,
                nPosition,
                nGeneration
            )
        );
        jButton = NuiWidth(jButton, 84.0f);
        jButton = NuiHeight(jButton, 36.0f);
        jButton = NuiMargin(jButton, 1.0f);
        jButton = NuiTooltip(jButton, JsonString(sTooltip));
        jButton = NuiDisabledTooltip(jButton, JsonString(sTooltip));
        jButton = NuiEnabled(jButton, JsonBool(bAvailable));
        if (bAvailable && nPosition == nSelected)
            jButton = NuiEncouraged(jButton, JsonBool(TRUE));
        jChildren = JsonArrayInsert(jChildren, jButton);
    }

    return NuiRow(jChildren);
}

string RBTierDisabledTooltip(object oPC, int nTier)
{
    if (nTier > RunescarScribeGetMaximumTier(oPC))
        return "This runescar tier has not been unlocked.";
    if (NUISpellbookGetRunescarScribeUses(oPC, nTier) <= 0)
        return "No level " + IntToString(nTier)
             + " runescars remain to be scribed today.";
    if (GetAbilityScore(oPC, ABILITY_WISDOM) < 10 + nTier)
        return "Wisdom " + IntToString(10 + nTier)
             + " is required for this runescar tier.";
    return "This runescar tier is unavailable.";
}

json RBCreateTierRow(object oPC, int nGeneration)
{
    json jChildren = JsonArray();
    int nSelected = GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_TIER_VAR);
    int nTier;
    for (nTier = 1; nTier <= PRC_RUNESCAR_SCRIBE_TIER_COUNT; nTier++)
    {
        int nUses = NUISpellbookGetRunescarScribeUses(oPC, nTier);
        int bAvailable = RunescarScribeTierIsAvailable(oPC, nTier);
        string sLabel = "L" + IntToString(nTier)
                      + "  x" + IntToString(nUses);
        json jButton = NuiId(
            NuiButton(JsonString(sLabel)),
            RunescarScribeStampValueId(
                PRC_RUNESCAR_SCRIBE_TIER_BUTTON,
                nTier,
                nGeneration
            )
        );
        jButton = NuiWidth(jButton, 84.0f);
        jButton = NuiHeight(jButton, 34.0f);
        jButton = NuiMargin(jButton, 1.0f);
        jButton = NuiTooltip(jButton, JsonString(
            "Level " + IntToString(nTier) + " runescars: "
            + IntToString(nUses) + " left to scribe today."
        ));
        jButton = NuiDisabledTooltip(
            jButton,
            JsonString(RBTierDisabledTooltip(oPC, nTier))
        );
        jButton = NuiEnabled(jButton, JsonBool(bAvailable));
        if (bAvailable && nTier == nSelected)
            jButton = NuiEncouraged(jButton, JsonBool(TRUE));
        jChildren = JsonArrayInsert(jChildren, jButton);
    }

    return NuiRow(jChildren);
}

void RBBuildSpellListData(object oPC, int nTier, int nGeneration)
{
    json jMap = JsonArray();
    json jNames = JsonArray();
    int i;
    for (i = 0; i < PRC_RUNESCAR_SCRIBE_SPELL_COUNT; i++)
    {
        int nSpell = RunescarScribeGetSpellByIndex(i);
        if (NUISpellbookGetRunescarSpellTier(nSpell) != nTier)
            continue;
        jMap = JsonArrayInsert(jMap, JsonInt(nSpell));
        jNames = JsonArrayInsert(jNames, JsonString(GetSpellName(nSpell)));
    }

    RunescarScribeSetSpellMap(oPC, jMap, jNames, nGeneration);
}

json RBCreateSpellPanel(object oPC, int nTier, int nGeneration)
{
    json jChildren = JsonArray();
    jChildren = JsonArrayInsert(
        jChildren,
        RBHeader("Runescar Spells - Level " + IntToString(nTier))
    );

    json jTemplate = JsonArray();
    json jButton = NuiId(
        NuiButton(NuiBind(PRC_RUNESCAR_SCRIBE_SPELL_NAMES_BIND)),
        RunescarScribeStampId(
            PRC_RUNESCAR_SCRIBE_SPELL_LIST_BUTTON,
            nGeneration
        )
    );
    jButton = NuiTooltip(
        jButton,
        JsonString("Left-click to select. Right-click for the spell description.")
    );
    jTemplate = JsonArrayInsert(
        jTemplate,
        NuiListTemplateCell(jButton, 0.0f, TRUE)
    );

    json jList = NuiList(
        jTemplate,
        NuiBind(PRC_RUNESCAR_SCRIBE_SPELL_COUNT_BIND),
        38.0f,
        TRUE,
        NUI_SCROLLBARS_Y
    );
    jList = NuiHeight(jList, 195.0f);
    jChildren = JsonArrayInsert(jChildren, jList);

    json jGroup = NuiGroup(NuiCol(jChildren), TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiWidth(jGroup, 350.0f);
    jGroup = NuiHeight(jGroup, 240.0f);
    return jGroup;
}

json RBCreateSelectionPanel(object oPC, int nGeneration)
{
    int nPosition = GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_LOCATION_VAR);
    int nTier = GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_TIER_VAR);
    int nSpell = GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_SPELL_VAR);
    int nCasterLevel = GetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_CASTER_LEVEL_VAR
    );
    int nMinimum = RunescarScribeGetMinimumCasterLevel(nTier);
    int nMaximum = GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC);
    int nGoldCost = RunescarScribeGetGoldCost(nTier, nCasterLevel);
    int nXPCost = RunescarScribeGetXPCost(nTier, nCasterLevel);

    json jChildren = JsonArray();
    jChildren = JsonArrayInsert(jChildren, RBHeader("Selected Runescar"));

    json jSpellRow = JsonArray();
    json jIcon = NuiImage(
        GetSpellIcon(nSpell),
        JsonInt(NUI_ASPECT_FIT),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jIcon = NuiWidth(jIcon, 42.0f);
    jIcon = NuiHeight(jIcon, 42.0f);
    jIcon = NuiTooltip(jIcon, JsonString(GetSpellName(nSpell)));
    jSpellRow = JsonArrayInsert(jSpellRow, jIcon);

    json jSpellName = NuiLabel(
        JsonString(GetSpellName(nSpell)),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jSpellName = NuiWidth(jSpellName, 215.0f);
    jSpellName = NuiHeight(jSpellName, 42.0f);
    jSpellRow = JsonArrayInsert(jSpellRow, jSpellName);
    jChildren = JsonArrayInsert(jChildren, NuiRow(jSpellRow));

    jChildren = JsonArrayInsert(
        jChildren,
        RBMessage(
            "Location: " + NUISpellbookGetRunescarPositionName(nPosition)
            + "\nRune tier: " + IntToString(nTier),
            38.0f
        )
    );

    json jCasterRow = JsonArray();
    json jCasterLabel = NuiLabel(
        JsonString("Caster level"),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jCasterLabel = NuiWidth(jCasterLabel, 105.0f);
    jCasterRow = JsonArrayInsert(jCasterRow, jCasterLabel);

    json jDown = NuiId(
        NuiButton(JsonString("-")),
        RunescarScribeStampId(
            PRC_RUNESCAR_SCRIBE_CASTER_DOWN_BUTTON,
            nGeneration
        )
    );
    jDown = NuiWidth(jDown, 38.0f);
    jDown = NuiHeight(jDown, 32.0f);
    jDown = NuiEnabled(jDown, JsonBool(nCasterLevel > nMinimum));
    jDown = NuiDisabledTooltip(jDown, JsonString(
        "The minimum caster level for this tier is "
        + IntToString(nMinimum) + "."
    ));
    jCasterRow = JsonArrayInsert(jCasterRow, jDown);

    json jCasterValue = NuiLabel(
        JsonString(IntToString(nCasterLevel)),
        JsonInt(NUI_HALIGN_CENTER),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jCasterValue = NuiWidth(jCasterValue, 48.0f);
    jCasterValue = NuiHeight(jCasterValue, 32.0f);
    jCasterRow = JsonArrayInsert(jCasterRow, jCasterValue);

    json jUp = NuiId(
        NuiButton(JsonString("+")),
        RunescarScribeStampId(
            PRC_RUNESCAR_SCRIBE_CASTER_UP_BUTTON,
            nGeneration
        )
    );
    jUp = NuiWidth(jUp, 38.0f);
    jUp = NuiHeight(jUp, 32.0f);
    jUp = NuiEnabled(jUp, JsonBool(nCasterLevel < nMaximum));
    jUp = NuiDisabledTooltip(jUp, JsonString(
        "Your Runescarred Berserker level is "
        + IntToString(nMaximum) + "."
    ));
    jCasterRow = JsonArrayInsert(jCasterRow, jUp);
    jChildren = JsonArrayInsert(jChildren, NuiRow(jCasterRow));

    jChildren = JsonArrayInsert(
        jChildren,
        RBMessage(
            "Cost: " + IntToString(nGoldCost) + " gp and "
            + IntToString(nXPCost) + " XP\n"
            + "Scribing damage: " + IntToString(nTier) + "d6",
            42.0f
        )
    );

    string sValidation = RunescarScribeValidateDraft(oPC);
    if (sValidation == "")
        sValidation = "Ready to scribe. This change is immediate.";
    jChildren = JsonArrayInsert(jChildren, RBMessage(sValidation, 44.0f));

    json jGroup = NuiGroup(NuiCol(jChildren), TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiWidth(jGroup, 300.0f);
    jGroup = NuiHeight(jGroup, 240.0f);
    return jGroup;
}

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC)
        || GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) <= 0
        || !GetHasFeat(NUI_SPELLBOOK_RUNESCAR_SCRIBE_FEAT, oPC))
    {
        RunescarScribeDiscardDraft(oPC);
        return;
    }

    // The spellbook event can enter through this view script directly, just as
    // the Archivist editor does. Bootstrap one fresh session, whose nested view
    // invocation sees the active generation and performs the actual render.
    if (!RunescarScribeHasActiveSession(oPC))
    {
        RunescarScribeOpenEditor(oPC);
        return;
    }

    // An active local can survive a disconnect even though its client window
    // cannot.  Retain the draft only for a marked editor rebuild or the nested
    // first render started by OpenEditor; otherwise a direct `/sb` entry starts
    // a clean session instead of resurrecting an abandoned selection.
    int nActiveSession = GetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_ACTIVE_SESSION_VAR
    );
    int nExistingWindow = NuiFindWindow(
        oPC,
        PRC_RUNESCAR_SCRIBE_NUI_WINDOW_ID
    );
    int bBootstrap = GetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_BOOTSTRAP_VAR
    ) == nActiveSession;
    int bRebuild = GetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_REBUILD_TOKEN_VAR
    ) > 0;
    if (!nExistingWindow && !bBootstrap && !bRebuild)
    {
        RunescarScribeDiscardDraft(oPC, FALSE);
        RunescarScribeOpenEditor(oPC);
        return;
    }
    if (bBootstrap)
        DeleteLocalInt(oPC, PRC_RUNESCAR_SCRIBE_BOOTSTRAP_VAR);

    int nPrevious = NuiFindWindow(oPC, PRC_RUNESCAR_SCRIBE_NUI_WINDOW_ID);
    if (nPrevious)
    {
        json jPreviousGeometry = NuiGetBind(oPC, nPrevious, "geometry");
        if (jPreviousGeometry != JsonNull())
        {
            SetLocalJson(
                oPC,
                PRC_RUNESCAR_SCRIBE_GEOMETRY_VAR,
                jPreviousGeometry
            );
        }
        SetLocalInt(
            oPC,
            PRC_RUNESCAR_SCRIBE_REBUILD_TOKEN_VAR,
            nPrevious
        );
        NuiDestroy(oPC, nPrevious);
    }

    int nPosition = GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_LOCATION_VAR);
    if (!RunescarScribePositionIsAvailable(oPC, nPosition))
    {
        nPosition = RunescarScribeGetFirstOpenPosition(oPC);
        if (nPosition < 1)
        {
            SendMessageToPC(oPC, "All seven runescar locations are occupied.");
            RunescarScribeDiscardDraft(oPC, FALSE);
            return;
        }
        SetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_LOCATION_VAR, nPosition);
    }

    int nTier = GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_TIER_VAR);
    if (!RunescarScribeTierIsAvailable(oPC, nTier))
    {
        nTier = RunescarScribeGetFirstAvailableTier(oPC);
        if (nTier < 1)
        {
            SendMessageToPC(
                oPC,
                "No runescar tier is currently available. Check your remaining scribing uses and Wisdom."
            );
            RunescarScribeDiscardDraft(oPC, FALSE);
            return;
        }
        RunescarScribeSelectTier(oPC, nTier);
    }

    int nSpell = GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_SPELL_VAR);
    if (!RunescarScribeIsAllowedSpell(nSpell)
        || NUISpellbookGetRunescarSpellTier(nSpell) != nTier)
    {
        nSpell = RunescarScribeGetFirstSpellAtTier(nTier);
        SetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_SPELL_VAR, nSpell);
    }

    int nCasterLevel = GetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_CASTER_LEVEL_VAR
    );
    int nMinimum = RunescarScribeGetMinimumCasterLevel(nTier);
    int nMaximum = GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC);
    if (nCasterLevel < nMinimum || nCasterLevel > nMaximum)
    {
        nCasterLevel = nMaximum;
        SetLocalInt(
            oPC,
            PRC_RUNESCAR_SCRIBE_CASTER_LEVEL_VAR,
            nCasterLevel
        );
    }

    int nGeneration = RunescarScribeAdvanceLayoutGeneration(oPC);
    RBBuildSpellListData(oPC, nTier, nGeneration);

    // The content stack is roughly 398 logical pixels high. A compact 450px
    // window therefore remains satisfiable when a 768px display at 1.5 UI
    // scale clamps the usable NUI height to about 448 logical pixels, including
    // enough slack for title-bar and container padding.
    float fWindowWidth = 700.0f;
    float fWindowHeight = 450.0f;
    int nGuiWidth = GetPlayerDeviceProperty(
        oPC,
        PLAYER_DEVICE_PROPERTY_GUI_WIDTH
    );
    int nGuiHeight = GetPlayerDeviceProperty(
        oPC,
        PLAYER_DEVICE_PROPERTY_GUI_HEIGHT
    );
    int nGuiScale = GetPlayerDeviceProperty(
        oPC,
        PLAYER_DEVICE_PROPERTY_GUI_SCALE
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

    json jRootChildren = JsonArray();
    jRootChildren = JsonArrayInsert(jRootChildren, RBHeader("Body Location"));
    jRootChildren = JsonArrayInsert(
        jRootChildren,
        RBCreateLocationRow(oPC, nGeneration)
    );
    jRootChildren = JsonArrayInsert(
        jRootChildren,
        RBHeader("Rune Tier - remaining scribing uses")
    );
    jRootChildren = JsonArrayInsert(
        jRootChildren,
        RBCreateTierRow(oPC, nGeneration)
    );

    json jPanels = JsonArray();
    jPanels = JsonArrayInsert(
        jPanels,
        RBCreateSpellPanel(oPC, nTier, nGeneration)
    );
    jPanels = JsonArrayInsert(
        jPanels,
        RBCreateSelectionPanel(oPC, nGeneration)
    );
    json jBody = NuiGroup(NuiRow(jPanels), FALSE, NUI_SCROLLBARS_AUTO);
    jBody = NuiWidth(jBody, fWindowWidth - 16.0f);
    jRootChildren = JsonArrayInsert(jRootChildren, jBody);

    string sValidation = RunescarScribeValidateDraft(oPC);
    json jBottom = JsonArray();
    json jCancel = NuiId(
        NuiButton(JsonString("Cancel")),
        RunescarScribeStampId(
            PRC_RUNESCAR_SCRIBE_CANCEL_BUTTON,
            nGeneration
        )
    );
    jCancel = NuiWidth(jCancel, 110.0f);
    jCancel = NuiHeight(jCancel, 34.0f);
    jBottom = JsonArrayInsert(jBottom, jCancel);
    jBottom = JsonArrayInsert(jBottom, NuiSpacer());

    json jSave = NuiId(
        NuiButton(JsonString("Scribe Runescar")),
        RunescarScribeStampId(
            PRC_RUNESCAR_SCRIBE_SAVE_BUTTON,
            nGeneration
        )
    );
    jSave = NuiWidth(jSave, 170.0f);
    jSave = NuiHeight(jSave, 34.0f);
    jSave = NuiEnabled(jSave, JsonBool(sValidation == ""));
    jSave = NuiEncouraged(jSave, JsonBool(sValidation == ""));
    jSave = NuiTooltip(jSave, JsonString(
        "Immediately spend the listed gold and XP, take the listed damage, and place this scar."
    ));
    jSave = NuiDisabledTooltip(jSave, JsonString(sValidation));
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
        JsonString("PRC8 Scribe Runescar"),
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

    int nToken = NuiCreate(oPC, jWindow, PRC_RUNESCAR_SCRIBE_NUI_WINDOW_ID);
    if (!nToken)
    {
        RunescarScribeDiscardDraft(oPC, FALSE);
        return;
    }

    json jGeometry = GetLocalJson(oPC, PRC_RUNESCAR_SCRIBE_GEOMETRY_VAR);
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
        PRC_RUNESCAR_SCRIBE_SPELL_NAMES_BIND,
        GetLocalJson(oPC, PRC_RUNESCAR_SCRIBE_SPELL_NAMES_VAR)
    );
    NuiSetBind(
        oPC,
        nToken,
        PRC_RUNESCAR_SCRIBE_SPELL_COUNT_BIND,
        JsonInt(JsonGetLength(GetLocalJson(
            oPC,
            PRC_RUNESCAR_SCRIBE_SPELL_MAP_VAR
        )))
    );
    NuiSetBindWatch(oPC, nToken, "geometry", TRUE);
}
