//::///////////////////////////////////////////////
//:: PRC Binder pact-management NUI view
//:: prc_nui_bnd_view
//:://////////////////////////////////////////////

#include "prc_nui_bnd_inc"

json BNDHeader(string sText)
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

json BNDText(string sText, float fHeight, int nScrollbars = NUI_SCROLLBARS_NONE)
{
    json jText = NuiText(JsonString(sText), FALSE, nScrollbars);
    jText = NuiHeight(jText, fHeight);
    return jText;
}

json BNDCreateList(string sNamesBind, string sCountBind, string sElement, float fHeight, string sTooltip)
{
    json jTemplate = JsonArray();
    json jButton = NuiId(NuiButton(NuiBind(sNamesBind)), sElement);
    jButton = NuiTooltip(jButton, JsonString(sTooltip));
    jTemplate = JsonArrayInsert(jTemplate, NuiListTemplateCell(jButton, 0.0f, TRUE));
    json jList = NuiList(
        jTemplate,
        NuiBind(sCountBind),
        38.0f,
        TRUE,
        NUI_SCROLLBARS_Y
    );
    return NuiHeight(jList, fHeight);
}

json BNDCreateHome(object oPC)
{
    int nBound = GetBindCount(oPC);
    int nMax = GetMaxVestigeCount(oPC);
    int nLevel = GetMaxVestigeLevel(oPC);
    string sStatus = "Effective Binder level " + IntToString(GetBinderLevel(oPC))
        + " | Vestige level up to " + IntToString(nLevel)
        + " | Bound " + IntToString(nBound) + "/" + IntToString(nMax);
    if (GetHasFeat(FEAT_EXPEL_VESTIGE, oPC))
        sStatus += " | Expel Vestige uses "
            + IntToString(GetFeatRemainingUses(FEAT_EXPEL_VESTIGE, oPC));
    else
        sStatus += " | Expel Vestige feat not known";

    json jRoot = JsonArray();
    jRoot = JsonArrayInsert(jRoot, BNDText(sStatus, 42.0f));

    json jPanels = JsonArray();
    json jBind = JsonArray();
    jBind = JsonArrayInsert(jBind, BNDHeader("Available Vestiges"));
    if (nBound >= nMax)
        jBind = JsonArrayInsert(jBind, BNDText(
            "You have bound the maximum number of vestiges allowed.", 44.0f
        ));
    jBind = JsonArrayInsert(jBind, BNDCreateList(
        PRC_BINDER_NUI_BIND_NAMES_BIND,
        PRC_BINDER_NUI_BIND_COUNT_BIND,
        PRC_BINDER_NUI_HOME_BIND_LIST,
        410.0f,
        "Left-click to configure this pact. Right-click to read its description."
    ));
    json jBindGroup = NuiGroup(NuiCol(jBind), TRUE, NUI_SCROLLBARS_NONE);
    jBindGroup = NuiWidth(jBindGroup, 370.0f);
    jPanels = JsonArrayInsert(jPanels, jBindGroup);

    json jBound = JsonArray();
    jBound = JsonArrayInsert(jBound, BNDHeader("Currently Bound"));
    jBound = JsonArrayInsert(jBound, BNDCreateList(
        PRC_BINDER_NUI_BOUND_NAMES_BIND,
        PRC_BINDER_NUI_BOUND_COUNT_BIND,
        PRC_BINDER_NUI_HOME_BOUND_LIST,
        410.0f,
        "Left-click to prepare Expel Vestige. Right-click to read the description."
    ));
    json jBoundGroup = NuiGroup(NuiCol(jBound), TRUE, NUI_SCROLLBARS_NONE);
    jBoundGroup = NuiWidth(jBoundGroup, 370.0f);
    jPanels = JsonArrayInsert(jPanels, jBoundGroup);
    jRoot = JsonArrayInsert(jRoot, NuiRow(jPanels));

    json jBottom = JsonArray();
    jBottom = JsonArrayInsert(jBottom, NuiSpacer());
    json jClose = NuiId(NuiButton(JsonString("Close")), PRC_BINDER_NUI_CLOSE_BUTTON);
    jClose = NuiWidth(jClose, 110.0f);
    jClose = NuiHeight(jClose, 34.0f);
    jBottom = JsonArrayInsert(jBottom, jClose);
    jRoot = JsonArrayInsert(jRoot, NuiRow(jBottom));
    return NuiCol(jRoot);
}

