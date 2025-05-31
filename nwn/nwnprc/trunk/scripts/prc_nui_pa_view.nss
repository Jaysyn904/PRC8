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
#include "prc_nui_consts"
// #include "nw_inc_nui_insp" // used to debug

void main()
{
    // First we look for any previous windows, if found (ie, non-zero) we destory them so we can start fresh.
    int nPreviousToken = NuiFindWindow(OBJECT_SELF, NUI_PRC_POWER_ATTACK_WINDOW);
    if (nPreviousToken != 0)
    {
        NuiDestroy(OBJECT_SELF, nPreviousToken);
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

    int nToken = NuiCreate(OBJECT_SELF, nui, NUI_PRC_POWER_ATTACK_WINDOW);

    // get the geometry of the window in case we opened this before and have a
    // preference for location
    json geometry = GetLocalJson(OBJECT_SELF, NUI_PRC_PA_GEOMETRY_VAR);

    // Default to put this near the middle and let the person adjust its location
    if (geometry == JsonNull())
    {
        geometry = NuiRect(1095.0f,312.0f, 166.0f, 93.0f);
    }

    // Set the binds to their default values
    NuiSetBind(OBJECT_SELF, nToken, "geometry", geometry);
    NuiSetBind(OBJECT_SELF, nToken, "collapsed", JsonBool(FALSE));
    NuiSetBind(OBJECT_SELF, nToken, "resizable", JsonBool(FALSE));
    NuiSetBind(OBJECT_SELF, nToken, "closable", JsonBool(TRUE));
    NuiSetBind(OBJECT_SELF, nToken, "transparent", JsonBool(TRUE));
    NuiSetBind(OBJECT_SELF, nToken, "border", JsonBool(FALSE));

    int paAmount = GetLocalInt(OBJECT_SELF, "PRC_PowerAttack_Level");
    int currentBAB = GetBaseAttackBonus(OBJECT_SELF);

    // if we reach the left or right limits of the power attack, then disable the buttons
    json leftButtonEnabled = (paAmount == 0) ? JsonBool(FALSE) : JsonBool(TRUE);
    json rightButtonEnabled = (paAmount == currentBAB) ? JsonBool(FALSE) : JsonBool(TRUE);


    // set the current PA amount to the window
    NuiSetBind(OBJECT_SELF, nToken, NUI_PRC_PA_TEXT_BIND, JsonString(IntToString(paAmount)));



    NuiSetBind(OBJECT_SELF, nToken, NUI_PRC_PA_LEFT_BUTTON_ENABLED_BIND, leftButtonEnabled);
    NuiSetBind(OBJECT_SELF, nToken, NUI_PRC_PA_RIGHT_BUTTON_ENABLED_BIND, rightButtonEnabled);
}
