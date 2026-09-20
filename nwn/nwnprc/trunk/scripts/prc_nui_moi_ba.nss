//::///////////////////////////////////////////////
//:: Apply an Incarnum Blade NUI selection
//:: prc_nui_moi_ba
//:://////////////////////////////////////////////

#include "prc_nui_moi_bld"
#include "prc_inc_util"
#include "inc_dynconv"

void MoiBladeOpenLegacyFallback(
    object oPC,
    int nSource,
    string sReason
)
{
    if (sReason != "")
        SendMessageToPC(
            oPC,
            "Saved blademeld default was not applied: " + sReason
          + ". Opening the original PRC picker instead."
        );

    // This fallback runs after the post-rest feat rebuild.  A forced start on
    // the pure path would erase casts queued by other completed-rest hooks.
    // Only a handoff from the just-finished legacy shaping conversation needs
    // the original force-start behavior; every delayed path waits its turn.
    int bForce = nSource == PRC_MOI_BLADE_REST_SOURCE_CONVERSATION;
    StartDynamicConversation(
        "moi_iblade_bind",
        oPC,
        DYNCONV_EXIT_NOT_ALLOWED,
        FALSE,
        bForce,
        oPC
    );
}

void MoiBladeApplyRebind(object oPC)
{
    DeleteLocalInt(oPC, PRC_MOI_BLADE_APPLY_MODE_VAR);
    int nFirst = GetLocalInt(oPC, PRC_MOI_BLADE_DRAFT_FIRST_VAR);
    int nSecond = GetLocalInt(oPC, PRC_MOI_BLADE_DRAFT_SECOND_VAR);
    string sError = MoiBladeValidateChoices(oPC, nFirst, nSecond);
    if (sError == "")
    {
        if (GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oPC) < 3)
            sError = "Rebind Blademeld is gained at Incarnum Blade level 3.";
        else if (GetFeatRemainingUses(
                FEAT_INCARNUM_BLADE_REBIND,
                oPC
            ) <= 0)
            sError = "No Rebind Blademeld uses remain today.";
    }

    if (sError != "")
    {
        SendMessageToPC(oPC, sError);
        ExecuteScript("prc_nui_moi_bv", oPC);
        return;
    }

    // Spend only after the final validation.  This mirrors the existing feat's
    // daily resource while leaving its radial/dialogue path unchanged.
    DecrementRemainingFeatUses(oPC, FEAT_INCARNUM_BLADE_REBIND);
    AssignCommand(oPC, ClearAllActions(TRUE));
    if (!MoiBladeApplyChoices(oPC, nFirst, nSecond))
    {
        // The same state was validated immediately above, so this is only a
        // defensive refund if a future helper adds another rejection path.
        IncrementRemainingFeatUses(oPC, FEAT_INCARNUM_BLADE_REBIND);
        SendMessageToPC(oPC, "The blademeld rebind was not applied.");
        ExecuteScript("prc_nui_moi_bv", oPC);
        return;
    }

    SendMessageToPC(
        oPC,
        "Rebound blademeld: "
      + MoiBladeChoiceSummary(nFirst, nSecond) + "."
    );
    MoiBladeDiscardDraft(oPC);
}

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC))
        return;

    if (GetLocalInt(oPC, PRC_MOI_BLADE_APPLY_MODE_VAR)
        == PRC_MOI_BLADE_APPLY_MODE_REBIND)
    {
        MoiBladeApplyRebind(oPC);
        return;
    }

    int nExpected = GetLocalInt(
        oPC,
        PRC_MOI_BLADE_REST_GENERATION_VAR
    );
    if (nExpected <= 0
        || nExpected != GetLocalInt(oPC, PRC_Rest_Generation))
        return;

    int nSource = GetLocalInt(oPC, PRC_MOI_BLADE_REST_SOURCE_VAR);
    DeleteLocalInt(oPC, PRC_MOI_BLADE_REST_GENERATION_VAR);
    DeleteLocalInt(oPC, PRC_MOI_BLADE_REST_SOURCE_VAR);

    if (GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oPC) <= 0)
        return;

    json jPlan = MoiBladeReadSaved(oPC);
    string sError = MoiBladeValidatePlan(oPC, jPlan);
    if (sError != "")
    {
        MoiBladeOpenLegacyFallback(oPC, nSource, sError);
        return;
    }

    int nFirst = MoiBladePlanFirst(jPlan);
    int nSecond = MoiBladePlanSecond(jPlan);
    if (!MoiBladeApplyChoices(oPC, nFirst, nSecond))
    {
        MoiBladeOpenLegacyFallback(
            oPC,
            nSource,
            "the final safety check did not complete"
        );
        return;
    }

    SendMessageToPC(
        oPC,
        "Your saved blademeld default was restored: "
      + MoiBladeChoiceSummary(nFirst, nSecond) + "."
    );
}
