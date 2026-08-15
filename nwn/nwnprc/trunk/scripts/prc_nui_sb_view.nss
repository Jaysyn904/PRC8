//::///////////////////////////////////////////////
//:: PRC Spellbook NUI View
//:: prc_nui_sb_view
//:://////////////////////////////////////////////
/*
    This is the NUI view for the PRC Spellbook
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 24.05.2005
//:://////////////////////////////////////////////

//#include "nw_inc_nui_insp"
#include "prc_nui_sb_inc"
#include "prc_nui_consts"
#include "prc_nui_res_inc"

//
// CreateSpellBookClassButtons
// Gets the list of classes that have Spells, "Spells" and /Spells/ the player has
// that are allowed to use the NUI Spellbook.
//
// Returns:
//   json NuiRow the list of class buttons allowed to use the NUI Spellbook
//
json CreateSpellBookClassButtons();

//
// CreateSpellbookSpellButtons
// Creates the NUI buttons for the spells a player knows in the specified class
// and circle provided.
//
// Arguments:
//   nClass int the class currently being checked for spells
//   circle int the circle level of the spells we want to check for
//
// Returns:
//   json:Array<NuiRow> the list of NuiRows of spells we have memorized
//
json CreateSpellbookSpellButtons(int nClass, int circle);
json CreateNativeClassSpellButtons(int nClass, int circle);

// Creates spell buttons for only the Epic Spells currently readied through
// the PRC conversation menu. Readied Epic Spells are represented by their
// granted SpellFeatID on the character skin.
json CreateReadiedEpicSpellButtons();

// Character-wide Domains mode. Bonus-domain entries cast through PRC's
// existing level-feat/slot-child pipeline. Native prepared-domain entries are
// cast from their exact displayed class/level/domain preparation.
json CreateDomainHeaderRows();
json CreateDomainCircleButtons();
json CreateBonusDomainSpellButtons(int nLevel);
json CreateNativePreparedDomainSpellButtons(int nLevel);
json CreateDomainSectionLabel(string sText);
int HasBonusDomainSpellAtLevel(int nLevel);
int HasNativePreparedDomainSpellAtLevel(int nLevel);
int CanShowBonusDomainsInSpontaneousClassTab(int nClass, int nLevel);
string GetDomainRefreshState();
void RefreshDomainModeLoop(int nToken, string sPreviousState);
string GetSpellbookTabRefreshState();
void RefreshSpellbookTabLoop(int nToken, string sPreviousState);

//
// CreateSpellbookSpellButtons
// Creates the buttons for what circles the class is allowed to cast in
// ranging from Cantrips to 9th circle or equivalent for classes that don't have
// a concept of spell circles, like ToB and Psionics
//
// Arguments:
//   nClass int the class id this is being constructed for.
//
// Returns:
//   json NuiRow the level at which the caster can or does know as buttons
//
json CreateSpellbookCircleButtons(int nClass);

//
// CreateMetaMagicFeatButtons
// Takes a class and creates the appropriate meta feat buttons it can use or
// possibly use.
//
// Arguments:
//   nClass:int the ClassID we are checking
//
// Returns:
//   json:Array<NuiRow> the list of meta feats the class can use. Can return an
//     empty JsonArray if no meta feats are allowed for the class.
//
json CreateMetaMagicFeatButtons(int nClass);

//
// CreateMetaFeatButtonRow
// a helper function for CreateMetaMagicFeatButtons that takes a list of featIds
// and creates buttons for them.
//
// Arguments:
//   featList:json:Array<int> the list of featIDs to render
//
// Returns:
//   json:Array<NuiButtons> the row of buttons rendered for the FeatIDs.
//
json CreateMetaFeatButtonRow(json spellList);

void main()
{
    // look for existing window and destroy
    int nPreviousToken = NuiFindWindow(OBJECT_SELF, PRC_SPELLBOOK_NUI_WINDOW_ID);
    if(nPreviousToken != 0)
    {
        // Live spell/resource refreshes rebuild this window. Capture the
        // current geometry synchronously before destroying the old token so a
        // queued geometry watch event is not the only copy of its position.
        json jPreviousGeometry = NuiGetBind(OBJECT_SELF, nPreviousToken, "geometry");
        if (jPreviousGeometry != JsonNull())
            SetLocalJson(OBJECT_SELF, PRC_SPELLBOOK_NUI_GEOMETRY_VAR, jPreviousGeometry);
        NuiDestroy(OBJECT_SELF, nPreviousToken);
    }
    DeleteLocalJson(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_BUTTON_MAP_VAR);

    json jRoot = JsonArray();
    json jRow = CreateSpellBookClassButtons();
    jRoot = JsonArrayInsert(jRoot, jRow);

    int selectedClassId = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);
    int nSelectedMode = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_MODE_VAR);
    int bHasDomainContent = NUISpellbookHasDomainContent(OBJECT_SELF);

    if (nSelectedMode == PRC_SPELLBOOK_MODE_DOMAIN && !bHasDomainContent)
    {
        nSelectedMode = PRC_SPELLBOOK_MODE_CLASS;
        SetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_MODE_VAR, nSelectedMode);
    }

    // Character-wide resources remain visible regardless of which spellbook
    // class is selected. This is important for combinations such as a native
    // Sorcerer/Wilder, where Sorcerer is not itself a PRC spellbook tab.
    json jResourceRows = NUIResourceCreateSpellbookRows(OBJECT_SELF, selectedClassId);
    int nResourceRow;
    for (nResourceRow = 0; nResourceRow < JsonGetLength(jResourceRows); nResourceRow++)
        jRoot = JsonArrayInsert(jRoot, JsonArrayGet(jResourceRows, nResourceRow));

    if (nSelectedMode == PRC_SPELLBOOK_MODE_DOMAIN && bHasDomainContent)
    {
        jRow = CreateDomainHeaderRows();
        int i;
        for (i = 0; i < JsonGetLength(jRow); i++)
            jRoot = JsonArrayInsert(jRoot, JsonArrayGet(jRow, i));

        jRoot = JsonArrayInsert(jRoot, CreateDomainCircleButtons());

        int nDomainLevel = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR);
        if (NUISpellbookHasBonusDomains(OBJECT_SELF))
        {
            jRow = CreateBonusDomainSpellButtons(nDomainLevel);
            for (i = 0; i < JsonGetLength(jRow); i++)
                jRoot = JsonArrayInsert(jRoot, JsonArrayGet(jRow, i));
        }

        if (NUISpellbookHasNativePreparedDomainSpells(OBJECT_SELF))
        {
            jRoot = JsonArrayInsert(jRoot, CreateDomainSectionLabel("Native Prepared Domain Spells"));
            jRow = CreateNativePreparedDomainSpellButtons(nDomainLevel);
            for (i = 0; i < JsonGetLength(jRow); i++)
                jRoot = JsonArrayInsert(jRoot, JsonArrayGet(jRow, i));
        }
    }
    // GetLocalInt returns 0 if not set, which is Barb class which conveniently doesn't have spells :)
    // if there was no selected class then there is nothing to render
    else if (selectedClassId != CLASS_TYPE_BARBARIAN)
    {
        // create the metamagic/metapsionic/metamystery/sudden buttons if applicable
        // suddens are on their own row so its possible we can have 2 NuiRows in the list
        jRow = CreateMetaMagicFeatButtons(selectedClassId);
        int i;
        for(i = 0; i < JsonGetLength(jRow); i++)
        {
            jRoot = JsonArrayInsert(jRoot, JsonArrayGet(jRow, i));
        }

        // create the spell/feat circle buttons for the class (most use 0-9, but
        // ToB uses something similar that ranges from 1-9 and Invokers essentially
        // go 1-4 as examples
        jRow = CreateSpellbookCircleButtons(selectedClassId);
        jRoot = JsonArrayInsert(jRoot, jRow);

        // Get the currently selected circle's spell buttons
        int currentCircle = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR);
        if (currentCircle == PRC_SPELLBOOK_NUI_EPIC_CIRCLE)
            jRow = CreateReadiedEpicSpellButtons();
        else
            jRow = CreateSpellbookSpellButtons(selectedClassId, currentCircle);

        // since we limit how many buttons a row can have here we need to add
        // multiple NuiRows if they exist
        for(i = 0; i < JsonGetLength(jRow); i++)
        {
            jRoot = JsonArrayInsert(jRoot, JsonArrayGet(jRow, i));
        }

        // PRC bonus domains are character-wide, but a spontaneous divine
        // caster pays for them with ordinary spell slots. Keep those choices
        // beside the spells they trade. The existing button IDs still route
        // through CastDomainSpell, which remains authoritative for spending.
        if (NUISpellbookHasBonusDomains(OBJECT_SELF)
            && HasBonusDomainSpellAtLevel(currentCircle)
            && CanShowBonusDomainsInSpontaneousClassTab(selectedClassId, currentCircle))
        {
            jRow = CreateBonusDomainSpellButtons(currentCircle);
            for(i = 0; i < JsonGetLength(jRow); i++)
                jRoot = JsonArrayInsert(jRoot, JsonArrayGet(jRow, i));
        }
    }

    jRoot = NuiCol(jRoot);

    string title = "PRC8 Spellbook";

    if (nSelectedMode == PRC_SPELLBOOK_MODE_DOMAIN && bHasDomainContent)
        title = title + ": Domains";
    else if (selectedClassId != CLASS_TYPE_BARBARIAN)
        title = title + ": " + GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", selectedClassId)));

    // This is the main window with jRoot as the main pane.  It includes titles and parameters (more on those later)
    json nui = NuiWindow(jRoot, JsonString(title), NuiBind("geometry"), NuiBind("resizable"), NuiBind("collapsed"), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"),JSON_NULL,JSON_NULL, NuiBind("edgeConstraint"));

    // finally create it and it'll return us a non-zero token.
    int nToken = NuiCreate(OBJECT_SELF, nui, PRC_SPELLBOOK_NUI_WINDOW_ID);

    // get the geometry of the window in case we opened this before and have a
    // preference for location
    json geometry = GetLocalJson(OBJECT_SELF, PRC_SPELLBOOK_NUI_GEOMETRY_VAR);
    
    // Default to put this near the middle and let the person adjust its location
    if (geometry == JsonNull())
    {
        geometry = NuiRect(-1.0f,-1.0f, 680.0f, 351.0f + NUIResourceGetSpellbookLayoutHeight(OBJECT_SELF, selectedClassId));
    }
    else
    {
        float x = JsonGetFloat(JsonObjectGet(geometry, "x"));
        float y = JsonGetFloat(JsonObjectGet(geometry, "y"));				
		
		float WINDOW_WIDTH = 680.0f;
        float WINDOW_HEIGHT = 351.0f + NUIResourceGetSpellbookLayoutHeight(OBJECT_SELF, selectedClassId);
		
        geometry = NuiRect(x, y, WINDOW_WIDTH, WINDOW_HEIGHT);
    }

    float QUICKBAR_HEIGHT_ESTIMATE = 40.0f;
	float CHAT_BAR_ESTIMATE = 20.0f;
    float MIN_BOTTOM_PADDING = 10.0f;
	
	int uiScale = GetPlayerDeviceProperty(OBJECT_SELF, PLAYER_DEVICE_PROPERTY_GUI_SCALE); 
    float scale = IntToFloat(uiScale) / 100.0f; 

    float bottomSize = QUICKBAR_HEIGHT_ESTIMATE * scale + CHAT_BAR_ESTIMATE * scale + MIN_BOTTOM_PADDING;
	float screenW = IntToFloat(GetPlayerDeviceProperty(OBJECT_SELF, PLAYER_DEVICE_PROPERTY_GUI_WIDTH));
    float screenH = IntToFloat(GetPlayerDeviceProperty(OBJECT_SELF, PLAYER_DEVICE_PROPERTY_GUI_HEIGHT));
	
    json edgeConstraint = NuiRect(0.0f,0.0f, 0.0f, bottomSize);
	
	//json edgeConstraint = NuiRect(0.0f, 0.0f, 0.0f, 0.0f);
    // Set the binds to their default values
    NuiSetBind(OBJECT_SELF, nToken, "geometry", geometry);
    NuiSetBind(OBJECT_SELF, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(OBJECT_SELF, nToken, "resizable", JsonBool(FALSE));
    NuiSetBind(OBJECT_SELF, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(OBJECT_SELF, nToken, "transparent", JsonBool(TRUE));
    NuiSetBind(OBJECT_SELF, nToken, "border", JsonBool(FALSE));		
	NuiSetBind(OBJECT_SELF, nToken, "edgeConstraint", edgeConstraint);		      
	
    NuiSetBindWatch(OBJECT_SELF, nToken, "geometry", TRUE);

    NUIResourceRefreshToken(OBJECT_SELF, nToken);
    NUIResourceRefreshSpellbookLoop(OBJECT_SELF, nToken);
    if ((nSelectedMode == PRC_SPELLBOOK_MODE_DOMAIN && bHasDomainContent)
        || (nSelectedMode == PRC_SPELLBOOK_MODE_CLASS
            && NUISpellbookHasBonusDomains(OBJECT_SELF)
            && CanShowBonusDomainsInSpontaneousClassTab(
                selectedClassId,
                GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR)
            )))
        DelayCommand(1.0f, RefreshDomainModeLoop(nToken, GetDomainRefreshState()));

    if (nSelectedMode == PRC_SPELLBOOK_MODE_CLASS
        && (NUISpellbookUsesNativeClassAdapter(OBJECT_SELF, selectedClassId)
            || selectedClassId == CLASS_TYPE_BINDER))
        DelayCommand(1.0f, RefreshSpellbookTabLoop(nToken, GetSpellbookTabRefreshState()));
}

json CreateSpellBookClassButtons()
{
    json jRow = JsonArray();
    // Get all the Classes that can use the NUI Spellbook
    json classList = GetSupportedNUISpellbookClasses(OBJECT_SELF);

    // if we have selected a class already due to re-rendering, we need to disable
    // the button for it.
    int selectedClassId = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);
    int nSelectedMode = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_MODE_VAR);
    int bHasDomainContent = NUISpellbookHasDomainContent(OBJECT_SELF);

    if (JsonGetLength(classList) == 0 && bHasDomainContent)
    {
        nSelectedMode = PRC_SPELLBOOK_MODE_DOMAIN;
        SetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_MODE_VAR, nSelectedMode);
    }

    int i;
    for (i = 0; i < JsonGetLength(classList); i++)
    {
        int classId = JsonGetInt(JsonArrayGet(classList, i));

        // if the selected class doen't exist, automatically use the first class allowed
        if (selectedClassId == 0)
        {
            selectedClassId = classId;
            SetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CLASSID_VAR, selectedClassId);
        }
        float width = 32.0f;
        float height = 32.0f;
        // Get the class icon from the classes.2da
        json jClassButton = NuiId(NuiButtonImage(JsonString(Get2DACache("classes", "Icon", classId))), PRC_SPELLBOOK_NUI_CLASS_BUTTON_BASEID + IntToString(classId));
        if (classId != selectedClassId || nSelectedMode == PRC_SPELLBOOK_MODE_DOMAIN)
            jClassButton = GreyOutButton(jClassButton, width, height);
        jClassButton = NuiWidth(jClassButton, width);
        jClassButton = NuiHeight(jClassButton, height);
        // Get the class name from the classes.2da and set it to the tooltip
        jClassButton = NuiTooltip(jClassButton, JsonString(GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", classId)))));

        jRow = JsonArrayInsert(jRow, jClassButton);
    }

    if (bHasDomainContent)
    {
        float width = 32.0f;
        float height = 32.0f;
        string sDomainIcon = Get2DACache("feat", "ICON", FEAT_CHECK_DOMAIN_SLOTS);
        json jDomainButton = NuiId(
            NuiButtonImage(JsonString(sDomainIcon)),
            PRC_SPELLBOOK_NUI_DOMAIN_MODE_BUTTON
        );
        jDomainButton = NuiWidth(jDomainButton, width);
        jDomainButton = NuiHeight(jDomainButton, height);
        jDomainButton = NuiTooltip(jDomainButton, JsonString("Domains"));

        if (nSelectedMode != PRC_SPELLBOOK_MODE_DOMAIN)
            jDomainButton = GreyOutButton(jDomainButton, width, height);

        jRow = JsonArrayInsert(jRow, jDomainButton);
    }

    jRow = NuiRow(jRow);

    return jRow;
}

json CreateDomainSectionLabel(string sText)
{
    json jRow = JsonArray();
    json jLabel = NuiLabel(
        JsonString(sText),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jLabel = NuiWidth(jLabel, 650.0f);
    jLabel = NuiHeight(jLabel, 20.0f);
    jRow = JsonArrayInsert(jRow, jLabel);
    return NuiRow(jRow);
}

string GetDomainRefreshState()
{
    string sState = "P" + IntToString(GetLocalInt(OBJECT_SELF, "DomainCast")) + ";";
    int nSlot;
    for (nSlot = 1; nSlot <= 5; nSlot++)
        sState += "B" + IntToString(nSlot) + ":" + IntToString(GetBonusDomain(OBJECT_SELF, nSlot)) + ";";

    int nLevel;
    for (nLevel = 1; nLevel <= 9; nLevel++)
    {
        sState += "U" + IntToString(nLevel) + ":"
               + IntToString(GetLocalInt(OBJECT_SELF, "DomainCastSpell" + IntToString(nLevel))) + ":"
               + IntToString(GetHasFeat(SpellLevelToFeat(nLevel), OBJECT_SELF)) + ";";
    }

    int nPosition = 1;
    int nClass = GetClassByPosition(nPosition, OBJECT_SELF);
    while (nClass != CLASS_TYPE_INVALID)
    {
        if (StringToInt(Get2DACache("classes", "PickDomains", nClass)))
        {
            sState += "D" + IntToString(nClass) + ":"
                   + IntToString(GetDomain(OBJECT_SELF, 1, nClass)) + ":"
                   + IntToString(GetDomain(OBJECT_SELF, 2, nClass)) + ";";
        }

        if (StringToInt(Get2DACache("classes", "MemorizesSpells", nClass)))
        {
            for (nLevel = 1; nLevel <= 9; nLevel++)
            {
                int nCount = GetMemorizedSpellCountByLevel(OBJECT_SELF, nClass, nLevel);
                int nIndex;
                for (nIndex = 0; nIndex < nCount; nIndex++)
                {
                    if (GetMemorizedSpellIsDomainSpell(OBJECT_SELF, nClass, nLevel, nIndex) == TRUE)
                    {
                        sState += "N" + IntToString(nClass) + ":"
                               + IntToString(nLevel) + ":"
                               + IntToString(nIndex) + ":"
                               + IntToString(GetMemorizedSpellId(OBJECT_SELF, nClass, nLevel, nIndex)) + ":"
                               + IntToString(GetMemorizedSpellReady(OBJECT_SELF, nClass, nLevel, nIndex)) + ":"
                               + IntToString(GetMemorizedSpellMetaMagic(OBJECT_SELF, nClass, nLevel, nIndex)) + ";";
                    }
                }
            }
        }

        nPosition++;
        nClass = GetClassByPosition(nPosition, OBJECT_SELF);
    }

    return sState;
}

void RefreshDomainModeLoop(int nToken, string sPreviousState)
{
    if (NuiFindWindow(OBJECT_SELF, PRC_SPELLBOOK_NUI_WINDOW_ID) != nToken)
        return;

    int nSelectedMode = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_MODE_VAR);
    int bTracksDomainState = nSelectedMode == PRC_SPELLBOOK_MODE_DOMAIN;
    if (nSelectedMode == PRC_SPELLBOOK_MODE_CLASS)
    {
        bTracksDomainState = CanShowBonusDomainsInSpontaneousClassTab(
            GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CLASSID_VAR),
            GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR)
        );
    }

    if (!bTracksDomainState)
        return;

    string sCurrentState = GetDomainRefreshState();
    if (sCurrentState != sPreviousState)
    {
        // Rebuild only when domain state actually changes. A bonus-domain use is
        // marked by the spell hook after the cast completes, so this cannot
        // interrupt the targeting mode used to select that spell's target.
        ExecuteScript("prc_nui_sb_view", OBJECT_SELF);
        return;
    }

    DelayCommand(1.0f, RefreshDomainModeLoop(nToken, sCurrentState));
}

string GetSpellbookTabRefreshState()
{
    int nClass = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);
    int nCircle = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR);
    string sState = IntToString(nClass) + ":" + IntToString(nCircle) + ";";

    if (nClass == CLASS_TYPE_BINDER)
    {
        json jDict = GetBinderSpellToFeatDictionary(OBJECT_SELF);
        json jKeys = JsonObjectKeys(jDict);
        int i;
        for (i = 0; i < JsonGetLength(jKeys); i++)
        {
            string sKey = JsonGetString(JsonArrayGet(jKeys, i));
            if (IsBinderSpellActive(OBJECT_SELF, StringToInt(sKey)))
                sState += sKey + ",";
        }
        return sState;
    }

    if (!NUISpellbookUsesNativeClassAdapter(OBJECT_SELF, nClass))
        return sState;

    int nLevel;
    if (NUISpellbookIsNativePreparedClass(nClass))
    {
        for (nLevel = 0; nLevel <= 9; nLevel++)
        {
            int nCount = GetMemorizedSpellCountByLevel(OBJECT_SELF, nClass, nLevel);
            sState += "L" + IntToString(nLevel) + "=" + IntToString(nCount) + ":";
            int nIndex;
            for (nIndex = 0; nIndex < nCount; nIndex++)
            {
                sState += IntToString(GetMemorizedSpellId(OBJECT_SELF, nClass, nLevel, nIndex)) + "/"
                       + IntToString(GetMemorizedSpellReady(OBJECT_SELF, nClass, nLevel, nIndex)) + "/"
                       + IntToString(GetMemorizedSpellMetaMagic(OBJECT_SELF, nClass, nLevel, nIndex)) + "/"
                       + IntToString(GetMemorizedSpellIsDomainSpell(OBJECT_SELF, nClass, nLevel, nIndex)) + ",";
            }
        }
    }
    else
    {
        for (nLevel = 0; nLevel <= 9; nLevel++)
        {
            int nKnown = GetKnownSpellCount(OBJECT_SELF, nClass, nLevel);
            sState += "L" + IntToString(nLevel) + "=" + IntToString(nKnown) + ":";
            int nIndex;
            for (nIndex = 0; nIndex < nKnown; nIndex++)
            {
                int nSpell = GetKnownSpellId(OBJECT_SELF, nClass, nLevel, nIndex);
                sState += IntToString(nSpell) + "/"
                       + IntToString(GetSpellUsesLeft(OBJECT_SELF, nClass, nSpell)) + ",";
            }
        }
    }

    return sState;
}

void RefreshSpellbookTabLoop(int nToken, string sPreviousState)
{
    if (NuiFindWindow(OBJECT_SELF, PRC_SPELLBOOK_NUI_WINDOW_ID) != nToken
        || GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_MODE_VAR) != PRC_SPELLBOOK_MODE_CLASS)
        return;

    int nClass = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);
    if (!NUISpellbookUsesNativeClassAdapter(OBJECT_SELF, nClass)
        && nClass != CLASS_TYPE_BINDER)
        return;

    string sCurrentState = GetSpellbookTabRefreshState();
    if (sCurrentState != sPreviousState)
    {
        ExecuteScript("prc_nui_sb_view", OBJECT_SELF);
        return;
    }

    DelayCommand(1.0f, RefreshSpellbookTabLoop(nToken, sCurrentState));
}

int HasBonusDomainSpellAtLevel(int nLevel)
{
    int nSlot;
    for (nSlot = 1; nSlot <= 5; nSlot++)
    {
        if (NUISpellbookGetBonusDomainSpell(OBJECT_SELF, nSlot, nLevel) >= 0)
            return TRUE;
    }

    return FALSE;
}

int HasNativePreparedDomainSpellAtLevel(int nLevel)
{
    int nPosition = 1;
    int nClass = GetClassByPosition(nPosition, OBJECT_SELF);

    while (nClass != CLASS_TYPE_INVALID)
    {
        if (StringToInt(Get2DACache("classes", "MemorizesSpells", nClass)))
        {
            int nCount = GetMemorizedSpellCountByLevel(OBJECT_SELF, nClass, nLevel);
            int nIndex;
            for (nIndex = 0; nIndex < nCount; nIndex++)
            {
                if (GetMemorizedSpellIsDomainSpell(OBJECT_SELF, nClass, nLevel, nIndex) == TRUE
                    && GetMemorizedSpellId(OBJECT_SELF, nClass, nLevel, nIndex) >= 0)
                    return TRUE;
            }
        }

        nPosition++;
        nClass = GetClassByPosition(nPosition, OBJECT_SELF);
    }

    return FALSE;
}

int CanShowBonusDomainsInSpontaneousClassTab(int nClass, int nLevel)
{
    return nLevel >= 1
        && nLevel <= 9
        && GetIsDivineClass(nClass, OBJECT_SELF)
        && GetSpellbookTypeForClass(nClass) == SPELLBOOK_TYPE_SPONTANEOUS;
}

json CreateDomainHeaderRows()
{
    json jRows = JsonArray();

    if (NUISpellbookHasBonusDomains(OBJECT_SELF))
    {
        json jBonusRow = JsonArray();
        json jLabel = NuiLabel(
            JsonString("Bonus Domains"),
            JsonInt(NUI_HALIGN_LEFT),
            JsonInt(NUI_VALIGN_MIDDLE)
        );
        jLabel = NuiWidth(jLabel, 105.0f);
        jLabel = NuiHeight(jLabel, 32.0f);
        jBonusRow = JsonArrayInsert(jBonusRow, jLabel);

        int nSlot;
        for (nSlot = 1; nSlot <= 5; nSlot++)
        {
            int nDomain = GetBonusDomain(OBJECT_SELF, nSlot);
            if (nDomain > 0)
            {
                string sIcon = Get2DACache("domains", "Icon", nDomain - 1);
                json jIcon = NuiImage(
                    JsonString(sIcon),
                    JsonInt(NUI_ASPECT_FIT),
                    JsonInt(NUI_HALIGN_LEFT),
                    JsonInt(NUI_VALIGN_MIDDLE)
                );
                jIcon = NuiWidth(jIcon, 32.0f);
                jIcon = NuiHeight(jIcon, 32.0f);
                jIcon = NuiTooltip(jIcon, JsonString(
                    "Slot " + IntToString(nSlot) + ": " + GetDomainName(nDomain)
                ));
                jBonusRow = JsonArrayInsert(jBonusRow, jIcon);
            }
        }

        jRows = JsonArrayInsert(jRows, NuiRow(jBonusRow));
    }

    if (NUISpellbookHasNativeDomains(OBJECT_SELF))
    {
        json jNativeRow = JsonArray();
        json jNativeLabel = NuiLabel(
            JsonString("Native Domains"),
            JsonInt(NUI_HALIGN_LEFT),
            JsonInt(NUI_VALIGN_MIDDLE)
        );
        jNativeLabel = NuiWidth(jNativeLabel, 105.0f);
        jNativeLabel = NuiHeight(jNativeLabel, 32.0f);
        jNativeRow = JsonArrayInsert(jNativeRow, jNativeLabel);

        int nPosition = 1;
        int nClass = GetClassByPosition(nPosition, OBJECT_SELF);
        while (nClass != CLASS_TYPE_INVALID)
        {
            if (StringToInt(Get2DACache("classes", "PickDomains", nClass)))
            {
                int nDomainIndex;
                for (nDomainIndex = 1; nDomainIndex <= 2; nDomainIndex++)
                {
                    int nDomain = GetDomain(OBJECT_SELF, nDomainIndex, nClass);
                    if (nDomain >= 0)
                    {
                        string sIcon = Get2DACache("domains", "Icon", nDomain);
                        string sName = GetStringByStrRef(StringToInt(
                            Get2DACache("domains", "Name", nDomain)
                        ));
                        string sClassName = GetStringByStrRef(StringToInt(
                            Get2DACache("classes", "Name", nClass)
                        ));

                        json jIcon = NuiImage(
                            JsonString(sIcon),
                            JsonInt(NUI_ASPECT_FIT),
                            JsonInt(NUI_HALIGN_LEFT),
                            JsonInt(NUI_VALIGN_MIDDLE)
                        );
                        jIcon = NuiWidth(jIcon, 32.0f);
                        jIcon = NuiHeight(jIcon, 32.0f);
                        jIcon = NuiTooltip(jIcon, JsonString(sClassName + ": " + sName));
                        jNativeRow = JsonArrayInsert(jNativeRow, jIcon);
                    }
                }
            }

            nPosition++;
            nClass = GetClassByPosition(nPosition, OBJECT_SELF);
        }

        jRows = JsonArrayInsert(jRows, NuiRow(jNativeRow));
    }

    return jRows;
}

json CreateDomainCircleButtons()
{
    json jRow = JsonArray();
    int nPendingDomainCast = GetLocalInt(OBJECT_SELF, "DomainCast");
    int nCurrentLevel = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR);
    if (nCurrentLevel < 1 || nCurrentLevel > 9)
    {
        nCurrentLevel = 1;
        SetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR, nCurrentLevel);
    }

    int nLevel;
    for (nLevel = 1; nLevel <= 9; nLevel++)
    {
        float width = 42.0f;
        float height = 42.0f;
        json jButton = NuiId(
            NuiButtonImage(JsonString(GetSpellLevelIcon(nLevel))),
            PRC_SPELLBOOK_NUI_CIRCLE_BUTTON_BASEID + IntToString(nLevel)
        );
        jButton = NuiWidth(jButton, width);
        jButton = NuiHeight(jButton, height);

        string sTooltip = GetSpellLevelToolTip(nLevel);
        if (HasBonusDomainSpellAtLevel(nLevel))
        {
            if (nPendingDomainCast)
                sTooltip += " - bonus-domain cast pending";
            else if (GetLocalInt(OBJECT_SELF, "DomainCastSpell" + IntToString(nLevel)))
                sTooltip += " - bonus-domain use spent";
            else if (!GetHasFeat(SpellLevelToFeat(nLevel), OBJECT_SELF))
                sTooltip += " - bonus-domain level not unlocked";
            else
                sTooltip += " - bonus-domain use ready";
        }
        jButton = NuiTooltip(jButton, JsonString(sTooltip));

        int bHasContent = HasBonusDomainSpellAtLevel(nLevel)
                       || HasNativePreparedDomainSpellAtLevel(nLevel);
        int bBonusOnlySpent = HasBonusDomainSpellAtLevel(nLevel)
                           && !HasNativePreparedDomainSpellAtLevel(nLevel)
                           && GetLocalInt(OBJECT_SELF, "DomainCastSpell" + IntToString(nLevel));
        if (nLevel != nCurrentLevel || !bHasContent || bBonusOnlySpent)
            jButton = GreyOutButton(jButton, width, height);

        jRow = JsonArrayInsert(jRow, jButton);
    }

    return NuiRow(jRow);
}

json CreateBonusDomainSpellButtons(int nLevel)
{
    json jRows = JsonArray();
    json jTempRow = JsonArray();
    int nCastFeat = SpellLevelToFeat(nLevel);
    int nPendingDomainCast = GetLocalInt(OBJECT_SELF, "DomainCast");
    int bReady = nCastFeat > 0
              && GetHasFeat(nCastFeat, OBJECT_SELF)
              && !nPendingDomainCast
              && !GetLocalInt(OBJECT_SELF, "DomainCastSpell" + IntToString(nLevel));

    int nSlot;
    for (nSlot = 1; nSlot <= 5; nSlot++)
    {
        int nSpell = NUISpellbookGetBonusDomainSpell(OBJECT_SELF, nSlot, nLevel);
        if (nSpell >= 0)
        {
            int nDomain = GetBonusDomain(OBJECT_SELF, nSlot);
            int nCode = nSlot * 10 + nLevel;
            json jButton = NuiId(
                NuiButtonImage(GetSpellIcon(nSpell)),
                PRC_SPELLBOOK_NUI_DOMAIN_SPELL_BUTTON_BASEID + IntToString(nCode)
            );
            jButton = NuiWidth(jButton, 38.0f);
            jButton = NuiHeight(jButton, 38.0f);

            string sTooltip = GetDomainName(nDomain) + ": " + GetSpellName(nSpell);
            if (bReady)
                sTooltip += " - burns one level " + IntToString(nLevel) + " spell slot";
            else if (nPendingDomainCast)
                sTooltip += " - another domain spell is awaiting completion";
            else if (GetLocalInt(OBJECT_SELF, "DomainCastSpell" + IntToString(nLevel)))
                sTooltip += " - domain use spent";
            else
                sTooltip += " - domain level not unlocked";
            jButton = NuiTooltip(jButton, JsonString(sTooltip));

            if (!bReady)
                jButton = GreyOutButton(jButton, 38.0f, 38.0f);

            jTempRow = JsonArrayInsert(jTempRow, jButton);
        }
    }

    if (JsonGetLength(jTempRow) > 0)
        jRows = JsonArrayInsert(jRows, NuiRow(jTempRow));
    else
        jRows = JsonArrayInsert(jRows, CreateDomainSectionLabel("No bonus-domain spell at this level."));

    return jRows;
}

json CreateNativePreparedDomainSpellButtons(int nLevel)
{
    json jRows = JsonArray();
    json jTempRow = JsonArray();
    int nPosition = 1;
    int nClass = GetClassByPosition(nPosition, OBJECT_SELF);

    while (nClass != CLASS_TYPE_INVALID)
    {
        if (StringToInt(Get2DACache("classes", "MemorizesSpells", nClass)))
        {
            int nCount = GetMemorizedSpellCountByLevel(OBJECT_SELF, nClass, nLevel);
            int nIndex;
            for (nIndex = 0; nIndex < nCount; nIndex++)
            {
                if (GetMemorizedSpellIsDomainSpell(OBJECT_SELF, nClass, nLevel, nIndex) == TRUE)
                {
                    int nSpell = GetMemorizedSpellId(OBJECT_SELF, nClass, nLevel, nIndex);
                    if (nSpell >= 0)
                    {
                        int bReady = GetMemorizedSpellReady(OBJECT_SELF, nClass, nLevel, nIndex) == TRUE;
                        int nMetamagic = GetMemorizedSpellMetaMagic(OBJECT_SELF, nClass, nLevel, nIndex);
                        int nCode = nClass * 10000 + nLevel * 1000 + nIndex;
                        json jButton = NuiId(
                            NuiButtonImage(GetSpellIcon(nSpell)),
                            PRC_SPELLBOOK_NUI_NATIVE_DOMAIN_SPELL_BUTTON_BASEID + IntToString(nCode)
                        );
                        jButton = NuiWidth(jButton, 38.0f);
                        jButton = NuiHeight(jButton, 38.0f);

                        string sClassName = GetStringByStrRef(StringToInt(
                            Get2DACache("classes", "Name", nClass)
                        ));
                        string sTooltip = sClassName + ": " + GetSpellName(nSpell);
                        if (nMetamagic > METAMAGIC_NONE)
                            sTooltip += " (" + GetMetaMagicString(nMetamagic) + ")";
                        sTooltip += bReady ? " - Ready" : " - Expended";
                        if (bReady && Get2DACache("spells", "SubRadSpell1", nSpell) != "")
                            sTooltip += " - choose its variant from the native spellbook";
                        else if (bReady)
                            sTooltip += " - left-click to cast this exact slot";
                        jButton = NuiTooltip(jButton, JsonString(sTooltip));

                        if (!bReady)
                            jButton = GreyOutButton(jButton, 38.0f, 38.0f);

                        jTempRow = JsonArrayInsert(jTempRow, jButton);
                        if (JsonGetLength(jTempRow) >= NUI_SPELLBOOK_SPELL_BUTTON_LENGTH)
                        {
                            jRows = JsonArrayInsert(jRows, NuiRow(jTempRow));
                            jTempRow = JsonArray();
                        }
                    }
                }
            }
        }

        nPosition++;
        nClass = GetClassByPosition(nPosition, OBJECT_SELF);
    }

    if (JsonGetLength(jTempRow) > 0)
        jRows = JsonArrayInsert(jRows, NuiRow(jTempRow));
    else if (JsonGetLength(jRows) == 0)
        jRows = JsonArrayInsert(jRows, CreateDomainSectionLabel("No native domain spell prepared at this level."));

    return jRows;
}

json CreateSpellbookCircleButtons(int nClass)
{
    json jRow = JsonArray();
    int i;
    // Get the current selected circle and the class caster level.
    int currentCircle = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR);

    if (NUISpellbookUsesNativeClassAdapter(OBJECT_SELF, nClass))
    {
        int nFirstCircle = -1;
        for (i = 0; i <= 9; i++)
        {
            if (NUISpellbookNativeLevelHasContent(OBJECT_SELF, nClass, i))
            {
                if (nFirstCircle < 0)
                    nFirstCircle = i;

                float width = 42.0f;
                float height = 42.0f;
                json jButton = NuiId(
                    NuiButtonImage(JsonString(GetSpellLevelIcon(i))),
                    PRC_SPELLBOOK_NUI_CIRCLE_BUTTON_BASEID + IntToString(i)
                );
                jButton = NuiWidth(jButton, width);
                jButton = NuiHeight(jButton, height);
                jButton = NuiTooltip(jButton, JsonString(GetSpellLevelToolTip(i)));
                if (i != currentCircle)
                    jButton = GreyOutButton(jButton, width, height);
                jRow = JsonArrayInsert(jRow, jButton);
            }
        }

        if (nFirstCircle >= 0
            && !NUISpellbookNativeLevelHasContent(OBJECT_SELF, nClass, currentCircle)
            && !(currentCircle == PRC_SPELLBOOK_NUI_EPIC_CIRCLE
                && NUIResourceHasEpicSpells(OBJECT_SELF)))
        {
            currentCircle = nFirstCircle;
            SetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR, currentCircle);

            // Rebuild the buttons once so the newly selected first circle is
            // visually active instead of retaining the stale grey state.
            jRow = JsonArray();
            for (i = 0; i <= 9; i++)
            {
                if (NUISpellbookNativeLevelHasContent(OBJECT_SELF, nClass, i))
                {
                    float width = 42.0f;
                    float height = 42.0f;
                    json jButton = NuiId(
                        NuiButtonImage(JsonString(GetSpellLevelIcon(i))),
                        PRC_SPELLBOOK_NUI_CIRCLE_BUTTON_BASEID + IntToString(i)
                    );
                    jButton = NuiWidth(jButton, width);
                    jButton = NuiHeight(jButton, height);
                    jButton = NuiTooltip(jButton, JsonString(GetSpellLevelToolTip(i)));
                    if (i != currentCircle)
                        jButton = GreyOutButton(jButton, width, height);
                    jRow = JsonArrayInsert(jRow, jButton);
                }
            }
        }

        if (NUIResourceHasEpicSpells(OBJECT_SELF))
        {
            float width = 42.0f;
            float height = 42.0f;
            json jEpicButton = NuiId(
                NuiButtonImage(JsonString(GetSpellLevelIcon(PRC_SPELLBOOK_NUI_EPIC_CIRCLE))),
                PRC_SPELLBOOK_NUI_CIRCLE_BUTTON_BASEID + IntToString(PRC_SPELLBOOK_NUI_EPIC_CIRCLE)
            );
            jEpicButton = NuiWidth(jEpicButton, width);
            jEpicButton = NuiHeight(jEpicButton, height);
            jEpicButton = NuiTooltip(jEpicButton, JsonString(GetSpellLevelToolTip(PRC_SPELLBOOK_NUI_EPIC_CIRCLE)));
            if (currentCircle != PRC_SPELLBOOK_NUI_EPIC_CIRCLE)
                jEpicButton = GreyOutButton(jEpicButton, width, height);
            jRow = JsonArrayInsert(jRow, jEpicButton);
        }

        return NuiRow(jRow);
    }

    int casterLevel = GetCasterLevelByClass(nClass, OBJECT_SELF);

    // Get what the lowest level of a circle is for the class (some start at 1,
    // some start higher, some start at cantrips)
    int minSpellLevel = GetMinSpellLevel(nClass);

    if (minSpellLevel >= 0)
    {

        // Get what the max circle the class can reach at is
        int totalMaxSpellLevel = GetMaxSpellLevel(nClass);

        // if the current circle is less than the minimum level (possibly due to
        // switching classes) then set it to that.
        if (currentCircle < minSpellLevel)
        {
            currentCircle = minSpellLevel;
            SetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR, currentCircle);
        }

        // conversily if it is higher than the max the class has (possibly due to
        // switching classes) then set it to that.
        int bHasEpicCircle = NUIResourceHasEpicSpells(OBJECT_SELF);
        if (currentCircle > totalMaxSpellLevel
            && !(bHasEpicCircle && currentCircle == PRC_SPELLBOOK_NUI_EPIC_CIRCLE))
        {
            currentCircle = totalMaxSpellLevel;
            SetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR, currentCircle);
        }

        for (i = minSpellLevel; i <= totalMaxSpellLevel; i++)
        {
            json enabled;
            json jButton = NuiId(NuiButtonImage(JsonString(GetSpellLevelIcon(i))), PRC_SPELLBOOK_NUI_CIRCLE_BUTTON_BASEID + IntToString(i));
            float width = 42.0f;
            float height = 42.0f;
            jButton = NuiWidth(jButton, width);
            jButton = NuiHeight(jButton, height);
            jButton = NuiTooltip(jButton, JsonString(GetSpellLevelToolTip(i)));

            // if the current circle is selected or if the person can't cast at
            // that circle yet then disable the button.

            if (i != currentCircle)
                jButton = GreyOutButton(jButton, width, height);


            jRow = JsonArrayInsert(jRow, jButton);
        }

        // Epic spell preparation is character-wide, but the tab belongs beside
        // levels 0-9 in whichever spellbook is currently open. The stock plus
        // icon remains useful here because this is the extra Epic circle.
        if (bHasEpicCircle)
        {
            float width = 42.0f;
            float height = 42.0f;
            json jEpicButton = NuiId(
                NuiButtonImage(JsonString(GetSpellLevelIcon(PRC_SPELLBOOK_NUI_EPIC_CIRCLE))),
                PRC_SPELLBOOK_NUI_CIRCLE_BUTTON_BASEID + IntToString(PRC_SPELLBOOK_NUI_EPIC_CIRCLE)
            );
            jEpicButton = NuiWidth(jEpicButton, width);
            jEpicButton = NuiHeight(jEpicButton, height);
            jEpicButton = NuiTooltip(
                jEpicButton,
                JsonString(GetSpellLevelToolTip(PRC_SPELLBOOK_NUI_EPIC_CIRCLE))
            );

            if (currentCircle != PRC_SPELLBOOK_NUI_EPIC_CIRCLE)
                jEpicButton = GreyOutButton(jEpicButton, width, height);

            jRow = JsonArrayInsert(jRow, jEpicButton);
        }
    }

    jRow = NuiRow(jRow);

    return jRow;
}

json CreateSpellbookSpellButtons(int nClass, int circle)
{
    if (NUISpellbookUsesNativeClassAdapter(OBJECT_SELF, nClass))
        return CreateNativeClassSpellButtons(nClass, circle);

    json jRows = JsonArray();

    // we only want to get spells at the currently selected circle.
    int currentCircle = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR);
    json spellListAtCircle = GetSpellListForCircle(OBJECT_SELF, nClass, currentCircle);
    string sFile = GetClassSpellbookFile(nClass);

    // how many buttons a row can have before we have to make a new row.
    int rowLimit = NUI_SPELLBOOK_SPELL_BUTTON_LENGTH;

    json tempRow = JsonArray();
    int i;
    for (i = 0; i < JsonGetLength(spellListAtCircle); i++)
    {
        int spellbookId = JsonGetInt(JsonArrayGet(spellListAtCircle, i));
        int featId;
        int spellId;
        // Binders don't have a spellbook, so spellbookId is actually SpellID
        if (nClass == CLASS_TYPE_BINDER)
        {
            spellId = spellbookId;
            json binderDict = GetBinderSpellToFeatDictionary(OBJECT_SELF);
            featId = JsonGetInt(JsonObjectGet(binderDict, IntToString(spellId)));
        }
        else
        {
            spellId = StringToInt(Get2DACache(sFile, "SpellID", spellbookId));
            featId = StringToInt(Get2DACache(sFile, "FeatID", spellbookId));
        }

        json jSpellButton = NuiId(NuiButtonImage(GetSpellIcon(spellId, featId, nClass)), PRC_SPELLBOOK_NUI_SPELL_BUTTON_BASEID + IntToString(spellbookId));
        jSpellButton = NuiWidth(jSpellButton, 38.0f);
        jSpellButton = NuiHeight(jSpellButton, 38.0f);

        // the RealSpellID has the accurate descriptions for the spells/abilities
        int realSpellId = StringToInt(Get2DACache(sFile, "RealSpellID", spellbookId));
        jSpellButton = NuiTooltip(jSpellButton, JsonString(GetSpellName(spellId, realSpellId, featId, nClass)));

        // if the row limit has been reached, make a new row
        tempRow = JsonArrayInsert(tempRow, jSpellButton);
        if (JsonGetLength(tempRow) >= rowLimit)
        {
            tempRow = NuiRow(tempRow);
            jRows = JsonArrayInsert(jRows, tempRow);
            tempRow = JsonArray();
        }
    }

    // if the row was cut short (a remainder) then we finish the row and add it
    // to the list
    if (JsonGetLength(tempRow) > 0)
    {
        tempRow = NuiRow(tempRow);
        jRows = JsonArrayInsert(jRows, tempRow);
    }

    return jRows;
}

json CreateNativeClassSpellButtons(int nClass, int circle)
{
    json jRows = JsonArray();
    json jEntries = JsonArray();
    json jTempRow = JsonArray();

    if (!NUISpellbookUsesNativeClassAdapter(OBJECT_SELF, nClass)
        || circle < 0 || circle > 9)
    {
        SetLocalJson(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_BUTTON_MAP_VAR, jEntries);
        return jRows;
    }

    if (NUISpellbookIsNativePreparedClass(nClass))
    {
        int nSlotCount = GetMemorizedSpellCountByLevel(OBJECT_SELF, nClass, circle);
        int nIndex;
        for (nIndex = 0; nIndex < nSlotCount; nIndex++)
        {
            int nSpell = GetMemorizedSpellId(OBJECT_SELF, nClass, circle, nIndex);
            if (nSpell < 0)
                continue;

            int nMetamagic = GetMemorizedSpellMetaMagic(OBJECT_SELF, nClass, circle, nIndex);
            if (nMetamagic < METAMAGIC_NONE)
                continue;
            int bDomain = GetMemorizedSpellIsDomainSpell(OBJECT_SELF, nClass, circle, nIndex) == TRUE;
            int bReady = GetMemorizedSpellReady(OBJECT_SELF, nClass, circle, nIndex) == TRUE;

            int nFound = -1;
            int i;
            for (i = 0; i < JsonGetLength(jEntries); i++)
            {
                json jEntry = JsonArrayGet(jEntries, i);
                if (JsonGetInt(JsonObjectGet(jEntry, "s")) == nSpell
                    && JsonGetInt(JsonObjectGet(jEntry, "m")) == nMetamagic
                    && JsonGetInt(JsonObjectGet(jEntry, "d")) == bDomain)
                {
                    nFound = i;
                    break;
                }
            }

            if (nFound >= 0)
            {
                json jEntry = JsonArrayGet(jEntries, nFound);
                jEntry = JsonObjectSet(jEntry, "n", JsonInt(JsonGetInt(JsonObjectGet(jEntry, "n")) + 1));
                if (bReady)
                    jEntry = JsonObjectSet(jEntry, "r", JsonInt(JsonGetInt(JsonObjectGet(jEntry, "r")) + 1));
                jEntries = JsonArraySet(jEntries, nFound, jEntry);
            }
            else
            {
                json jEntry = JsonObject();
                jEntry = JsonObjectSet(jEntry, "t", JsonInt(NUI_SPELLBOOK_NATIVE_CAST_PREPARED));
                jEntry = JsonObjectSet(jEntry, "c", JsonInt(nClass));
                jEntry = JsonObjectSet(jEntry, "l", JsonInt(circle));
                jEntry = JsonObjectSet(jEntry, "s", JsonInt(nSpell));
                jEntry = JsonObjectSet(jEntry, "m", JsonInt(nMetamagic));
                jEntry = JsonObjectSet(jEntry, "d", JsonInt(bDomain));
                jEntry = JsonObjectSet(jEntry, "n", JsonInt(1));
                jEntry = JsonObjectSet(jEntry, "r", JsonInt(bReady));
                jEntries = JsonArrayInsert(jEntries, jEntry);
            }
        }
    }
    else
    {
        int nKnown = GetKnownSpellCount(OBJECT_SELF, nClass, circle);
        int nIndex;
        for (nIndex = 0; nIndex < nKnown; nIndex++)
        {
            int nSpell = GetKnownSpellId(OBJECT_SELF, nClass, circle, nIndex);
            if (nSpell < 0)
                continue;

            int nUses = GetSpellUsesLeft(OBJECT_SELF, nClass, nSpell);
            if (nUses < 0)
                nUses = 0;
            json jEntry = JsonObject();
            jEntry = JsonObjectSet(jEntry, "t", JsonInt(NUI_SPELLBOOK_NATIVE_CAST_SPONTANEOUS));
            jEntry = JsonObjectSet(jEntry, "c", JsonInt(nClass));
            jEntry = JsonObjectSet(jEntry, "l", JsonInt(circle));
            jEntry = JsonObjectSet(jEntry, "s", JsonInt(nSpell));
            jEntry = JsonObjectSet(jEntry, "m", JsonInt(METAMAGIC_NONE));
            jEntry = JsonObjectSet(jEntry, "d", JsonInt(FALSE));
            jEntry = JsonObjectSet(jEntry, "n", JsonInt(nUses));
            jEntry = JsonObjectSet(jEntry, "r", JsonInt(nUses));
            jEntries = JsonArrayInsert(jEntries, jEntry);
        }
    }

    SetLocalJson(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_BUTTON_MAP_VAR, jEntries);

    int i;
    for (i = 0; i < JsonGetLength(jEntries); i++)
    {
        json jEntry = JsonArrayGet(jEntries, i);
        int nSpell = JsonGetInt(JsonObjectGet(jEntry, "s"));
        int nMetamagic = JsonGetInt(JsonObjectGet(jEntry, "m"));
        int bDomain = JsonGetInt(JsonObjectGet(jEntry, "d"));
        int nTotal = JsonGetInt(JsonObjectGet(jEntry, "n"));
        int nReady = JsonGetInt(JsonObjectGet(jEntry, "r"));

        json jButton = NuiId(
            NuiButtonImage(GetSpellIcon(nSpell)),
            PRC_SPELLBOOK_NUI_NATIVE_CLASS_SPELL_BUTTON_BASEID + IntToString(i)
        );
        jButton = NuiWidth(jButton, 38.0f);
        jButton = NuiHeight(jButton, 38.0f);

        string sTooltip = GetSpellName(nSpell);
        if (bDomain)
            sTooltip += " [Domain]";
        if (nMetamagic > METAMAGIC_NONE)
            sTooltip += " (" + GetMetaMagicString(nMetamagic) + ")";
        if (JsonGetInt(JsonObjectGet(jEntry, "t")) == NUI_SPELLBOOK_NATIVE_CAST_PREPARED)
            sTooltip += " - " + IntToString(nReady) + " / " + IntToString(nTotal) + " ready";
        else
            sTooltip += " - " + IntToString(nReady) + " uses left";
        if (Get2DACache("spells", "SubRadSpell1", nSpell) != "")
            sTooltip += " - choose its variant from the native spellbook";
        jButton = NuiTooltip(jButton, JsonString(sTooltip));

        if (nReady <= 0)
            jButton = GreyOutButton(jButton, 38.0f, 38.0f);

        jTempRow = JsonArrayInsert(jTempRow, jButton);
        if (JsonGetLength(jTempRow) >= NUI_SPELLBOOK_SPELL_BUTTON_LENGTH)
        {
            jRows = JsonArrayInsert(jRows, NuiRow(jTempRow));
            jTempRow = JsonArray();
        }
    }

    if (JsonGetLength(jTempRow) > 0)
        jRows = JsonArrayInsert(jRows, NuiRow(jTempRow));

    return jRows;
}

json CreateReadiedEpicSpellButtons()
{
    json jRows = JsonArray();
    json tempRow = JsonArray();
    int rowLimit = NUI_SPELLBOOK_SPELL_BUTTON_LENGTH;
    int totalEpicSpells = Get2DARowCount("epicspells");
    int i;

    for (i = 0; i < totalEpicSpells; i++)
    {
        int featId = GetFeatForSpell(i);

        // This is the exact readiness test used by Manage Epic Spells. Known
        // but unprepared Epic Spells do not have this feat and stay hidden.
        if (featId > 0 && GetHasFeat(featId, OBJECT_SELF))
        {
            int spellId = StringToInt(Get2DACache("feat", "SPELLID", featId));
            if (spellId <= 0)
                continue;

            json jSpellButton = NuiId(
                NuiButtonImage(GetSpellIcon(spellId, featId)),
                PRC_SPELLBOOK_NUI_EPIC_SPELL_BUTTON_BASEID + IntToString(i)
            );
            jSpellButton = NuiWidth(jSpellButton, 38.0f);
            jSpellButton = NuiHeight(jSpellButton, 38.0f);
            jSpellButton = NuiTooltip(
                jSpellButton,
                JsonString(GetSpellName(spellId, 0, featId))
            );

            tempRow = JsonArrayInsert(tempRow, jSpellButton);
            if (JsonGetLength(tempRow) >= rowLimit)
            {
                jRows = JsonArrayInsert(jRows, NuiRow(tempRow));
                tempRow = JsonArray();
            }
        }
    }

    if (JsonGetLength(tempRow) > 0)
        jRows = JsonArrayInsert(jRows, NuiRow(tempRow));

    return jRows;
}


json CreateMetaMagicFeatButtons(int nClass)
{
    json jRows = JsonArray();
    json currentRow = JsonArray();
    int bEpicAdded;

    // PRC metamagic activation feats arm NewSpellbook state; native engine
    // ActionCastSpell calls do not consume that state. Hiding those controls
    // prevents a misleading unmodified cast and a leaked one-shot toggle.
    // Prepared native metamagic remains represented by the exact memorized
    // tuple. Native spontaneous metamagic stays in the stock spellbook for
    // this first pass.
    if (NUISpellbookUsesNativeClassAdapter(OBJECT_SELF, nClass))
    {
        if (NUIResourceHasEpicSpells(OBJECT_SELF))
            jRows = JsonArrayInsert(jRows, NUIResourceCreateEpicRow());
        return jRows;
    }

    // if an invoker, add the invoker shapes and essences as its own row of buttons
    if (nClass == CLASS_TYPE_WARLOCK
        || nClass == CLASS_TYPE_DRAGONFIRE_ADEPT
        || nClass == CLASS_TYPE_DRAGON_SHAMAN)
    {
        currentRow = CreateMetaFeatButtonRow(GetInvokerShapeSpellList(nClass));

        if (JsonGetLength(currentRow) > 0)
        {
            currentRow = NuiRow(currentRow);
            jRows = JsonArrayInsert(jRows, currentRow);
        }

        currentRow = CreateMetaFeatButtonRow(GetInvokerEssenceSpellList(nClass));

        if (JsonGetLength(currentRow) > 0)
        {
            currentRow = NuiRow(currentRow);
            jRows = JsonArrayInsert(jRows, currentRow);
        }
    }

    // if a ToB class, add its stances as its own row of buttons
    if (nClass == CLASS_TYPE_WARBLADE
        || nClass == CLASS_TYPE_CRUSADER
        || nClass == CLASS_TYPE_SWORDSAGE)
    {
        currentRow = CreateMetaFeatButtonRow(GetToBStanceSpellList(nClass));

        if (JsonGetLength(currentRow) > 0)
        {
            currentRow = NuiRow(currentRow);
            jRows = JsonArrayInsert(jRows, currentRow);
        }
    }

    currentRow = JsonArray();

    // check to see if the class can use any particular meta feats
    if (CanClassUseMetamagicFeats(nClass))
        currentRow = CreateMetaFeatButtonRow(GetMetaMagicFeatList());
    else if (CanClassUseMetaPsionicFeats(nClass))
        currentRow = CreateMetaFeatButtonRow(GetMetaPsionicFeatList());
    else if (CanClassUseMetaMysteryFeats(nClass))
        currentRow = CreateMetaFeatButtonRow(GetMetaMysteryFeatList());

    if (JsonGetLength(currentRow) > 0)
    {
        if (NUIResourceHasEpicSpells(OBJECT_SELF))
        {
            currentRow = NUIResourceAppendEpicControls(currentRow);
            bEpicAdded = TRUE;
        }
        currentRow = NuiRow(currentRow);
        jRows = JsonArrayInsert(jRows, currentRow);
    }

    // and check to see if the class can use sudden meta feats
    currentRow = JsonArray();
    if (CanClassUseSuddenMetamagicFeats(nClass))
        currentRow = CreateMetaFeatButtonRow(GetSuddenMetaMagicFeatList());

    if (JsonGetLength(currentRow) > 0)
    {
        if (!bEpicAdded && NUIResourceHasEpicSpells(OBJECT_SELF))
        {
            currentRow = NUIResourceAppendEpicControls(currentRow);
            bEpicAdded = TRUE;
        }
        currentRow = NuiRow(currentRow);
        jRows = JsonArrayInsert(jRows, currentRow);
    }

    if (!bEpicAdded && NUIResourceHasEpicSpells(OBJECT_SELF))
        jRows = JsonArrayInsert(jRows, NUIResourceCreateEpicRow());

    return jRows;
}

json CreateMetaFeatButtonRow(json spellList)
{
    json jRow = JsonArray();

    int i;
    for (i = 0; i < JsonGetLength(spellList); i++)
    {
        int spellId = JsonGetInt(JsonArrayGet(spellList, i));
        int featId;
        int masterSpell = StringToInt(Get2DACache("spells", "Master", spellId));
        if (masterSpell)
            featId = StringToInt(Get2DACache("spells", "FeatID", masterSpell));
        else
            featId = StringToInt(Get2DACache("spells", "FeatID", spellId));

        int selectedFeatId = featId;
        if (featId == FEAT_EXTEND_SPELL_ABILITY)
            selectedFeatId = FEAT_EXTEND_SPELL;
        if (featId == FEAT_EMPOWER_SPELL_ABILITY)
            selectedFeatId = FEAT_EMPOWER_SPELL;
        if (featId == FEAT_MAXIMIZE_SPELL_ABILITY)
            selectedFeatId = FEAT_MAXIMIZE_SPELL;
        if (featId == FEAT_QUICKEN_SPELL_ABILITY)
            selectedFeatId = FEAT_QUICKEN_SPELL;
        if (featId == FEAT_STILL_SPELL_ABILITY)
            selectedFeatId = FEAT_STILL_SPELL;

        if (GetHasFeat(selectedFeatId, OBJECT_SELF, TRUE))
        {
            string featName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", spellId)));

            json jMetaButton = NuiId(NuiButtonImage(GetSpellIcon(spellId, featId)), PRC_SPELLBOOK_NUI_META_BUTTON_BASEID + IntToString(spellId));
            jMetaButton = NuiWidth(jMetaButton, 32.0f);
            jMetaButton = NuiHeight(jMetaButton, 32.0f);
            jMetaButton = NuiTooltip(jMetaButton, JsonString(featName));

            jRow = JsonArrayInsert(jRow, jMetaButton);
        }
    }

    return jRow;
}
