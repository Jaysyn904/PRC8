//::///////////////////////////////////////////////
//:: Incarnum live essentia allocation view
//:: prc_nui_moi_lv
//:://////////////////////////////////////////////

#include "prc_nui_moi_liv"

json MoiLiveViewHeader(string sText)
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

json MoiLiveViewText(string sText, float fHeight)
{
    json jText = NuiText(JsonString(sText), FALSE, NUI_SCROLLBARS_NONE);
    return NuiHeight(jText, fHeight);
}

json MoiLiveViewImage(string sIcon, float fSize)
{
    json jImage;
    if (sIcon == "")
    {
        jImage = NuiLabel(
            JsonString("?"),
            JsonInt(NUI_HALIGN_CENTER),
            JsonInt(NUI_VALIGN_MIDDLE)
        );
    }
    else
    {
        jImage = NuiImage(
            JsonString(sIcon),
            JsonInt(NUI_ASPECT_FIT),
            JsonInt(NUI_HALIGN_CENTER),
            JsonInt(NUI_VALIGN_MIDDLE)
        );
    }
    jImage = NuiWidth(jImage, fSize);
    return NuiHeight(jImage, fSize);
}

json MoiLiveViewPageTabs(int nPage, int nGeneration)
{
    json jRow = JsonArray();
    int nTab;
    for (nTab = PRC_MOI_LIVE_PAGE_MOVABLE;
         nTab <= PRC_MOI_LIVE_PAGE_SOULCASTER;
         nTab++)
    {
        string sLabel = "Movable";
        if (nTab == PRC_MOI_LIVE_PAGE_FEATS)
            sLabel = "Feats";
        else if (nTab == PRC_MOI_LIVE_PAGE_SOULCASTER)
            sLabel = "Soulcaster";
        json jButton = NuiId(
            NuiButton(JsonString(sLabel)),
            MoiLiveStampValue(PRC_MOI_LIVE_PAGE_BUTTON, nTab, nGeneration)
        );
        jButton = NuiWidth(jButton, 190.0f);
        jButton = NuiHeight(jButton, 36.0f);
        jButton = NuiMargin(jButton, 1.0f);
        if (nTab == nPage)
            jButton = NuiEncouraged(jButton, JsonBool(TRUE));
        jRow = JsonArrayInsert(jRow, jButton);
    }
    return NuiRow(jRow);
}

json MoiLiveViewMovable(object oPC, json jDraft, int nGeneration)
{
    json jChildren = JsonArray();
    jChildren = JsonArrayInsert(
        jChildren,
        MoiLiveViewHeader("Shaped soulmelds and class/racial receptacles")
    );
    jChildren = JsonArrayInsert(
        jChildren,
        MoiLiveViewText(
            "Adjust this draft, then Apply once. Applying consumes a swift action and rebuilds existing meld effects; it does not alter which soulmelds are shaped or bound.",
            48.0f
        )
    );

    if (JsonGetLength(jDraft) == 0)
    {
        jChildren = JsonArrayInsert(
            jChildren,
            MoiLiveViewText(
                "No shaped soulmeld or eligible class/racial receptacle is currently available.",
                42.0f
            )
        );
        return NuiCol(jChildren);
    }

    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        int nMeld = MoiLiveField(jEntry, "m");
        int nInvest = MoiLiveField(jEntry, "i");
        int nCapacity = MoiLiveField(jEntry, "k")
            ? MoiLiveSpecialCapacity(oPC, nMeld)
            : GetMaxEssentiaCapacity(
                oPC,
                MoiLiveField(jEntry, "c"),
                nMeld
            );

        json jRow = JsonArray();
        json jIcon = MoiLiveViewImage(MoiLiveSpellIcon(nMeld), 34.0f);
        jIcon = NuiTooltip(jIcon, JsonString(MoiLiveTextField(jEntry, "n")));
        jRow = JsonArrayInsert(jRow, jIcon);

        json jName = NuiLabel(
            JsonString(MoiLiveTextField(jEntry, "n")),
            JsonInt(NUI_HALIGN_LEFT),
            JsonInt(NUI_VALIGN_MIDDLE)
        );
        jName = NuiWidth(jName, 390.0f);
        jName = NuiHeight(jName, 36.0f);
        jRow = JsonArrayInsert(jRow, jName);

        json jAmount = NuiLabel(
            JsonString(IntToString(nInvest) + " / " + IntToString(nCapacity)),
            JsonInt(NUI_HALIGN_CENTER),
            JsonInt(NUI_VALIGN_MIDDLE)
        );
        jAmount = NuiWidth(jAmount, 72.0f);
        jAmount = NuiHeight(jAmount, 36.0f);
        jRow = JsonArrayInsert(jRow, jAmount);

        json jDown = NuiId(
            NuiButton(JsonString("-")),
            MoiLiveStampValue(
                PRC_MOI_LIVE_MOVABLE_DOWN_BUTTON,
                i,
                nGeneration
            )
        );
        jDown = NuiWidth(jDown, 44.0f);
        jDown = NuiHeight(jDown, 34.0f);
        jDown = NuiEnabled(jDown, JsonBool(nInvest > 0));
        jRow = JsonArrayInsert(jRow, jDown);

        json jUp = NuiId(
            NuiButton(JsonString("+")),
            MoiLiveStampValue(
                PRC_MOI_LIVE_MOVABLE_UP_BUTTON,
                i,
                nGeneration
            )
        );
        jUp = NuiWidth(jUp, 44.0f);
        jUp = NuiHeight(jUp, 34.0f);
        jUp = NuiEnabled(jUp, JsonBool(
            nInvest < nCapacity
            && MoiLiveMovableSum(jDraft) < MoiLiveMovableAvailable(oPC)
        ));
        jRow = JsonArrayInsert(jRow, jUp);
        jChildren = JsonArrayInsert(jChildren, NuiRow(jRow));
    }
    return NuiCol(jChildren);
}

