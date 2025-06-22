//::///////////////////////////////////////////////
//:: PRC Level Up NUI View
//:: prc_nui_lv_view
//:://////////////////////////////////////////////
/*
    This is the logic that handles the view for the Level Up NUI
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 20.06.2005
//:://////////////////////////////////////////////

#include "nw_inc_nui"
#include "prc_nui_consts"
#include "prc_inc_function"
#include "prc_nui_lv_inc"

//
// CreateCircleButtons
// Creates the spell circle buttons for the given class Id
//
// Arguments:
//   nClass:int the ClassID
//
// Returns:
//   json the NUI spell circle buttons
//
json CreateCircleButtons(int nClass)
{
    json jRow = JsonArray();
    // get the spell list for the class
    json spellList = GetSpellListObject(nClass);

    // get the keys which are circles
    json circleList = JsonObjectKeys(spellList);
    int totalCircles = JsonGetLength(circleList);
    int selectedCircle = GetLocalInt(OBJECT_SELF, NUI_LEVEL_UP_SELECTED_CIRCLE_VAR);

    int i;
    for (i = 0; i < 10; i++)
    {
        json jCircle;
        // some classes have less than 10 circles, build buttons for circles
        // we have, leave the rest blank
        if (i < totalCircles)
        {
            int spellLevel = StringToInt(JsonGetString(JsonArrayGet(circleList, i)));
            // in case this isn't set, and we start at a spot higher than 0.
            // OR we switched classes and the selected circle is higher than possible
            // we set the value
            if ((selectedCircle == -1)
                && (GetRemainingSpellChoices(nClass, spellLevel) || (i+1 == totalCircles)))
            {
                SetLocalInt(OBJECT_SELF, NUI_LEVEL_UP_SELECTED_CIRCLE_VAR, spellLevel);
                selectedCircle = spellLevel;
            }

            jCircle = NuiId(NuiButtonImage(JsonString(GetSpellLevelIcon(spellLevel))), NUI_LEVEL_UP_SPELL_CIRCLE_BUTTON_BASEID + IntToString(spellLevel));
            jCircle = NuiTooltip(jCircle, JsonString(GetSpellLevelToolTip(spellLevel)));

            if (selectedCircle != spellLevel)
                jCircle = GreyOutButton(jCircle, 36.0f, 36.0f);
        }
        else
            jCircle = NuiText(JsonString(""), TRUE, NUI_SCROLLBARS_NONE);
        jCircle = NuiWidth(jCircle, 36.0f);
        jCircle = NuiHeight(jCircle, 36.0f);
        jCircle = NuiMargin(jCircle, 0.0f);
        jRow = JsonArrayInsert(jRow, jCircle);
    }

    jRow = NuiRow(jRow);
    jRow = NuiMargin(jRow, 0.0f);
    return jRow;
}

json CreateSpellButtons(int nClass, int selectedCircle)
{
    json jRow = JsonArray();

    json spellList = GetSpellListObject(nClass);
    json currentList = JsonObjectGet(spellList, IntToString(selectedCircle));
    int totalSpells = JsonGetLength(currentList);

    int i;
    for (i = 0; i < totalSpells; i++)
    {
        int spellbookId = JsonGetInt(JsonArrayGet(currentList, i));
        if (ShouldAddSpellToSpellButtons(nClass, spellbookId))
        {
            string sFile = GetClassSpellbookFile(nClass);
            string sRealSpellID = Get2DACache(sFile, "RealSpellID", spellbookId);
            int nRealSpellID = StringToInt(sRealSpellID);
            int spellId = StringToInt(Get2DACache(sFile, "SpellID", spellbookId));
            int featId = StringToInt(Get2DACache(sFile, "FeatID", spellbookId));

            string spellName = GetSpellName(spellId, nRealSpellID, featId, nClass);

            int enabled = ShouldSpellButtonBeEnabled(nClass, selectedCircle, spellbookId);
            json jSpellButton;
            if (enabled)
                jSpellButton = NuiId(NuiButton(JsonString("")), NUI_LEVEL_UP_SPELL_BUTTON_BASEID + IntToString(spellbookId));
            else
                jSpellButton = NuiId(NuiButton(JsonString("")), NUI_LEVEL_UP_SPELL_DISABLED_BUTTON_BASEID + IntToString(spellbookId));

            json jIcons = JsonArray();
            json jIconLeft = NuiDrawListImage(JsonBool(TRUE), GetSpellIcon(spellId, featId), NuiRect(5.0f,5.0f,32.0f,32.0f), JsonInt(NUI_ASPECT_FIT), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE), NUI_DRAW_LIST_ITEM_ORDER_AFTER);
            json jIconRight = NuiDrawListImage(JsonBool(TRUE), JsonString("nui_shld_right"), NuiRect(299.0f,8.0f,26.0f,26.0f), JsonInt(NUI_ASPECT_FIT), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE), NUI_DRAW_LIST_ITEM_ORDER_AFTER);
            json jText = NuiDrawListText(JsonBool(TRUE), NuiColor(255, 255, 255), NuiRect(40.0f, 12.0f, 290.0f, 32.0f), JsonString(spellName));
            jIcons = JsonArrayInsert(jIcons, jIconLeft);
            jIcons = JsonArrayInsert(jIcons, jIconRight);
            jIcons = JsonArrayInsert(jIcons, jText);
            if (!enabled)
                jIcons = JsonArrayInsert(jIcons, CreateGreyOutRectangle(335.0f, 42.0f));
            jSpellButton = NuiDrawList(jSpellButton, JsonBool(FALSE), jIcons);
            jSpellButton = NuiWidth(jSpellButton, 335.0f);
            jSpellButton = NuiHeight(jSpellButton, 42.0f);
            jSpellButton = NuiMargin(jSpellButton, 0.0f);

            jRow = JsonArrayInsert(jRow, jSpellButton);
        }
    }
    jRow = NuiCol(jRow);
    jRow = NuiGroup(jRow, TRUE, NUI_SCROLLBARS_Y);
    jRow = NuiWidth(jRow, 360.0f);
    jRow = NuiHeight(jRow, 360.0f);
    jRow = NuiMargin(jRow, 0.0f);

    return jRow;
}

json CreateChosenButtons(int nClass, int selectedCircle)
{
    json jRow = JsonArray();

    json selectedList = GetChosenSpellListObject(nClass);
    json currentList = JsonObjectGet(selectedList, IntToString(selectedCircle));
    if (currentList != JsonNull())
    {
        int totalSpells = JsonGetLength(currentList);

        int i;
        for (i = 0; i < totalSpells; i++)
        {
            int spellbookId = JsonGetInt(JsonArrayGet(currentList, i));

            string sFile = GetClassSpellbookFile(nClass);
            string sRealSpellID = Get2DACache(sFile, "RealSpellID", spellbookId);
            int nRealSpellID = StringToInt(sRealSpellID);
            int spellId = StringToInt(Get2DACache(sFile, "SpellID", spellbookId));
            int featId = StringToInt(Get2DACache(sFile, "FeatID", spellbookId));

            int enabled = EnableChosenButton(nClass, spellbookId, selectedCircle);

            string spellName = GetSpellName(spellId, nRealSpellID, featId, nClass);

            json jSpellButton;
            if (enabled)
                jSpellButton = NuiId(NuiButton(JsonString("")), NUI_LEVEL_UP_SPELL_CHOSEN_BUTTON_BASEID + IntToString(spellbookId));
            else
                jSpellButton = NuiId(NuiButton(JsonString("")), NUI_LEVEL_UP_SPELL_CHOSEN_DISABLED_BUTTON_BASEID + IntToString(spellbookId));

            json jIcons = JsonArray();
            json jIconLeft = NuiDrawListImage(JsonBool(TRUE), GetSpellIcon(spellId, featId), NuiRect(5.0f,5.0f,32.0f,32.0f), JsonInt(NUI_ASPECT_FIT), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE), NUI_DRAW_LIST_ITEM_ORDER_AFTER);
            json jIconRight = NuiDrawListImage(JsonBool(TRUE), JsonString("nui_shld_left"), NuiRect(299.0f,8.0f,26.0f,26.0f), JsonInt(NUI_ASPECT_FIT), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE), NUI_DRAW_LIST_ITEM_ORDER_AFTER);
            json jText = NuiDrawListText(JsonBool(TRUE), NuiColor(255, 255, 255), NuiRect(40.0f, 12.0f, 290.0f, 32.0f), JsonString(spellName));
            jIcons = JsonArrayInsert(jIcons, jIconLeft);
            jIcons = JsonArrayInsert(jIcons, jIconRight);
            jIcons = JsonArrayInsert(jIcons, jText);
            if (!enabled)
                jIcons = JsonArrayInsert(jIcons, CreateGreyOutRectangle(335.0f, 42.0f));
            jSpellButton = NuiDrawList(jSpellButton, JsonBool(FALSE), jIcons);
            jSpellButton = NuiWidth(jSpellButton, 335.0f);
            jSpellButton = NuiHeight(jSpellButton, 42.0f);
            jSpellButton = NuiMargin(jSpellButton, 0.0f);

            jRow = JsonArrayInsert(jRow, jSpellButton);
        }
    }

    jRow = NuiCol(jRow);
    jRow = NuiGroup(jRow, TRUE, NUI_SCROLLBARS_Y);
    jRow = NuiWidth(jRow, 360.0f);
    jRow = NuiHeight(jRow, 360.0f);
    jRow = NuiMargin(jRow, 0.0f);

    return jRow;
}

string GetRemainingText(int nClass, int selectedCircle)
{
    if (GetIsBladeMagicClass(nClass))
    {
        string remainingMan = IntToString(GetRemainingManeuverChoices(nClass));
        string remainingStance = IntToString(GetRemainingStanceChoices(nClass));

        return remainingMan + " Remaining Maneuevers / " + remainingStance + " Remaining Stances";
    }

    if (GetIsTruenamingClass(nClass))
        return IntToString(GetRemainingTruenameChoices(nClass, LEXICON_EVOLVING_MIND)) + " EM / "
            + IntToString(GetRemainingTruenameChoices(nClass, LEXICON_CRAFTED_TOOL)) + " CT / "
            + IntToString(GetRemainingTruenameChoices(nClass, LEXICON_PERFECTED_MAP)) + " PM";

    int remainingSpellChoices = GetRemainingSpellChoices(nClass, selectedCircle, OBJECT_SELF);

    if (GetIsInvocationClass(nClass))
        return IntToString(remainingSpellChoices) + " Remaining Invocations";
    if (GetIsShadowMagicClass(nClass))
        return IntToString(remainingSpellChoices) + " Remaining Mysteries";
    if (GetIsPsionicClass(nClass))
        return IntToString(remainingSpellChoices) + " Remaining Powers";
    return IntToString(remainingSpellChoices) + " Remaining Spells";
}

void main()
{
    int nClass = GetLocalInt(OBJECT_SELF, NUI_LEVEL_UP_SELECTED_CLASS_VAR);
    if (!IsClassAllowedToUseLevelUpNUI(nClass))
    {
        string name = GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)));
        SendMessageToPC(OBJECT_SELF, "The class " + name + " is not allowed to use the Level Up NUI!");
        DeleteLocalInt(OBJECT_SELF, NUI_LEVEL_UP_SELECTED_CLASS_VAR);
        return;
    }

    // First we look for any previous windows, if found (ie, non-zero) we destory them so we can start fresh.
    if (IsLevelUpNUIOpen())
    {
        // this is already rendered
        return;
    }


    ///////////////
    // LEFT SIDE //
    ///////////////

    json jRoot = JsonArray();
    json jLeftSide = JsonArray();
    json jRightSide = JsonArray();

    // Title

    json jRow = JsonArray();
    json jTitle = NuiText(JsonString("Available/Known"), TRUE, NUI_SCROLLBARS_NONE);
    jTitle = NuiHeight(jTitle, 26.0f);
    jTitle = NuiWidth(jTitle, 360.0f);
    jTitle = NuiMargin(jTitle, 0.0f);
    jRow = JsonArrayInsert(jRow, jTitle);
    jRow = NuiRow(jRow);
    jRow = NuiMargin(jRow, 0.0f);
    jLeftSide = JsonArrayInsert(jLeftSide, jRow);

    // Circles

    jRow = CreateCircleButtons(nClass);
    jLeftSide = JsonArrayInsert(jLeftSide, jRow);

    int selectedCircle = GetLocalInt(OBJECT_SELF, NUI_LEVEL_UP_SELECTED_CIRCLE_VAR);

    // Spells

    jRow = CreateSpellButtons(nClass, selectedCircle);
    jLeftSide = JsonArrayInsert(jLeftSide, jRow);
    jLeftSide = NuiCol(jLeftSide);

    ////////////////
    // RIGHT SIDE //
    ////////////////

    // Title

    jRow = JsonArray();

    jTitle = NuiText(JsonString("Selected/Prepared"), TRUE, NUI_SCROLLBARS_NONE);
    jTitle = NuiHeight(jTitle, 26.0f);
    jTitle = NuiWidth(jTitle, 360.0f);
    jTitle = NuiMargin(jTitle, 0.0f);
    jRow = JsonArrayInsert(jRow, jTitle);
    jRow = NuiRow(jRow);
    jRow = NuiMargin(jRow, 0.0f);
    jRightSide = JsonArrayInsert(jRightSide, jRow);

    // Remaining Choice

    jRow = JsonArray();
    json jAmountLeft = NuiText(JsonString(GetRemainingText(nClass, selectedCircle)), TRUE, NUI_SCROLLBARS_NONE);
    jAmountLeft = NuiHeight(jAmountLeft, 36.0f);
    jAmountLeft = NuiWidth(jAmountLeft, 360.0f);
    jAmountLeft = NuiMargin(jAmountLeft, 0.0f);
    jRow = JsonArrayInsert(jRow, jAmountLeft);
    jRow = NuiRow(jRow);
    jRow = NuiMargin(jRow, 0.0f);
    jRightSide = JsonArrayInsert(jRightSide, jRow);

    // Selected Choices

    jRow = CreateChosenButtons(nClass, selectedCircle);
    jRightSide = JsonArrayInsert(jRightSide, jRow);
    jRightSide = NuiCol(jRightSide);

    // Make each side

    json tempRow = JsonArray();
    tempRow = JsonArrayInsert(tempRow, jLeftSide);
    tempRow = JsonArrayInsert(tempRow, jRightSide);
    tempRow = NuiRow(tempRow);

    jRoot = JsonArrayInsert(jRoot, tempRow);

    // Done button

    jRow = JsonArray();
    json jResetButton = NuiId(NuiButton(JsonString("Reset")), NUI_LEVEL_UP_RESET_BUTTON);
    jResetButton = NuiWidth(jResetButton, 118.0f);
    jResetButton = NuiHeight(jResetButton, 50.0f);
    json jDoneButton = NuiId(NuiButton(JsonString("Done")), NUI_LEVEL_UP_DONE_BUTTON);
    jDoneButton = NuiWidth(jDoneButton, 118.0f);
    jDoneButton = NuiHeight(jDoneButton, 50.0f);
    if (!AllSpellsAreChosen(nClass, OBJECT_SELF))
        jDoneButton = NuiEnabled(jDoneButton, JsonBool(FALSE));
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, jResetButton);
    jRow = JsonArrayInsert(jRow, jDoneButton);
    jRow = NuiRow(jRow);
    jRoot = JsonArrayInsert(jRoot, jRow);

    jRoot = NuiCol(jRoot);

    string className = GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)));
    string title = className + " Level Up";

    // This is the main window with jRoot as the main pane.  It includes titles and parameters (more on those later)
    json nui = NuiWindow(jRoot, JsonString(title), NuiBind("geometry"), NuiBind("resizable"), JsonBool(FALSE), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));

    // finally create it and it'll return us a non-zero token.
    int nToken = NuiCreate(OBJECT_SELF, nui, NUI_LEVEL_UP_WINDOW_ID);

    // get the geometry of the window in case we opened this before and have a
    // preference for location
    json geometry = NuiRect(-1.0f,-1.0f, 748.0f, 535.0f);

    // Set the binds to their default values
    NuiSetBind(OBJECT_SELF, nToken, "geometry", geometry);
    NuiSetBind(OBJECT_SELF, nToken, "resizable", JsonBool(FALSE));
    NuiSetBind(OBJECT_SELF, nToken, "closable", JsonBool(FALSE));
    NuiSetBind(OBJECT_SELF, nToken, "transparent", JsonBool(FALSE));
    NuiSetBind(OBJECT_SELF, nToken, "border", JsonBool(TRUE));
}



