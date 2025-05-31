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

#include "nw_inc_nui"
//#include "nw_inc_nui_insp"
#include "prc_nui_sb_inc"
#include "prc_nui_consts"

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

//
// GetSpellLevelIcon
// Takes the spell circle int and gets the icon appropriate for it (i.e. 0 turns
// into "ir_cantrips"
//
// Arguments:
//   spellLevel:int the spell level we want the icon for
//
// Returns:
//   string the spell level icon
//
string GetSpellLevelIcon(int spellLevel);

//
// GetSpellLevelToolTip
// Gets the spell level tool tip text based on the int spell level provided (i.e.
// 0 turns into "Cantrips")
//
// Arguments:
//   spellLevel:int the spell level we want the tooltip for
//
// Returns:
//   string the spell level toop tip
//
string GetSpellLevelToolTip(int spellLevel);

//
// GetSpellIcon
// Gets the spell icon based off the spellId by using the FeatID instead
//
// Arguments:
//   nClass:int the class Id
//   spellId:int the spell Id we want the icon for
//
// Returns:
//   json:String the string of the icon we want.
//
json GetSpellIcon(int spellId, int nClass=0);

void main()
{
    // look for existing window and destroy
    int nPreviousToken = NuiFindWindow(OBJECT_SELF, PRC_SPELLBOOK_NUI_WINDOW_ID);
    if(nPreviousToken != 0)
    {
        NuiDestroy(OBJECT_SELF, nPreviousToken);
    }

    json jRoot = JsonArray();
    json jRow = CreateSpellBookClassButtons();
    jRoot = JsonArrayInsert(jRoot, jRow);

    int selectedClassId = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);

    // GetLocalInt returns 0 if not set, which is Barb class which conveniently doesn't have spells :)
    // if there was no selected class then there is nothing to render
    if (selectedClassId != CLASS_TYPE_BARBARIAN)
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
        jRow = CreateSpellbookSpellButtons(selectedClassId, currentCircle);

        // since we limit how many buttons a row can have here we need to add
        // multiple NuiRows if they exist
        for(i = 0; i < JsonGetLength(jRow); i++)
        {
            jRoot = JsonArrayInsert(jRoot, JsonArrayGet(jRow, i));
        }
    }

    jRoot = NuiCol(jRoot);

    string title = "PRC Spellbook";

    if (selectedClassId != CLASS_TYPE_BARBARIAN)
        title = title + ": " + GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", selectedClassId)));

    // This is the main window with jRoot as the main pane.  It includes titles and parameters (more on those later)
    json nui = NuiWindow(jRoot, JsonString(title), NuiBind("geometry"), NuiBind("resizable"), NuiBind("collapsed"), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));

    // finally create it and it'll return us a non-zero token.
    int nToken = NuiCreate(OBJECT_SELF, nui, PRC_SPELLBOOK_NUI_WINDOW_ID);

    // get the geometry of the window in case we opened this before and have a
    // preference for location
    json geometry = GetLocalJson(OBJECT_SELF, PRC_SPELLBOOK_NUI_GEOMETRY_VAR);

    // Default to put this near the middle and let the person adjust its location
    if (geometry == JsonNull())
    {
        geometry = NuiRect(893.0f,346.0f, 489.0f, 351.0f);
    }

    // Set the binds to their default values
    NuiSetBind(OBJECT_SELF, nToken, "geometry", geometry);
    NuiSetBind(OBJECT_SELF, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(OBJECT_SELF, nToken, "resizable", JsonBool(FALSE));
    NuiSetBind(OBJECT_SELF, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(OBJECT_SELF, nToken, "transparent", JsonBool(TRUE));
    NuiSetBind(OBJECT_SELF, nToken, "border", JsonBool(FALSE));
}

json CreateSpellBookClassButtons()
{
    json jRow = JsonArray();
    // Get all the Classes that can use the NUI Spellbook
    json classList = GetSupportedNUISpellbookClasses(OBJECT_SELF);

    // if we have selected a class already due to re-rendering, we need to disable
    // the button for it.
    int selectedClassId = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);

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

        // Get the class icon from the classes.2da
        json jClassButton = NuiId(NuiButtonImage(JsonString(Get2DACache("classes", "Icon", classId))), PRC_SPELLBOOK_NUI_CLASS_BUTTON_BASEID + IntToString(classId));
        jClassButton = NuiWidth(jClassButton, 32.0f);
        jClassButton = NuiHeight(jClassButton, 32.0f);
        // Get the class name from the classes.2da and set it to the tooltip
        jClassButton = NuiTooltip(jClassButton, JsonString(GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", classId)))));

        jRow = JsonArrayInsert(jRow, jClassButton);
    }

    jRow = NuiRow(jRow);

    return jRow;
}

json CreateSpellbookCircleButtons(int nClass)
{
    json jRow = JsonArray();
    int i;
    // Get the current selected circle and the class caster level.
    int currentCircle = GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR);
    int casterLevel = GetPrCAdjustedCasterLevel(nClass, OBJECT_SELF);

    // Get what the lowest level of a circle is for the class (some start at 1,
    // some start higher, some start at cantrips)
    int minSpellLevel = GetMinSpellLevel(nClass);

    if (minSpellLevel >= 0)
    {
        // get what is the highest circle the class can cast at
        int currentMaxSpellLevel = GetCurrentSpellLevel(nClass, casterLevel);
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
        if (currentCircle > currentMaxSpellLevel)
        {
            currentCircle = currentMaxSpellLevel;
            SetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR, currentCircle);
        }

        for (i = minSpellLevel; i <= totalMaxSpellLevel; i++)
        {
            json enabled;
            json jButton = NuiId(NuiButtonImage(JsonString(GetSpellLevelIcon(i))), PRC_SPELLBOOK_NUI_CIRCLE_BUTTON_BASEID + IntToString(i));
            jButton = NuiWidth(jButton, 42.0f);
            jButton = NuiHeight(jButton, 42.0f);
            jButton = NuiTooltip(jButton, JsonString(GetSpellLevelToolTip(i)));

            // if the current circle is selected or if the person can't cast at
            // that circle yet then disable the button.
            if (currentCircle == i || i > currentMaxSpellLevel)
            {
                enabled = JsonBool(FALSE);
            }
            else
            {
                enabled = JsonBool(TRUE);
            }
            jButton = NuiEnabled(jButton, enabled);

            jRow = JsonArrayInsert(jRow, jButton);
        }
    }

    jRow = NuiRow(jRow);

    return jRow;
}

