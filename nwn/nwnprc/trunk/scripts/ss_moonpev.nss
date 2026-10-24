#include "nw_inc_nui"
#include "prc_ss_prep"

void main()
{
    object oPC = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    if(NuiGetWindowId(oPC, nToken) != SSP_WINDOW
        || NuiFindWindow(oPC, SSP_WINDOW) != nToken) return;
    string sEvent = NuiGetEventType();
    string sId = NuiGetEventElement();
    int nClass = SSPGetClass(oPC);
    if(nClass == CLASS_TYPE_INVALID || !SSPIsNativePrepared(oPC, nClass))
    {
        NuiDestroy(oPC, nToken);
        return;
    }
    if(sEvent == "watch" && sId == "ss_meta")
    {
        int nMeta = JsonGetInt(NuiGetBind(oPC, nToken, "ss_meta"));
        if(nMeta != METAMAGIC_NONE
            && (SSPMetaFeat(nMeta) < 0 || !GetHasFeat(SSPMetaFeat(nMeta), oPC)))
            return;
        SetLocalInt(oPC, SSP_META, nMeta);
        DeleteLocalInt(oPC, SSP_LEVEL);
        ExecuteScript("ss_moonprep", oPC);
        return;
    }
    if(sEvent != "click") return;
    if(sId == "close")
    {
        NuiDestroy(oPC, nToken);
        DeleteLocalInt(oPC, SSP_LEVEL);
        DeleteLocalJson(oPC, SSP_SLOT_MAP);
        return;
    }
    if(sId == "back")
    {
        DeleteLocalInt(oPC, SSP_LEVEL);
        ExecuteScript("ss_moonprep", oPC);
        return;
    }
    if(GetStringLeft(sId, 5) == "moon_")
    {
        int nLevel = StringToInt(GetStringRight(sId, GetStringLength(sId) - 5));
        int nSpell = SSPMoonSpell(nLevel);
        int nMeta = GetLocalInt(oPC, SSP_META);
        int nSlot = nLevel + GetMetaMagicSpellLevelAdjustment(nMeta);
        if(nSpell < 0 || nSlot > 9 || !SSPMetaAllowed(oPC, nSpell, nMeta)
            || GetAbilityScoreForClass(nClass, oPC) < 10 + nLevel
            || GetMemorizedSpellCountByLevel(oPC, nClass, nSlot) <= 0) return;
        SetLocalInt(oPC, SSP_LEVEL, nLevel);
        ExecuteScript("ss_moonprep", oPC);
        return;
    }
    if(GetStringLeft(sId, 5) != "slot_") return;
    json jSlot = JsonObjectGet(GetLocalJson(oPC, SSP_SLOT_MAP), sId);
    if(jSlot == JsonNull()) return;
    int nLevel = JsonGetInt(JsonObjectGet(jSlot, "level"));
    int nIndex = JsonGetInt(JsonObjectGet(jSlot, "index"));
    int nSpell = JsonGetInt(JsonObjectGet(jSlot, "new"));
    int nMeta = JsonGetInt(JsonObjectGet(jSlot, "newmeta"));
    int nOld = JsonGetInt(JsonObjectGet(jSlot, "old"));
    if(nClass != JsonGetInt(JsonObjectGet(jSlot, "class"))
        || !SSPIsPreparedMoon(oPC, nClass, nLevel, nSpell, nMeta, FALSE)
        || nIndex < 0 || nIndex >= GetMemorizedSpellCountByLevel(oPC, nClass, nLevel)
        || nOld < 0 || GetMemorizedSpellId(oPC, nClass, nLevel, nIndex) != nOld
        || GetMemorizedSpellIsDomainSpell(oPC, nClass, nLevel, nIndex) != FALSE
        || GetMemorizedSpellMetaMagic(oPC, nClass, nLevel, nIndex)
            != JsonGetInt(JsonObjectGet(jSlot, "meta"))
        || GetMemorizedSpellReady(oPC, nClass, nLevel, nIndex)
            != JsonGetInt(JsonObjectGet(jSlot, "ready")))
    {
        SendMessageToPC(oPC, "That slot changed. Choose again from the refreshed list.");
        ExecuteScript("ss_moonprep", oPC);
        return;
    }
    // Never set TRUE here. Even replacing a ready spell requires a new rest.
    SetMemorizedSpell(oPC, nClass, nLevel, nIndex, nSpell, FALSE, nMeta, FALSE);
    SendMessageToPC(oPC, SSPSpellName(nSpell) + " prepared in ordinary slot "
        + IntToString(nIndex + 1) + ". Rest to ready it, then cast through /sb.");
    ExecuteScript("ss_moonprep", oPC);
}
