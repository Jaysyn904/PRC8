//::///////////////////////////////////////////////
//:: Incarnum Loadout editor view
//:: prc_nui_moi_vw
//:://////////////////////////////////////////////

#include "prc_nui_moi_pln"

json MoiViewHeader(string sText)
{
    json jLabel = NuiLabel(
        JsonString(sText),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jLabel = NuiHeight(jLabel, 26.0f);
    jLabel = NuiStyleForegroundColor(jLabel, NuiColor(220, 185, 105));
    return jLabel;
}

json MoiViewMessage(string sText, float fHeight)
{
    json jText = NuiText(JsonString(sText), FALSE, NUI_SCROLLBARS_NONE);
    jText = NuiHeight(jText, fHeight);
    return jText;
}

string MoiViewShortText(string sText, int nLimit)
{
    if (GetStringLength(sText) <= nLimit)
        return sText;
    if (nLimit <= 3)
        return GetStringLeft(sText, nLimit);
    return GetStringLeft(sText, nLimit - 3) + "...";
}

json MoiViewMeldImage(
    int nMeld,
    int nClass,
    float fSize,
    int bSoulmeld = TRUE
)
{
    string sIcon = MoiLoadoutMeldIcon(nMeld, nClass, bSoulmeld);
    json jIcon;
    if (sIcon == "")
    {
        jIcon = NuiLabel(
            JsonString("?"),
            JsonInt(NUI_HALIGN_CENTER),
            JsonInt(NUI_VALIGN_MIDDLE)
        );
    }
    else
    {
        jIcon = NuiImage(
            JsonString(sIcon),
            JsonInt(NUI_ASPECT_FIT),
            JsonInt(NUI_HALIGN_CENTER),
            JsonInt(NUI_VALIGN_MIDDLE)
        );
    }
    jIcon = NuiWidth(jIcon, fSize);
    jIcon = NuiHeight(jIcon, fSize);
    jIcon = NuiTooltip(jIcon, JsonString(MoiLoadoutMeldName(nMeld)));
    return jIcon;
}

json MoiViewStepRow(int nStage, int nGeneration)
{
    json jChildren = JsonArray();
    int nStep;
    for (nStep = PRC_MOI_LOADOUT_STAGE_SHAPE;
         nStep <= PRC_MOI_LOADOUT_STAGE_BIND;
         nStep++)
    {
        string sLabel = "Shape";
        if (nStep == PRC_MOI_LOADOUT_STAGE_INVEST)
            sLabel = "Invest";
        else if (nStep == PRC_MOI_LOADOUT_STAGE_BIND)
            sLabel = "Bind";

        json jButton = NuiId(
            NuiButton(JsonString(sLabel)),
            MoiLoadoutStampValue(
                PRC_MOI_LOADOUT_STEP_BUTTON,
                nStep,
                nGeneration
            )
        );
        jButton = NuiWidth(jButton, 170.0f);
        jButton = NuiHeight(jButton, 36.0f);
        jButton = NuiMargin(jButton, 1.0f);
        if (nStep == nStage)
            jButton = NuiEncouraged(jButton, JsonBool(TRUE));
        jChildren = JsonArrayInsert(jChildren, jButton);
    }
    return NuiRow(jChildren);
}

json MoiViewClassRow(
    object oPC,
    json jDraft,
    int nSelectedClass,
    int nGeneration
)
{
    json jChildren = JsonArray();
    int i;
    for (i = 0; i < 4; i++)
    {
        int nClass = MoiLoadoutClassByIndex(i);
        int nMaximum = MoiLoadoutClassMaximum(oPC, nClass);
        if (nMaximum <= 0)
            continue;

        int nSelected = MoiLoadoutClassCount(jDraft, nClass);
        string sLabel = MoiLoadoutClassName(nClass) + "  "
                      + IntToString(nSelected) + "/"
                      + IntToString(nMaximum);
        json jButton = NuiId(
            NuiButton(JsonString(sLabel)),
            MoiLoadoutStampValue(
                PRC_MOI_LOADOUT_CLASS_BUTTON,
                nClass,
                nGeneration
            )
        );
        jButton = NuiWidth(jButton, 190.0f);
        jButton = NuiHeight(jButton, 36.0f);
        jButton = NuiMargin(jButton, 1.0f);
        jButton = NuiTooltip(
            jButton,
            JsonString(
                MoiLoadoutClassName(nClass) + ": "
                + IntToString(nSelected) + " selected of "
                + IntToString(nMaximum) + " required."
            )
        );
        if (nClass == nSelectedClass)
            jButton = NuiEncouraged(jButton, JsonBool(TRUE));
        jChildren = JsonArrayInsert(jChildren, jButton);
    }
    return NuiRow(jChildren);
}

json MoiViewChakraCell(
    object oPC,
    json jDraft,
    int nClass,
    int nChakra,
    int nSelectedChakra,
    int bEnabled,
    float fWidth,
    int nGeneration
)
{
    int nIndex = MoiLoadoutFindClassChakra(jDraft, nClass, nChakra);
    int nMeld;
    if (nIndex >= 0)
        nMeld = MoiLoadoutField(JsonArrayGet(jDraft, nIndex), "m");

    string sPrefix = MoiLoadoutChakraShort(nChakra);
    if (nChakra >= CHAKRA_DOUBLE_CROWN)
        sPrefix = "D-" + sPrefix;
    string sOccupant = nMeld > 0
        ? MoiViewShortText(MoiLoadoutMeldName(nMeld), 18)
        : "Empty";
    string sLabel = sPrefix + ": " + sOccupant;
    string sTooltip = MoiLoadoutChakraName(nChakra) + ": "
                    + (nMeld > 0 ? MoiLoadoutMeldName(nMeld) : "empty");

    json jButton = NuiId(
        NuiButton(JsonString(sLabel)),
        MoiLoadoutStampValue(
            PRC_MOI_LOADOUT_CHAKRA_BUTTON,
            nChakra,
            nGeneration
        )
    );
    jButton = NuiWidth(jButton, fWidth);
    jButton = NuiHeight(jButton, 48.0f);
    jButton = NuiMargin(jButton, 1.0f);
    jButton = NuiTooltip(jButton, JsonString(sTooltip));
    jButton = NuiEnabled(jButton, JsonBool(bEnabled));
    if (!bEnabled)
    {
        jButton = NuiDisabledTooltip(
            jButton,
            JsonString(
                "Shape the matching base chakra before using this double chakra."
            )
        );
    }
    if (nChakra == nSelectedChakra && bEnabled)
        jButton = NuiEncouraged(jButton, JsonBool(TRUE));
    return jButton;
}

json MoiViewChakraGrid(
    object oPC,
    json jDraft,
    int nClass,
    int nSelectedChakra,
    int nColumns,
    float fCellWidth,
    int nGeneration
)
{
    json jChildren = JsonArray();
    jChildren = JsonArrayInsert(jChildren, MoiViewHeader("Base chakras"));

    json jRows = JsonArray();
    json jRow = JsonArray();
    int nInRow;
    int nChakra;
    for (nChakra = CHAKRA_CROWN; nChakra <= CHAKRA_SOUL; nChakra++)
    {
        jRow = JsonArrayInsert(
            jRow,
            MoiViewChakraCell(
                oPC,
                jDraft,
                nClass,
                nChakra,
                nSelectedChakra,
                TRUE,
                fCellWidth,
                nGeneration
            )
        );
        nInRow++;
        if (nInRow == nColumns || nChakra == CHAKRA_SOUL)
        {
            jRows = JsonArrayInsert(jRows, NuiRow(jRow));
            jRow = JsonArray();
            nInRow = 0;
        }
    }
    jChildren = JsonArrayInsert(jChildren, NuiCol(jRows));

    json jDoubleRows = JsonArray();
    jRow = JsonArray();
    nInRow = 0;
    int nDoubleCount;
    for (nChakra = CHAKRA_DOUBLE_CROWN;
         nChakra <= CHAKRA_DOUBLE_SOUL;
         nChakra++)
    {
        int nFeat = MoiLoadoutDoubleChakraFeat(nChakra);
        if (nFeat <= 0 || !GetHasFeat(nFeat, oPC))
            continue;

        int nBase = DoubleChakraToChakra(nChakra);
        int bEnabled = MoiLoadoutHasClassChakra(jDraft, nClass, nBase);
        jRow = JsonArrayInsert(
            jRow,
            MoiViewChakraCell(
                oPC,
                jDraft,
                nClass,
                nChakra,
                nSelectedChakra,
                bEnabled,
                fCellWidth,
                nGeneration
            )
        );
        nInRow++;
        nDoubleCount++;
        if (nInRow == nColumns)
        {
            jDoubleRows = JsonArrayInsert(jDoubleRows, NuiRow(jRow));
            jRow = JsonArray();
            nInRow = 0;
        }
    }
    if (nInRow > 0)
        jDoubleRows = JsonArrayInsert(jDoubleRows, NuiRow(jRow));
    if (nDoubleCount > 0)
    {
        jChildren = JsonArrayInsert(
            jChildren,
            MoiViewHeader("Double chakras")
        );
        jChildren = JsonArrayInsert(jChildren, NuiCol(jDoubleRows));
    }
    return NuiCol(jChildren);
}

json MoiViewSelectedSlot(
    object oPC,
    json jDraft,
    int nClass,
    int nChakra,
    int nGeneration
)
{
    int nIndex = MoiLoadoutFindClassChakra(jDraft, nClass, nChakra);
    int nMeld;
    if (nIndex >= 0)
        nMeld = MoiLoadoutField(JsonArrayGet(jDraft, nIndex), "m");

    json jRow = JsonArray();
    if (nMeld > 0)
        jRow = JsonArrayInsert(
            jRow,
            MoiViewMeldImage(nMeld, nClass, 42.0f)
        );

    string sTop = "Selected slot: " + MoiLoadoutClassName(nClass)
                + " / " + MoiLoadoutChakraName(nChakra);
    string sBottom = nMeld > 0
        ? "Occupant: " + MoiLoadoutMeldName(nMeld)
        : "Occupant: Empty";
    json jLabels = JsonArray();
    jLabels = JsonArrayInsert(
        jLabels,
        MoiViewMessage(sTop + "\n" + sBottom, 44.0f)
    );
    json jLabelCol = NuiCol(jLabels);
    jLabelCol = NuiWidth(jLabelCol, 540.0f);
    jRow = JsonArrayInsert(jRow, jLabelCol);
    jRow = JsonArrayInsert(jRow, NuiSpacer());

    json jClear = NuiId(
        NuiButton(JsonString("Clear Slot")),
        MoiLoadoutStamp(
            PRC_MOI_LOADOUT_CLEAR_SLOT_BUTTON,
            nGeneration
        )
    );
    jClear = NuiWidth(jClear, 110.0f);
    jClear = NuiHeight(jClear, 34.0f);
    jClear = NuiEnabled(jClear, JsonBool(nMeld > 0));
    jClear = NuiDisabledTooltip(
        jClear,
        JsonString("The selected chakra is already empty.")
    );
    jRow = JsonArrayInsert(jRow, jClear);

    json jGroup = NuiGroup(NuiRow(jRow), TRUE, NUI_SCROLLBARS_AUTO);
    jGroup = NuiHeight(jGroup, 58.0f);
    return jGroup;
}

json MoiViewMeldCard(
    json jDraft,
    int nMeld,
    int nClass,
    int nSlotIndex,
    float fWidth,
    int nGeneration
)
{
    int nExisting = MoiLoadoutFindMeld(jDraft, nMeld);
    int bAvailable = nExisting < 0 || nExisting == nSlotIndex;
    string sName = MoiLoadoutMeldName(nMeld);
    string sIcon = MoiLoadoutMeldIcon(nMeld, nClass);

    json jButton;
    if (sIcon == "")
        jButton = NuiButton(JsonString("?"));
    else
        jButton = NuiButtonImage(JsonString(sIcon));
    jButton = NuiId(
        jButton,
        MoiLoadoutStampValue(
            PRC_MOI_LOADOUT_MELD_BUTTON,
            nMeld,
            nGeneration
        )
    );
    jButton = NuiWidth(jButton, 48.0f);
    jButton = NuiHeight(jButton, 48.0f);
    jButton = NuiTooltip(
        jButton,
        JsonString(
            sName + " - left-click to select; right-click for details."
        )
    );
    jButton = NuiEnabled(jButton, JsonBool(bAvailable));
    if (!bAvailable)
    {
        json jOther = JsonArrayGet(jDraft, nExisting);
        jButton = NuiDisabledTooltip(
            jButton,
            JsonString(
                sName + " is already assigned to "
                + MoiLoadoutClassName(MoiLoadoutField(jOther, "c"))
                + " / "
                + MoiLoadoutChakraName(MoiLoadoutField(jOther, "k"))
                + "."
            )
        );
    }
    if (nExisting == nSlotIndex)
        jButton = NuiEncouraged(jButton, JsonBool(TRUE));

    json jButtonRow = JsonArray();
    jButtonRow = JsonArrayInsert(jButtonRow, NuiSpacer());
    jButtonRow = JsonArrayInsert(jButtonRow, jButton);
    jButtonRow = JsonArrayInsert(jButtonRow, NuiSpacer());

    json jLabel = NuiLabel(
        JsonString(MoiViewShortText(sName, 18)),
        JsonInt(NUI_HALIGN_CENTER),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jLabel = NuiWidth(jLabel, fWidth - 4.0f);
    jLabel = NuiHeight(jLabel, 24.0f);
    jLabel = NuiTooltip(jLabel, JsonString(sName));

    json jChildren = JsonArray();
    jChildren = JsonArrayInsert(jChildren, NuiRow(jButtonRow));
    jChildren = JsonArrayInsert(jChildren, jLabel);
    json jCard = NuiCol(jChildren);
    jCard = NuiWidth(jCard, fWidth);
    jCard = NuiHeight(jCard, 78.0f);
    return jCard;
}

json MoiViewMeldGrid(
    object oPC,
    json jDraft,
    int nClass,
    int nChakra,
    float fPanelWidth,
    float fHeight,
    int nGeneration
)
{
    int nColumns = FloatToInt((fPanelWidth - 12.0f) / 128.0f);
    if (nColumns < 2)
        nColumns = 2;
    if (nColumns > 6)
        nColumns = 6;
    float fCardWidth = (fPanelWidth - 18.0f) / IntToFloat(nColumns);

    int nSlotIndex = MoiLoadoutFindClassChakra(
        jDraft,
        nClass,
        nChakra
    );
    json jRows = JsonArray();
    json jRow = JsonArray();
    int nInRow;
    int nEligible;
    int nRows = Get2DARowCount(GetMeldFile());
    int i;
    for (i = 1; i < nRows; i++)
    {
        int nMeld = StringToInt(Get2DACache(
            GetMeldFile(),
            "SpellID",
            i
        ));
        if (nMeld <= 0
            || !MoiLoadoutMeldEligible(oPC, nClass, nChakra, nMeld))
            continue;

        jRow = JsonArrayInsert(
            jRow,
            MoiViewMeldCard(
                jDraft,
                nMeld,
                nClass,
                nSlotIndex,
                fCardWidth,
                nGeneration
            )
        );
        nInRow++;
        nEligible++;
        if (nInRow == nColumns)
        {
            jRows = JsonArrayInsert(jRows, NuiRow(jRow));
            jRow = JsonArray();
            nInRow = 0;
        }
    }
    if (nInRow > 0)
        jRows = JsonArrayInsert(jRows, NuiRow(jRow));
    if (nEligible <= 0)
    {
        jRows = JsonArrayInsert(
            jRows,
            MoiViewMessage(
                "No soulmeld is eligible for this class and chakra.",
                40.0f
            )
        );
    }

    json jGrid = NuiGroup(NuiCol(jRows), TRUE, NUI_SCROLLBARS_AUTO);
    jGrid = NuiWidth(jGrid, fPanelWidth);
    jGrid = NuiHeight(jGrid, fHeight);
    return jGrid;
}

json MoiViewShapeStage(
    object oPC,
    json jDraft,
    int nClass,
    int nChakra,
    float fWindowWidth,
    float fWindowHeight,
    int nGeneration
)
{
    int nColumns = 5;
    if (fWindowWidth < 760.0f)
        nColumns = 4;
    if (fWindowWidth < 560.0f)
        nColumns = 3;
    float fPanelWidth = fWindowWidth - 28.0f;
    float fCellWidth = (fPanelWidth - 18.0f) / IntToFloat(nColumns);
    float fGridHeight = fWindowHeight - 390.0f;
    if (fGridHeight < 160.0f)
        fGridHeight = 160.0f;
    if (fGridHeight > 320.0f)
        fGridHeight = 320.0f;

    json jChildren = JsonArray();
    jChildren = JsonArrayInsert(
        jChildren,
        MoiViewHeader("Shaping class - selected / maximum")
    );
    jChildren = JsonArrayInsert(
        jChildren,
        MoiViewClassRow(oPC, jDraft, nClass, nGeneration)
    );
    jChildren = JsonArrayInsert(
        jChildren,
        MoiViewChakraGrid(
            oPC,
            jDraft,
            nClass,
            nChakra,
            nColumns,
            fCellWidth,
            nGeneration
        )
    );
    jChildren = JsonArrayInsert(
        jChildren,
        MoiViewSelectedSlot(
            oPC,
            jDraft,
            nClass,
            nChakra,
            nGeneration
        )
    );
    jChildren = JsonArrayInsert(
        jChildren,
        MoiViewHeader("Eligible soulmelds")
    );
    jChildren = JsonArrayInsert(
        jChildren,
        MoiViewMeldGrid(
            oPC,
            jDraft,
            nClass,
            nChakra,
            fPanelWidth,
            fGridHeight,
            nGeneration
        )
    );
    return NuiCol(jChildren);
}

json MoiViewInvestRow(
    object oPC,
    json jDraft,
    int nIndex,
    int nInvested,
    int nPool,
    int nExpanded,
    int nExpandedMaximum,
    int nGeneration
)
{
    json jEntry = JsonArrayGet(jDraft, nIndex);
    int nClass = MoiLoadoutField(jEntry, "c");
    int nChakra = MoiLoadoutField(jEntry, "k");
    int nMeld = MoiLoadoutField(jEntry, "m");
    int nTarget = MoiLoadoutField(jEntry, "i");
    int nCapacity = MoiLoadoutCapacity(oPC, jEntry);
    int bExpanded = MoiLoadoutField(jEntry, "e") != 0;
    int bSoulmeld = MoiLoadoutIsSoulmeldEntry(jEntry);
    string sName = bSoulmeld
        ? MoiLoadoutMeldName(nMeld)
        : MoiLoadoutSpecialName(nMeld);
    string sSource = bSoulmeld
        ? MoiLoadoutClassName(nClass)
        : MoiLoadoutSpecialSourceName(nMeld);

    json jRow = JsonArray();
    jRow = JsonArrayInsert(
        jRow,
        MoiViewMeldImage(nMeld, nClass, 40.0f, bSoulmeld)
    );

    json jName = NuiLabel(
        JsonString(MoiViewShortText(sName, 25)),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jName = NuiWidth(jName, 190.0f);
    jName = NuiHeight(jName, 40.0f);
    jName = NuiTooltip(jName, JsonString(sName));
    jRow = JsonArrayInsert(jRow, jName);

    json jClass = NuiLabel(
        JsonString(MoiViewShortText(sSource, 16)),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jClass = NuiWidth(jClass, 115.0f);
    jClass = NuiTooltip(jClass, JsonString(sSource));
    jRow = JsonArrayInsert(jRow, jClass);

    json jChakra = NuiLabel(
        JsonString(
            bSoulmeld
                ? MoiLoadoutChakraName(nChakra)
                : (nMeld == MELD_DUSKLING_SPEED ? "Racial" : "Feature")
        ),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jChakra = NuiWidth(jChakra, 95.0f);
    jChakra = NuiTooltip(
        jChakra,
        JsonString(
            bSoulmeld
                ? MoiLoadoutChakraName(nChakra)
                : "Class and racial essentia receptacle"
        )
    );
    jRow = JsonArrayInsert(jRow, jChakra);

    json jDown = NuiId(
        NuiButton(JsonString("-")),
        MoiLoadoutStampValue(
            PRC_MOI_LOADOUT_INVEST_DOWN_BUTTON,
            nIndex,
            nGeneration
        )
    );
    jDown = NuiWidth(jDown, 34.0f);
    jDown = NuiHeight(jDown, 32.0f);
    jDown = NuiEnabled(jDown, JsonBool(nTarget > 0));
    jRow = JsonArrayInsert(jRow, jDown);

    json jValue = NuiLabel(
        JsonString(
            IntToString(nTarget) + " / " + IntToString(nCapacity)
        ),
        JsonInt(NUI_HALIGN_CENTER),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jValue = NuiWidth(jValue, 58.0f);
    jValue = NuiHeight(jValue, 32.0f);
    jValue = NuiTooltip(
        jValue,
        JsonString("Saved investment / current capacity")
    );
    jRow = JsonArrayInsert(jRow, jValue);

    json jUp = NuiId(
        NuiButton(JsonString("+")),
        MoiLoadoutStampValue(
            PRC_MOI_LOADOUT_INVEST_UP_BUTTON,
            nIndex,
            nGeneration
        )
    );
    jUp = NuiWidth(jUp, 34.0f);
    jUp = NuiHeight(jUp, 32.0f);
    jUp = NuiEnabled(
        jUp,
        JsonBool(nTarget < nCapacity && nInvested < nPool)
    );
    jUp = NuiDisabledTooltip(
        jUp,
        JsonString("This meld is at capacity or the saved pool is full.")
    );
    jRow = JsonArrayInsert(jRow, jUp);

    json jExpanded;
    if (bSoulmeld)
    {
        jExpanded = NuiId(
            NuiButton(JsonString(
                bExpanded ? "Expanded: On" : "Expanded: Off"
            )),
            MoiLoadoutStampValue(
                PRC_MOI_LOADOUT_EXPANDED_BUTTON,
                nIndex,
                nGeneration
            )
        );
        jExpanded = NuiEnabled(
            jExpanded,
            JsonBool(bExpanded || nExpanded < nExpandedMaximum)
        );
        jExpanded = NuiDisabledTooltip(
            jExpanded,
            JsonString("No unassigned Expanded Soulmeld Capacity choice remains.")
        );
        if (bExpanded)
            jExpanded = NuiEncouraged(jExpanded, JsonBool(TRUE));
    }
    else
    {
        jExpanded = NuiLabel(
            JsonString("Receptacle"),
            JsonInt(NUI_HALIGN_CENTER),
            JsonInt(NUI_VALIGN_MIDDLE)
        );
        jExpanded = NuiTooltip(
            jExpanded,
            JsonString(
                "This saved investment is restored on completed rest. Expanded Soulmeld Capacity does not apply."
            )
        );
    }
    jExpanded = NuiWidth(jExpanded, 125.0f);
    jExpanded = NuiHeight(jExpanded, 32.0f);
    jRow = JsonArrayInsert(jRow, jExpanded);

    json jResult = NuiRow(jRow);
    jResult = NuiHeight(jResult, 48.0f);
    return jResult;
}

json MoiViewInvestStage(
    object oPC,
    json jDraft,
    float fWindowWidth,
    float fWindowHeight,
    int nGeneration
)
{
    int nInvested = MoiLoadoutInvestedTotal(jDraft);
    int nPool = GetTotalEssentia(oPC);
    int nExpanded = MoiLoadoutExpandedCount(jDraft);
    int nExpandedMaximum = MoiLoadoutExpandedFeatCount(oPC);

    json jChildren = JsonArray();
    jChildren = JsonArrayInsert(
        jChildren,
        MoiViewHeader(
            "Essentia pool: " + IntToString(nInvested) + " / "
            + IntToString(nPool) + "    Expanded choices: "
            + IntToString(nExpanded) + " / "
            + IntToString(nExpandedMaximum)
        )
    );
    jChildren = JsonArrayInsert(
        jChildren,
        MoiViewMessage(
            "Each row shows an essentia receptacle, its source, saved investment / capacity, and any Expanded Soulmeld Capacity choice.",
            34.0f
        )
    );

    json jRows = JsonArray();
    int nLength = JsonGetLength(jDraft);
    int i;
    for (i = 0; i < nLength; i++)
    {
        jRows = JsonArrayInsert(
            jRows,
            MoiViewInvestRow(
                oPC,
                jDraft,
                i,
                nInvested,
                nPool,
                nExpanded,
                nExpandedMaximum,
                nGeneration
            )
        );
    }
    if (nLength <= 0)
    {
        jRows = JsonArrayInsert(
            jRows,
            MoiViewMessage(
                "Shape soulmelds before assigning essentia.",
                44.0f
            )
        );
    }

    float fListHeight = fWindowHeight - 205.0f;
    if (fListHeight < 220.0f)
        fListHeight = 220.0f;
    if (fListHeight > 475.0f)
        fListHeight = 475.0f;
    json jList = NuiGroup(NuiCol(jRows), TRUE, NUI_SCROLLBARS_AUTO);
    jList = NuiWidth(jList, fWindowWidth - 28.0f);
    jList = NuiHeight(jList, fListHeight);
    jChildren = JsonArrayInsert(jChildren, jList);
    return NuiCol(jChildren);
}

string MoiViewBindSummary(object oPC, json jDraft)
{
    string sSummary = "Binds by class: ";
    int nShown;
    int i;
    for (i = 0; i < 4; i++)
    {
        int nClass = MoiLoadoutClassByIndex(i);
        if (MoiLoadoutClassMaximum(oPC, nClass) <= 0)
            continue;
        if (nShown)
            sSummary += "  |  ";
        sSummary += MoiLoadoutClassName(nClass) + " "
                  + IntToString(MoiLoadoutClassBindCount(jDraft, nClass))
                  + "/" + IntToString(GetMaxBindCount(oPC, nClass));
        nShown++;
    }
    return sSummary;
}

json MoiViewBindRow(
    object oPC,
    json jDraft,
    int nIndex,
    int nGeneration
)
{
    json jEntry = JsonArrayGet(jDraft, nIndex);
    int nClass = MoiLoadoutField(jEntry, "c");
    int nChakra = MoiLoadoutField(jEntry, "k");
    int nMeld = MoiLoadoutField(jEntry, "m");
    int nBind = MoiLoadoutField(jEntry, "b");
    int nTotem = MoiLoadoutField(jEntry, "t");
    int nAspect = MoiLoadoutField(jEntry, "a");

    json jRow = JsonArray();
    jRow = JsonArrayInsert(
        jRow,
        MoiViewMeldImage(nMeld, nClass, 40.0f)
    );

    json jName = NuiLabel(
        JsonString(MoiViewShortText(MoiLoadoutMeldName(nMeld), 22)),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jName = NuiWidth(jName, 165.0f);
    jName = NuiHeight(jName, 40.0f);
    jName = NuiTooltip(jName, JsonString(MoiLoadoutMeldName(nMeld)));
    jRow = JsonArrayInsert(jRow, jName);

    json jClass = NuiLabel(
        JsonString(MoiViewShortText(MoiLoadoutClassName(nClass), 14)),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jClass = NuiWidth(jClass, 100.0f);
    jClass = NuiTooltip(jClass, JsonString(MoiLoadoutClassName(nClass)));
    jRow = JsonArrayInsert(jRow, jClass);

    json jChakra = NuiLabel(
        JsonString(MoiLoadoutChakraShort(nChakra)),
        JsonInt(NUI_HALIGN_CENTER),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jChakra = NuiWidth(jChakra, 42.0f);
    jChakra = NuiTooltip(
        jChakra,
        JsonString(MoiLoadoutChakraName(nChakra))
    );
    jRow = JsonArrayInsert(jRow, jChakra);

    int bPhysicalAvailable = nBind != 0
        || (GetCanBindChakra(oPC, nChakra)
            && (nChakra < CHAKRA_DOUBLE_CROWN
                || GetCanBindChakra(
                    oPC,
                    DoubleChakraToChakra(nChakra)
                )));
    json jPhysical = NuiId(
        NuiButton(JsonString(
            nBind ? "Physical: On" : "Physical: Off"
        )),
        MoiLoadoutStampValue(
            PRC_MOI_LOADOUT_BIND_SLOT_BUTTON,
            nIndex,
            nGeneration
        )
    );
    jPhysical = NuiWidth(jPhysical, 108.0f);
    jPhysical = NuiHeight(jPhysical, 32.0f);
    jPhysical = NuiEnabled(jPhysical, JsonBool(bPhysicalAvailable));
    jPhysical = NuiDisabledTooltip(
        jPhysical,
        JsonString("This physical chakra is not open for binding.")
    );
    if (nBind)
        jPhysical = NuiEncouraged(jPhysical, JsonBool(TRUE));
    jRow = JsonArrayInsert(jRow, jPhysical);

    int bTotemEligible = nClass == CLASS_TYPE_TOTEMIST
        && GetLevelByClass(CLASS_TYPE_TOTEMIST, oPC) >= 2
        && MoiLoadoutMeldSupportsTotem(nMeld);
    if (bTotemEligible)
    {
        json jTotem = NuiId(
            NuiButton(JsonString(
                nTotem == CHAKRA_TOTEM ? "Totem: On" : "Totem: Off"
            )),
            MoiLoadoutStampValue(
                PRC_MOI_LOADOUT_BIND_TOTEM_BUTTON,
                nIndex,
                nGeneration
            )
        );
        jTotem = NuiWidth(jTotem, 94.0f);
        jTotem = NuiHeight(jTotem, 32.0f);
        if (nTotem == CHAKRA_TOTEM)
            jTotem = NuiEncouraged(jTotem, JsonBool(TRUE));
        jRow = JsonArrayInsert(jRow, jTotem);

        if (GetHasFeat(FEAT_DOUBLE_CHAKRA_TOTEM, oPC))
        {
            json jDoubleTotem = NuiId(
                NuiButton(JsonString(
                    nTotem == CHAKRA_DOUBLE_TOTEM
                        ? "Double Totem: On"
                        : "Double Totem: Off"
                )),
                MoiLoadoutStampValue(
                    PRC_MOI_LOADOUT_BIND_DTOTEM_BUTTON,
                    nIndex,
                    nGeneration
                )
            );
            jDoubleTotem = NuiWidth(jDoubleTotem, 132.0f);
            jDoubleTotem = NuiHeight(jDoubleTotem, 32.0f);
            if (nTotem == CHAKRA_DOUBLE_TOTEM)
                jDoubleTotem = NuiEncouraged(
                    jDoubleTotem,
                    JsonBool(TRUE)
                );
            jRow = JsonArrayInsert(jRow, jDoubleTotem);
        }
    }

    if (nMeld == MELD_ASTRAL_VAMBRACES
        && nBind
        && DoubleChakraToChakra(nBind) == CHAKRA_ARMS)
    {
        json jAspectDown = NuiId(
            NuiButton(JsonString("Prev")),
            MoiLoadoutStampValue(
                PRC_MOI_LOADOUT_ASTRAL_DOWN_BUTTON,
                nIndex,
                nGeneration
            )
        );
        jAspectDown = NuiWidth(jAspectDown, 46.0f);
        jAspectDown = NuiHeight(jAspectDown, 32.0f);
        jRow = JsonArrayInsert(jRow, jAspectDown);

        json jAspect = NuiLabel(
            JsonString(MoiViewShortText(
                "Aspect: " + MoiLoadoutAstralName(nAspect),
                22
            )),
            JsonInt(NUI_HALIGN_CENTER),
            JsonInt(NUI_VALIGN_MIDDLE)
        );
        jAspect = NuiWidth(jAspect, 145.0f);
        jAspect = NuiTooltip(
            jAspect,
            JsonString("Astral aspect: " + MoiLoadoutAstralName(nAspect))
        );
        jRow = JsonArrayInsert(jRow, jAspect);

        json jAspectUp = NuiId(
            NuiButton(JsonString("Next")),
            MoiLoadoutStampValue(
                PRC_MOI_LOADOUT_ASTRAL_UP_BUTTON,
                nIndex,
                nGeneration
            )
        );
        jAspectUp = NuiWidth(jAspectUp, 46.0f);
        jAspectUp = NuiHeight(jAspectUp, 32.0f);
        jRow = JsonArrayInsert(jRow, jAspectUp);
    }

    json jResult = NuiRow(jRow);
    jResult = NuiHeight(jResult, 48.0f);
    return jResult;
}

json MoiViewBindStage(
    object oPC,
    json jDraft,
    float fWindowWidth,
    float fWindowHeight,
    int nGeneration
)
{
    json jChildren = JsonArray();
    jChildren = JsonArrayInsert(
        jChildren,
        MoiViewHeader(MoiViewBindSummary(oPC, jDraft))
    );
    jChildren = JsonArrayInsert(
        jChildren,
        MoiViewMessage(
            "Toggle physical, Totem, and Double Totem binds. Astral Vambraces shows its Arms aspect when bound.",
            34.0f
        )
    );

    json jRows = JsonArray();
    int nLength = JsonGetLength(jDraft);
    int nShown;
    int i;
    for (i = 0; i < nLength; i++)
    {
        if (!MoiLoadoutIsSoulmeldEntry(JsonArrayGet(jDraft, i)))
            continue;
        jRows = JsonArrayInsert(
            jRows,
            MoiViewBindRow(oPC, jDraft, i, nGeneration)
        );
        nShown++;
    }
    if (nShown <= 0)
    {
        jRows = JsonArrayInsert(
            jRows,
            MoiViewMessage(
                "Shape soulmelds before assigning chakra binds.",
                44.0f
            )
        );
    }

    float fListHeight = fWindowHeight - 205.0f;
    if (fListHeight < 220.0f)
        fListHeight = 220.0f;
    if (fListHeight > 475.0f)
        fListHeight = 475.0f;
    json jList = NuiGroup(NuiCol(jRows), TRUE, NUI_SCROLLBARS_AUTO);
    jList = NuiWidth(jList, fWindowWidth - 28.0f);
    jList = NuiHeight(jList, fListHeight);
    jChildren = JsonArrayInsert(jChildren, jList);
    return NuiCol(jChildren);
}

json MoiViewFooter(
    object oPC,
    json jDraft,
    string sValidation,
    int nGeneration
)
{
    json jRow = JsonArray();

    json jCapture = NuiId(
        NuiButton(JsonString("Capture Current")),
        MoiLoadoutStamp(PRC_MOI_LOADOUT_CAPTURE_BUTTON, nGeneration)
    );
    jCapture = NuiWidth(jCapture, 128.0f);
    jCapture = NuiHeight(jCapture, 34.0f);
    jCapture = NuiTooltip(
        jCapture,
        JsonString("Replace this draft with the current live Incarnum setup.")
    );
    jRow = JsonArrayInsert(jRow, jCapture);

    json jClearDraft = NuiId(
        NuiButton(JsonString("Clear Draft")),
        MoiLoadoutStamp(PRC_MOI_LOADOUT_CLEAR_DRAFT_BUTTON, nGeneration)
    );
    jClearDraft = NuiWidth(jClearDraft, 104.0f);
    jClearDraft = NuiHeight(jClearDraft, 34.0f);
    jClearDraft = NuiEnabled(
        jClearDraft,
        JsonBool(JsonGetLength(jDraft) > 0)
    );
    jRow = JsonArrayInsert(jRow, jClearDraft);

    int bHasSaved = GetPersistantLocalInt(
        oPC,
        PRC_MOI_LOADOUT_VERSION_VAR
    ) == PRC_MOI_LOADOUT_VERSION;
    json jClearSaved = NuiId(
        NuiButton(JsonString("Clear Saved")),
        MoiLoadoutStamp(PRC_MOI_LOADOUT_CLEAR_SAVED_BUTTON, nGeneration)
    );
    jClearSaved = NuiWidth(jClearSaved, 108.0f);
    jClearSaved = NuiHeight(jClearSaved, 34.0f);
    jClearSaved = NuiEnabled(jClearSaved, JsonBool(bHasSaved));
    jClearSaved = NuiDisabledTooltip(
        jClearSaved,
        JsonString("This character has no saved Incarnum default.")
    );
    jRow = JsonArrayInsert(jRow, jClearSaved);

    jRow = JsonArrayInsert(jRow, NuiSpacer());

    json jCancel = NuiId(
        NuiButton(JsonString("Cancel")),
        MoiLoadoutStamp(PRC_MOI_LOADOUT_CANCEL_BUTTON, nGeneration)
    );
    jCancel = NuiWidth(jCancel, 90.0f);
    jCancel = NuiHeight(jCancel, 34.0f);
    jRow = JsonArrayInsert(jRow, jCancel);

    json jSave = NuiId(
        NuiButton(JsonString("Save Default")),
        MoiLoadoutStamp(PRC_MOI_LOADOUT_SAVE_BUTTON, nGeneration)
    );
    jSave = NuiWidth(jSave, 130.0f);
    jSave = NuiHeight(jSave, 34.0f);
    jSave = NuiEnabled(jSave, JsonBool(sValidation == ""));
    jSave = NuiEncouraged(jSave, JsonBool(sValidation == ""));
    jSave = NuiTooltip(
        jSave,
        JsonString("Save this loadout as the default for completed rests.")
    );
    jSave = NuiDisabledTooltip(jSave, JsonString(sValidation));
    jRow = JsonArrayInsert(jRow, jSave);

    return NuiRow(jRow);
}

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC)
        || !GetLocalInt(oPC, PRC_MOI_LOADOUT_ACTIVE_VAR)
        || !MoiLoadoutHasShapingClass(oPC))
    {
        MoiLoadoutDiscardDraft(oPC);
        return;
    }

    int nPrevious = NuiFindWindow(oPC, PRC_MOI_LOADOUT_NUI_WINDOW_ID);
    if (nPrevious)
    {
        json jPreviousGeometry = NuiGetBind(oPC, nPrevious, "geometry");
        if (jPreviousGeometry != JsonNull())
        {
            SetLocalJson(
                oPC,
                PRC_MOI_LOADOUT_GEOMETRY_VAR,
                jPreviousGeometry
            );
        }
        SetLocalInt(oPC, PRC_MOI_LOADOUT_REBUILD_TOKEN_VAR, nPrevious);
        NuiDestroy(oPC, nPrevious);
    }

    json jDraft = MoiLoadoutGetDraft(oPC);
    int nStage = GetLocalInt(oPC, PRC_MOI_LOADOUT_STAGE_VAR);
    if (nStage < PRC_MOI_LOADOUT_STAGE_SHAPE
        || nStage > PRC_MOI_LOADOUT_STAGE_BIND)
    {
        nStage = PRC_MOI_LOADOUT_STAGE_SHAPE;
        SetLocalInt(oPC, PRC_MOI_LOADOUT_STAGE_VAR, nStage);
    }

    int nClass = GetLocalInt(oPC, PRC_MOI_LOADOUT_CLASS_VAR);
    if (MoiLoadoutClassMaximum(oPC, nClass) <= 0)
    {
        nClass = MoiLoadoutFirstClass(oPC);
        SetLocalInt(oPC, PRC_MOI_LOADOUT_CLASS_VAR, nClass);
    }

    int nChakra = GetLocalInt(oPC, PRC_MOI_LOADOUT_CHAKRA_VAR);
    int bInvalidChakra = nChakra < CHAKRA_CROWN
        || nChakra > CHAKRA_DOUBLE_SOUL
        || nChakra == CHAKRA_TOTEM;
    if (!bInvalidChakra && nChakra >= CHAKRA_DOUBLE_CROWN)
    {
        bInvalidChakra = !GetHasFeat(
            MoiLoadoutDoubleChakraFeat(nChakra),
            oPC
        ) || !MoiLoadoutHasClassChakra(
            jDraft,
            nClass,
            DoubleChakraToChakra(nChakra)
        );
    }
    if (bInvalidChakra)
    {
        nChakra = CHAKRA_CROWN;
        SetLocalInt(oPC, PRC_MOI_LOADOUT_CHAKRA_VAR, nChakra);
    }

    int nGeneration = MoiLoadoutNextGeneration(oPC);

    float fWindowWidth = 860.0f;
    float fWindowHeight = 680.0f;
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

    json jStage;
    if (nStage == PRC_MOI_LOADOUT_STAGE_INVEST)
    {
        jStage = MoiViewInvestStage(
            oPC,
            jDraft,
            fWindowWidth,
            fWindowHeight,
            nGeneration
        );
    }
    else if (nStage == PRC_MOI_LOADOUT_STAGE_BIND)
    {
        jStage = MoiViewBindStage(
            oPC,
            jDraft,
            fWindowWidth,
            fWindowHeight,
            nGeneration
        );
    }
    else
    {
        jStage = MoiViewShapeStage(
            oPC,
            jDraft,
            nClass,
            nChakra,
            fWindowWidth,
            fWindowHeight,
            nGeneration
        );
    }

    string sValidation = MoiLoadoutValidate(oPC, jDraft);
    string sStatus = sValidation == ""
        ? "Ready to save as the completed-rest default."
        : sValidation;

    json jRootChildren = JsonArray();
    json jSteps = NuiGroup(
        MoiViewStepRow(nStage, nGeneration),
        FALSE,
        NUI_SCROLLBARS_AUTO
    );
    jSteps = NuiWidth(jSteps, fWindowWidth - 16.0f);
    jSteps = NuiHeight(jSteps, 52.0f);
    jRootChildren = JsonArrayInsert(jRootChildren, jSteps);
    jRootChildren = JsonArrayInsert(
        jRootChildren,
        MoiViewMessage(MoiLoadoutSummary(oPC, jDraft), 28.0f)
    );

    json jBody = NuiGroup(jStage, FALSE, NUI_SCROLLBARS_AUTO);
    jBody = NuiWidth(jBody, fWindowWidth - 16.0f);
    jRootChildren = JsonArrayInsert(jRootChildren, jBody);

    jRootChildren = JsonArrayInsert(
        jRootChildren,
        MoiViewMessage("Status: " + sStatus, 42.0f)
    );
    json jFooter = NuiGroup(
        MoiViewFooter(oPC, jDraft, sValidation, nGeneration),
        FALSE,
        NUI_SCROLLBARS_AUTO
    );
    jFooter = NuiWidth(jFooter, fWindowWidth - 16.0f);
    jFooter = NuiHeight(jFooter, 52.0f);
    jRootChildren = JsonArrayInsert(jRootChildren, jFooter);

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
        JsonString("PRC8 Incarnum Loadout"),
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

    int nToken = NuiCreate(oPC, jWindow, PRC_MOI_LOADOUT_NUI_WINDOW_ID);
    if (!nToken)
    {
        MoiLoadoutDiscardDraft(oPC, FALSE);
        return;
    }

    json jGeometry = GetLocalJson(oPC, PRC_MOI_LOADOUT_GEOMETRY_VAR);
    float fWindowX = -1.0f;
    float fWindowY = -1.0f;
    if (jGeometry != JsonNull())
    {
        fWindowX = JsonGetFloat(JsonObjectGet(jGeometry, "x"));
        fWindowY = JsonGetFloat(JsonObjectGet(jGeometry, "y"));
    }
    jGeometry = NuiRect(
        fWindowX,
        fWindowY,
        fWindowWidth,
        fWindowHeight
    );

    NuiSetBind(oPC, nToken, "geometry", jGeometry);
    NuiSetBind(oPC, nToken, "resizable", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPC, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(oPC, nToken, "border", JsonBool(TRUE));
    NuiSetBindWatch(oPC, nToken, "geometry", TRUE);
}