json MoiLiveViewFeats(object oPC, int nGeneration)
{
    json jChildren = JsonArray();
    jChildren = JsonArrayInsert(jChildren, MoiLiveViewHeader(
        "Incarnum feats - locked until rest"
    ));
    jChildren = JsonArrayInsert(jChildren, MoiLiveViewText(
        "Choose an amount and Lock it once. Each lock consumes a swift action. These allocations are live only and are never stored in a saved loadout.",
        48.0f
    ));

    int nFound;
    int nFeat;
    for (nFeat = 8869; nFeat <= 8888; nFeat++)
    {
        if (!MoiLiveSafeFeat(nFeat) || !GetHasFeat(nFeat, oPC))
            continue;
        nFound++;
        int nLocked = GetEssentiaInvestedFeat(oPC, nFeat);
        int nAmount = MoiLiveGetFeatAmount(oPC, nFeat);
        int nCapacity = MoiLiveFeatCapacity(oPC, nFeat);
        int nFree = MoiLiveFreeEssentia(oPC);
        int bCanLock = !nLocked && nFree > 0;

        json jRow = JsonArray();
        json jIcon = MoiLiveViewImage(MoiLiveFeatIcon(nFeat), 34.0f);
        jIcon = NuiTooltip(jIcon, JsonString(MoiLiveFeatName(nFeat)));
        jRow = JsonArrayInsert(jRow, jIcon);

        json jName = NuiLabel(
            JsonString(MoiLiveFeatName(nFeat)),
            JsonInt(NUI_HALIGN_LEFT),
            JsonInt(NUI_VALIGN_MIDDLE)
        );
        jName = NuiWidth(jName, 310.0f);
        jName = NuiHeight(jName, 36.0f);
        jRow = JsonArrayInsert(jRow, jName);

        if (nLocked)
        {
            json jStatus = NuiLabel(
                JsonString(IntToString(nLocked) + " locked"),
                JsonInt(NUI_HALIGN_CENTER),
                JsonInt(NUI_VALIGN_MIDDLE)
            );
            jStatus = NuiWidth(jStatus, 205.0f);
            jStatus = NuiHeight(jStatus, 36.0f);
            jRow = JsonArrayInsert(jRow, jStatus);
        }
        else
        {
            json jDown = NuiId(
                NuiButton(JsonString("-")),
                MoiLiveStampValue(
                    PRC_MOI_LIVE_FEAT_DOWN_BUTTON,
                    nFeat,
                    nGeneration
                )
            );
            jDown = NuiWidth(jDown, 40.0f);
            jDown = NuiHeight(jDown, 34.0f);
            jDown = NuiEnabled(jDown, JsonBool(bCanLock && nAmount > 1));
            jRow = JsonArrayInsert(jRow, jDown);

            json jAmount = NuiLabel(
                JsonString(IntToString(nAmount) + " / " + IntToString(nCapacity)),
                JsonInt(NUI_HALIGN_CENTER),
                JsonInt(NUI_VALIGN_MIDDLE)
            );
            jAmount = NuiWidth(jAmount, 62.0f);
            jAmount = NuiHeight(jAmount, 36.0f);
            jRow = JsonArrayInsert(jRow, jAmount);

            json jUp = NuiId(
                NuiButton(JsonString("+")),
                MoiLiveStampValue(
                    PRC_MOI_LIVE_FEAT_UP_BUTTON,
                    nFeat,
                    nGeneration
                )
            );
            jUp = NuiWidth(jUp, 40.0f);
            jUp = NuiHeight(jUp, 34.0f);
            jUp = NuiEnabled(jUp, JsonBool(
                bCanLock && nAmount < nCapacity && nAmount < nFree
            ));
            jRow = JsonArrayInsert(jRow, jUp);

            json jLock = NuiId(
                NuiButton(JsonString("Lock")),
                MoiLiveStampValue(
                    PRC_MOI_LIVE_FEAT_COMMIT_BUTTON,
                    nFeat,
                    nGeneration
                )
            );
            jLock = NuiWidth(jLock, 76.0f);
            jLock = NuiHeight(jLock, 34.0f);
            jLock = NuiEnabled(jLock, JsonBool(bCanLock));
            jLock = NuiTooltip(
                jLock,
                JsonString("Lock this essentia until the next completed rest")
            );
            jRow = JsonArrayInsert(jRow, jLock);
        }
        jChildren = JsonArrayInsert(jChildren, NuiRow(jRow));
    }

    if (GetHasFeat(8884, oPC))
    {
        nFound++;
        jChildren = JsonArrayInsert(jChildren, MoiLiveViewText(
            "Midnight Augmentation: use its existing dedicated PRC action, which also chooses the power to augment.",
            42.0f
        ));
    }
    if (GetHasFeat(FEAT_AZURE_TALENT, oPC))
    {
        nFound++;
        jChildren = JsonArrayInsert(jChildren, MoiLiveViewText(
            "Azure Talent is not offered here because its current PRC investment order does not apply the selected amount correctly.",
            42.0f
        ));
    }
    if (GetHasFeat(8889, oPC))
    {
        nFound++;
        jChildren = JsonArrayInsert(jChildren, MoiLiveViewText(
            "Soultouched Spellcasting is not offered here because PRC does not yet count or clear its investment safely.",
            42.0f
        ));
    }
    if (!nFound)
        jChildren = JsonArrayInsert(jChildren, MoiLiveViewText(
            "No supported, owned Incarnum investment feats were found.",
            42.0f
        ));
    return NuiCol(jChildren);
}