json CreateSpellbookSpellButtons(int nClass, int circle)
{
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
        int spellId;
        // Binders don't have a spellbook, so spellbookId is actually SpellID
        if (nClass == CLASS_TYPE_BINDER)
            spellId = spellbookId;
        else
            spellId = StringToInt(Get2DACache(sFile, "SpellID", spellbookId));

        json jSpellButton = NuiId(NuiButtonImage(GetSpellIcon(spellId, nClass)), PRC_SPELLBOOK_NUI_SPELL_BUTTON_BASEID + IntToString(spellbookId));
        jSpellButton = NuiWidth(jSpellButton, 38.0f);
        jSpellButton = NuiHeight(jSpellButton, 38.0f);

        // the RealSpellID has the accurate descriptions for the spells/abilities
        int realSpellId = StringToInt(Get2DACache(sFile, "RealSpellID", spellbookId));
        if (!realSpellId)
            realSpellId = spellId;
        jSpellButton = NuiTooltip(jSpellButton, JsonString(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", realSpellId)))));

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


json CreateMetaMagicFeatButtons(int nClass)
{
    json jRows = JsonArray();
    json currentRow = JsonArray();

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
        currentRow = NuiRow(currentRow);
        jRows = JsonArrayInsert(jRows, currentRow);
    }

    // and check to see if the class can use sudden meta feats
    currentRow = JsonArray();
    if (CanClassUseSuddenMetamagicFeats(nClass))
        currentRow = CreateMetaFeatButtonRow(GetSuddenMetaMagicFeatList());

    if (JsonGetLength(currentRow) > 0)
    {
        currentRow = NuiRow(currentRow);
        jRows = JsonArrayInsert(jRows, currentRow);
    }

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


        if (GetHasFeat(featId, OBJECT_SELF, TRUE))
        {
            string featName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", spellId)));

            json jMetaButton = NuiId(NuiButtonImage(GetSpellIcon(spellId)), PRC_SPELLBOOK_NUI_META_BUTTON_BASEID + IntToString(spellId));
            jMetaButton = NuiWidth(jMetaButton, 32.0f);
            jMetaButton = NuiHeight(jMetaButton, 32.0f);
            jMetaButton = NuiTooltip(jMetaButton, JsonString(featName));

            jRow = JsonArrayInsert(jRow, jMetaButton);
        }
    }

    return jRow;
}

json GetSpellIcon(int spellId,int nClass=0)
{
    // Binder's spells don't have the FeatID on the spells.2da, so we have to use
    // the mapping we constructed to get it.
    if (nClass == CLASS_TYPE_BINDER)
    {
        json binderDict = GetBinderSpellToFeatDictionary();
        int featId = JsonGetInt(JsonObjectGet(binderDict, IntToString(spellId)));
        return JsonString(Get2DACache("feat", "Icon", featId));
    }

    int masterSpellID = StringToInt(Get2DACache("spells", "Master", spellId));

    // if this is a sub radial spell, then we use spell's icon instead
    if (masterSpellID)
        return JsonString(Get2DACache("spells", "IconResRef", spellId));

    // the FeatID holds the accurate spell icon, not the SpellID
    int featId = StringToInt(Get2DACache("spells", "FeatID", spellId));

    return JsonString(Get2DACache("feat", "Icon", featId));
}

string GetSpellLevelIcon(int spellLevel)
{
    switch (spellLevel)
    {
        case 0: return "ir_cantrips";
        case 1: return "ir_level1";
        case 2: return "ir_level2";
        case 3: return "ir_level3";
        case 4: return "ir_level4";
        case 5: return "ir_level5";
        case 6: return "ir_level6";
        case 7: return "ir_level789";
        case 8: return "ir_level789";
        case 9: return "ir_level789";
    }

    return "";
}

string GetSpellLevelToolTip(int spellLevel)
{
    switch (spellLevel)
    {
        case 0: return "Cantrips";
        case 1: return "Level 1";
        case 2: return "Level 2";
        case 3: return "Level 3";
        case 4: return "Level 4";
        case 5: return "Level 5";
        case 6: return "Level 6";
        case 7: return "Level 7";
        case 8: return "Level 8";
        case 9: return "Level 9";
    }

    return "";
}
