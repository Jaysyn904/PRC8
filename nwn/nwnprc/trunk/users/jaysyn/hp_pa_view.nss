//::///////////////////////////////////////////////
//:: Power Attack NUI
//:: ha_pa_view
//:://////////////////////////////////////////////
/*
    A NUI that sets the power attack on a player based on the amount
    given.
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 22.05.2005
//:://////////////////////////////////////////////

#include "nw_inc_nui"
// #include "nw_inc_nui_insp" // used to debug

//
// NuiPRCPowerAttackView
// The NUI window for the Power Attack interface, running this function
// creates the window itself
//
// Arguments:
//   oPlayer object the player referenced for the NUI
//
void NuiPRCPowerAttackView(object oPlayer);


// The Window ID
const string NUI_PRC_POWER_ATTACK_WINDOW = "nui_prc_power_attack_window";

// LocalVar for the geometry of the window
const string NUI_PRC_PA_GEOMETRY_VAR = "paNuiGeometry";

// Event For Left Button
const string NUI_PRC_PA_LEFT_BUTTON_EVENT = "nui_prc_pa_left_button_event";
// Event For Right Button
const string NUI_PRC_PA_RIGHT_BUTTON_EVENT = "nui_prc_pa_right_button_event";

// Bind for Text
const string NUI_PRC_PA_TEXT_BIND = "nui_prc_pa_text_bind";
// Left Button Enabled Bind
const string NUI_PRC_PA_LEFT_BUTTON_ENABLED_BIND = "leftButtonEnabled";
// Right Button Enabled Bind
const string NUI_PRC_PA_RIGHT_BUTTON_ENABLED_BIND = "rightButtonEnabled";

void NuiPRCPowerAttackView(object oPlayer)
{
    // First we look for any previous windows, if found (ie, non-zero) we destory them so we can start fresh.
    int nPreviousToken = NuiFindWindow(oPlayer, NUI_PRC_POWER_ATTACK_WINDOW);
    if (nPreviousToken != 0)
    {
        NuiDestroy(oPlayer, nPreviousToken);
    }

    // base element for NUI
    json jRoot = JsonArray();

    // Create and set parameters for left button
    json jLeftButton = NuiId(NuiButton(JsonString("-")), NUI_PRC_PA_LEFT_BUTTON_EVENT);
    jLeftButton = NuiWidth(jLeftButton, 32.0f);
    jLeftButton = NuiHeight(jLeftButton, 32.0f);
    jLeftButton = NuiEnabled(jLeftButton, NuiBind(NUI_PRC_PA_LEFT_BUTTON_ENABLED_BIND));

    // Create and set parameters for text field
    json jText = NuiText(NuiBind(NUI_PRC_PA_TEXT_BIND), TRUE, NUI_SCROLLBARS_NONE);
    jText = NuiWidth(jText, 32.0f);
    jText = NuiHeight(jText, 32.0f);

    // Create and set parameters for right button
    json jRightButton = NuiId(NuiButton(JsonString("+")), NUI_PRC_PA_RIGHT_BUTTON_EVENT);
    jRightButton = NuiWidth(jRightButton, 32.0f);
    jRightButton = NuiHeight(jRightButton, 32.0f);
    jRightButton = NuiEnabled(jRightButton, NuiBind(NUI_PRC_PA_RIGHT_BUTTON_ENABLED_BIND));

    // create button layout
    json jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = JsonArrayInsert(jRow, jLeftButton);
    jRow = JsonArrayInsert(jRow, jText);
    jRow = JsonArrayInsert(jRow, jRightButton);
    jRow = JsonArrayInsert(jRow, NuiSpacer());
    jRow = NuiRow(jRow);
    jRoot = JsonArrayInsert(jRoot, jRow);

    // set overall layout
    jRoot = NuiCol(jRoot);

    // Create the window and set binds for parameters in case we want to change them later
    json nui = NuiWindow(jRoot, JsonString("Power Attack"), NuiBind("geometry"), NuiBind("resizable"), NuiBind("collapsed"), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));

    int nToken = NuiCreate(oPlayer, nui, NUI_PRC_POWER_ATTACK_WINDOW);

    // get the geometry of the window in case we opened this before and have a
    // preference for location
    json geometry = GetLocalJson(oPlayer, NUI_PRC_PA_GEOMETRY_VAR);

    // Default to put this near the middle and let the person adjust its location
    if (geometry == JsonNull())
    {
        geometry = NuiRect(1095.0f,312.0f, 166.0f, 93.0f);
    }

    // Set the binds to their default values
    NuiSetBind(oPlayer, nToken, "geometry", geometry);
    NuiSetBind(oPlayer, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(oPlayer, nToken, "resizable", JsonBool(FALSE));
    NuiSetBind(oPlayer, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(oPlayer, nToken, "transparent", JsonBool(TRUE));
    NuiSetBind(oPlayer, nToken, "border", JsonBool(FALSE));

    int paAmount = GetLocalInt(oPlayer, "PRC_PowerAttack_Level");
    int currentBAB = GetBaseAttackBonus(oPlayer);

    // if we reach the left or right limits of the power attack, then disable the buttons
    json leftButtonEnabled = (paAmount == 0) ? JsonBool(FALSE) : JsonBool(TRUE);
    json rightButtonEnabled = (paAmount == currentBAB) ? JsonBool(FALSE) : JsonBool(TRUE);


    // set the current PA amount to the window
    NuiSetBind(oPlayer, nToken, NUI_PRC_PA_TEXT_BIND, JsonString(IntToString(paAmount)));



    NuiSetBind(oPlayer, nToken, NUI_PRC_PA_LEFT_BUTTON_ENABLED_BIND, leftButtonEnabled);
    NuiSetBind(oPlayer, nToken, NUI_PRC_PA_RIGHT_BUTTON_ENABLED_BIND, rightButtonEnabled);
}