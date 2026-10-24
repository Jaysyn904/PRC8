// Moon Spells preparation. Every change consumes an existing ordinary slot
// and is unready until rest; it never creates slots or restores a live cast.
#include "nw_inc_nui"
#include "prc_ss_prep"

json SSPButton(string sText, string sId, int bEnabled = TRUE)
{
    return NuiEnabled(NuiHeight(NuiId(NuiButton(JsonString(sText)), sId),
        38.0f), JsonBool(bEnabled));
}

void main()
{
    object oPC = OBJECT_SELF;
    int nClass = SSPGetClass(oPC);
    if(nClass == CLASS_TYPE_INVALID)
    {
        SendMessageToPC(oPC, "Moon Spells requires Silverstar and the advancement selection for your primary divine spellbook.");
        return;
    }
    int nOld = NuiFindWindow(oPC, SSP_WINDOW);
    if(nOld) NuiDestroy(oPC, nOld);
    if(!SSPIsNativePrepared(oPC, nClass))
    {
        DeleteLocalJson(oPC, SSP_SLOT_MAP);
        DeleteLocalInt(oPC, SSP_LEVEL);
        SendMessageToPC(oPC, "Use the Moon bonus-domain buttons in your spellbook to cast Moon spells, spending a spell slot of the same level. This spellbook does not use the optional Moon preparation window.");
        return;
    }

    int nLevel = GetLocalInt(oPC, SSP_LEVEL);
    int nMeta = GetLocalInt(oPC, SSP_META);
    json jRoot = JsonArray();
    json jOptions = JsonArray();
    jOptions = JsonArrayInsert(jOptions, NuiComboEntry("No metamagic", METAMAGIC_NONE));
    if(GetHasFeat(FEAT_EXTEND_SPELL, oPC))
        jOptions = JsonArrayInsert(jOptions, NuiComboEntry("Extend (+1 slot level)", METAMAGIC_EXTEND));
    if(GetHasFeat(FEAT_EMPOWER_SPELL, oPC))
        jOptions = JsonArrayInsert(jOptions, NuiComboEntry("Empower (+2 slot levels)", METAMAGIC_EMPOWER));
    if(GetHasFeat(FEAT_MAXIMIZE_SPELL, oPC))
        jOptions = JsonArrayInsert(jOptions, NuiComboEntry("Maximize (+3 slot levels)", METAMAGIC_MAXIMIZE));
    if(GetHasFeat(FEAT_QUICKEN_SPELL, oPC))
        jOptions = JsonArrayInsert(jOptions, NuiComboEntry("Quicken (+4 slot levels)", METAMAGIC_QUICKEN));
    if(GetHasFeat(FEAT_SILENCE_SPELL, oPC))
        jOptions = JsonArrayInsert(jOptions, NuiComboEntry("Silent (+1 slot level)", METAMAGIC_SILENT));
    if(GetHasFeat(FEAT_STILL_SPELL, oPC))
        jOptions = JsonArrayInsert(jOptions, NuiComboEntry("Still (+1 slot level)", METAMAGIC_STILL));

    string sClass = GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)));
    jRoot = JsonArrayInsert(jRoot, NuiHeight(NuiText(JsonString(
        sClass + ": choose a Moon spell, then replace an ordinary prepared slot. Rest to ready it; cast through /sb. Domain slots are excluded."), FALSE, NUI_SCROLLBARS_AUTO), 70.0f));
    jRoot = JsonArrayInsert(jRoot, NuiHeight(NuiCombo(jOptions, NuiBind("ss_meta")), 32.0f));
    json jBody = JsonArray();
    json jSlots = JsonObject();
    if(nLevel < 1 || nLevel > 9)
    {
        for(nLevel = 1; nLevel <= 9; nLevel++)
        {
            int nSpell = SSPMoonSpell(nLevel);
            int nSlotLevel = nLevel + GetMetaMagicSpellLevelAdjustment(nMeta);
            int bAllowed = nSpell >= 0 && nSlotLevel <= 9
                && SSPMetaAllowed(oPC, nSpell, nMeta)
                && GetAbilityScoreForClass(nClass, oPC) >= 10 + nLevel
                && GetMemorizedSpellCountByLevel(oPC, nClass, nSlotLevel) > 0;
            jBody = JsonArrayInsert(jBody, SSPButton(
                IntToString(nLevel) + ": " + SSPSpellName(nSpell)
                + " (slot " + IntToString(nSlotLevel) + ")",
                "moon_" + IntToString(nLevel), bAllowed));
        }
    }
    else
    {
        int nSpell = SSPMoonSpell(nLevel);
        int nSlotLevel = nLevel + GetMetaMagicSpellLevelAdjustment(nMeta);
        int nCount = 0;
        if(nSlotLevel <= 9 && SSPMetaAllowed(oPC, nSpell, nMeta))
            nCount = GetMemorizedSpellCountByLevel(oPC, nClass, nSlotLevel);
        jBody = JsonArrayInsert(jBody, NuiHeight(NuiLabel(JsonString(
            "Prepare " + SSPSpellName(nSpell) + " in level "
            + IntToString(nSlotLevel)), JsonInt(NUI_HALIGN_LEFT),
            JsonInt(NUI_VALIGN_MIDDLE)), 30.0f));
        int nShown;
        int i;
        for(i = 0; i < nCount; i++)
        {
            int nOldSpell = GetMemorizedSpellId(oPC, nClass, nSlotLevel, i);
            // An empty Cleric slot does not expose its domain reservation.
            // Require an existing ordinary spell to prove it is not a domain
            // slot. Fill an empty slot in the native book first if necessary.
            if(nOldSpell < 0
                || GetMemorizedSpellIsDomainSpell(oPC, nClass, nSlotLevel, i) != FALSE)
                continue;
            int nOldMeta = GetMemorizedSpellMetaMagic(oPC, nClass, nSlotLevel, i);
            int bReady = GetMemorizedSpellReady(oPC, nClass, nSlotLevel, i);
            json jSlot = JsonObject();
            jSlot = JsonObjectSet(jSlot, "class", JsonInt(nClass));
            jSlot = JsonObjectSet(jSlot, "level", JsonInt(nSlotLevel));
            jSlot = JsonObjectSet(jSlot, "index", JsonInt(i));
            jSlot = JsonObjectSet(jSlot, "old", JsonInt(nOldSpell));
            jSlot = JsonObjectSet(jSlot, "meta", JsonInt(nOldMeta));
            jSlot = JsonObjectSet(jSlot, "ready", JsonInt(bReady));
            jSlot = JsonObjectSet(jSlot, "new", JsonInt(nSpell));
            jSlot = JsonObjectSet(jSlot, "newmeta", JsonInt(nMeta));
            string sId = "slot_" + IntToString(i);
            jSlots = JsonObjectSet(jSlots, sId, jSlot);
            jBody = JsonArrayInsert(jBody, SSPButton(
                "Replace slot " + IntToString(i + 1) + ": "
                + SSPSpellName(nOldSpell) + (bReady ? " [ready]" : " [unready]"), sId));
            nShown++;
        }
        if(!nShown)
            jBody = JsonArrayInsert(jBody, NuiHeight(NuiText(JsonString(
                "No occupied ordinary slot is available. Prepare a spell of this level in your native spellbook, then reopen Moon Spells."), FALSE, NUI_SCROLLBARS_AUTO), 85.0f));
        jBody = JsonArrayInsert(jBody, SSPButton("Back to Moon spell list", "back"));
    }
    SetLocalJson(oPC, SSP_SLOT_MAP, jSlots);
    jRoot = JsonArrayInsert(jRoot, NuiGroup(NuiCol(jBody), TRUE, NUI_SCROLLBARS_AUTO));
    jRoot = JsonArrayInsert(jRoot, SSPButton("Close", "close"));
    json jWindow = NuiWindow(NuiCol(jRoot), JsonString("Silverstar: Moon Spells"),
        NuiRect(-1.0f, -1.0f, 440.0f, 560.0f), JsonBool(FALSE), JsonBool(FALSE),
        JsonBool(TRUE), JsonBool(FALSE), JsonBool(TRUE), JsonNull(), JsonNull());
    int nToken = NuiCreate(oPC, jWindow, SSP_WINDOW);
    if(nToken)
    {
        NuiSetBind(oPC, nToken, "ss_meta", JsonInt(nMeta));
        NuiSetBindWatch(oPC, nToken, "ss_meta", TRUE);
    }
}