json MoiLiveViewCastKind(object oPC, int nKind, int nGeneration)
{
    json jRow = JsonArray();
    if (GetPrimaryArcaneClass(oPC) != CLASS_TYPE_INVALID)
    {
        json jArcane = NuiId(
            NuiButton(JsonString("Arcane spells")),
            MoiLiveStampValue(
                PRC_MOI_LIVE_CAST_KIND_BUTTON,
                PRC_MOI_LIVE_CAST_ARCANE,
                nGeneration
            )
        );
        jArcane = NuiWidth(jArcane, 180.0f);
        jArcane = NuiHeight(jArcane, 34.0f);
        if (nKind == PRC_MOI_LIVE_CAST_ARCANE)
            jArcane = NuiEncouraged(jArcane, JsonBool(TRUE));
        jRow = JsonArrayInsert(jRow, jArcane);
    }
    if (GetPrimaryPsionicClass(oPC) != CLASS_TYPE_INVALID)
    {
        json jPsionic = NuiId(
            NuiButton(JsonString("Psionic powers")),
            MoiLiveStampValue(
                PRC_MOI_LIVE_CAST_KIND_BUTTON,
                PRC_MOI_LIVE_CAST_PSIONIC,
                nGeneration
            )
        );
        jPsionic = NuiWidth(jPsionic, 180.0f);
        jPsionic = NuiHeight(jPsionic, 34.0f);
        if (nKind == PRC_MOI_LIVE_CAST_PSIONIC)
            jPsionic = NuiEncouraged(jPsionic, JsonBool(TRUE));
        jRow = JsonArrayInsert(jRow, jPsionic);
    }
    return NuiRow(jRow);
}

