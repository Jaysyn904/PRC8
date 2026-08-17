//::///////////////////////////////////////////////
//:: PRC Archivist Preparation NUI View
//:: prc_nui_ap_view
//:://////////////////////////////////////////////

#include "prc_nui_ap_inc"

json APCreateCircleButtons(object oPC);
json APCreateMetamagicButtons(object oPC, int nCircle);
json APCreateKnownPanel(object oPC, int nCircle, int nMetamagic);
void APBuildKnownListData(object oPC, int nCircle, int nMetamagic);
json APCreatePlanPanel(object oPC, int nCircle);
json APCreateReadyPanel(object oPC, int nCircle);
json APCreateSpellButton(int nSpellbookRow, string sId, string sSuffix, float fWidth);
int APGetMetamagicFeat(int nMetamagic);
int APMetamagicAvailable(object oPC, int nCircle, int nMetamagic);

json APHeader(string sText)
{
    json jLabel = NuiLabel(JsonString(sText), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE));
    jLabel = NuiHeight(jLabel, 28.0f);
    jLabel = NuiStyleForegroundColor(jLabel, NuiColor(220, 185, 105));
    return jLabel;
}

json APMessage(string sText, float fHeight)
{
    json jText = NuiText(JsonString(sText), FALSE, NUI_SCROLLBARS_NONE);
    jText = NuiHeight(jText, fHeight);
    return jText;
}

int APGetMetamagicFeat(int nMetamagic)
{
    switch (nMetamagic)
    {
        case METAMAGIC_EMPOWER:  return FEAT_EMPOWER_SPELL;
        case METAMAGIC_EXTEND:   return FEAT_EXTEND_SPELL;
        case METAMAGIC_MAXIMIZE: return FEAT_MAXIMIZE_SPELL;
        case METAMAGIC_QUICKEN:  return FEAT_QUICKEN_SPELL;
        case METAMAGIC_SILENT:   return FEAT_SILENCE_SPELL;
        case METAMAGIC_STILL:    return FEAT_STILL_SPELL;
    }
    return 0;
}

int APMetamagicAvailable(object oPC, int nCircle, int nMetamagic)
{
    if (nMetamagic == METAMAGIC_NONE)
        return TRUE;

    int nFeat = APGetMetamagicFeat(nMetamagic);
    int nAdjustment = GetMetaMagicSpellLevelAdjustment(nMetamagic);
    return nFeat > 0 && GetHasFeat(nFeat, oPC) && nAdjustment > 0 && nAdjustment <= nCircle;
}

json APCreateCircleButtons(object oPC)
{
    json jChildren = JsonArray();
    int nSelected = GetLocalInt(oPC, PRC_ARCHIVIST_PREP_CIRCLE_VAR);
    int nCircle;
    for (nCircle = 0; nCircle <= 9; nCircle++)
    {
        int nSlots = ArchivistPrepGetSlotCount(oPC, nCircle);
        json jButton = NuiId(
            NuiButtonImage(JsonString(GetSpellLevelIcon(nCircle))),
            PRC_ARCHIVIST_PREP_CIRCLE_BUTTON + IntToString(nCircle)
        );
        jButton = NuiWidth(jButton, 40.0f);
        jButton = NuiHeight(jButton, 40.0f);
        jButton = NuiMargin(jButton, 1.0f);
        jButton = NuiTooltip(jButton, JsonString(
            GetSpellLevelToolTip(nCircle) + " - " + IntToString(nSlots) + " preparation slots"
        ));

        if (nSlots <= 0)
            jButton = NuiEnabled(jButton, JsonBool(FALSE));
        else if (nSelected != nCircle)
            jButton = GreyOutButton(jButton, 40.0f, 40.0f);

        jChildren = JsonArrayInsert(jChildren, jButton);
    }

    json jRow = NuiRow(jChildren);
    jRow = NuiHeight(jRow, 44.0f);
    return jRow;
}

