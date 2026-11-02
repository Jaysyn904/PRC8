//::///////////////////////////////////////////////
//:: PRC8 Binder NUI Spellbook Test Suite
//:: test_binder_nui.nss
//:://////////////////////////////////////////////
//:: Tests Binder NUI Spellbook (/sb) single-page
//:: consolidation (<= 15 active abilities) vs.
//:: Vestige Level split tabs (> 15 active abilities
//:: across Circles 1-8 and Circle 0 "Prestige Class
//:: Abilities"), dynamic switching back and forth
//:: across the 15-ability threshold, Swift Action
//:: upgrade deduplication, live vestige spell-effect
//:: ownership validation, subradial icon preservation,
//:: and BinderNUIBuildHomeMaps cold-cache TMI avoidance.
//:://////////////////////////////////////////////

#include "bnd_inc_bndfunc"
#include "prc_nui_com_inc"
#include "prc_nui_sb_inc"
#include "prc_nui_bnd_inc"

void ResetBinderState(object oBinder)
{
    int i;
    for(i = 1; i <= 40; i++)
    {
        int nSpell = BinderNUIVestigeSpell(i);
        if(nSpell > 0)
            DeleteLocalInt(oBinder, "PactQuality" + IntToString(nSpell));
    }
    DeleteLocalInt(oBinder, "ExploitVestige");
    DeleteLocalInt(oBinder, "IgnoreSpecialRequirements");
    DeleteLocalInt(oBinder, "PactAugment_HP");
    DeleteLocalInt(oBinder, "PactAugment_ER");
    DeleteLocalInt(oBinder, "PactAugment_ST");
    DeleteLocalInt(oBinder, "PactAugment_DR");
    DeleteLocalInt(oBinder, "PactAugment_AC");
    DeleteLocalInt(oBinder, "PactAugment_AB");
    DeleteLocalInt(oBinder, "PactAugment_DB");
}