json MoiLiveViewCastLevels(int nLevel, int nGeneration)
{
    json jRow = JsonArray();
    int i;
    for (i = 1; i <= 9; i++)
    {
        json jButton = NuiId(
            NuiButton(JsonString(IntToString(i))),
            MoiLiveStampValue(
                PRC_MOI_LIVE_CAST_LEVEL_BUTTON,
                i,
                nGeneration
            )
        );
        jButton = NuiWidth(jButton, 55.0f);
        jButton = NuiHeight(jButton, 34.0f);
        if (i == nLevel)
            jButton = NuiEncouraged(jButton, JsonBool(TRUE));
        jRow = JsonArrayInsert(jRow, jButton);
    }
    return NuiRow(jRow);
}

json MoiLiveViewSoulcaster(
    object oPC,
    int nKind,
    int nLevel,
    int nGeneration)
{
    json jChildren = JsonArray();
    int nSoulcaster = GetLevelByClass(CLASS_TYPE_SOULCASTER, oPC);
    jChildren = JsonArrayInsert(jChildren, MoiLiveViewHeader(
        "Soulcaster spells and powers"
    ));
    if (nSoulcaster <= 0)
    {
        jChildren = JsonArrayInsert(jChildren, MoiLiveViewText(
            "This character has no Soulcaster levels.",
            42.0f
        ));
        return NuiCol(jChildren);
    }
    jChildren = JsonArrayInsert(jChildren, MoiLiveViewText(
        "Investment lasts until the matching spell or power is cast. It is never saved. Each investment consumes a swift action.",
        42.0f
    ));
    jChildren = JsonArrayInsert(
        jChildren,
        MoiLiveViewCastKind(oPC, nKind, nGeneration)
    );
    jChildren = JsonArrayInsert(
        jChildren,
        MoiLiveViewCastLevels(nLevel, nGeneration)
    );

    json jEntries = MoiLiveKnownSpells(oPC, nKind, nLevel);
    if (JsonGetLength(jEntries) == 0)
    {
        jChildren = JsonArrayInsert(jChildren, MoiLiveViewText(
            "No known spell or power was found at this level for the selected casting family.",
            42.0f
        ));
        return NuiCol(jChildren);
    }

    int nAmount = MoiLiveSoulcasterAmount(oPC);
    int nTracked = MoiLiveSpellTrackerCount(oPC);
    int i;
    for (i = 0; i < JsonGetLength(jEntries); i++)
    {
        json jEntry = JsonArrayGet(jEntries, i);
        int nSpell = MoiLiveField(jEntry, "s");
        int nInvested = GetLocalInt(
            oPC,
            "SpellEssentia" + IntToString(nSpell)
        );
        json jRow = JsonArray();
        json jIcon = MoiLiveViewImage(MoiLiveSpellIcon(nSpell), 34.0f);
        jIcon = NuiTooltip(jIcon, JsonString(MoiLiveTextField(jEntry, "n")));
        jRow = JsonArrayInsert(jRow, jIcon);

        json jName = NuiLabel(
            JsonString(MoiLiveTextField(jEntry, "n")),
            JsonInt(NUI_HALIGN_LEFT),
            JsonInt(NUI_VALIGN_MIDDLE)
        );
        jName = NuiWidth(jName, 390.0f);
        jName = NuiHeight(jName, 36.0f);
        jRow = JsonArrayInsert(jRow, jName);

        if (nInvested > 0)
        {
            json jStatus = NuiLabel(
                JsonString(IntToString(nInvested) + " invested"),
                JsonInt(NUI_HALIGN_CENTER),
                JsonInt(NUI_VALIGN_MIDDLE)
            );
            jStatus = NuiWidth(jStatus, 130.0f);
            jStatus = NuiHeight(jStatus, 36.0f);
            jRow = JsonArrayInsert(jRow, jStatus);
        }
        else
        {
            json jCommit = NuiId(
                NuiButton(JsonString("Invest " + IntToString(nAmount))),
                MoiLiveStampValue(
                    PRC_MOI_LIVE_CAST_COMMIT_BUTTON,
                    nSpell,
                    nGeneration
                )
            );
            jCommit = NuiWidth(jCommit, 130.0f);
            jCommit = NuiHeight(jCommit, 34.0f);
            jCommit = NuiEnabled(jCommit, JsonBool(
                nTracked < nSoulcaster
                && nAmount <= MoiLiveFreeEssentia(oPC)
            ));
            jCommit = NuiTooltip(
                jCommit,
                JsonString("Lock essentia until this spell or power is cast")
            );
            jRow = JsonArrayInsert(jRow, jCommit);
        }
        jChildren = JsonArrayInsert(jChildren, NuiRow(jRow));
    }
    return NuiCol(jChildren);
}