json APCreateMetamagicButtons(object oPC, int nCircle)
{
    json jChildren = JsonArray();
    jChildren = JsonArrayInsert(jChildren,
        NuiWidth(NuiLabel(JsonString("Prepare as:"), JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)), 78.0f));

    int nSelected = GetLocalInt(oPC, PRC_ARCHIVIST_PREP_METAMAGIC_VAR);
    int nMeta;
    for (nMeta = 0; nMeta < 0x40; nMeta = nMeta ? (nMeta << 1) : 1)
    {
        if (!APMetamagicAvailable(oPC, nCircle, nMeta))
            continue;

        string sName = nMeta == METAMAGIC_NONE ? "Normal" : GetMetaMagicString(nMeta);
        json jButton = NuiId(
            NuiButton(JsonString(sName)),
            PRC_ARCHIVIST_PREP_META_BUTTON + IntToString(nMeta)
        );
        jButton = NuiWidth(jButton, 84.0f);
        jButton = NuiHeight(jButton, 30.0f);
        jButton = NuiMargin(jButton, 1.0f);
        if (nSelected == nMeta)
            jButton = NuiEncouraged(jButton, JsonBool(TRUE));
        jChildren = JsonArrayInsert(jChildren, jButton);
    }

    json jRow = NuiRow(jChildren);
    jRow = NuiHeight(jRow, 34.0f);
    return jRow;
}

json APCreateSpellButton(int nSpellbookRow, string sId, string sSuffix, float fWidth)
{
    int nFeat = StringToInt(Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "FeatID", nSpellbookRow));
    int nSpell = StringToInt(Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "SpellID", nSpellbookRow));
    string sName = ArchivistPrepSpellName(nSpellbookRow) + sSuffix;

    json jButton = NuiId(NuiButton(JsonString("")), sId);
    json jDraw = JsonArray();
    jDraw = JsonArrayInsert(jDraw, NuiDrawListImage(
        JsonBool(TRUE),
        GetSpellIcon(nSpell, nFeat, CLASS_TYPE_ARCHIVIST),
        NuiRect(4.0f, 4.0f, 30.0f, 30.0f),
        JsonInt(NUI_ASPECT_FIT),
        JsonInt(NUI_HALIGN_CENTER),
        JsonInt(NUI_VALIGN_MIDDLE),
        NUI_DRAW_LIST_ITEM_ORDER_AFTER
    ));
    jDraw = JsonArrayInsert(jDraw, NuiDrawListText(
        JsonBool(TRUE),
        NuiColor(255, 255, 255),
        NuiRect(40.0f, 9.0f, fWidth - 45.0f, 24.0f),
        JsonString(sName)
    ));
    jButton = NuiDrawList(jButton, JsonBool(FALSE), jDraw);
    jButton = NuiWidth(jButton, fWidth);
    jButton = NuiHeight(jButton, 38.0f);
    jButton = NuiMargin(jButton, 1.0f);
    return jButton;
}

void APBuildKnownListData(object oPC, int nCircle, int nMetamagic)
{
    json jRows = JsonArray();
    json jNames = JsonArray();
    string sFilter = GetStringLowerCase(GetLocalString(oPC, PRC_ARCHIVIST_PREP_FILTER_VAR));
    int nSourceCircle = nCircle - GetMetaMagicSpellLevelAdjustment(nMetamagic);

    if (nSourceCircle >= 0)
    {
        string sKnown = ArchivistPrepKnownArrayName(nSourceCircle);
        int nKnown = persistant_array_get_size(oPC, sKnown);
        int i;
        for (i = 0; i < nKnown; i++)
        {
            int nBaseRow = persistant_array_get_int(oPC, sKnown, i);
            string sBaseLevel = Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "Level", nBaseRow);
            int nBaseReqFeat = StringToInt(Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "ReqFeat", nBaseRow));
            if (sBaseLevel == "" || sBaseLevel == "****"
                || StringToInt(sBaseLevel) != nSourceCircle || nBaseReqFeat != 0)
                continue;

            int nRow = ArchivistPrepFindVariant(nBaseRow, nMetamagic);
            if (!nRow
                || StringToInt(Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "Level", nRow)) != nCircle)
                continue;

            string sName = ArchivistPrepSpellName(nRow);
            if (sFilter != "" && FindSubString(GetStringLowerCase(sName), sFilter) < 0)
                continue;

            jRows = JsonArrayInsert(jRows, JsonInt(nRow));
            jNames = JsonArrayInsert(jNames, JsonString(sName));
        }
    }

    SetLocalJson(oPC, PRC_ARCHIVIST_PREP_KNOWN_MAP_VAR, jRows);
    SetLocalJson(oPC, PRC_ARCHIVIST_PREP_KNOWN_NAMES_VAR, jNames);
}