void CastTestVestigeOnSelf(object oBinder, int nVestigeSpell)
{
    AssignCommand(oBinder, ActionCastSpellAtObject(nVestigeSpell, oBinder, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
}

void RunTestSuite_BinderNUI_PhaseC(object oBinder)
{
    // Phase C (Switch back > 15 -> <= 15 abilities): After RemoveSpellEffectsByID
    // removed Naberius (19023), active abilities drop from 17 back to 7 (<= 15),
    // restoring single-page consolidation on Circle 1.
    AssertInt("NUI-07k: Active Binder ability count drops back to 7 (<= 15) after unbinding Naberius",
              GetBinderActiveSpellCount(oBinder), 7);
    AssertInt("NUI-07l: ShouldSplitBinderSpellbookByLevel switches back to FALSE at 7 (<= 15) abilities",
              ShouldSplitBinderSpellbookByLevel(oBinder), FALSE);
    AssertInt("NUI-07m: GetMinSpellLevel and GetMaxSpellLevel collapse back to 1:1 single-page mode",
              GetMinSpellLevel(CLASS_TYPE_BINDER) * 10 + GetMaxSpellLevel(CLASS_TYPE_BINDER), 11);
    AssertInt("NUI-07n: Circle 1 re-pools all 7 remaining abilities onto one page (Circles 4 & 5 = 0)",
              JsonGetLength(GetSpellListForCircle(oBinder, CLASS_TYPE_BINDER, 1)) * 100
              + JsonGetLength(GetSpellListForCircle(oBinder, CLASS_TYPE_BINDER, 4)) * 10
              + JsonGetLength(GetSpellListForCircle(oBinder, CLASS_TYPE_BINDER, 5)), 700);

    // Clean up bound test vestiges and skin feats
    RemoveSkinBonusFeat(oBinder, 13733);
    RemoveSkinBonusFeat(oBinder, 13734);
    RemoveSkinBonusFeat(oBinder, 13770);
    RemoveSkinBonusFeat(oBinder, 13771);
    RemoveSkinBonusFeat(oBinder, 13772);
    RemoveSkinBonusFeat(oBinder, 13761);
    RemoveSkinBonusFeat(oBinder, 13762);
    RemoveSkinBonusFeat(oBinder, 13763);
    RemoveSkinBonusFeat(oBinder, 13764);
    ClearAllEffectsOn(oBinder);

    // -------------------------------------------------------------------------
    // NUI-06: BinderNUIBuildHomeMaps Cold-Cache TMI Prevention & Map Population
    // -------------------------------------------------------------------------
    // Cap test character at Binder 20 before BinderNUIBuildHomeMaps on pre-epic
    // branches where cls_bind_binder.2da rows 21-40 still have MaxSoulBinding=0.
    if(GetHitDice(oBinder) > 20)
        SetXP(oBinder, 190000);
    BinderNUIBuildHomeMaps(oBinder);
    json jBindMap = GetLocalJson(oBinder, PRC_BINDER_NUI_HOME_BIND_MAP_VAR);
    int nAvailableVestiges = JsonGetLength(jBindMap);
    AssertTrue("NUI-06: BinderNUIBuildHomeMaps completes without TMI and populates available vestiges (" + IntToString(nAvailableVestiges) + ")",
               nAvailableVestiges >= 30);
}

void RunTestSuite_BinderNUI_PhaseB(object oBinder)
{
    // Phase B (Switch <= 15 -> > 15 abilities): Naberius (19023, 10 subradials:
    // 19074..19078, 19080..19084) is now bound alongside Tenebrous (4) and
    // Dantalion (3) -> 17 active abilities (> 15).
    AssertInt("NUI-07g: Active Binder ability count with Naberius (10) + Tenebrous (4) + Dantalion (3) is 17 (> 15)",
              GetBinderActiveSpellCount(oBinder), 17);
    AssertInt("NUI-07h: ShouldSplitBinderSpellbookByLevel switches to TRUE at 17 (> 15) abilities",
              ShouldSplitBinderSpellbookByLevel(oBinder), TRUE);
    AssertInt("NUI-07i: GetMinSpellLevel is 0 and GetMaxSpellLevel is 8 when split by vestige level",
              GetMinSpellLevel(CLASS_TYPE_BINDER) * 10 + GetMaxSpellLevel(CLASS_TYPE_BINDER), 8);
    AssertInt("NUI-07j: Circle 1 has 10 (Naberius L1), Circle 4 has 4 (Tenebrous L4), Circle 5 has 3 (Dantalion L5)",
              JsonGetLength(GetSpellListForCircle(oBinder, CLASS_TYPE_BINDER, 1)) * 100
              + JsonGetLength(GetSpellListForCircle(oBinder, CLASS_TYPE_BINDER, 4)) * 10
              + JsonGetLength(GetSpellListForCircle(oBinder, CLASS_TYPE_BINDER, 5)), 1043);

    // Now unbind Naberius (remove spell effect 19023) and verify in Phase C (0.5s later
    // after RemoveEffect settles) that the spellbook collapses back to single-page mode.
    RemoveSpellEffectsByID(oBinder, VESTIGE_NABERIUS);
    DelayCommand(0.5, RunTestSuite_BinderNUI_PhaseC(oBinder));
}

void RunTestSuite_BinderNUI_PhaseA(object oBinder)
{
    // Verify Dantalion (19042, 3 abilities) and Tenebrous (19037, 4 abilities) are bound
    AssertInt("NUI-05c: IsBinderFeatActive(9072) is TRUE when Dantalion is bound",
              IsBinderFeatActive(oBinder, 9072), TRUE);
    AssertInt("NUI-05d: IsBinderSpellActive(19120) is TRUE when Dantalion is bound",
              IsBinderSpellActive(oBinder, 19120), TRUE);

    // -------------------------------------------------------------------------
    // NUI-07: <= 15 Single-Page Consolidation & Dynamic Switching (<= 15 <-> > 15)
    // -------------------------------------------------------------------------
    // Phase A (<= 15 abilities): Dantalion (3 abilities: 19118..19120) +
    // Tenebrous (4 abilities: 19109..19112) = 7 active abilities (<= 15).
    AssertInt("NUI-07a: Active Binder ability count with Tenebrous (4) + Dantalion (3) is 7 (<= 15)",
              GetBinderActiveSpellCount(oBinder), 7);
    AssertInt("NUI-07b: ShouldSplitBinderSpellbookByLevel is FALSE when 7 (<= 15) abilities are active",
              ShouldSplitBinderSpellbookByLevel(oBinder), FALSE);
    AssertInt("NUI-07c: GetMinSpellLevel(CLASS_TYPE_BINDER) is 1 in single-page mode (<= 15 abilities)",
              GetMinSpellLevel(CLASS_TYPE_BINDER), 1);
    AssertInt("NUI-07d: GetMaxSpellLevel(CLASS_TYPE_BINDER) is 1 in single-page mode (<= 15 abilities)",
              GetMaxSpellLevel(CLASS_TYPE_BINDER), 1);
    AssertInt("NUI-07e: Circle 1 pools all 7 active abilities (Tenebrous L4 + Dantalion L5) on one page",
              JsonGetLength(GetSpellListForCircle(oBinder, CLASS_TYPE_BINDER, 1)), 7);
    AssertInt("NUI-07f: Circles 4 and 5 return 0 entries while consolidated onto Circle 1",
              JsonGetLength(GetSpellListForCircle(oBinder, CLASS_TYPE_BINDER, 4))
              + JsonGetLength(GetSpellListForCircle(oBinder, CLASS_TYPE_BINDER, 5)), 0);

    // Now bind Naberius (19023, 10 subradials) to cross > 15 abilities and verify in Phase B
    CastTestVestigeOnSelf(oBinder, VESTIGE_NABERIUS);
    DelayCommand(3.2, RunTestSuite_BinderNUI_PhaseB(oBinder));
}

void RunTestSuite_BinderNUI(object oApply, object oBinder, object oTarget)
{
    WriteTimestampedLogEntry("[HARNESS] --- Suite: Binder NUI Spellbook Circles 0-8, <=15 Single-Page Mode & Swift Deduplication ---");
    if(GetLevelByClass(CLASS_TYPE_BINDER, oBinder) < 17)
    {
        SetXP(oBinder, 190000);
        int nLv;
        for(nLv = GetHitDice(oBinder); nLv < 18; nLv++)
        {
            LevelUpHenchman(oBinder, CLASS_TYPE_BINDER, TRUE, PACKAGE_INVALID);
        }
    }
    GetPCSkin(oBinder);
    ResetBinderState(oBinder);
    ClearAllEffectsOn(oBinder);
    ClearAllEffectsOn(oTarget);

    // Build NUI dictionaries on oBinder
    GetBinderSpellToFeatDictionary(oBinder);
    GetBinderFeatToVestigeDictionary(oBinder);

    // -------------------------------------------------------------------------
    // NUI-01: GetBinderMaxVestigeLevelForNUI & Single-Page Default When 0 Bound
    // -------------------------------------------------------------------------
    int nMinLvl = GetMinSpellLevel(CLASS_TYPE_BINDER);
    int nMaxLvl = GetMaxSpellLevel(CLASS_TYPE_BINDER);
    int nExpectedMaxVL = GetBinderMaxVestigeLevelForNUI(oBinder);
    AssertInt("NUI-01a: GetMinSpellLevel(CLASS_TYPE_BINDER) defaults to 1 when <= 15 abilities are active",
              nMinLvl, 1);
    AssertInt("NUI-01b: GetMaxSpellLevel(CLASS_TYPE_BINDER) defaults to 1 when <= 15 abilities are active",
              nMaxLvl, 1);
    AssertInt("NUI-01c: GetBinderMaxVestigeLevelForNUI reaches Circle 8 at EBL 17+",
              nExpectedMaxVL, 8);

    // -------------------------------------------------------------------------
    // NUI-02: GetBinderSpellCircle maps vestige abilities to Circles 1-8
    // -------------------------------------------------------------------------
    AssertInt("NUI-02a: Amon Fire Breath (19070) maps to Circle 1",
              GetBinderSpellCircle(oBinder, 19070), 1);
    AssertInt("NUI-02b: Savnok Call Armor (19088) maps to Circle 2",
              GetBinderSpellCircle(oBinder, 19088), 2);
    AssertInt("NUI-02c: Paimon Dance of Death (19096) maps to Circle 3",
              GetBinderSpellCircle(oBinder, 19096), 3);
    AssertInt("NUI-02d: Paimon Whirlwind Attack (19101) maps to Circle 3",
              GetBinderSpellCircle(oBinder, 19101), 3);
    AssertInt("NUI-02e: Tenebrous Deeper Darkness (19105) maps to Circle 4",
              GetBinderSpellCircle(oBinder, 19105), 4);
    AssertInt("NUI-02f: Dantalion Awe of Dantalion (19119) maps to Circle 5",
              GetBinderSpellCircle(oBinder, 19119), 5);
    AssertInt("NUI-02g: Zceryll Summon Alien (19130) maps to Circle 6",
              GetBinderSpellCircle(oBinder, 19130), 6);
    AssertInt("NUI-02h: Marchosias Smoke Form (19146) maps to Circle 7",
              GetBinderSpellCircle(oBinder, 19146), 7);
    AssertInt("NUI-02i: Halphax Iron Wall (19151) maps to Circle 8",
              GetBinderSpellCircle(oBinder, 19151), 8);
    AssertInt("NUI-02j: Non-Binder spell (SPELL_FIREBALL = 58) returns -1 sentinel",
              GetBinderSpellCircle(oBinder, 58), -1);

    // -------------------------------------------------------------------------
    // NUI-03: Circle 0 ("Prestige Class Abilities") & Scion 9312 Mapping
    // -------------------------------------------------------------------------
    json jCircles = GetBinderFeatCircleDictionary(oBinder);
    AssertInt("NUI-03a: Anima Mage Vestige Metamagic (feat 9260) maps to Circle 0",
              JsonGetInt(JsonObjectGet(jCircles, "9260")), 0);
    AssertInt("NUI-03b: Tenebrous Apostate Turn Undead (feat 9262) maps to Circle 0",
              JsonGetInt(JsonObjectGet(jCircles, "9262")), 0);
    AssertInt("NUI-03c: Knight of the Sacred Seal Aligned Strike (feat 9306) maps to Circle 0",
              JsonGetInt(JsonObjectGet(jCircles, "9306")), 0);
    AssertInt("NUI-03d: Scion of Dantalion Read Thoughts (feat 9309) maps to Circle 0",
              JsonGetInt(JsonObjectGet(jCircles, "9309")), 0);
    AssertInt("NUI-03e: Scion Improved Thought Travel (feat 9312) maps to Dantalion Circle 5",
              JsonGetInt(JsonObjectGet(jCircles, "9312")), 5);

    // -------------------------------------------------------------------------
    // NUI-04: Dynamic Swift-Action Upgrade Resolution (GetBinderActiveFeatForSpell)
    // -------------------------------------------------------------------------
    RemoveSkinBonusFeat(oBinder, 13741);
    RemoveSkinBonusFeat(oBinder, 13742);
    RemoveSkinBonusFeat(oBinder, 13744);
    RemoveSkinBonusFeat(oBinder, 13745);
    RemoveSkinBonusFeat(oBinder, 13772);

    // Malphas Invisibility (19091): base 9041 (13741) -> swift 9042 (13742) at EBL 15+
    AddSkinBonusFeat(oBinder, 13741);
    AssertInt("NUI-04a: Malphas Invisibility (19091) resolves to base feat 9041 when 9042 not present",
              GetBinderActiveFeatForSpell(oBinder, 19091), 9041);
    AddSkinBonusFeat(oBinder, 13742);
    AssertInt("NUI-04b: Malphas Invisibility (19091) upgrades to swift feat 9042 at EBL 15+",
              GetBinderActiveFeatForSpell(oBinder, 19091), 9042);

    // Savnok Move Ally (19093): base 9044 (13744) -> swift 9045 (13745) at EBL 13+
    AddSkinBonusFeat(oBinder, 13744);
    AssertInt("NUI-04c: Savnok Move Ally (19093) resolves to base feat 9044 when 9045 not present",
              GetBinderActiveFeatForSpell(oBinder, 19093), 9044);
    AddSkinBonusFeat(oBinder, 13745);
    AssertInt("NUI-04d: Savnok Move Ally (19093) upgrades to swift feat 9045 at EBL 13+",
              GetBinderActiveFeatForSpell(oBinder, 19093), 9045);

    // Dantalion Thought Travel (19120): base 9072 (13772)
    AddSkinBonusFeat(oBinder, 13772);
    AssertInt("NUI-04e: Dantalion Thought Travel (19120) resolves to base feat 9072 without Scion feat",
              GetBinderActiveFeatForSpell(oBinder, 19120), 9072);

    RemoveSkinBonusFeat(oBinder, 13741);
    RemoveSkinBonusFeat(oBinder, 13742);
    RemoveSkinBonusFeat(oBinder, 13744);
    RemoveSkinBonusFeat(oBinder, 13745);
    RemoveSkinBonusFeat(oBinder, 13772);

    // -------------------------------------------------------------------------
    // NUI-05: IsBinderFeatActive & IsBinderSpellActive Live Effect Validation
    // -------------------------------------------------------------------------
    AddSkinBonusFeat(oBinder, 13772);
    AssertInt("NUI-05a: IsBinderFeatActive(9072) is FALSE when Dantalion is not bound",
              IsBinderFeatActive(oBinder, 9072), FALSE);
    AssertInt("NUI-05b: IsBinderSpellActive(19120) is FALSE when Dantalion is not bound",
              IsBinderSpellActive(oBinder, 19120), FALSE);

    // Subradial GetSpellIcon check: Focalor Aura of Sadness (19087) has its own icon
    string sIcon = JsonGetString(GetSpellIcon(19087));
    AssertTrue("NUI-05e: GetSpellIcon returns valid icon resref for vestige ability spell",
               sIcon != "");

    // Bind Dantalion (19042, 3 abilities) and Tenebrous (19037, 4 abilities) first
    // for Phase A (7 abilities <= 15); Phase A then binds Naberius (10 subradials)
    // for Phase B (17 abilities > 15) and unbinds Naberius for Phase C (7 <= 15).
    SetLocalInt(oBinder, "PactQuality" + IntToString(VESTIGE_DANTALION), TRUE);
    SetLocalInt(oBinder, "PactQuality" + IntToString(VESTIGE_TENEBROUS), TRUE);
    SetLocalInt(oBinder, "PactQuality" + IntToString(VESTIGE_NABERIUS), TRUE);
    AssignCommand(oBinder, ClearAllActions());
    DelayCommand(0.1, CastTestVestigeOnSelf(oBinder, VESTIGE_DANTALION));
    DelayCommand(3.1, CastTestVestigeOnSelf(oBinder, VESTIGE_TENEBROUS));
    DelayCommand(6.5, RunTestSuite_BinderNUI_PhaseA(oBinder));
}