json MoiLiveViewFooter(int nPage, int nGeneration)
{
    json jRow = JsonArray();
    if (nPage == PRC_MOI_LIVE_PAGE_MOVABLE)
    {
        json jApply = NuiId(
            NuiButton(JsonString("Apply movable allocation")),
            MoiLiveStamp(PRC_MOI_LIVE_MOVABLE_APPLY_BUTTON, nGeneration)
        );
        jApply = NuiWidth(jApply, 220.0f);
        jApply = NuiHeight(jApply, 36.0f);
        jApply = NuiEncouraged(jApply, JsonBool(TRUE));
        jRow = JsonArrayInsert(jRow, jApply);
    }

    json jRefresh = NuiId(
        NuiButton(JsonString("Refresh")),
        MoiLiveStamp(PRC_MOI_LIVE_REFRESH_BUTTON, nGeneration)
    );
    jRefresh = NuiWidth(jRefresh, 100.0f);
    jRefresh = NuiHeight(jRefresh, 36.0f);
    jRow = JsonArrayInsert(jRow, jRefresh);

    json jClose = NuiId(
        NuiButton(JsonString("Close")),
        MoiLiveStamp(PRC_MOI_LIVE_CLOSE_BUTTON, nGeneration)
    );
    jClose = NuiWidth(jClose, 100.0f);
    jClose = NuiHeight(jClose, 36.0f);
    jRow = JsonArrayInsert(jRow, jClose);
    return NuiRow(jRow);
}

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC))
        return;

    int nPrevious = NuiFindWindow(oPC, PRC_MOI_LIVE_NUI_WINDOW_ID);
    if (nPrevious)
    {
        json jPreviousGeometry = NuiGetBind(oPC, nPrevious, "geometry");
        if (jPreviousGeometry != JsonNull())
            SetLocalJson(oPC, PRC_MOI_LIVE_GEOMETRY_VAR, jPreviousGeometry);
        SetLocalInt(oPC, PRC_MOI_LIVE_REBUILD_TOKEN_VAR, nPrevious);
        NuiDestroy(oPC, nPrevious);
    }

    json jDraft = GetLocalJson(oPC, PRC_MOI_LIVE_DRAFT_VAR);
    if (jDraft == JsonNull())
    {
        jDraft = MoiLiveBuildMovable(oPC);
        SetLocalJson(oPC, PRC_MOI_LIVE_DRAFT_VAR, jDraft);
    }

    int nPage = GetLocalInt(oPC, PRC_MOI_LIVE_PAGE_VAR);
    if (nPage < PRC_MOI_LIVE_PAGE_MOVABLE
        || nPage > PRC_MOI_LIVE_PAGE_SOULCASTER)
    {
        nPage = PRC_MOI_LIVE_PAGE_MOVABLE;
        SetLocalInt(oPC, PRC_MOI_LIVE_PAGE_VAR, nPage);
    }

    int nKind = GetLocalInt(oPC, PRC_MOI_LIVE_CAST_KIND_VAR);
    if (nKind != PRC_MOI_LIVE_CAST_ARCANE
        && nKind != PRC_MOI_LIVE_CAST_PSIONIC)
    {
        nKind = GetPrimaryArcaneClass(oPC) != CLASS_TYPE_INVALID
            ? PRC_MOI_LIVE_CAST_ARCANE
            : PRC_MOI_LIVE_CAST_PSIONIC;
        SetLocalInt(oPC, PRC_MOI_LIVE_CAST_KIND_VAR, nKind);
    }
    if (nKind == PRC_MOI_LIVE_CAST_ARCANE
        && GetPrimaryArcaneClass(oPC) == CLASS_TYPE_INVALID)
        nKind = PRC_MOI_LIVE_CAST_PSIONIC;
    else if (nKind == PRC_MOI_LIVE_CAST_PSIONIC
        && GetPrimaryPsionicClass(oPC) == CLASS_TYPE_INVALID)
        nKind = PRC_MOI_LIVE_CAST_ARCANE;
    SetLocalInt(oPC, PRC_MOI_LIVE_CAST_KIND_VAR, nKind);

    int nLevel = GetLocalInt(oPC, PRC_MOI_LIVE_CAST_LEVEL_VAR);
    if (nLevel < 1 || nLevel > 9)
    {
        nLevel = 1;
        SetLocalInt(oPC, PRC_MOI_LIVE_CAST_LEVEL_VAR, nLevel);
    }

    int nGeneration = MoiLiveNextGeneration(oPC);

    float fWindowWidth = 820.0f;
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

    string sSummary = "Essentia: "
        + IntToString(MoiLiveFreeEssentia(oPC)) + " free; "
        + IntToString(GetFeatLockedEssentia(oPC)) + " locked; "
        + IntToString(GetTotalEssentia(oPC)) + " total";
    if (nPage == PRC_MOI_LIVE_PAGE_MOVABLE)
        sSummary += ". Draft uses " + IntToString(MoiLiveMovableSum(jDraft))
                 + " / " + IntToString(MoiLiveMovableAvailable(oPC));
    else if (nPage == PRC_MOI_LIVE_PAGE_SOULCASTER)
        sSummary += ". Soulcaster investments "
                 + IntToString(MoiLiveSpellTrackerCount(oPC)) + " / "
                 + IntToString(GetLevelByClass(CLASS_TYPE_SOULCASTER, oPC));

    json jBody;
    if (nPage == PRC_MOI_LIVE_PAGE_FEATS)
        jBody = MoiLiveViewFeats(oPC, nGeneration);
    else if (nPage == PRC_MOI_LIVE_PAGE_SOULCASTER)
        jBody = MoiLiveViewSoulcaster(oPC, nKind, nLevel, nGeneration);
    else
        jBody = MoiLiveViewMovable(oPC, jDraft, nGeneration);

    json jRoot = JsonArray();
    jRoot = JsonArrayInsert(
        jRoot,
        MoiLiveViewPageTabs(nPage, nGeneration)
    );
    jRoot = JsonArrayInsert(jRoot, MoiLiveViewText(sSummary, 30.0f));
    json jBodyGroup = NuiGroup(jBody, FALSE, NUI_SCROLLBARS_AUTO);
    jBodyGroup = NuiWidth(jBodyGroup, fWindowWidth - 16.0f);
    jRoot = JsonArrayInsert(jRoot, jBodyGroup);
    json jFooter = NuiGroup(
        MoiLiveViewFooter(nPage, nGeneration),
        FALSE,
        NUI_SCROLLBARS_AUTO
    );
    jFooter = NuiWidth(jFooter, fWindowWidth - 16.0f);
    jFooter = NuiHeight(jFooter, 48.0f);
    jRoot = JsonArrayInsert(jRoot, jFooter);

    json jWindow = NuiWindow(
        NuiCol(jRoot),
        JsonString("PRC8 Live Essentia Allocation"),
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
    int nToken = NuiCreate(oPC, jWindow, PRC_MOI_LIVE_NUI_WINDOW_ID);
    if (!nToken)
    {
        MoiLiveClearState(oPC);
        return;
    }

    json jGeometry = GetLocalJson(oPC, PRC_MOI_LIVE_GEOMETRY_VAR);
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
