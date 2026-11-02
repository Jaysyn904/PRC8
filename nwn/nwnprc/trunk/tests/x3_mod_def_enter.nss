//::///////////////////////////////////////////////
//:: PRC8 Automated In-Engine Test Harness
//:: x3_mod_def_enter.nss
//:://////////////////////////////////////////////
//:: Generic module OnClientEnter test entrypoint.
//:: Provides common assertion and effect/skin helpers
//:: and dispatches registered feature test suites.
//:://////////////////////////////////////////////

#include "prc_inc_spells"

const string HARNESS_TAG_DONE = "PRC8_TEST_HARNESS_DONE";

void ClearAllEffectsOn(object oTarget)
{
    effect e = GetFirstEffect(oTarget);
    while(GetIsEffectValid(e))
    {
        RemoveEffect(oTarget, e);
        e = GetNextEffect(oTarget);
    }
}

void RemoveSpellEffectsByID(object oTarget, int nSpellID)
{
    effect e = GetFirstEffect(oTarget);
    while(GetIsEffectValid(e))
    {
        if(GetEffectSpellId(e) == nSpellID)
            RemoveEffect(oTarget, e);
        e = GetNextEffect(oTarget);
    }
}

void AddSkinBonusFeat(object oCreature, int nIPFeat)
{
    object oSkin = GetPCSkin(oCreature);
    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(nIPFeat), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

void RemoveSkinBonusFeat(object oCreature, int nIPFeat)
{
    object oSkin = GetPCSkin(oCreature);
    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, nIPFeat, -1, 1, "", -1, DURATION_TYPE_PERMANENT);
    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, nIPFeat, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
}

void AssertInt(string sName, int nActual, int nExpected)
{
    object oMod = GetModule();
    if(nActual == nExpected)
    {
        int nPass = GetLocalInt(oMod, "HARNESS_PASS") + 1;
        SetLocalInt(oMod, "HARNESS_PASS", nPass);
        WriteTimestampedLogEntry("[PASS] " + sName + " (actual=" + IntToString(nActual) + ", expected=" + IntToString(nExpected) + ")");
    }
    else
    {
        int nFail = GetLocalInt(oMod, "HARNESS_FAIL") + 1;
        SetLocalInt(oMod, "HARNESS_FAIL", nFail);
        WriteTimestampedLogEntry("[FAIL] " + sName + " (actual=" + IntToString(nActual) + ", expected=" + IntToString(nExpected) + ")");
    }
}

void AssertTrue(string sName, int bCond)
{
    AssertInt(sName, bCond ? 1 : 0, 1);
}

void FinishTestHarness()
{
    object oMod = GetModule();
    int nPass = GetLocalInt(oMod, "HARNESS_PASS");
    int nFail = GetLocalInt(oMod, "HARNESS_FAIL");
    WriteTimestampedLogEntry("[HARNESS] ==========================================");
    WriteTimestampedLogEntry("[HARNESS] SUMMARY: PASS=" + IntToString(nPass) + " FAIL=" + IntToString(nFail));
    WriteTimestampedLogEntry("[HARNESS] ==========================================");
    int nFlush;
    for(nFlush = 0; nFlush < 40; nFlush++)
    {
        WriteTimestampedLogEntry("[HARNESS_FLUSH] ========================================================================================================================");
    }
    EndGame("");
}

#include "test_binder_nui"

void RunAllTestSuites(object oPC)
{
    location lLoc = GetLocation(oPC);
    object oHelper = CreateObject(OBJECT_TYPE_CREATURE, "nw_goblina", lLoc, FALSE, "HARNESS_HELPER");
    SetPlotFlag(oHelper, TRUE);
    object oTarget = CreateObject(OBJECT_TYPE_CREATURE, "nw_bandit001", lLoc, FALSE, "HARNESS_TARGET");
    SetPlotFlag(oTarget, TRUE);

    RunTestSuite_BinderNUI(oHelper, oPC, oTarget);
    DelayCommand(13.5, FinishTestHarness());
}

void main()
{
    object oMod = GetModule();
    if(GetLocalInt(oMod, HARNESS_TAG_DONE))
        return;

    object oPC = GetEnteringObject();
    if(!GetIsObjectValid(oPC))
        oPC = GetFirstPC();
    if(!GetIsObjectValid(oPC))
        return;

    SetLocalInt(oMod, HARNESS_TAG_DONE, TRUE);
    WriteTimestampedLogEntry("[HARNESS] Starting PRC8 Automated Test Harness...");
    // Wait 6.5s so prc_onenter's DelayCommand(6.0, RestoreCraftingStateOnLogin()) completes first
    DelayCommand(6.5, RunAllTestSuites(oPC));
}
