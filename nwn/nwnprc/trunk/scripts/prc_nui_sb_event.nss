//::///////////////////////////////////////////////
//:: PRC Spellbook NUI Events
//:: prc_nui_sb_event
//:://////////////////////////////////////////////
/*
    This is the event script for the PRC Spellbook NUI that handles button presses
    and the like
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 24.05.2005
//:://////////////////////////////////////////////

#include "prc_nui_consts"
#include "prc_nui_sb_inc"
#include "prc_nui_res_inc"

//
// SetWindowGeometry
// Saves the window geometry of the NUI Spellbook to the player so next time it
// renders it remembers where it was
//
// Arguments:
//   oPlayer:object player tied to NUI
//   nToken:int the NUI Spellbook window
//
void SetWindowGeometry(object oPlayer, int nToken);
void ClearPendingNativeDomainSelection(object oPlayer);
void ClearPendingNativeClassSelection(object oPlayer);
void SetPreferredDomainClass(object oPlayer, int nClass);
void ExpirePreferredDomainClass(object oPlayer, int nGeneration);

//
// DetermineRangeForSpell
// Takes the string range from the spells.2da of a spell and converts it to
// the appropriate float range for the manual targetting mode
//
// Arguments:
//   sRange:string the string range of the spell (P,T,S,M,L)
//
// Returns:
//   float The flaot representation of the sRange provided
//
float DetermineRangeForSpell(string sRange);

//
// DetermineShapeForSpell
// Takes the string shape from the spells.2da of a spell and converts it to
// the int representation of the spell's shape. This is case sensitive and
// has to be in all UpperCase
//
// Arguments:
//   shape:string the string shape of the spell (SPHERE,CONE, etc.)
//
// Returns:
//   int the int representation of the shape provided
//
int DetermineShapeForSpell(string shape);

//
// DetermineTargetType
// Takes the string (actually hex) target type from the spells.2da of a spell and convers it to
// the int representation of the spell's target type. How this works is a bit unintuitive but
// it converts the string hex to a int, then subtracts it by the powers of 2. Each power represents
// the target the spell is allowed to be used on as all the ints are bitwise added together
//
// Arguments:
//   targetType:string the hex value of the target type as a string.
//
// Returns:
//   int the bitwise int representation of the targetType
int DetermineTargetType(string targetType);

void main()
{
    object oPlayer   = NuiGetEventPlayer();
    int nToken               = NuiGetEventWindow();
    string sEvent    = NuiGetEventType();
    string sElement  = NuiGetEventElement();
    string sWindowId = NuiGetWindowId(oPlayer, nToken);

    if (sEvent == "watch" && sElement == "geometry")
    {
        // Save the geometry
        SetWindowGeometry(oPlayer, nToken);
        return;
    }

    // Not a mouseup event, nothing to do.
    if (sEvent != "mouseup")
    {
        return;
    }

    // Live refresh destroys and recreates the window, replacing the native
    // button-index map. Ignore a delayed mouseup from the destroyed token so
    // its old index can never resolve to a different entry in the new map.
    if (NuiFindWindow(oPlayer, PRC_SPELLBOOK_NUI_WINDOW_ID) != nToken)
        return;

    int spellId;
    int featId;
    int realSpellId;
    int bEpicSpellButton;
    int bDomainSpellButton;

    if (FindSubString(sElement, NUI_PRC_RESOURCE_SB_SLOT_BUTTON_BASE) == 0
        || sElement == NUI_PRC_RESOURCE_FOCUS_STATUS_BUTTON
        || sElement == NUI_PRC_RESOURCE_PP_BUTTON
        || sElement == NUI_PRC_RESOURCE_EPIC_ICON_BUTTON
        || sElement == NUI_PRC_RESOURCE_EPIC_BUTTON)
        return;

    if (sElement == NUI_PRC_RESOURCE_FOCUS_BUTTON)
    {
        if (GetMaximumPowerPoints(oPlayer) <= 0)
            return;

        if (GetIsPsionicallyFocused(oPlayer))
        {
            SendMessageToPC(oPlayer, "You are already Psionically Focused.");
            return;
        }

        if (GetCurrentPowerPoints(oPlayer) <= 0)
        {
            SendMessageToPC(oPlayer, "You have no Power Points and cannot gain Psionic Focus.");
            return;
        }

        AssignCommand(oPlayer,
            ActionUseFeat(FEAT_PSIONIC_FOCUS, oPlayer, NUI_PRC_RESOURCE_FOCUS_GAIN_SPELL));
        return;
    }

    if (sElement == PRC_SPELLBOOK_NUI_DOMAIN_MODE_BUTTON)
    {
        if (!NUISpellbookHasDomainContent(oPlayer))
            return;

        ClearPendingNativeDomainSelection(oPlayer);
        ClearPendingNativeClassSelection(oPlayer);
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
        SetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR, PRC_SPELLBOOK_MODE_DOMAIN);
        int nCircle = GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR);
        if (nCircle < 1 || nCircle > 9)
            SetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR, 1);
        ExecuteScript("prc_nui_sb_view", oPlayer);
        return;
    }

    // Checks to see if the event button has the class button baseId
    // Then replaces the baseId with nothing and converts the end of the string to a int
    // representing the ClassID gathered. (i.e. "test_123" gets converted to 123)
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_CLASS_BUTTON_BASEID) >= 0)
    {
        int classId = StringToInt(RegExpReplace(PRC_SPELLBOOK_NUI_CLASS_BUTTON_BASEID, sElement, ""));
        ClearPendingNativeDomainSelection(oPlayer);
        ClearPendingNativeClassSelection(oPlayer);
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
        SetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR, PRC_SPELLBOOK_MODE_CLASS);
        SetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR, classId);
        ExecuteScript("prc_nui_sb_view", oPlayer);
        return;
    }

    // Checks to see if the event button has the circle button baseId
    // Then replaces the baseId with nothing and converts the end of the string to a int
    // representing the circle number gathered. (i.e. "test_5" gets converted to 5)
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_CIRCLE_BUTTON_BASEID) >= 0)
    {
        int circle = StringToInt(RegExpReplace(PRC_SPELLBOOK_NUI_CIRCLE_BUTTON_BASEID, sElement, ""));
        ClearPendingNativeDomainSelection(oPlayer);
        ClearPendingNativeClassSelection(oPlayer);
        SetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR, circle);
        ExecuteScript("prc_nui_sb_view", oPlayer);
        return;
    }

    // Checks to see if the event button has the meta button baseId
    // Then replaces the baseId with nothing and converts the end of the string to a int
    // representing the SpellID gathered. (i.e. "test_123" gets converted to 123)
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_META_BUTTON_BASEID) >= 0)
    {
        spellId = StringToInt(RegExpReplace(PRC_SPELLBOOK_NUI_META_BUTTON_BASEID, sElement, ""));
        int masterSpellId = StringToInt(Get2DACache("spells", "Master", spellId));
        if (masterSpellId)
        {
            SetLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR, spellId);
            featId = StringToInt(Get2DACache("spells", "FeatID", masterSpellId));
        }
        else
            featId = StringToInt(Get2DACache("spells", "FeatID", spellId));
    }

    // PRC bonus-domain buttons display the actual domain spell, but cast the
    // already-existing level feat and its slot-specific radial child. This
    // retains all of CastDomainSpell's slot selection and one-use-per-level
    // enforcement instead of duplicating those rules in NUI code.
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_DOMAIN_SPELL_BUTTON_BASEID) == 0)
    {
        int nCode = StringToInt(RegExpReplace(
            PRC_SPELLBOOK_NUI_DOMAIN_SPELL_BUTTON_BASEID,
            sElement,
            ""
        ));
        int nSlot = nCode / 10;
        int nLevel = nCode - nSlot * 10;
        spellId = NUISpellbookGetBonusDomainSpell(oPlayer, nSlot, nLevel);
        if (spellId < 0)
        {
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        json jDomainPayload = NuiGetEventPayload();
        int nDomainButton = JsonGetInt(JsonObjectGet(jDomainPayload, "mouse_btn"));
        if (nDomainButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            CreateSpellDescriptionNUI(oPlayer, 0, spellId, 0, CLASS_TYPE_BARBARIAN);
            return;
        }
        if (nDomainButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        if (GetLocalInt(oPlayer, "DomainCast"))
        {
            SendMessageToPC(oPlayer, "Finish the pending domain spell selection before casting another domain spell.");
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        if (GetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR))
        {
            SendMessageToPC(oPlayer, "Finish or cancel the pending native domain spell target before casting another domain spell.");
            return;
        }

        if (GetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_PENDING_VAR))
        {
            SendMessageToPC(oPlayer, "Finish or cancel the pending native spell target before casting a bonus-domain spell.");
            return;
        }

        if (GetLocalInt(oPlayer, "DomainCastSpell" + IntToString(nLevel)))
        {
            SendMessageToPC(oPlayer, "You have already cast your bonus-domain spell for level " + IntToString(nLevel) + ".");
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        featId = SpellLevelToFeat(nLevel);
        if (featId <= 0 || !GetHasFeat(featId, oPlayer))
        {
            SendMessageToPC(oPlayer, "You have not unlocked bonus-domain spells of that level.");
            return;
        }

        int nMasterSpell = StringToInt(Get2DACache("feat", "SPELLID", featId));
        if (nMasterSpell <= 0)
            return;

        // In the class-tab view, pay from the spontaneous divine spellbook
        // whose slots are shown directly above this button. Domains mode is
        // character-wide and intentionally retains the legacy fallback order.
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR) == PRC_SPELLBOOK_MODE_CLASS)
        {
            int nPreferredClass = GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);
            if (GetLevelByClass(nPreferredClass, oPlayer) > 0
                && !GetIsBioDivineClass(nPreferredClass)
                && GetIsDivineClass(nPreferredClass, oPlayer)
                && GetSpellbookTypeForClass(nPreferredClass) == SPELLBOOK_TYPE_SPONTANEOUS)
                SetPreferredDomainClass(oPlayer, nPreferredClass);
        }

        SetLocalInt(
            oPlayer,
            NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR,
            nMasterSpell + nSlot
        );
        bDomainSpellButton = TRUE;
    }

    // Native prepared domain spells retain their exact class, level, slot and
    // metamagic while manual targeting is active. The trigger revalidates that
    // same preparation, then the engine performs the real cast and slot spend.
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_NATIVE_DOMAIN_SPELL_BUTTON_BASEID) == 0)
    {
        int nCode = StringToInt(RegExpReplace(
            PRC_SPELLBOOK_NUI_NATIVE_DOMAIN_SPELL_BUTTON_BASEID,
            sElement,
            ""
        ));
        int nClass = nCode / 10000;
        int nRemainder = nCode - nClass * 10000;
        int nLevel = nRemainder / 1000;
        int nIndex = nRemainder - nLevel * 1000;

        if (nClass == CLASS_TYPE_INVALID
            || GetLevelByClass(nClass, oPlayer) <= 0
            || nLevel < 1
            || nLevel > 9
            || StringToInt(Get2DACache("classes", "MemorizesSpells", nClass)) != TRUE)
        {
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        int nCount = GetMemorizedSpellCountByLevel(oPlayer, nClass, nLevel);

        if (nIndex < 0 || nIndex >= nCount
            || GetMemorizedSpellIsDomainSpell(oPlayer, nClass, nLevel, nIndex) != TRUE)
        {
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        int nNativeSpell = GetMemorizedSpellId(oPlayer, nClass, nLevel, nIndex);
        if (nNativeSpell < 0)
            return;

        json jNativePayload = NuiGetEventPayload();
        int nNativeButton = JsonGetInt(JsonObjectGet(jNativePayload, "mouse_btn"));
        if (nNativeButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            CreateSpellDescriptionNUI(oPlayer, 0, nNativeSpell, 0, nClass);
            return;
        }
        if (nNativeButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        if (GetLocalInt(oPlayer, "DomainCast"))
        {
            SendMessageToPC(oPlayer, "Finish the pending bonus-domain spell selection before casting a native domain spell.");
            return;
        }

        if (GetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR))
        {
            // A prior targeting mode may have been cancelled without a usable
            // callback. A fresh native click explicitly replaces that stale
            // request instead of leaving the domain UI permanently blocked.
            ClearPendingNativeDomainSelection(oPlayer);
        }

        if (GetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_PENDING_VAR))
        {
            SendMessageToPC(oPlayer, "Finish or cancel the pending native class spell target first.");
            return;
        }

        if (GetMemorizedSpellReady(oPlayer, nClass, nLevel, nIndex) != TRUE)
        {
            SendMessageToPC(oPlayer, "That native domain spell slot has already been expended.");
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        // A memorized radial master does not identify which child spell the
        // player intends to cast. Keep those in the native spellbook, where the
        // engine can present its normal subradial safely.
        if (Get2DACache("spells", "SubRadSpell1", nNativeSpell) != "")
        {
            SendMessageToPC(oPlayer, "This domain spell has multiple choices; cast it from the native spellbook so you can select one.");
            return;
        }

        int nNativeMetamagic = GetMemorizedSpellMetaMagic(oPlayer, nClass, nLevel, nIndex);
        if (nNativeMetamagic < METAMAGIC_NONE)
        {
            SendMessageToPC(oPlayer, "That native domain spell slot is no longer valid.");
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR, TRUE);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_CLASS_VAR, nClass);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_LEVEL_VAR, nLevel);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_INDEX_VAR, nIndex);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_SPELL_VAR, nNativeSpell);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_METAMAGIC_VAR, nNativeMetamagic);

        string sNativeRange = GetStringUpperCase(Get2DACache("spells", "Range", nNativeSpell));
        if (sNativeRange == "P")
        {
            SetLocalInt(oPlayer, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT, TRUE);
            ExecuteScript("prc_nui_sb_trggr", oPlayer);
            return;
        }

        SetLocalString(oPlayer, NUI_SPELLBOOK_ON_TARGET_ACTION_VAR, "PRC_NUI_SPELLBOOK");
        float fNativeRange = DetermineRangeForSpell(sNativeRange);
        string sNativeShape = GetStringUpperCase(Get2DACache("spells", "TargetShape", nNativeSpell));
        int nNativeShape = DetermineShapeForSpell(sNativeShape);
        float fNativeSizeX = StringToFloat(Get2DACache("spells", "TargetSizeX", nNativeSpell));
        float fNativeSizeY = StringToFloat(Get2DACache("spells", "TargetSizeY", nNativeSpell));
        int nNativeFlags = StringToInt(Get2DACache("spells", "TargetFlags", nNativeSpell));
        int nNativeTargetType = DetermineTargetType(Get2DACache("spells", "TargetType", nNativeSpell));

        SetEnterTargetingModeData(
            oPlayer,
            nNativeShape,
            fNativeSizeX,
            fNativeSizeY,
            nNativeFlags,
            fNativeRange,
            nNativeSpell
        );
        EnterTargetingMode(oPlayer, nNativeTargetType);
        return;
    }

    // Native engine spellbooks are rendered from a server-side button map.
    // Revalidate its class, level, tuple and remaining resource before entering
    // targeting mode; the trigger repeats these checks immediately before cast.
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_NATIVE_CLASS_SPELL_BUTTON_BASEID) == 0)
    {
        int nButtonIndex = StringToInt(RegExpReplace(
            PRC_SPELLBOOK_NUI_NATIVE_CLASS_SPELL_BUTTON_BASEID,
            sElement,
            ""
        ));
        json jMap = GetLocalJson(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_BUTTON_MAP_VAR);
        if (jMap == JsonNull()
            || nButtonIndex < 0 || nButtonIndex >= JsonGetLength(jMap))
        {
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        json jEntry = JsonArrayGet(jMap, nButtonIndex);
        int nCastType = JsonGetInt(JsonObjectGet(jEntry, "t"));
        int nClass = JsonGetInt(JsonObjectGet(jEntry, "c"));
        int nLevel = JsonGetInt(JsonObjectGet(jEntry, "l"));
        int nNativeSpell = JsonGetInt(JsonObjectGet(jEntry, "s"));
        int nNativeMetamagic = JsonGetInt(JsonObjectGet(jEntry, "m"));
        int bNativeDomain = JsonGetInt(JsonObjectGet(jEntry, "d"));

        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR) != PRC_SPELLBOOK_MODE_CLASS
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR) != nClass
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR) != nLevel
            || !NUISpellbookUsesNativeClassAdapter(oPlayer, nClass)
            || nNativeSpell < 0 || nLevel < 0 || nLevel > 9
            || (nCastType != NUI_SPELLBOOK_NATIVE_CAST_PREPARED
                && nCastType != NUI_SPELLBOOK_NATIVE_CAST_SPONTANEOUS))
        {
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        json jNativePayload = NuiGetEventPayload();
        int nNativeButton = JsonGetInt(JsonObjectGet(jNativePayload, "mouse_btn"));
        if (nNativeButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            CreateSpellDescriptionNUI(oPlayer, 0, nNativeSpell, 0, nClass);
            return;
        }
        if (nNativeButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        if (GetLocalInt(oPlayer, "DomainCast")
            || GetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR))
        {
            SendMessageToPC(oPlayer, "Finish or cancel the pending domain spell target first.");
            return;
        }
        if (GetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_PENDING_VAR))
            ClearPendingNativeClassSelection(oPlayer);

        if (Get2DACache("spells", "SubRadSpell1", nNativeSpell) != "")
        {
            SendMessageToPC(oPlayer, "This spell has multiple choices; cast it from the native spellbook so you can select one.");
            return;
        }

        if (nCastType == NUI_SPELLBOOK_NATIVE_CAST_PREPARED)
        {
            if (!NUISpellbookIsNativePreparedClass(nClass)
                || NUISpellbookNativePreparedCount(oPlayer, nClass, nLevel,
                    nNativeSpell, nNativeMetamagic, bNativeDomain, TRUE) <= 0)
            {
                SendMessageToPC(oPlayer, "That prepared spell is no longer ready.");
                ExecuteScript("prc_nui_sb_view", oPlayer);
                return;
            }
        }
        else
        {
            nNativeMetamagic = METAMAGIC_NONE;
            bNativeDomain = FALSE;
            if (!NUISpellbookIsNativeSpontaneousClass(nClass)
                || !NUISpellbookNativeKnownAtLevel(oPlayer, nClass, nLevel, nNativeSpell)
                || GetSpellUsesLeft(oPlayer, nClass, nNativeSpell) <= 0)
            {
                SendMessageToPC(oPlayer, "You have no remaining uses of that native spell level.");
                ExecuteScript("prc_nui_sb_view", oPlayer);
                return;
            }
        }

        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_PENDING_VAR, TRUE);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_CAST_TYPE_VAR, nCastType);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_CLASS_VAR, nClass);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_LEVEL_VAR, nLevel);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_SPELL_VAR, nNativeSpell);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_METAMAGIC_VAR, nNativeMetamagic);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_DOMAIN_VAR, bNativeDomain);

        string sNativeRange = GetStringUpperCase(Get2DACache("spells", "Range", nNativeSpell));
        if (sNativeRange == "P")
        {
            SetLocalInt(oPlayer, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT, TRUE);
            ExecuteScript("prc_nui_sb_trggr", oPlayer);
            return;
        }

        SetLocalString(oPlayer, NUI_SPELLBOOK_ON_TARGET_ACTION_VAR, "PRC_NUI_SPELLBOOK");
        float fNativeRange = DetermineRangeForSpell(sNativeRange);
        string sNativeShape = GetStringUpperCase(Get2DACache("spells", "TargetShape", nNativeSpell));
        int nNativeShape = DetermineShapeForSpell(sNativeShape);
        float fNativeSizeX = StringToFloat(Get2DACache("spells", "TargetSizeX", nNativeSpell));
        float fNativeSizeY = StringToFloat(Get2DACache("spells", "TargetSizeY", nNativeSpell));
        int nNativeFlags = StringToInt(Get2DACache("spells", "TargetFlags", nNativeSpell));
        int nNativeTargetType = DetermineTargetType(Get2DACache("spells", "TargetType", nNativeSpell));
        SetEnterTargetingModeData(oPlayer, nNativeShape, fNativeSizeX, fNativeSizeY,
            nNativeFlags, fNativeRange, nNativeSpell);
        EnterTargetingMode(oPlayer, nNativeTargetType);
        return;
    }

    // Epic spell buttons store the epicspells.2da row. Re-check the granted
    // feat at click time so a spell removed through Manage Epic Spells cannot
    // be cast from a stale, already-open NUI window.
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_EPIC_SPELL_BUTTON_BASEID) >= 0)
    {
        int epicSpellId = StringToInt(RegExpReplace(PRC_SPELLBOOK_NUI_EPIC_SPELL_BUTTON_BASEID, sElement, ""));
        featId = GetFeatForSpell(epicSpellId);

        if (featId <= 0 || !GetHasFeat(featId, oPlayer))
        {
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        spellId = StringToInt(Get2DACache("feat", "SPELLID", featId));
        if (spellId <= 0)
            return;

        bEpicSpellButton = TRUE;
    }

    // Checks to see if the event button has the class button baseId
    // Then replaces the baseId with nothing and converts the end of the string to a int
    // representing the SpellbookID gathered. (i.e. "test_123" gets converted to 123)
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_SPELL_BUTTON_BASEID) >= 0)
    {
        int spellbookId = StringToInt(RegExpReplace(PRC_SPELLBOOK_NUI_SPELL_BUTTON_BASEID, sElement, ""));
        int classId = GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);

        // special case for binders, since they don't have a spell 2da of their own.
        if (classId == CLASS_TYPE_BINDER)
        {
            json binderDict = GetBinderSpellToFeatDictionary(oPlayer);
            spellId = spellbookId;
            featId = JsonGetInt(JsonObjectGet(binderDict, IntToString(spellId)));
            if (!IsBinderSpellActive(oPlayer, spellId))
            {
                SendMessageToPC(oPlayer, "That vestige is no longer bound.");
                ExecuteScript("prc_nui_sb_view", oPlayer);
                return;
            }
            int masterSpellId = StringToInt(Get2DACache("spells", "Master", spellId));
            if (masterSpellId)
            {
                SetLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR, spellId);
            }

        }
        else
        {
            string sFile = GetClassSpellbookFile(classId);

            spellId = StringToInt(Get2DACache(sFile, "SpellID", spellbookId));
            realSpellId = StringToInt(Get2DACache(sFile, "RealSpellID", spellbookId));

            int masterSpellId = StringToInt(Get2DACache("spells", "Master", spellId));
            // If this spell is part of a radial we need to send the master featID
            // to be used along with the radial spellId
            if (masterSpellId)
            {
                SetLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR, spellId);
                featId = StringToInt(Get2DACache("spells", "FeatID", masterSpellId));
            }
            else
                featId = StringToInt(Get2DACache("spells", "FeatID", spellId));
        }
    }

    json jPayload = NuiGetEventPayload();
    int nButton = JsonGetInt(JsonObjectGet(jPayload, "mouse_btn"));

    // If right click, open the Spell Description NUI
    if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
    {
        int classId = (bEpicSpellButton || bDomainSpellButton)
                    ? CLASS_TYPE_BARBARIAN
                    : GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);
        CreateSpellDescriptionNUI(oPlayer, featId, spellId, realSpellId, classId);
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
        return;
    }
    // If left click, operate normally
    if (nButton == NUI_PAYLOAD_BUTTON_LEFT_CLICK)
    {

        if (GetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR))
        {
            SendMessageToPC(oPlayer, "Finish or cancel the pending native domain spell target first.");
            return;
        }

        if (GetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_PENDING_VAR))
        {
            SendMessageToPC(oPlayer, "Finish or cancel the pending native spell target first.");
            return;
        }

        // We use the spell's FeatID to do actions, and we set the OnTarget action
        // to PRC_NUI_SPELLBOOK so the handler knows what the action is being done
        SetLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_FEATID_VAR, featId);

        string sRange = GetStringUpperCase(Get2DACache("spells", "Range", spellId));
        // If its a personal spell/feat than use it directly on the player.
        if (sRange == "P")
        {
            SetLocalInt(oPlayer, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT, 1);
            ExecuteScript("prc_nui_sb_trggr", oPlayer);
        }
        // otherwise enter targetting mode
        else
        {
            SetLocalString(oPlayer, NUI_SPELLBOOK_ON_TARGET_ACTION_VAR, "PRC_NUI_SPELLBOOK");

            // These gather the targetting information for the TargetingMode functions
            float fRange = DetermineRangeForSpell(sRange);
            string sShape = GetStringUpperCase(Get2DACache("spells", "TargetShape", spellId));
            int iShape = DetermineShapeForSpell(sShape);
            float fSizeX = StringToFloat(Get2DACache("spells", "TargetSizeX", spellId));
            float fSizeY = StringToFloat(Get2DACache("spells", "TargetSizeY", spellId));
            int nFlags = StringToInt(Get2DACache("spells", "TargetFlags", spellId));
            string sTargetType = Get2DACache("spells", "TargetType", spellId);
            int iTargetType = DetermineTargetType(sTargetType);

            SetEnterTargetingModeData(oPlayer, iShape, fSizeX, fSizeY, nFlags, fRange);
            EnterTargetingMode(oPlayer, iTargetType);
            }
    }
}

void ClearPendingNativeDomainSelection(object oPlayer)
{
    int bWasPending = GetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_CLASS_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_LEVEL_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_INDEX_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_SPELL_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_METAMAGIC_VAR);
    if (bWasPending)
    {
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
        DeleteLocalString(oPlayer, NUI_SPELLBOOK_ON_TARGET_ACTION_VAR);
    }
}

void ClearPendingNativeClassSelection(object oPlayer)
{
    int bWasPending = GetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_PENDING_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_PENDING_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_CAST_TYPE_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_CLASS_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_LEVEL_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_SPELL_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_METAMAGIC_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_DOMAIN_VAR);
    if (bWasPending)
    {
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
        DeleteLocalString(oPlayer, NUI_SPELLBOOK_ON_TARGET_ACTION_VAR);
    }
}

void ExpirePreferredDomainClass(object oPlayer, int nGeneration)
{
    if (GetLocalInt(oPlayer, NUI_SPELLBOOK_DOMAIN_PREFERRED_GENERATION_VAR) == nGeneration)
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
}

void SetPreferredDomainClass(object oPlayer, int nClass)
{
    int nGeneration = GetLocalInt(oPlayer, NUI_SPELLBOOK_DOMAIN_PREFERRED_GENERATION_VAR) + 1;
    if (nGeneration <= 0)
        nGeneration = 1;

    // Store class + 1 so an absent int cannot be confused with class row 0.
    SetLocalInt(oPlayer, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR, nClass + 1);
    SetLocalInt(oPlayer, NUI_SPELLBOOK_DOMAIN_PREFERRED_GENERATION_VAR, nGeneration);
    DelayCommand(30.0f, ExpirePreferredDomainClass(oPlayer, nGeneration));
}

void SetWindowGeometry(object oPlayer, int nToken)
{
    // A live refresh may have destroyed this token and opened its successor
    // before the old geometry watch event reaches this script. Never let that
    // stale callback overwrite the successor's saved position.
    if (NuiFindWindow(oPlayer, PRC_SPELLBOOK_NUI_WINDOW_ID) != nToken)
        return;

    json dimensions = NuiGetBind(oPlayer, nToken, "geometry");
    if (dimensions != JsonNull())
        SetLocalJson(oPlayer, PRC_SPELLBOOK_NUI_GEOMETRY_VAR, dimensions);
}

int DetermineShapeForSpell(string shape)
{
    if (shape == "CONE")
    {
        return SPELL_TARGETING_SHAPE_CONE;
    }
    if (shape == "SPHERE")
    {
        return SPELL_TARGETING_SHAPE_SPHERE;
    }
    if (shape == "RECTANGLE")
    {
        return SPELL_TARGETING_SHAPE_RECT;
    }
    if (shape == "HSPHERE")
    {
        return SPELL_TARGETING_SHAPE_HSPHERE;
    }

    return SPELL_TARGETING_SHAPE_NONE;
}

float DetermineRangeForSpell(string sRange)
{
    //Personal
    if (sRange == "P")
    {
        return StringToFloat(Get2DACache("ranges", "PrimaryRange", 0));
    }
    //Touch
    if(sRange == "T")
    {
        return StringToFloat(Get2DACache("ranges", "PrimaryRange", 1));
    }
    //Short
    if(sRange == "S")
    {
        return StringToFloat(Get2DACache("ranges", "PrimaryRange", 2));
    }
    //Medium
    if(sRange == "M")
    {
        return StringToFloat(Get2DACache("ranges", "PrimaryRange", 3));
    }
    //Long
    if(sRange == "L")
    {
        return StringToFloat(Get2DACache("ranges", "PrimaryRange", 4));
    }

    return 0.0;
}

int DetermineTargetType(string targetType)
{
    int retValue = -1;
    int iTargetType = HexToInt(targetType);

    if (iTargetType - 64 >= 0)
    {
        if (retValue == -1)
        {
            retValue = OBJECT_TYPE_TRIGGER;
        }
        else
        {
            retValue = retValue | OBJECT_TYPE_TRIGGER;
        }
        iTargetType -= 64;
    }
    if (iTargetType - 32 >= 0)
    {
        if (retValue == -1)
        {
            retValue = OBJECT_TYPE_PLACEABLE;
        }
        else
        {
            retValue = retValue | OBJECT_TYPE_PLACEABLE;
        }
        iTargetType -= 32;
    }
    if (iTargetType - 16 >= 0)
    {
        if (retValue == -1)
        {
            retValue = OBJECT_TYPE_DOOR;
        }
        else
        {
            retValue = retValue | OBJECT_TYPE_DOOR;
        }
        iTargetType -= 16;
    }
    if (iTargetType - 8 >= 0)
    {
        if (retValue == -1)
        {
            retValue = OBJECT_TYPE_ITEM;
        }
        else
        {
            retValue = retValue | OBJECT_TYPE_ITEM;
        }
        iTargetType -= 8;
    }
    if (iTargetType - 4 >= 0)
    {
        if (retValue == -1)
        {
            retValue = OBJECT_TYPE_TILE;
        }
        else
        {
            retValue = retValue | OBJECT_TYPE_TILE;
        }

        iTargetType -= 4;
    }
    if (iTargetType - 2 >= 0 || iTargetType - 1 >= 0)
    {
        if (retValue == -1)
        {
            retValue = OBJECT_TYPE_CREATURE;
        }
        else
        {
            retValue = retValue | OBJECT_TYPE_CREATURE;
        }
        iTargetType = 0;
    }

    return retValue;
}