string BNDStageHeading(object oPC, int nStage)
{
    int nRow = GetLocalInt(oPC, PRC_BINDER_NUI_SELECTED_ROW_VAR);
    string sName = BinderNUIVestigeName(nRow);
    if (nStage == PRC_BINDER_NUI_STAGE_EXPLOIT)
        return "Exploit Vestige - " + sName;
    if (nStage == PRC_BINDER_NUI_STAGE_METHOD)
        return "Binding Method - " + sName;
    if (nStage == PRC_BINDER_NUI_STAGE_AUGMENT)
        return "Pact Augmentation - " + sName;
    if (nStage == PRC_BINDER_NUI_STAGE_NABERIUS)
        return "Naberius's Skills";
    if (nStage == PRC_BINDER_NUI_STAGE_ASTAROTH)
        return "Astaroth's Master Craftsman";
    if (nStage == PRC_BINDER_NUI_STAGE_BIND_CONFIRM)
        return "Confirm Pact - " + sName;
    if (nStage == PRC_BINDER_NUI_STAGE_EXPEL_CONFIRM)
        return "Confirm Expulsion - " + sName;
    if (nStage == PRC_BINDER_NUI_STAGE_EXPLOIT_SPELL)
        return "Exploit Vestige Bonus Spell";
    return "Binder Pacts";
}

string BNDStageInstructions(object oPC, int nStage)
{
    if (nStage == PRC_BINDER_NUI_STAGE_EXPLOIT)
        return "Choose one granted ability to forgo. Exploiting the vestige imposes a -5 penalty on the binding check. Choose None to keep every ability.";
    if (nStage == PRC_BINDER_NUI_STAGE_METHOD)
        return BinderNUIVestigeDescription(GetLocalInt(oPC, PRC_BINDER_NUI_SELECTED_ROW_VAR));
    if (nStage == PRC_BINDER_NUI_STAGE_AUGMENT)
        return "Choose exactly " + IntToString(GetPactAugmentCount(oPC))
            + " benefits. A benefit may be chosen more than once and stacks. Selected "
            + IntToString(BinderNUIAugmentTotal(oPC)) + "/"
            + IntToString(GetPactAugmentCount(oPC)) + ".\n\nCurrent: "
            + BinderNUIAugmentSummary(oPC);
    if (nStage == PRC_BINDER_NUI_STAGE_NABERIUS)
    {
        json jNab = GetLocalJson(oPC, PRC_BINDER_NUI_NABERIUS_VAR);
        int nSelected;
        if (JsonGetType(jNab) == JSON_TYPE_ARRAY)
            nSelected = JsonGetLength(jNab);
        int nTarget = GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
        return "Choose exactly " + IntToString(nTarget)
            + " unranked skills that can be used untrained. Selected "
            + IntToString(nSelected) + "/" + IntToString(nTarget)
            + ".\n\nCurrent: " + BinderNUINaberiusSummary(oPC);
    }
    if (nStage == PRC_BINDER_NUI_STAGE_ASTAROTH)
        return "Choose one item-creation feat allowed by your effective Binder level. It lasts while this Astaroth pact is active, up to 24 hours.";
    if (nStage == PRC_BINDER_NUI_STAGE_BIND_CONFIRM)
        return BinderNUIBindingSummary(oPC)
            + "\n\nBeginning the pact starts the normal contact and binding timers. Entering combat interrupts the ritual.";
    if (nStage == PRC_BINDER_NUI_STAGE_EXPEL_CONFIRM)
        return BinderNUIVestigeDescription(GetLocalInt(oPC, PRC_BINDER_NUI_SELECTED_ROW_VAR))
            + "\n\nExpel Vestige is spent when the ritual starts. The normal binding check and post-expulsion penalties apply.";
    if (nStage == PRC_BINDER_NUI_STAGE_EXPLOIT_SPELL)
        return "The pact was good. Choose one arcane spell of the highest level you can cast. This selection completes Exploit Vestige and cannot be cancelled.";
    return "";
}

