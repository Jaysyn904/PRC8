//::///////////////////////////////////////////////
//:: Incarnum Blade blademeld editor view
//:: prc_nui_moi_bv
//:://////////////////////////////////////////////

#include "prc_nui_moi_bld"

json MoiBladeViewHeader(string sText)
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

json MoiBladeViewText(string sText, float fHeight)
{
    json jText = NuiText(JsonString(sText), FALSE, NUI_SCROLLBARS_NONE);
    jText = NuiHeight(jText, fHeight);
    return jText;
}

string MoiBladeUnlockText(int nChakra)
{
    int nLevel = 1;
    if (nChakra == CHAKRA_ARMS
        || nChakra == CHAKRA_BROW
        || nChakra == CHAKRA_SHOULDERS)
        nLevel = 2;
    else if (nChakra == CHAKRA_THROAT || nChakra == CHAKRA_WAIST)
        nLevel = 3;
    else if (nChakra == CHAKRA_HEART)
        nLevel = 4;
    else if (nChakra == CHAKRA_SOUL)
        nLevel = 5;
    return "Incarnum Blade level " + IntToString(nLevel) + " is required.";
}

json MoiBladeViewChakraButton(
    object oPC,
    int nChakra,
    int nFirst,
    int nSecond,
    int nGeneration
)
{
    int bUnlocked = MoiBladeChakraUnlocked(oPC, nChakra);
    int bSelected = nChakra == nFirst || nChakra == nSecond;
    string sTooltip = bUnlocked
        ? GetBlademeldDesc(nChakra)
        : MoiBladeUnlockText(nChakra);

    json jButton = NuiId(
        NuiButton(JsonString(
            MoiBladeChakraShort(nChakra) + "  "
          + MoiBladeChakraName(nChakra)
        )),
        MoiBladeStampValueId(
            PRC_MOI_BLADE_CHAKRA_BUTTON,
            nChakra,
            nGeneration
        )
    );
    jButton = NuiWidth(jButton, 106.0f);
    jButton = NuiHeight(jButton, 42.0f);
    jButton = NuiMargin(jButton, 1.0f);
    jButton = NuiTooltip(jButton, JsonString(sTooltip));
    jButton = NuiDisabledTooltip(jButton, JsonString(sTooltip));
    jButton = NuiEnabled(jButton, JsonBool(bUnlocked));
    if (bSelected)
        jButton = NuiEncouraged(jButton, JsonBool(TRUE));
    return jButton;
}

json MoiBladeViewChakraRows(
    object oPC,
    int nFirst,
    int nSecond,
    int nGeneration
)
{
    json jRows = JsonArray();
    json jRow = JsonArray();
    int nChakra;
    for (nChakra = CHAKRA_CROWN; nChakra <= CHAKRA_SOUL; nChakra++)
    {
        jRow = JsonArrayInsert(
            jRow,
            MoiBladeViewChakraButton(
                oPC,
                nChakra,
                nFirst,
                nSecond,
                nGeneration
            )
        );
        if (JsonGetLength(jRow) == 5)
        {
            jRows = JsonArrayInsert(jRows, NuiRow(jRow));
            jRow = JsonArray();
        }
    }
    if (JsonGetLength(jRow) > 0)
        jRows = JsonArrayInsert(jRows, NuiRow(jRow));
    return NuiCol(jRows);
}

