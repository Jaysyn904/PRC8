//::///////////////////////////////////////////////
//:: Apply a saved Incarnum loadout after rest
//:: prc_nui_moi_ap
//:://////////////////////////////////////////////

#include "prc_nui_moi_pln"
#include "prc_nui_consts"
#include "prc_inc_util"
#include "inc_dynconv"

void MoiLoadoutOpenLegacyFallback(object oPC, string sReason)
{
    int bHasLegacyPicker = MoiLoadoutHasShapingClass(oPC);
    if (sReason != "")
        SendMessageToPC(
            oPC,
            "Saved Incarnum loadout was not applied: " + sReason
          + (bHasLegacyPicker
                ? " Opening the normal soulmeld selection instead."
                : " No soulmeld selection is currently available.")
        );

    MoiLoadoutClearConversationMarkers(oPC);
    // Saved plans suppress the class rest hooks before they mutate live state.
    // The rest handler already provided the legacy flow with one clean slate.
    if (!bHasLegacyPicker)
    {
        // A full respec leaves no legacy picker to open.  The rest handler has
        // already removed the old state and effects.  A mixed Incarnum Blade
        // can also reach this path after losing enough Constitution to shape
        // zero normal soulmelds, so preserve its independent saved default.
        if (GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oPC) > 0
            && GetLocalInt(oPC, PRC_MOI_BLADE_REST_GENERATION_VAR)
                == GetLocalInt(oPC, PRC_Rest_Generation)
            && GetLocalInt(oPC, PRC_MOI_BLADE_REST_GENERATION_VAR) > 0)
        {
            SetLocalInt(
                oPC,
                PRC_MOI_BLADE_REST_SOURCE_VAR,
                PRC_MOI_BLADE_REST_SOURCE_PURE
            );
            DelayCommand(0.1f, ExecuteScript("prc_nui_moi_ba", oPC));
        }
        return;
    }

    StartDynamicConversation(
        "moi_meldshapecnv",
        oPC,
        DYNCONV_EXIT_NOT_ALLOWED,
        FALSE,
        TRUE,
        oPC
    );
}

void main()
{
    object oPC = OBJECT_SELF;
    int nExpected = GetLocalInt(oPC, PRC_MOI_LOADOUT_REST_GENERATION_VAR);
    if (!GetIsPC(oPC)
        || nExpected <= 0
        || nExpected != GetLocalInt(oPC, PRC_Rest_Generation))
        return;

    DeleteLocalInt(oPC, PRC_MOI_LOADOUT_REST_GENERATION_VAR);
    json jPlan = MoiLoadoutReadSaved(oPC);
    if (jPlan == JsonNull())
    {
        MoiLoadoutOpenLegacyFallback(oPC, "the saved data is incomplete");
        return;
    }

    string sError = MoiLoadoutValidate(oPC, jPlan);
    if (sError != "")
    {
        MoiLoadoutOpenLegacyFallback(oPC, sError);
        return;
    }
    if (!MoiLoadoutApplyValidated(oPC, jPlan))
    {
        MoiLoadoutOpenLegacyFallback(
            oPC,
            "the final safety check did not complete"
        );
        return;
    }

    SendMessageToPC(
        oPC,
        "Your saved Incarnum loadout was restored: "
      + MoiLoadoutSummary(oPC, jPlan) + "."
    );

    if (NuiFindWindow(oPC, PRC_SPELLBOOK_NUI_WINDOW_ID)
        && GetLocalInt(oPC, PRC_SPELLBOOK_SELECTED_MODE_VAR)
            == 2) // PRC_SPELLBOOK_MODE_INCARNUM
        DelayCommand(1.0f, ExecuteScript("prc_nui_sb_view", oPC));

    // Incarnum Blade has its own, separate blademeld lifecycle.  A saved
    // blademeld default applies behind every queued ReshapeMelds cast; without
    // one, retain the original picker and its exact queue-safe start mode.
    if (GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oPC) > 0)
    {
        if (GetLocalInt(oPC, PRC_MOI_BLADE_REST_GENERATION_VAR)
                == GetLocalInt(oPC, PRC_Rest_Generation)
            && GetLocalInt(oPC, PRC_MOI_BLADE_REST_GENERATION_VAR) > 0)
        {
            SetLocalInt(
                oPC,
                PRC_MOI_BLADE_REST_SOURCE_VAR,
                PRC_MOI_BLADE_REST_SOURCE_QUEUE
            );
            DelayCommand(1.0f, ExecuteScript("prc_nui_moi_ba", oPC));
        }
        else
            DelayCommand(1.0f, StartDynamicConversation(
                "moi_iblade_bind",
                oPC,
                DYNCONV_EXIT_NOT_ALLOWED,
                FALSE,
                FALSE,
                oPC
            ));
    }
}