int BNDStageHasChoiceList(int nStage)
{
    return nStage == PRC_BINDER_NUI_STAGE_EXPLOIT
        || nStage == PRC_BINDER_NUI_STAGE_METHOD
        || nStage == PRC_BINDER_NUI_STAGE_AUGMENT
        || nStage == PRC_BINDER_NUI_STAGE_NABERIUS
        || nStage == PRC_BINDER_NUI_STAGE_ASTAROTH
        || nStage == PRC_BINDER_NUI_STAGE_EXPLOIT_SPELL;
}

json BNDCreateStage(object oPC, int nStage)
{
    json jRoot = JsonArray();
    jRoot = JsonArrayInsert(jRoot, BNDHeader(BNDStageHeading(oPC, nStage)));
    float fTextHeight = 125.0f;
    if (nStage == PRC_BINDER_NUI_STAGE_METHOD
        || nStage == PRC_BINDER_NUI_STAGE_EXPEL_CONFIRM)
        fTextHeight = 220.0f;
    jRoot = JsonArrayInsert(jRoot, BNDText(
        BNDStageInstructions(oPC, nStage), fTextHeight, NUI_SCROLLBARS_Y
    ));

    if (BNDStageHasChoiceList(nStage))
    {
        jRoot = JsonArrayInsert(jRoot, BNDCreateList(
            PRC_BINDER_NUI_CHOICE_NAMES_BIND,
            PRC_BINDER_NUI_CHOICE_COUNT_BIND,
            PRC_BINDER_NUI_CHOICE_LIST,
            330.0f,
            "Select this choice."
        ));
    }
    else
        jRoot = JsonArrayInsert(jRoot, NuiSpacer());

    json jBottom = JsonArray();
    if (nStage != PRC_BINDER_NUI_STAGE_EXPLOIT_SPELL)
    {
        json jCancel = NuiId(
            NuiButton(JsonString("Cancel Pact")),
            PRC_BINDER_NUI_CANCEL_BUTTON
        );
        jCancel = NuiWidth(jCancel, 120.0f);
        jCancel = NuiHeight(jCancel, 34.0f);
        jBottom = JsonArrayInsert(jBottom, jCancel);
    }

    if (nStage == PRC_BINDER_NUI_STAGE_AUGMENT
        || nStage == PRC_BINDER_NUI_STAGE_NABERIUS)
    {
        json jReset = NuiId(
            NuiButton(JsonString("Reset Choices")),
            PRC_BINDER_NUI_RESET_BUTTON
        );
        jReset = NuiWidth(jReset, 130.0f);
        jReset = NuiHeight(jReset, 34.0f);
        jBottom = JsonArrayInsert(jBottom, jReset);
    }

    jBottom = JsonArrayInsert(jBottom, NuiSpacer());
    if (nStage == PRC_BINDER_NUI_STAGE_AUGMENT
        || nStage == PRC_BINDER_NUI_STAGE_NABERIUS
        || nStage == PRC_BINDER_NUI_STAGE_BIND_CONFIRM
        || nStage == PRC_BINDER_NUI_STAGE_EXPEL_CONFIRM)
    {
        string sLabel = "Continue";
        int bEnabled = TRUE;
        if (nStage == PRC_BINDER_NUI_STAGE_AUGMENT)
            bEnabled = BinderNUIAugmentTotal(oPC) == GetPactAugmentCount(oPC);
        else if (nStage == PRC_BINDER_NUI_STAGE_NABERIUS)
        {
            json jNab = GetLocalJson(oPC, PRC_BINDER_NUI_NABERIUS_VAR);
            bEnabled = JsonGetType(jNab) == JSON_TYPE_ARRAY
                && JsonGetLength(jNab) == GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
        }
        else if (nStage == PRC_BINDER_NUI_STAGE_BIND_CONFIRM)
            sLabel = "Begin Pact";
        else if (nStage == PRC_BINDER_NUI_STAGE_EXPEL_CONFIRM)
            sLabel = "Begin Expulsion";

        json jContinue = NuiId(
            NuiButton(JsonString(sLabel)),
            PRC_BINDER_NUI_CONTINUE_BUTTON
        );
        jContinue = NuiWidth(jContinue, 155.0f);
        jContinue = NuiHeight(jContinue, 34.0f);
        jContinue = NuiEnabled(jContinue, JsonBool(bEnabled));
        jContinue = NuiEncouraged(jContinue, JsonBool(bEnabled));
        jBottom = JsonArrayInsert(jBottom, jContinue);
    }
    jRoot = JsonArrayInsert(jRoot, NuiRow(jBottom));
    return NuiCol(jRoot);
}