json APCreateKnownPanel(object oPC, int nCircle, int nMetamagic)
{
    APBuildKnownListData(oPC, nCircle, nMetamagic);

    json jChildren = JsonArray();
    jChildren = JsonArrayInsert(jChildren, APHeader("Known Divine Spells"));

    json jSearch = JsonArray();
    json jEdit = NuiTextEdit(
        JsonString("Search known spells"),
        NuiBind(PRC_ARCHIVIST_PREP_FILTER_BIND),
        64,
        FALSE
    );
    jEdit = NuiWidth(jEdit, 292.0f);
    jEdit = NuiHeight(jEdit, 32.0f);
    jSearch = JsonArrayInsert(jSearch, jEdit);
    json jSearchButton = NuiId(
        NuiButton(JsonString("Search")),
        PRC_ARCHIVIST_PREP_FILTER_BUTTON
    );
    jSearchButton = NuiWidth(jSearchButton, 82.0f);
    jSearchButton = NuiHeight(jSearchButton, 32.0f);
    jSearch = JsonArrayInsert(jSearch, jSearchButton);
    jChildren = JsonArrayInsert(jChildren, NuiRow(jSearch));

    // One template cell is one spell. Keeping the complete entry in a single
    // full-width button prevents the client from presenting the icon and name
    // columns as two independently indexed spell entries.
    json jTemplate = JsonArray();
    json jNameButton = NuiId(
        NuiButton(NuiBind(PRC_ARCHIVIST_PREP_KNOWN_NAMES_BIND)),
        PRC_ARCHIVIST_PREP_KNOWN_LIST_BTN
    );
    jNameButton = NuiTooltip(jNameButton, JsonString(
        "Left-click to prepare one copy. Right-click for the spell description."
    ));
    jTemplate = JsonArrayInsert(jTemplate, NuiListTemplateCell(jNameButton, 0.0f, TRUE));

    json jList = NuiList(
        jTemplate,
        NuiBind(PRC_ARCHIVIST_PREP_KNOWN_COUNT_BIND),
        38.0f,
        TRUE,
        NUI_SCROLLBARS_Y
    );
    jList = NuiHeight(jList, 326.0f);
    jChildren = JsonArrayInsert(jChildren, jList);

    json jCol = NuiCol(jChildren);
    json jGroup = NuiGroup(jCol, TRUE, NUI_SCROLLBARS_NONE);
    jGroup = NuiWidth(jGroup, 405.0f);
    jGroup = NuiHeight(jGroup, 406.0f);
    return jGroup;
}