string MoiBladeSelectedDetails(int nFirst, int nSecond)
{
    if (nFirst <= 0)
        return "No blademeld chakra selected.";

    string sText = MoiBladeChakraName(nFirst) + ": "
                 + GetBlademeldDesc(nFirst);
    if (nSecond > 0)
        sText += "\n\n" + MoiBladeChakraName(nSecond) + ": "
              + GetBlademeldDesc(nSecond);
    return sText;
}

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC)
        || GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oPC) <= 0
        || !GetLocalInt(oPC, PRC_MOI_BLADE_ACTIVE_VAR))
    {
        MoiBladeDiscardDraft(oPC);
        return;
    }

    int nPrevious = NuiFindWindow(oPC, PRC_MOI_BLADE_NUI_WINDOW_ID);
    if (nPrevious)
    {
        json jPreviousGeometry = NuiGetBind(oPC, nPrevious, "geometry");
        if (jPreviousGeometry != JsonNull())
            SetLocalJson(
                oPC,
                PRC_MOI_BLADE_GEOMETRY_VAR,
                jPreviousGeometry
            );
        SetLocalInt(oPC, PRC_MOI_BLADE_REBUILD_TOKEN_VAR, nPrevious);
        NuiDestroy(oPC, nPrevious);
    }

    int nGeneration = MoiBladeAdvanceGeneration(oPC);
    int nFirst = GetLocalInt(oPC, PRC_MOI_BLADE_DRAFT_FIRST_VAR);
    int nSecond = GetLocalInt(oPC, PRC_MOI_BLADE_DRAFT_SECOND_VAR);
    int nRequired = MoiBladeRequiredChoices(oPC);
    string sValidation = MoiBladeValidateChoices(oPC, nFirst, nSecond);

    string sSaved = "No saved default. Completed rest will use the original PRC picker.";
    json jSaved = MoiBladeReadSaved(oPC);
    if (jSaved != JsonNull())
    {
        string sSavedError = MoiBladeValidatePlan(oPC, jSaved);
        if (sSavedError == "")
            sSaved = "Saved rest default: " + MoiBladeChoiceSummary(
                MoiBladePlanFirst(jSaved),
                MoiBladePlanSecond(jSaved)
            ) + ".";
        else
            sSaved = "Saved rest default is no longer valid; completed rest will fall back to the original PRC picker.";
    }

    json jRoot = JsonArray();
    jRoot = JsonArrayInsert(
        jRoot,
        MoiBladeViewText(
            "Choose " + IntToString(nRequired)
          + (nRequired == 1 ? " blademeld chakra." : " different blademeld chakras."),
            30.0f
        )
    );
    jRoot = JsonArrayInsert(jRoot, MoiBladeViewText(sSaved, 42.0f));
    jRoot = JsonArrayInsert(jRoot, MoiBladeViewHeader("Blademeld Chakras"));
    jRoot = JsonArrayInsert(
        jRoot,
        MoiBladeViewChakraRows(
            oPC,
            nFirst,
            nSecond,
            nGeneration
        )
    );
    jRoot = JsonArrayInsert(
        jRoot,
        MoiBladeViewHeader(
            "Selected: " + MoiBladeChoiceSummary(nFirst, nSecond)
        )
    );
    jRoot = JsonArrayInsert(
        jRoot,
        MoiBladeViewText(MoiBladeSelectedDetails(nFirst, nSecond), 108.0f)
    );

    json jSaveRow = JsonArray();
    json jClear = NuiId(
        NuiButton(JsonString("Clear Saved Default")),
        MoiBladeStampId(PRC_MOI_BLADE_CLEAR_BUTTON, nGeneration)
    );
    jClear = NuiWidth(jClear, 170.0f);
    jClear = NuiHeight(jClear, 34.0f);
    jClear = NuiEnabled(jClear, JsonBool(MoiBladeHasSavedDefault(oPC)));
    jClear = NuiDisabledTooltip(
        jClear,
        JsonString("No blademeld rest default is saved.")
    );
    jSaveRow = JsonArrayInsert(jSaveRow, jClear);
    jSaveRow = JsonArrayInsert(jSaveRow, NuiSpacer());

    json jSave = NuiId(
        NuiButton(JsonString("Save Rest Default")),
        MoiBladeStampId(PRC_MOI_BLADE_SAVE_BUTTON, nGeneration)
    );
    jSave = NuiWidth(jSave, 170.0f);
    jSave = NuiHeight(jSave, 34.0f);
    jSave = NuiEnabled(jSave, JsonBool(sValidation == ""));
    jSave = NuiEncouraged(jSave, JsonBool(sValidation == ""));
    jSave = NuiTooltip(
        jSave,
        JsonString("Use this selection automatically after completed rests.")
    );
    jSave = NuiDisabledTooltip(jSave, JsonString(sValidation));
    jSaveRow = JsonArrayInsert(jSaveRow, jSave);
    jRoot = JsonArrayInsert(jRoot, NuiRow(jSaveRow));

    int bCanRebind = sValidation == ""
        && GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oPC) >= 3
        && GetFeatRemainingUses(FEAT_INCARNUM_BLADE_REBIND, oPC) > 0;
    string sRebindDisabled = sValidation;
    if (sRebindDisabled == ""
        && GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oPC) < 3)
        sRebindDisabled = "Rebind Blademeld is gained at Incarnum Blade level 3.";
    else if (sRebindDisabled == ""
        && GetFeatRemainingUses(FEAT_INCARNUM_BLADE_REBIND, oPC) <= 0)
        sRebindDisabled = "No Rebind Blademeld uses remain today.";

    json jActionRow = JsonArray();
    json jClose = NuiId(
        NuiButton(JsonString("Close")),
        MoiBladeStampId(PRC_MOI_BLADE_CLOSE_BUTTON, nGeneration)
    );
    jClose = NuiWidth(jClose, 110.0f);
    jClose = NuiHeight(jClose, 34.0f);
    jActionRow = JsonArrayInsert(jActionRow, jClose);
    jActionRow = JsonArrayInsert(jActionRow, NuiSpacer());

    json jRebind = NuiId(
        NuiButton(JsonString(
            "Rebind Now ("
          + IntToString(GetFeatRemainingUses(
                FEAT_INCARNUM_BLADE_REBIND,
                oPC
            ))
          + " left)"
        )),
        MoiBladeStampId(PRC_MOI_BLADE_REBIND_BUTTON, nGeneration)
    );
    jRebind = NuiWidth(jRebind, 190.0f);
    jRebind = NuiHeight(jRebind, 34.0f);
    jRebind = NuiEnabled(jRebind, JsonBool(bCanRebind));
    jRebind = NuiEncouraged(jRebind, JsonBool(bCanRebind));
    jRebind = NuiTooltip(
        jRebind,
        JsonString("Spend one Rebind Blademeld use and apply this selection now.")
    );
    jRebind = NuiDisabledTooltip(jRebind, JsonString(sRebindDisabled));
    jActionRow = JsonArrayInsert(jActionRow, jRebind);
    jRoot = JsonArrayInsert(jRoot, NuiRow(jActionRow));

    float fWindowWidth = 575.0f;
    float fWindowHeight = 425.0f;
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

    json jBody = NuiGroup(NuiCol(jRoot), FALSE, NUI_SCROLLBARS_AUTO);
    jBody = NuiWidth(jBody, fWindowWidth - 14.0f);
    // Leave title-bar and frame slack inside the exact window constraint.
    // The group owns overflow, so small/high-scale clients scroll instead of
    // producing an unsatisfied-constraint error window.
    jBody = NuiHeight(jBody, fWindowHeight - 50.0f);
    json jSizeConstraint = NuiRect(
        fWindowWidth,
        fWindowHeight,
        fWindowWidth,
        fWindowHeight
    );
    json jEdgeConstraint = NuiRect(8.0f, 8.0f, 8.0f, 48.0f);
    json jWindow = NuiWindow(
        jBody,
        JsonString("PRC8 Incarnum Blade Blademelds"),
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

    int nToken = NuiCreate(oPC, jWindow, PRC_MOI_BLADE_NUI_WINDOW_ID);
    if (!nToken)
    {
        MoiBladeDiscardDraft(oPC, FALSE);
        return;
    }

    json jGeometry = GetLocalJson(oPC, PRC_MOI_BLADE_GEOMETRY_VAR);
    float fWindowX = -1.0f;
    float fWindowY = -1.0f;
    if (jGeometry != JsonNull())
    {
        fWindowX = JsonGetFloat(JsonObjectGet(jGeometry, "x"));
        fWindowY = JsonGetFloat(JsonObjectGet(jGeometry, "y"));
    }
    NuiSetBind(
        oPC,
        nToken,
        "geometry",
        NuiRect(fWindowX, fWindowY, fWindowWidth, fWindowHeight)
    );
    NuiSetBind(oPC, nToken, "resizable", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPC, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "border", JsonBool(TRUE));
    NuiSetBindWatch(oPC, nToken, "geometry", TRUE);
}