void main()
{
    object oPC = OBJECT_SELF;
    int nStage = GetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR);
    if (!GetIsPC(oPC) || !GetLocalInt(oPC, PRC_BINDER_NUI_ACTIVE_VAR)
        || (!BinderNUIHasAccess(oPC)
            && nStage != PRC_BINDER_NUI_STAGE_EXPLOIT_SPELL))
    {
        BinderNUIDiscardDraft(oPC);
        return;
    }

    int nPrevious = NuiFindWindow(oPC, PRC_BINDER_NUI_WINDOW_ID);
    if (nPrevious)
    {
        json jPreviousGeometry = NuiGetBind(oPC, nPrevious, "geometry");
        if (jPreviousGeometry != JsonNull())
            SetLocalJson(oPC, PRC_BINDER_NUI_GEOMETRY_VAR, jPreviousGeometry);
        SetLocalInt(oPC, PRC_BINDER_NUI_REBUILD_TOKEN_VAR, nPrevious);
        NuiDestroy(oPC, nPrevious);
    }

    if (nStage == PRC_BINDER_NUI_STAGE_HOME
        && JsonGetType(GetLocalJson(oPC, PRC_BINDER_NUI_HOME_BIND_MAP_VAR))
            != JSON_TYPE_ARRAY)
        BinderNUIBuildHomeMaps(oPC);

    int nViewGeneration = GetLocalInt(oPC, PRC_BINDER_NUI_VIEW_GEN_VAR) + 1;
    SetLocalInt(oPC, PRC_BINDER_NUI_VIEW_GEN_VAR, nViewGeneration);
    SetLocalInt(oPC, PRC_BINDER_NUI_MAP_GEN_VAR, nViewGeneration);

    float fWidth = 780.0f;
    float fHeight = 640.0f;
    int nGuiWidth = GetPlayerDeviceProperty(oPC, PLAYER_DEVICE_PROPERTY_GUI_WIDTH);
    int nGuiHeight = GetPlayerDeviceProperty(oPC, PLAYER_DEVICE_PROPERTY_GUI_HEIGHT);
    int nGuiScale = GetPlayerDeviceProperty(oPC, PLAYER_DEVICE_PROPERTY_GUI_SCALE);
    if (nGuiWidth > 0 && nGuiHeight > 0 && nGuiScale > 0)
    {
        float fScale = IntToFloat(nGuiScale) / 100.0f;
        float fAvailableWidth = IntToFloat(nGuiWidth) / fScale;
        float fAvailableHeight = IntToFloat(nGuiHeight) / fScale;
        if (fWidth > fAvailableWidth - 24.0f)
            fWidth = fAvailableWidth - 24.0f;
        if (fHeight > fAvailableHeight - 64.0f)
            fHeight = fAvailableHeight - 64.0f;
    }

    json jRoot;
    if (nStage == PRC_BINDER_NUI_STAGE_HOME)
        jRoot = BNDCreateHome(oPC);
    else
        jRoot = BNDCreateStage(oPC, nStage);

    // The stage layouts intentionally retain their full-height text, lists,
    // and action rows.  Constrain that content to the scaled client area and
    // let the outer group own overflow so Continue/Begin buttons remain
    // reachable on high-GUI-scale or short displays.
    jRoot = NuiGroup(jRoot, FALSE, NUI_SCROLLBARS_AUTO);
    jRoot = NuiWidth(jRoot, fWidth - 14.0f);
    jRoot = NuiHeight(jRoot, fHeight - 50.0f);

    json jWindow = NuiWindow(
        jRoot,
        JsonString("PRC8 Binder Pacts"),
        NuiBind("geometry"),
        NuiBind("resizable"),
        NuiBind("collapsed"),
        NuiBind("closable"),
        NuiBind("transparent"),
        NuiBind("border"),
        JsonBool(TRUE),
        NuiRect(fWidth, fHeight, fWidth, fHeight),
        NuiRect(8.0f, 8.0f, 8.0f, 48.0f)
    );
    int nToken = NuiCreate(oPC, jWindow, PRC_BINDER_NUI_WINDOW_ID);
    if (!nToken)
    {
        if (nStage != PRC_BINDER_NUI_STAGE_EXPLOIT_SPELL)
            BinderNUIDiscardDraft(oPC, FALSE);
        return;
    }

    json jGeometry = GetLocalJson(oPC, PRC_BINDER_NUI_GEOMETRY_VAR);
    float fX = -1.0f;
    float fY = -1.0f;
    if (jGeometry != JsonNull())
    {
        fX = JsonGetFloat(JsonObjectGet(jGeometry, "x"));
        fY = JsonGetFloat(JsonObjectGet(jGeometry, "y"));
    }
    NuiSetBind(oPC, nToken, "geometry", NuiRect(fX, fY, fWidth, fHeight));
    NuiSetBind(oPC, nToken, "resizable", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "closable", JsonBool(nStage != PRC_BINDER_NUI_STAGE_EXPLOIT_SPELL));
    NuiSetBind(oPC, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "border", JsonBool(TRUE));

    json jBindMap = GetLocalJson(oPC, PRC_BINDER_NUI_HOME_BIND_MAP_VAR);
    json jBoundMap = GetLocalJson(oPC, PRC_BINDER_NUI_HOME_BOUND_MAP_VAR);
    json jChoiceMap = GetLocalJson(oPC, PRC_BINDER_NUI_CHOICE_MAP_VAR);
    NuiSetBind(oPC, nToken, PRC_BINDER_NUI_BIND_NAMES_BIND,
        GetLocalJson(oPC, PRC_BINDER_NUI_HOME_BIND_NAMES_VAR));
    NuiSetBind(oPC, nToken, PRC_BINDER_NUI_BIND_COUNT_BIND,
        JsonInt(JsonGetType(jBindMap) == JSON_TYPE_ARRAY ? JsonGetLength(jBindMap) : 0));
    NuiSetBind(oPC, nToken, PRC_BINDER_NUI_BOUND_NAMES_BIND,
        GetLocalJson(oPC, PRC_BINDER_NUI_HOME_BOUND_NAMES_VAR));
    NuiSetBind(oPC, nToken, PRC_BINDER_NUI_BOUND_COUNT_BIND,
        JsonInt(JsonGetType(jBoundMap) == JSON_TYPE_ARRAY ? JsonGetLength(jBoundMap) : 0));
    NuiSetBind(oPC, nToken, PRC_BINDER_NUI_CHOICE_NAMES_BIND,
        GetLocalJson(oPC, PRC_BINDER_NUI_CHOICE_NAMES_VAR));
    NuiSetBind(oPC, nToken, PRC_BINDER_NUI_CHOICE_COUNT_BIND,
        JsonInt(JsonGetType(jChoiceMap) == JSON_TYPE_ARRAY ? JsonGetLength(jChoiceMap) : 0));
    NuiSetBindWatch(oPC, nToken, "geometry", TRUE);
}