json APCreatePlanPanel(object oPC, int nCircle)
{
    json jChildren = JsonArray();
    int nSlots = ArchivistPrepGetSlotCount(oPC, nCircle);
    int nFilled = ArchivistPrepDraftFilled(oPC, nCircle);
    jChildren = JsonArrayInsert(jChildren,
        APHeader("Prepared Next Rest - " + IntToString(nFilled) + "/" + IntToString(nSlots)));

    json jCircle = ArchivistPrepGetDraftCircle(oPC, nCircle);
    json jSeen = JsonObject();
    int nRows;
    int i;
    for (i = 0; i < JsonGetLength(jCircle); i++)
    {
        int nRow = JsonGetInt(JsonArrayGet(jCircle, i));
        if (nRow <= 0 || JsonObjectGet(jSeen, IntToString(nRow)) != JsonNull())
            continue;
        jSeen = JsonObjectSet(jSeen, IntToString(nRow), JsonBool(TRUE));

        int nCount = ArchivistPrepDraftCountRow(oPC, nCircle, nRow);
        json jRowChildren = JsonArray();
        json jSpell = APCreateSpellButton(
            nRow,
            PRC_ARCHIVIST_PREP_PLAN_BUTTON + IntToString(nRow),
            "  x" + IntToString(nCount),
            292.0f
        );
        jSpell = NuiTooltip(jSpell, JsonString("Right-click for the spell description."));
        jRowChildren = JsonArrayInsert(jRowChildren, jSpell);

        json jMinus = NuiId(
            NuiButton(JsonString("-")),
            PRC_ARCHIVIST_PREP_REMOVE_BUTTON + IntToString(nRow)
        );
        jMinus = NuiWidth(jMinus, 34.0f);
        jMinus = NuiHeight(jMinus, 38.0f);
        jMinus = NuiTooltip(jMinus, JsonString("Remove one prepared copy."));
        jRowChildren = JsonArrayInsert(jRowChildren, jMinus);

        json jPlus = NuiId(
            NuiButton(JsonString("+")),
            PRC_ARCHIVIST_PREP_KNOWN_BUTTON + IntToString(nRow)
        );
        jPlus = NuiWidth(jPlus, 34.0f);
        jPlus = NuiHeight(jPlus, 38.0f);
        jPlus = NuiEnabled(jPlus, JsonBool(nFilled < nSlots));
        jPlus = NuiTooltip(jPlus, JsonString("Prepare another copy."));
        jRowChildren = JsonArrayInsert(jRowChildren, jPlus);

        jChildren = JsonArrayInsert(jChildren, NuiRow(jRowChildren));
        nRows++;
    }

    if (!nRows)
        jChildren = JsonArrayInsert(jChildren, APMessage("No spells selected for this circle.", 42.0f));

    jChildren = JsonArrayInsert(jChildren, APMessage(
        "Empty slots: " + IntToString(nSlots - nFilled),
        28.0f
    ));

    json jClear = NuiId(NuiButton(JsonString("Clear Circle")), PRC_ARCHIVIST_PREP_CLEAR_BUTTON);
    jClear = NuiWidth(jClear, 120.0f);
    jClear = NuiHeight(jClear, 30.0f);
    jClear = NuiEnabled(jClear, JsonBool(nFilled > 0));
    jChildren = JsonArrayInsert(jChildren, jClear);

    json jCol = NuiCol(jChildren);
    json jGroup = NuiGroup(jCol, TRUE, NUI_SCROLLBARS_Y);
    jGroup = NuiWidth(jGroup, 385.0f);
    jGroup = NuiHeight(jGroup, 282.0f);
    return jGroup;
}

