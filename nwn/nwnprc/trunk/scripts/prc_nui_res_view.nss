//::///////////////////////////////////////////////
//:: PRC Character Resource NUI - view
//:: prc_nui_res_view
//:://////////////////////////////////////////////

#include "prc_nui_res_inc"

void main()
{
    object oPC = OBJECT_SELF;
    int nExisting = NuiFindWindow(oPC, NUI_PRC_RESOURCE_WINDOW);

    // Calling the opener again refreshes and restarts one clean update loop.
    if (nExisting)
    {
        int nExistingGeneration = GetLocalInt(oPC, NUI_PRC_RESOURCE_GENERATION_VAR) + 1;
        SetLocalInt(oPC, NUI_PRC_RESOURCE_GENERATION_VAR, nExistingGeneration);
        NUIResourceRefreshWindow(oPC);
        DelayCommand(1.0f, NUIResourceRefreshLoop(oPC, nExistingGeneration));
        return;
    }

    int nMaxPP = GetMaximumPowerPoints(oPC);
    json jClasses = NUIResourceGetSpontaneousClasses(oPC);
    int nClassCount = JsonGetLength(jClasses);
    int bHasEpic = NUIResourceHasEpicSpells(oPC);

    if (nMaxPP <= 0 && nClassCount == 0 && !bHasEpic)
    {
        SendMessageToPC(oPC, "You do not currently have Power Points, spontaneous spell slots, or Epic Spell slots to display.");
        return;
    }

    json jRoot = NuiCol(NUIResourceCreateRows(oPC));
    json jWindow = NuiWindow(
        jRoot,
        JsonString("Resources"),
        NuiBind("geometry"),
        JsonBool(FALSE),
        JsonBool(FALSE),
        JsonBool(TRUE),
        JsonBool(TRUE),
        JsonBool(FALSE)
    );

    int nToken = NuiCreate(oPC, jWindow, NUI_PRC_RESOURCE_WINDOW);

    json jGeometry = GetLocalJson(oPC, NUI_PRC_RESOURCE_GEOMETRY_VAR);
    if (jGeometry == JsonNull())
    {
        float fHeight = 32.0f + NUIResourceGetLayoutHeight(oPC);
        jGeometry = NuiRect(20.0f, 180.0f, 680.0f, fHeight);
    }

    NuiSetBind(oPC, nToken, "geometry", jGeometry);
    NuiSetBindWatch(oPC, nToken, "geometry", TRUE);

    NUIResourceRefreshWindow(oPC);

    int nGeneration = GetLocalInt(oPC, NUI_PRC_RESOURCE_GENERATION_VAR) + 1;
    SetLocalInt(oPC, NUI_PRC_RESOURCE_GENERATION_VAR, nGeneration);
    DelayCommand(1.0f, NUIResourceRefreshLoop(oPC, nGeneration));
}