json APCreateReadyPanel(object oPC, int nCircle)
{
    json jChildren = JsonArray();
    jChildren = JsonArrayInsert(jChildren, APHeader("Ready Now - remaining uses"));

    string sIndex = "SpellbookIDX" + IntToString(nCircle) + "_" + IntToString(CLASS_TYPE_ARCHIVIST);
    string sMemory = GetSpellsMemorized_Array(CLASS_TYPE_ARCHIVIST);
    int nIndexed = persistant_array_get_size(oPC, sIndex);
    int nShown;
    int i;
    for (i = 0; i < nIndexed; i++)
    {
        int nRow = persistant_array_get_int(oPC, sIndex, i);
        if (nRow <= 0)
            continue;

        int nRemaining = persistant_array_get_int(oPC, sMemory, nRow);
        json jLabel = NuiLabel(
            JsonString(ArchivistPrepSpellName(nRow) + ": " + IntToString(nRemaining)),
            JsonInt(NUI_HALIGN_LEFT),
            JsonInt(NUI_VALIGN_MIDDLE)
        );
        jLabel = NuiHeight(jLabel, 24.0f);
        if (nRemaining <= 0)
            jLabel = NuiStyleForegroundColor(jLabel, NuiColor(135, 135, 135));
        jChildren = JsonArrayInsert(jChildren, jLabel);
        nShown++;
    }

    if (!nShown)
        jChildren = JsonArrayInsert(jChildren, APMessage("Nothing from this circle is currently ready.", 36.0f));

    json jCol = NuiCol(jChildren);
    json jGroup = NuiGroup(jCol, TRUE, NUI_SCROLLBARS_Y);
    jGroup = NuiWidth(jGroup, 385.0f);
    jGroup = NuiHeight(jGroup, 120.0f);
    return jGroup;
}

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC) || GetLevelByClass(CLASS_TYPE_ARCHIVIST, oPC) <= 0)
    {
        ArchivistPrepDiscardDraft(oPC);
        SendMessageToPC(oPC, "Only an Archivist can open the Archivist preparation window.");
        return;
    }

    int nPrevious = NuiFindWindow(oPC, PRC_ARCHIVIST_PREP_NUI_WINDOW_ID);
    if (nPrevious)
    {
        json jGeometry = NuiGetBind(oPC, nPrevious, "geometry");
        if (jGeometry != JsonNull())
            SetLocalJson(oPC, PRC_ARCHIVIST_PREP_GEOMETRY_VAR, jGeometry);
        SetLocalInt(oPC, PRC_ARCHIVIST_PREP_REBUILD_TOKEN_VAR, nPrevious);
        NuiDestroy(oPC, nPrevious);
    }

    if (!GetLocalInt(oPC, PRC_ARCHIVIST_PREP_ACTIVE_VAR)
        || JsonGetType(GetLocalJson(oPC, PRC_ARCHIVIST_PREP_DRAFT_VAR)) != JSON_TYPE_OBJECT)
    {
        if (!ArchivistPrepInitializeDraft(oPC))
            return;
    }

    int nCircle = GetLocalInt(oPC, PRC_ARCHIVIST_PREP_CIRCLE_VAR);
    if (nCircle < 0 || nCircle > 9)
    {
        nCircle = 0;
        SetLocalInt(oPC, PRC_ARCHIVIST_PREP_CIRCLE_VAR, nCircle);
    }

    int nMetamagic = GetLocalInt(oPC, PRC_ARCHIVIST_PREP_METAMAGIC_VAR);
    if (!APMetamagicAvailable(oPC, nCircle, nMetamagic))
    {
        nMetamagic = METAMAGIC_NONE;
        DeleteLocalInt(oPC, PRC_ARCHIVIST_PREP_METAMAGIC_VAR);
    }

    // 1920x1080 is the baseline layout. Device dimensions are physical GUI
    // pixels, so convert them back to logical NUI units before capping the
    // window. Larger displays keep the comfortable 830x615 layout; smaller
    // effective viewports shrink the flexible middle rather than losing the
    // Save/Cancel footer beyond the bottom edge.
    float fWindowWidth = 830.0f;
    float fWindowHeight = 615.0f;
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

    json jRootChildren = JsonArray();
    jRootChildren = JsonArrayInsert(jRootChildren, APCreateCircleButtons(oPC));

    int nInt = GetAbilityScore(oPC, ABILITY_INTELLIGENCE);
    int nWis = GetAbilityScore(oPC, ABILITY_WISDOM);
    json jRules = APMessage(
        "INT " + IntToString(nInt) + " unlocks spell circles. WIS " + IntToString(nWis)
        + " grants Archivist bonus slots. Changes apply only after your next completed rest.",
        45.0f
    );
    jRules = NuiTooltip(jRules, JsonString(
        "Saving changes the next-rest preparation plan only. It never refills or changes spells that are ready now."
    ));
    jRootChildren = JsonArrayInsert(jRootChildren, jRules);
    jRootChildren = JsonArrayInsert(jRootChildren, APCreateMetamagicButtons(oPC, nCircle));

    json jPanels = JsonArray();
    jPanels = JsonArrayInsert(jPanels, APCreateKnownPanel(oPC, nCircle, nMetamagic));

    json jRight = JsonArray();
    jRight = JsonArrayInsert(jRight, APCreatePlanPanel(oPC, nCircle));
    jRight = JsonArrayInsert(jRight, APCreateReadyPanel(oPC, nCircle));
    jPanels = JsonArrayInsert(jPanels, NuiCol(jRight));

    // The preparation panels are the flexible middle of the window. Keeping
    // them inside an unheighted scrollable group lets this region shrink at
    // higher UI scales while the action footer below remains permanently
    // visible. The spell-description NUI uses the same fixed-footer pattern.
    json jPanelBody = NuiGroup(NuiRow(jPanels), FALSE, NUI_SCROLLBARS_AUTO);
    // NuiGroup does not advertise its content width to its parent. Give the
    // flexible body the window's inner width so both panels—and the footer
    // spacer—lay out across the complete window at the 1920x1080 baseline.
    jPanelBody = NuiWidth(jPanelBody, fWindowWidth - 16.0f);
    jRootChildren = JsonArrayInsert(jRootChildren, jPanelBody);

    json jBottom = JsonArray();
    json jCancel = NuiId(NuiButton(JsonString("Cancel")), PRC_ARCHIVIST_PREP_CANCEL_BUTTON);
    jCancel = NuiWidth(jCancel, 110.0f);
    jCancel = NuiHeight(jCancel, 34.0f);
    jBottom = JsonArrayInsert(jBottom, jCancel);
    jBottom = JsonArrayInsert(jBottom, NuiSpacer());
    json jSave = NuiId(NuiButton(JsonString("Save for Next Rest")), PRC_ARCHIVIST_PREP_SAVE_BUTTON);
    jSave = NuiWidth(jSave, 180.0f);
    jSave = NuiHeight(jSave, 34.0f);
    jSave = NuiEncouraged(jSave, JsonBool(TRUE));
    jBottom = JsonArrayInsert(jBottom, jSave);
    jRootChildren = JsonArrayInsert(jRootChildren, NuiRow(jBottom));

    json jRoot = NuiCol(jRootChildren);

    json jSizeConstraint = NuiRect(
        fWindowWidth, fWindowHeight, fWindowWidth, fWindowHeight
    );
    json jEdgeConstraint = NuiRect(8.0f, 8.0f, 8.0f, 48.0f);
    json jWindow = NuiWindow(
        jRoot,
        JsonString("PRC8 Archivist Preparation"),
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

    int nToken = NuiCreate(oPC, jWindow, PRC_ARCHIVIST_PREP_NUI_WINDOW_ID);
    if (!nToken)
    {
        ArchivistPrepDiscardDraft(oPC, FALSE);
        return;
    }

    json jGeometry = GetLocalJson(oPC, PRC_ARCHIVIST_PREP_GEOMETRY_VAR);
    float fWindowX = -1.0f;
    float fWindowY = -1.0f;
    if (jGeometry != JsonNull())
    {
        fWindowX = JsonGetFloat(JsonObjectGet(jGeometry, "x"));
        fWindowY = JsonGetFloat(JsonObjectGet(jGeometry, "y"));
    }
    jGeometry = NuiRect(
        fWindowX, fWindowY, fWindowWidth, fWindowHeight
    );

    NuiSetBind(oPC, nToken, "geometry", jGeometry);
    NuiSetBind(oPC, nToken, "resizable", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPC, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "border", JsonBool(TRUE));
    json jKnownRows = GetLocalJson(oPC, PRC_ARCHIVIST_PREP_KNOWN_MAP_VAR);
    NuiSetBind(oPC, nToken, PRC_ARCHIVIST_PREP_FILTER_BIND,
        JsonString(GetLocalString(oPC, PRC_ARCHIVIST_PREP_FILTER_VAR)));
    NuiSetBind(oPC, nToken, PRC_ARCHIVIST_PREP_KNOWN_NAMES_BIND,
        GetLocalJson(oPC, PRC_ARCHIVIST_PREP_KNOWN_NAMES_VAR));
    NuiSetBind(oPC, nToken, PRC_ARCHIVIST_PREP_KNOWN_COUNT_BIND,
        JsonInt(JsonGetLength(jKnownRows)));
    NuiSetBindWatch(oPC, nToken, "geometry", TRUE);
}
