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
#include "prc_nui_moi_inc"
#include "prc_nui_moi_lc"
#include "prc_nui_res_inc"
#include "prc_nui_ap_inc"
#include "prc_nui_rb_const"
#include "prc_nui_bnd_cst"
#include "prc_nui_arch_inc"
#include "prc_nui_psi_cst"

// feat.2da row 9259 is Exploit Vestige. Its Constant column incorrectly names
// Sudden Empower, so this NUI integration must use the authoritative row ID.
const int NUI_SPELLBOOK_ANIMA_EXPLOIT_FEAT = 9259;

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
void ClearOneShotSpellbookMetamagic(object oPlayer);
int CancelPendingSpellbookTarget(object oPlayer);
void RequestSpellbookNavigationRefresh(object oPlayer, int bCancelledTarget);
void FinishSpellbookNavigationRefresh(object oPlayer);
void SetPreferredDomainClass(object oPlayer, int nClass);
void ExpirePreferredDomainClass(object oPlayer, int nGeneration);

void ExpireManeuverRecoveryRequest(object oPlayer, int nGeneration)
{
    if (!GetIsObjectValid(oPlayer)
        || GetLocalInt(oPlayer, PRC_MANEUVER_RECOVER_PENDING_GENERATION_VAR)
            != nGeneration)
        return;

    DeleteLocalInt(oPlayer, PRC_MANEUVER_RECOVER_PENDING_VAR);
    int nToken = NuiFindWindow(oPlayer, PRC_SPELLBOOK_NUI_WINDOW_ID);
    if (nToken)
        NUISpellbookRefreshReadiedManeuverButtons(oPlayer, nToken);
}

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

int NUISpellbookMetamagicFromAbilitySpell(int nSpell)
{
    switch (nSpell)
    {
        case SPELL_EXTEND_SPELL_ABILITY:   return METAMAGIC_EXTEND;
        case SPELL_SILENT_SPELL_ABILITY:   return METAMAGIC_SILENT;
        case SPELL_STILL_SPELL_ABILITY:    return METAMAGIC_STILL;
        case SPELL_EMPOWER_SPELL_ABILITY:  return METAMAGIC_EMPOWER;
        case SPELL_MAXIMIZE_SPELL_ABILITY: return METAMAGIC_MAXIMIZE;
        case SPELL_QUICKEN_SPELL_ABILITY:  return METAMAGIC_QUICKEN;
    }
    return METAMAGIC_NONE;
}

int NUISpellbookActivateNativeSpontaneousMetamagic(
    object oPlayer, int nClass, int nSpell)
{
    if ((nClass != CLASS_TYPE_BARD && nClass != CLASS_TYPE_SORCERER)
        || !NUISpellbookUsesNativeClassAdapter(oPlayer, nClass))
        return FALSE;

    int nMetamagic = NUISpellbookMetamagicFromAbilitySpell(nSpell);
    if (nMetamagic == METAMAGIC_NONE)
        return FALSE;

    // ft_metamagic normally runs as a queued feat action. Native spontaneous
    // spell buttons need the selection synchronously: otherwise a fast
    // personal spell click can snapshot the old state before that action runs.
    // Preserve ft_metamagic's exact one-shot/persistent/off state cycle.
    int nMetaState = GetLocalInt(oPlayer, "PRC_metamagic_state");
    int nMetaOld = GetLocalInt(oPlayer, "MetamagicFeatAdjust");
    string sName = GetStringByStrRef(StringToInt(
        Get2DACache("spells", "Name", nSpell)));

    if (nMetaState < 1 || (nMetaState > 0 && nMetaOld != nMetamagic))
    {
        SetLocalInt(oPlayer, "MetamagicFeatAdjust", nMetamagic);
        SetLocalInt(oPlayer, "PRC_metamagic_state", 1);
        FloatingTextStringOnCreature(
            "*" + sName + " " + GetStringByStrRef(63798) + "*",
            oPlayer, FALSE);
        SendMessageToPC(oPlayer, "Metamagic activated for the next spell you cast.");
    }
    else if (nMetaState == 1 && nMetaOld == nMetamagic)
    {
        SetLocalInt(oPlayer, "PRC_metamagic_state", 2);
        FloatingTextStringOnCreature(
            "*" + sName + " " + GetStringByStrRef(63798) + "*",
            oPlayer, FALSE);
        SendMessageToPC(oPlayer, "Metamagic activated for all spells you cast.");
    }
    else if (nMetaState == 2)
    {
        SetLocalInt(oPlayer, "PRC_metamagic_state", 0);
        SetLocalInt(oPlayer, "MetamagicFeatAdjust", 0);
        FloatingTextStringOnCreature(
            "*" + sName + " " + GetStringByStrRef(63799) + "*",
            oPlayer, FALSE);
    }

    return TRUE;
}

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

    // Ignore events that do not belong to the live spellbook window.
    if (NuiFindWindow(oPlayer, PRC_SPELLBOOK_NUI_WINDOW_ID) != nToken)
        return;

    // Cast-capable buttons are stamped with the layout generation. The window
    // token remains stable across an in-place root swap, so this prevents a
    // delayed click from the prior layout resolving against a new class/map.
    int bGeneratedElement =
           FindSubString(sElement, PRC_SPELLBOOK_NUI_SPELL_BUTTON_BASEID) == 0
        || FindSubString(sElement, PRC_MANEUVER_READY_NUI_BUTTON) == 0
        || FindSubString(sElement, PRC_SPELLBOOK_NUI_READIED_MANEUVER_BUTTON_BASEID) == 0
        || FindSubString(sElement, PRC_SPELLBOOK_NUI_NATIVE_CLASS_SPELL_BUTTON_BASEID) == 0
        || FindSubString(sElement, PRC_SPELLBOOK_NUI_EPIC_SPELL_BUTTON_BASEID) == 0
        || FindSubString(sElement, PRC_SPELLBOOK_NUI_DOMAIN_SPELL_BUTTON_BASEID) == 0
        || FindSubString(sElement, PRC_SPELLBOOK_NUI_NATIVE_DOMAIN_SPELL_BUTTON_BASEID) == 0
        || FindSubString(sElement, PRC_SPELLBOOK_NUI_SPECIAL_BUTTON_BASEID) == 0
        || FindSubString(sElement, PRC_SPELLBOOK_NUI_INCARNUM_CHAKRA_BUTTON_BASEID) == 0
        || FindSubString(sElement, PRC_SPELLBOOK_NUI_INCARNUM_ACTION_BUTTON_BASEID) == 0
        || FindSubString(sElement, PRC_SPELLBOOK_NUI_META_BUTTON_BASEID) == 0
        || FindSubString(sElement, PRC_RUNESCAR_SCRIBE_NUI_BUTTON) == 0
        || FindSubString(sElement, PRC_RUNESCAR_DEFAULT_SAVE_BUTTON) == 0
        || FindSubString(sElement, PRC_RUNESCAR_DEFAULT_SCRIBE_BUTTON) == 0
        || FindSubString(sElement, PRC_MOI_LOADOUT_OPEN_BUTTON) == 0
        || FindSubString(sElement, PRC_MOI_BLADE_OPEN_BUTTON) == 0
        || FindSubString(sElement, PRC_MOI_LIVE_OPEN_BUTTON) == 0
        || FindSubString(sElement, PRC_BINDER_NUI_OPEN_BUTTON) == 0
        || FindSubString(sElement, PRC_NUI_PSI_OPEN_BUTTON) == 0
        || FindSubString(
            sElement,
            PRC_SPELLBOOK_NUI_ARCHMAGE_BUTTON_BASEID
        ) == 0;
    if (bGeneratedElement)
    {
        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_INPUT_LOCK_VAR))
            return;

        int nMarker = FindSubString(
            sElement,
            PRC_SPELLBOOK_NUI_LAYOUT_GENERATION_MARKER
        );
        if (nMarker < 0)
            return;

        int nGenerationStart = nMarker
            + GetStringLength(PRC_SPELLBOOK_NUI_LAYOUT_GENERATION_MARKER);
        if (StringToInt(GetSubString(
                sElement,
                nGenerationStart,
                GetStringLength(sElement) - nGenerationStart
            )) != GetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR))
            return;

        sElement = GetSubString(sElement, 0, nMarker);
    }

    int spellId;
    int featId;
    int realSpellId;
    int bEpicSpellButton;
    int bDomainSpellButton;
    int bReadiedManeuverButton;
    int nReadiedManeuverSubSpell;
    int bSpecialSpellButton;
    int bSpecialForcePersonal;
    int bArchmageSpellButton;
    int bArchmageForcePersonal;
    int bBinderExploitButton;
    int nBinderExploitSpell;
    int nBinderExploitVestige;

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

    if (sElement == PRC_ARCHIVIST_PREP_NUI_BUTTON)
    {
        if (GetLevelByClass(CLASS_TYPE_ARCHIVIST, oPlayer) <= 0
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR) != PRC_SPELLBOOK_MODE_CLASS
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR) != CLASS_TYPE_ARCHIVIST)
            return;

        // Server locals can survive a disconnect even when the client-side
        // window no longer exists. Treat an absent window as a fresh entry so
        // an abandoned, unsaved draft can never reappear after relogging.
        // Internal AP refreshes call the AP view directly and retain the draft.
        if (!NuiFindWindow(oPlayer, PRC_ARCHIVIST_PREP_NUI_WINDOW_ID))
            ArchivistPrepDiscardDraft(oPlayer, FALSE);

        ExecuteScript("prc_nui_ap_view", oPlayer);
        return;
    }

    if (sElement == PRC_BINDER_NUI_OPEN_BUTTON)
    {
        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                != PRC_SPELLBOOK_MODE_CLASS
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR)
                != CLASS_TYPE_BINDER
            || GetLevelByClass(CLASS_TYPE_BINDER, oPlayer) <= 0)
            return;

        CancelPendingSpellbookTarget(oPlayer);
        ExecuteScript(PRC_BINDER_NUI_OPEN_SCRIPT, oPlayer);
        return;
    }

    if (sElement == PRC_BINDER_NUI_OPEN_BUTTON + "Exploit")
    {
        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                != PRC_SPELLBOOK_MODE_CLASS
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR)
                != CLASS_TYPE_BINDER
            || GetLevelByClass(CLASS_TYPE_BINDER, oPlayer) <= 0
            || GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oPlayer) < 2
            || !GetHasFeat(NUI_SPELLBOOK_ANIMA_EXPLOIT_FEAT, oPlayer))
        {
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        nBinderExploitVestige = GetLocalInt(oPlayer, "ExploitVestige");
        nBinderExploitSpell = GetLocalInt(oPlayer, "ExploitVestigeSpell");
        if (nBinderExploitVestige <= 0 || nBinderExploitSpell <= 0)
        {
            SendMessageToPC(
                oPlayer,
                "Choose an exploited vestige ability and bonus spell through Manage Pacts first."
            );
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }
        if (GetFeatRemainingUses(
                NUI_SPELLBOOK_ANIMA_EXPLOIT_FEAT,
                oPlayer
            ) <= 0)
        {
            SendMessageToPC(
                oPlayer,
                "You have no Exploit Vestige uses remaining today."
            );
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }
        if (GetPrimaryArcaneClass(oPlayer) == CLASS_TYPE_INVALID)
        {
            SendMessageToPC(
                oPlayer,
                "Exploit Vestige has no valid primary arcane class for its stored spell."
            );
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        // Keep the feat wrapper authoritative for daily-use consumption. The
        // stored spell only supplies accurate range/shape/personal targeting;
        // bnd_anim_cast remains the engine-dispatched impact script.
        DeleteLocalInt(
            oPlayer,
            NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR
        );
        bBinderExploitButton = TRUE;
        featId = NUI_SPELLBOOK_ANIMA_EXPLOIT_FEAT;
        spellId = nBinderExploitSpell;
    }

    if (sElement == PRC_NUI_PSI_OPEN_BUTTON)
    {
        int nPsiClass = GetLocalInt(
            oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR
        );
        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                != PRC_SPELLBOOK_MODE_CLASS
            || !CanClassUseMetaPsionicFeats(nPsiClass)
            || GetLevelByClass(nPsiClass, oPlayer) <= 0)
            return;

        CancelPendingSpellbookTarget(oPlayer);
        ExecuteScript(PRC_NUI_PSI_OPEN_SCRIPT, oPlayer);
        return;
    }

    if (sElement == PRC_RUNESCAR_SCRIBE_NUI_BUTTON)
    {
        if (GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPlayer) <= 0
            || !GetHasFeat(NUI_SPELLBOOK_RUNESCAR_SCRIBE_FEAT, oPlayer)
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                != PRC_SPELLBOOK_MODE_CLASS
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR)
                != CLASS_TYPE_RUNESCARRED
            || !NUISpellbookHasOpenRunescarPosition(oPlayer)
            || NUISpellbookGetRunescarTotalScribeUses(oPlayer) <= 0)
            return;

        CancelPendingSpellbookTarget(oPlayer);

        // Entering from the live spellbook always starts a fresh draft. This
        // also discards server locals left behind by a disconnect where the
        // client-side editor window no longer exists.
        DeleteLocalInt(oPlayer, PRC_RUNESCAR_SCRIBE_ACTIVE_SESSION_VAR);
        ExecuteScript("prc_nui_rb_view", oPlayer);
        return;
    }

    if (sElement == PRC_RUNESCAR_DEFAULT_SAVE_BUTTON
        || sElement == PRC_RUNESCAR_DEFAULT_SCRIBE_BUTTON)
    {
        if (GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPlayer) <= 0
            || !GetHasFeat(NUI_SPELLBOOK_RUNESCAR_SCRIBE_FEAT, oPlayer)
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                != PRC_SPELLBOOK_MODE_CLASS
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR)
                != CLASS_TYPE_RUNESCARRED)
            return;

        json jRunescarPayload = NuiGetEventPayload();
        int nRunescarButton = JsonGetInt(JsonObjectGet(
            jRunescarPayload,
            "mouse_btn"
        ));
        int nRunescarAction;
        if (sElement == PRC_RUNESCAR_DEFAULT_SAVE_BUTTON)
        {
            if (nRunescarButton == NUI_PAYLOAD_BUTTON_LEFT_CLICK)
                nRunescarAction = PRC_RUNESCAR_DEFAULT_ACTION_SAVE;
            else if (nRunescarButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
                nRunescarAction = PRC_RUNESCAR_DEFAULT_ACTION_CLEAR;
            else
                return;
        }
        else
        {
            if (nRunescarButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
                return;
            nRunescarAction = PRC_RUNESCAR_DEFAULT_ACTION_SCRIBE;
        }

        CancelPendingSpellbookTarget(oPlayer);
        SetLocalInt(
            oPlayer,
            PRC_RUNESCAR_DEFAULT_ACTION_VAR,
            nRunescarAction
        );
        ExecuteScript("prc_nui_rb_plan", oPlayer);
        return;
    }

    if (sElement == PRC_MANEUVER_READY_NUI_BUTTON)
    {
        int nClass = GetLocalInt(
            oPlayer,
            PRC_SPELLBOOK_SELECTED_CLASSID_VAR
        );
        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                != PRC_SPELLBOOK_MODE_CLASS
            || !NUISpellbookIsInitiatorClass(nClass)
            || GetLevelByClass(nClass, oPlayer) <= 0)
            return;

        int nReadyFeat = -1;
        switch (nClass)
        {
            case CLASS_TYPE_CRUSADER:
                nReadyFeat = PRC_MANEUVER_READY_FEAT_CRUSADER;
                break;
            case CLASS_TYPE_SWORDSAGE:
                nReadyFeat = PRC_MANEUVER_READY_FEAT_SWORDSAGE;
                break;
            case CLASS_TYPE_WARBLADE:
                nReadyFeat = PRC_MANEUVER_READY_FEAT_WARBLADE;
                break;
        }
        if (nReadyFeat <= 0 || !GetHasFeat(nReadyFeat, oPlayer))
            return;

        CancelPendingSpellbookTarget(oPlayer);
        AssignCommand(oPlayer, ActionUseFeat(nReadyFeat, oPlayer));
        return;
    }

    if (sElement == PRC_SPELLBOOK_NUI_DOMAIN_MODE_BUTTON)
    {
        if (!NUISpellbookHasDomainContent(oPlayer))
            return;

        int bCancelledTarget = CancelPendingSpellbookTarget(oPlayer);
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
        SetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR, PRC_SPELLBOOK_MODE_DOMAIN);
        int nCircle = GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR);
        if (nCircle < 1 || nCircle > 9)
            SetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR, 1);
        RequestSpellbookNavigationRefresh(oPlayer, bCancelledTarget);
        return;
    }

    if (sElement == PRC_SPELLBOOK_NUI_INCARNUM_MODE_BUTTON)
    {
        if (!NUISpellbookMoiHasContent(oPlayer))
            return;

        int bCancelledTarget = CancelPendingSpellbookTarget(oPlayer);
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
        SetLocalInt(
            oPlayer,
            PRC_SPELLBOOK_SELECTED_MODE_VAR,
            PRC_SPELLBOOK_MODE_INCARNUM
        );
        RequestSpellbookNavigationRefresh(oPlayer, bCancelledTarget);
        return;
    }

    if (sElement == PRC_MOI_LOADOUT_OPEN_BUTTON)
    {
        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                != PRC_SPELLBOOK_MODE_INCARNUM
            || !NUISpellbookMoiHasLoadoutShapingClass(oPlayer))
            return;

        CancelPendingSpellbookTarget(oPlayer);
        ExecuteScript("prc_nui_moi_ed", oPlayer);
        return;
    }

    if (sElement == PRC_MOI_BLADE_OPEN_BUTTON)
    {
        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                != PRC_SPELLBOOK_MODE_INCARNUM
            || GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oPlayer) <= 0)
            return;

        CancelPendingSpellbookTarget(oPlayer);
        ExecuteScript("prc_nui_moi_bo", oPlayer);
        return;
    }

    if (sElement == PRC_MOI_LIVE_OPEN_BUTTON)
    {
        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                != PRC_SPELLBOOK_MODE_INCARNUM
            || !NUISpellbookMoiHasContent(oPlayer))
            return;

        CancelPendingSpellbookTarget(oPlayer);
        ExecuteScript("prc_nui_moi_lo", oPlayer);
        return;
    }

    if (FindSubString(
            sElement,
            PRC_SPELLBOOK_NUI_INCARNUM_CHAKRA_BUTTON_BASEID
        ) == 0)
    {
        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                != PRC_SPELLBOOK_MODE_INCARNUM
            || !NUISpellbookMoiHasContent(oPlayer))
            return;

        string sChakra = GetSubString(
            sElement,
            GetStringLength(PRC_SPELLBOOK_NUI_INCARNUM_CHAKRA_BUTTON_BASEID),
            GetStringLength(sElement)
                - GetStringLength(
                    PRC_SPELLBOOK_NUI_INCARNUM_CHAKRA_BUTTON_BASEID
                )
        );
        int nChakra = StringToInt(sChakra);
        if (sChakra == ""
            || IntToString(nChakra) != sChakra
            || nChakra < CHAKRA_CROWN
            || nChakra > CHAKRA_TOTEM)
            return;

        int bCancelledTarget = CancelPendingSpellbookTarget(oPlayer);
        SetLocalInt(
            oPlayer,
            NUI_SPELLBOOK_INCARNUM_SELECTED_CHAKRA_VAR,
            nChakra
        );
        RequestSpellbookNavigationRefresh(oPlayer, bCancelledTarget);
        return;
    }

    // Checks to see if the event button has the class button baseId
    // Then replaces the baseId with nothing and converts the end of the string to a int
    // representing the ClassID gathered. (i.e. "test_123" gets converted to 123)
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_CLASS_BUTTON_BASEID) >= 0)
    {
        int classId = StringToInt(RegExpReplace(PRC_SPELLBOOK_NUI_CLASS_BUTTON_BASEID, sElement, ""));
        int nPreviousClass = GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);
        if (nPreviousClass != classId)
            ClearOneShotSpellbookMetamagic(oPlayer);
        int bCancelledTarget = CancelPendingSpellbookTarget(oPlayer);
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
        SetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR, PRC_SPELLBOOK_MODE_CLASS);
        SetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR, classId);
        RequestSpellbookNavigationRefresh(oPlayer, bCancelledTarget);
        return;
    }

    // Checks to see if the event button has the circle button baseId
    // Then replaces the baseId with nothing and converts the end of the string to a int
    // representing the circle number gathered. (i.e. "test_5" gets converted to 5)
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_CIRCLE_BUTTON_BASEID) >= 0)
    {
        int circle = StringToInt(RegExpReplace(PRC_SPELLBOOK_NUI_CIRCLE_BUTTON_BASEID, sElement, ""));
        int bCancelledTarget = CancelPendingSpellbookTarget(oPlayer);
        SetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR, circle);
        RequestSpellbookNavigationRefresh(oPlayer, bCancelledTarget);
        return;
    }

    // Archmage High Arcana buttons retain their existing feat/spell scripts as
    // the authority. The NUI map records only the selected radial child or SLA
    // targeting geometry and is revalidated again by the target callback.
    if (FindSubString(
            sElement,
            PRC_SPELLBOOK_NUI_ARCHMAGE_BUTTON_BASEID
        ) == 0)
    {
        int nArchmageIndex = NUISpellbookArchmageGetActionIndex(sElement);
        json jArchmageEntry = NUISpellbookArchmageGetValidatedEntry(
            oPlayer,
            nArchmageIndex
        );
        if (jArchmageEntry == JsonNull())
        {
            NUISpellbookArchmageClearPending(oPlayer);
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        int nArchmageFeat = JsonGetInt(JsonObjectGet(jArchmageEntry, "f"));
        int nArchmageTargetSpell = JsonGetInt(JsonObjectGet(
            jArchmageEntry, "s"
        ));
        int nArchmageDescriptionSpell = JsonGetInt(JsonObjectGet(
            jArchmageEntry, "d"
        ));
        int nArchmageSubSpell = JsonGetInt(JsonObjectGet(
            jArchmageEntry, "u"
        ));
        int bArchmagePersonal = JsonGetInt(JsonObjectGet(
            jArchmageEntry, "p"
        ));
        json jArchmagePayload = NuiGetEventPayload();
        int nArchmageButton = JsonGetInt(JsonObjectGet(
            jArchmagePayload, "mouse_btn"
        ));
        if (nArchmageButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            CreateSpellDescriptionNUI(
                oPlayer,
                nArchmageFeat,
                nArchmageTargetSpell,
                nArchmageDescriptionSpell,
                CLASS_TYPE_ARCHMAGE
            );
            return;
        }
        if (nArchmageButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        if (GetLocalString(oPlayer, NUI_SPELLBOOK_ON_TARGET_ACTION_VAR)
                == "PRC_NUI_SPELLBOOK"
            || GetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR)
            || GetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_PENDING_VAR))
        {
            SendMessageToPC(
                oPlayer,
                "Finish or cancel the pending spellbook target first."
            );
            return;
        }

        NUISpellbookClearSpecialPending(oPlayer);
        NUISpellbookMoiClearPendingAction(oPlayer);
        NUISpellbookArchmageClearPending(oPlayer);
        if (!NUISpellbookArchmageSetPending(oPlayer, jArchmageEntry))
            return;

        bArchmageSpellButton = TRUE;
        bArchmageForcePersonal = bArchmagePersonal;
        featId = nArchmageFeat;
        spellId = nArchmageTargetSpell;
        realSpellId = nArchmageDescriptionSpell;
        if (nArchmageSubSpell > 0)
            SetLocalInt(
                oPlayer,
                NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR,
                nArchmageSubSpell
            );
        else
            DeleteLocalInt(
                oPlayer,
                NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR
            );
    }

    // Factotum Arcane Dilettante and Runescarred Berserker buttons use a
    // generation-stamped server map.  The displayed spell supplies Factotum's
    // target geometry and the description shown for a stored runescar, while
    // the mapped wrapper feat remains the only execution authority.
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_SPECIAL_BUTTON_BASEID) == 0)
    {
        int nSpecialIndex = StringToInt(RegExpReplace(
            PRC_SPELLBOOK_NUI_SPECIAL_BUTTON_BASEID,
            sElement,
            ""
        ));
        int nLayoutGeneration = GetLocalInt(
            oPlayer,
            PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR
        );
        json jSpecialEntry = NUISpellbookGetSpecialButtonEntry(
            oPlayer,
            nSpecialIndex,
            nLayoutGeneration
        );
        if (!NUISpellbookValidateSpecialAction(oPlayer, jSpecialEntry))
        {
            NUISpellbookClearSpecialPending(oPlayer);
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        int nSpecialType = JsonGetInt(JsonObjectGet(jSpecialEntry, "y"));
        int nSpecialClass = JsonGetInt(JsonObjectGet(jSpecialEntry, "c"));
        int nActionSpell = JsonGetInt(JsonObjectGet(jSpecialEntry, "a"));
        int nDisplaySpell = JsonGetInt(JsonObjectGet(jSpecialEntry, "s"));
        featId = JsonGetInt(JsonObjectGet(jSpecialEntry, "f"));

        json jSpecialPayload = NuiGetEventPayload();
        int nSpecialButton = JsonGetInt(JsonObjectGet(
            jSpecialPayload,
            "mouse_btn"
        ));
        if (nSpecialButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            CreateSpellDescriptionNUI(
                oPlayer,
                featId,
                nDisplaySpell,
                0,
                nSpecialClass
            );
            return;
        }
        if (nSpecialButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

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

        bSpecialSpellButton = TRUE;
        bSpecialForcePersonal = nSpecialType
            == NUI_SPELLBOOK_SPECIAL_ACTION_RUNESCAR_SCRIBE
            || nSpecialType == NUI_SPELLBOOK_SPECIAL_ACTION_RUNESCAR_CAST;
        spellId = bSpecialForcePersonal ? nActionSpell : nDisplaySpell;
        realSpellId = nDisplaySpell;
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
        NUISpellbookSetSpecialPending(oPlayer, jSpecialEntry);
    }

    // Character-wide Incarnum actions have their own map because shaped meld
    // investment, radial children, forced-personal wrappers, and ordinary
    // targeted feats each need a different validated payload.  This branch is
    // terminal so none of those entries can fall through as spell row zero.
    if (FindSubString(
            sElement,
            PRC_SPELLBOOK_NUI_INCARNUM_ACTION_BUTTON_BASEID
        ) == 0)
    {
        int nMoiIndex = NUISpellbookMoiGetActionIndex(sElement);
        json jMoiEntry = NUISpellbookMoiGetValidatedActionEntry(
            oPlayer,
            nMoiIndex
        );
        if (jMoiEntry == JsonNull())
        {
            NUISpellbookMoiClearPendingAction(oPlayer);
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        int nMoiFeat = JsonGetInt(JsonObjectGet(jMoiEntry, "f"));
        int nMoiTargetSpell = JsonGetInt(JsonObjectGet(jMoiEntry, "s"));
        int nMoiDescriptionSpell = JsonGetInt(JsonObjectGet(jMoiEntry, "d"));
        int bMoiPersonal = JsonGetInt(JsonObjectGet(jMoiEntry, "p"));
        json jMoiPayload = NuiGetEventPayload();
        int nMoiButton = JsonGetInt(JsonObjectGet(jMoiPayload, "mouse_btn"));
        if (nMoiButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            CreateSpellDescriptionNUI(
                oPlayer,
                nMoiFeat,
                nMoiTargetSpell,
                nMoiDescriptionSpell,
                CLASS_TYPE_BARBARIAN
            );
            return;
        }
        if (nMoiButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

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

        NUISpellbookClearSpecialPending(oPlayer);
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_READIED_MANEUVER_PENDING_VAR);
        if (!NUISpellbookMoiSetPendingAction(oPlayer, nMoiIndex))
            return;

        if (bMoiPersonal)
        {
            ExecuteScript("prc_nui_sb_trggr", oPlayer);
            return;
        }

        SetLocalString(
            oPlayer,
            NUI_SPELLBOOK_ON_TARGET_ACTION_VAR,
            "PRC_NUI_SPELLBOOK"
        );
        string sMoiRange = GetStringUpperCase(Get2DACache(
            "spells",
            "Range",
            nMoiTargetSpell
        ));
        float fMoiRange = DetermineRangeForSpell(sMoiRange);
        string sMoiShape = GetStringUpperCase(Get2DACache(
            "spells",
            "TargetShape",
            nMoiTargetSpell
        ));
        int nMoiShape = DetermineShapeForSpell(sMoiShape);
        float fMoiSizeX = StringToFloat(Get2DACache(
            "spells",
            "TargetSizeX",
            nMoiTargetSpell
        ));
        float fMoiSizeY = StringToFloat(Get2DACache(
            "spells",
            "TargetSizeY",
            nMoiTargetSpell
        ));
        int nMoiFlags = StringToInt(Get2DACache(
            "spells",
            "TargetFlags",
            nMoiTargetSpell
        ));
        int nMoiTargetType = DetermineTargetType(Get2DACache(
            "spells",
            "TargetType",
            nMoiTargetSpell
        ));
        SetEnterTargetingModeData(
            oPlayer,
            nMoiShape,
            fMoiSizeX,
            fMoiSizeY,
            nMoiFlags,
            fMoiRange
        );
        EnterTargetingMode(oPlayer, nMoiTargetType);
        return;
    }

    // Checks to see if the event button has the meta button baseId
    // Then replaces the baseId with nothing and converts the end of the string to a int
    // representing the SpellID gathered. (i.e. "test_123" gets converted to 123)
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_META_BUTTON_BASEID) >= 0)
    {
        spellId = StringToInt(RegExpReplace(PRC_SPELLBOOK_NUI_META_BUTTON_BASEID, sElement, ""));
        int nMetaClass = GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);
        int masterSpellId = StringToInt(Get2DACache("spells", "Master", spellId));
        if (masterSpellId)
        {
            SetLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR, spellId);
        }
        featId = GetNUISpellbookMetaFeatId(nMetaClass, spellId);
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
    // metamagic while manual targeting is active. Radial masters map each child
    // choice back to that same owner tuple. The trigger revalidates both before
    // the engine performs the real cast and slot spend.
    if (FindSubString(sElement, PRC_SPELLBOOK_NUI_NATIVE_DOMAIN_SPELL_BUTTON_BASEID) == 0)
    {
        int nButtonIndex = StringToInt(RegExpReplace(
            PRC_SPELLBOOK_NUI_NATIVE_DOMAIN_SPELL_BUTTON_BASEID,
            sElement,
            ""
        ));
        json jDomainMap = GetLocalJson(
            oPlayer,
            NUI_SPELLBOOK_NATIVE_DOMAIN_BUTTON_MAP_VAR
        );
        if (jDomainMap == JsonNull()
            || nButtonIndex < 0
            || nButtonIndex >= JsonGetLength(jDomainMap))
        {
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        json jDomainEntry = JsonArrayGet(jDomainMap, nButtonIndex);
        int nClass = JsonGetInt(JsonObjectGet(jDomainEntry, "c"));
        int nLevel = JsonGetInt(JsonObjectGet(jDomainEntry, "l"));
        int nIndex = JsonGetInt(JsonObjectGet(jDomainEntry, "i"));
        int nNativeSpell = JsonGetInt(JsonObjectGet(jDomainEntry, "s"));
        int nNativeCastSpell = JsonGetInt(JsonObjectGet(jDomainEntry, "x"));
        int nNativeMetamagic = JsonGetInt(JsonObjectGet(jDomainEntry, "m"));

        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                != PRC_SPELLBOOK_MODE_DOMAIN
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR) != nLevel
            || nClass == CLASS_TYPE_INVALID
            || GetLevelByClass(nClass, oPlayer) <= 0
            || nLevel < 1
            || nLevel > 9
            || StringToInt(Get2DACache("classes", "MemorizesSpells", nClass)) != TRUE
            || !NUISpellbookNativeCastSpellIsValid(
                nNativeSpell,
                nNativeCastSpell
            ))
        {
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        int nCount = GetMemorizedSpellCountByLevel(oPlayer, nClass, nLevel);

        if (nIndex < 0 || nIndex >= nCount
            || nNativeSpell < 0
            || nNativeMetamagic < METAMAGIC_NONE
            || GetMemorizedSpellId(oPlayer, nClass, nLevel, nIndex) != nNativeSpell
            || GetMemorizedSpellIsDomainSpell(oPlayer, nClass, nLevel, nIndex) != TRUE
            || GetMemorizedSpellMetaMagic(oPlayer, nClass, nLevel, nIndex)
                != nNativeMetamagic)
        {
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        json jNativePayload = NuiGetEventPayload();
        int nNativeButton = JsonGetInt(JsonObjectGet(jNativePayload, "mouse_btn"));
        if (nNativeButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            CreateSpellDescriptionNUI(
                oPlayer,
                0,
                nNativeCastSpell,
                0,
                nClass
            );
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

        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR, TRUE);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_CLASS_VAR, nClass);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_LEVEL_VAR, nLevel);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_INDEX_VAR, nIndex);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_SPELL_VAR, nNativeSpell);
        SetLocalInt(
            oPlayer,
            NUI_SPELLBOOK_NATIVE_DOMAIN_CAST_SPELL_VAR,
            nNativeCastSpell
        );
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_METAMAGIC_VAR, nNativeMetamagic);

        string sNativeRange = GetStringUpperCase(Get2DACache(
            "spells",
            "Range",
            nNativeCastSpell
        ));
        if (sNativeRange == "P")
        {
            SetLocalInt(oPlayer, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT, TRUE);
            ExecuteScript("prc_nui_sb_trggr", oPlayer);
            return;
        }

        SetLocalString(oPlayer, NUI_SPELLBOOK_ON_TARGET_ACTION_VAR, "PRC_NUI_SPELLBOOK");
        float fNativeRange = DetermineRangeForSpell(sNativeRange);
        string sNativeShape = GetStringUpperCase(Get2DACache(
            "spells",
            "TargetShape",
            nNativeCastSpell
        ));
        int nNativeShape = DetermineShapeForSpell(sNativeShape);
        float fNativeSizeX = StringToFloat(Get2DACache(
            "spells", "TargetSizeX", nNativeCastSpell));
        float fNativeSizeY = StringToFloat(Get2DACache(
            "spells", "TargetSizeY", nNativeCastSpell));
        int nNativeFlags = StringToInt(Get2DACache(
            "spells", "TargetFlags", nNativeCastSpell));
        int nNativeTargetType = DetermineTargetType(Get2DACache(
            "spells", "TargetType", nNativeCastSpell));

        SetEnterTargetingModeData(
            oPlayer,
            nNativeShape,
            fNativeSizeX,
            fNativeSizeY,
            nNativeFlags,
            fNativeRange,
            nNativeCastSpell
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
        int nNativeCastSpell = JsonGetInt(JsonObjectGet(jEntry, "x"));
        int nNativeMetamagic = JsonGetInt(JsonObjectGet(jEntry, "m"));
        int bNativeDomain = JsonGetInt(JsonObjectGet(jEntry, "d"));

        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR) != PRC_SPELLBOOK_MODE_CLASS
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR) != nClass
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR) != nLevel
            || !NUISpellbookUsesNativeClassAdapter(oPlayer, nClass)
            || nNativeSpell < 0 || nLevel < 0 || nLevel > 9
            || !NUISpellbookNativeCastSpellIsValid(
                nNativeSpell,
                nNativeCastSpell
            )
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
            CreateSpellDescriptionNUI(
                oPlayer,
                0,
                nNativeCastSpell,
                0,
                nClass
            );
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
            int nMetaState = GetLocalInt(oPlayer, "PRC_metamagic_state");
            if ((nClass == CLASS_TYPE_BARD || nClass == CLASS_TYPE_SORCERER)
                && (nMetaState == 1 || nMetaState == 2))
                nNativeMetamagic = GetLocalInt(oPlayer, "MetamagicFeatAdjust");
            bNativeDomain = FALSE;
            if (!NUISpellbookIsNativeSpontaneousClass(nClass)
                || !NUISpellbookNativeKnownAtLevel(oPlayer, nClass, nLevel, nNativeSpell))
            {
                SendMessageToPC(oPlayer, "You have no remaining uses of that native spell level.");
                ExecuteScript("prc_nui_sb_view", oPlayer);
                return;
            }
            if (!NUISpellbookNativeSpontaneousMetamagicIsValid(
                    oPlayer, nClass, nLevel, nNativeSpell, nNativeMetamagic))
            {
                SendMessageToPC(
                    oPlayer,
                    "That native spontaneous spell cannot use the selected metamagic at this level."
                );
                return;
            }
            if (GetSpellUsesLeft(
                    oPlayer, nClass, nNativeSpell, nNativeMetamagic) <= 0)
            {
                SendMessageToPC(oPlayer,
                    nNativeMetamagic == METAMAGIC_NONE
                        ? "You have no remaining uses of that native spell level."
                        : "You have no native spell slots left at the metamagic-adjusted level.");
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
        SetLocalInt(
            oPlayer,
            NUI_SPELLBOOK_NATIVE_CLASS_CAST_SPELL_VAR,
            nNativeCastSpell
        );
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_METAMAGIC_VAR, nNativeMetamagic);
        SetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_DOMAIN_VAR, bNativeDomain);

        string sNativeRange = GetStringUpperCase(Get2DACache(
            "spells",
            "Range",
            nNativeCastSpell
        ));
        if (sNativeRange == "P")
        {
            SetLocalInt(oPlayer, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT, TRUE);
            ExecuteScript("prc_nui_sb_trggr", oPlayer);
            return;
        }

        SetLocalString(oPlayer, NUI_SPELLBOOK_ON_TARGET_ACTION_VAR, "PRC_NUI_SPELLBOOK");
        float fNativeRange = DetermineRangeForSpell(sNativeRange);
        string sNativeShape = GetStringUpperCase(Get2DACache(
            "spells",
            "TargetShape",
            nNativeCastSpell
        ));
        int nNativeShape = DetermineShapeForSpell(sNativeShape);
        float fNativeSizeX = StringToFloat(Get2DACache(
            "spells", "TargetSizeX", nNativeCastSpell));
        float fNativeSizeY = StringToFloat(Get2DACache(
            "spells", "TargetSizeY", nNativeCastSpell));
        int nNativeFlags = StringToInt(Get2DACache(
            "spells", "TargetFlags", nNativeCastSpell));
        int nNativeTargetType = DetermineTargetType(Get2DACache(
            "spells", "TargetType", nNativeCastSpell));
        SetEnterTargetingModeData(oPlayer, nNativeShape, fNativeSizeX, fNativeSizeY,
            nNativeFlags, fNativeRange, nNativeCastSpell);
        EnterTargetingMode(oPlayer, nNativeTargetType);
        return;
    }

    // Level 0 on a base initiator class is a live view of that class's
    // selected/readied roster. Resolve the compact button map back to the
    // class-specific wrapper feat, while retaining the real maneuver ID for
    // readiness checks and the description window.
    if (FindSubString(
            sElement,
            PRC_SPELLBOOK_NUI_READIED_MANEUVER_BUTTON_BASEID
        ) == 0)
    {
        int nButtonIndex = StringToInt(RegExpReplace(
            PRC_SPELLBOOK_NUI_READIED_MANEUVER_BUTTON_BASEID,
            sElement,
            ""
        ));
        json jMap = GetLocalJson(
            oPlayer,
            NUI_SPELLBOOK_READIED_MANEUVER_BUTTON_MAP_VAR
        );
        if (jMap == JsonNull()
            || nButtonIndex < 0
            || nButtonIndex >= JsonGetLength(jMap))
        {
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        json jEntry = JsonArrayGet(jMap, nButtonIndex);
        int nClass = JsonGetInt(JsonObjectGet(jEntry, "c"));
        int nManeuver = JsonGetInt(JsonObjectGet(jEntry, "m"));
        int nManeuverFeat = JsonGetInt(JsonObjectGet(jEntry, "f"));
        int nParentSpell = JsonGetInt(JsonObjectGet(jEntry, "p"));
        int nCastSpell = JsonGetInt(JsonObjectGet(jEntry, "s"));
        int nDisplayRealSpell = JsonGetInt(JsonObjectGet(jEntry, "r"));
        int nSubSpell = JsonGetInt(JsonObjectGet(jEntry, "u"));
        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                != PRC_SPELLBOOK_MODE_CLASS
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR) != nClass
            || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR) != 0
            || !NUISpellbookIsInitiatorClass(nClass)
            || GetLevelByClass(nClass, oPlayer) <= 0
            || NUISpellbookGetManeuverFeat(nClass, nManeuver) != nManeuverFeat
            || StringToInt(Get2DACache("feat", "SPELLID", nManeuverFeat))
                != nParentSpell
            || nCastSpell <= 0
            || (nSubSpell <= 0 && nCastSpell != nParentSpell)
            || (nSubSpell > 0
                && (nSubSpell != nCastSpell
                    || StringToInt(Get2DACache("spells", "Master", nCastSpell))
                        != nParentSpell)))
        {
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        json jManeuverPayload = NuiGetEventPayload();
        int nManeuverButton = JsonGetInt(JsonObjectGet(
            jManeuverPayload,
            "mouse_btn"
        ));
        if (nManeuverButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            CreateSpellDescriptionNUI(
                oPlayer,
                nManeuverFeat,
                nCastSpell,
                nDisplayRealSpell,
                nClass
            );
            return;
        }
        if (nManeuverButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        string sStatus = NUISpellbookGetReadiedManeuverStatus(
            oPlayer,
            nClass,
            nManeuver
        );
        if (sStatus == "Expended" && nClass == CLASS_TYPE_SWORDSAGE)
        {
            if (!GetHasFeat(PRC_MANEUVER_RECOVER_FEAT_SWORDSAGE, oPlayer))
            {
                SendMessageToPC(
                    oPlayer,
                    "You do not have the Swordsage Recover Maneuver ability."
                );
                return;
            }
            if (GetLocalInt(oPlayer, PRC_MANEUVER_RECOVER_PENDING_VAR))
            {
                SendMessageToPC(
                    oPlayer,
                    "A Swordsage maneuver recovery is already queued."
                );
                NUISpellbookRefreshReadiedManeuverButtons(oPlayer, nToken);
                return;
            }

            CancelPendingSpellbookTarget(oPlayer);
            int nRecoveryGeneration = GetLocalInt(
                oPlayer,
                PRC_MANEUVER_RECOVER_PENDING_GENERATION_VAR
            ) + 1;
            if (nRecoveryGeneration <= 0)
                nRecoveryGeneration = 1;
            SetLocalInt(
                oPlayer,
                PRC_MANEUVER_RECOVER_PENDING_GENERATION_VAR,
                nRecoveryGeneration
            );
            SetLocalInt(
                oPlayer,
                PRC_MANEUVER_RECOVER_PENDING_VAR,
                nManeuver
            );
            NUISpellbookRefreshReadiedManeuverButtons(oPlayer, nToken);
            AssignCommand(
                oPlayer,
                ActionUseFeat(PRC_MANEUVER_RECOVER_FEAT_SWORDSAGE, oPlayer)
            );
            DelayCommand(
                30.0f,
                ExpireManeuverRecoveryRequest(oPlayer, nRecoveryGeneration)
            );
            return;
        }
        if (sStatus != "Ready")
        {
            SendMessageToPC(
                oPlayer,
                GetManeuverName(nManeuver)
                    + " is not currently available (" + sStatus + ")."
            );
            NUISpellbookRefreshReadiedManeuverButtons(oPlayer, nToken);
            return;
        }

        bReadiedManeuverButton = TRUE;
        nReadiedManeuverSubSpell = nSubSpell;
        spellId = nCastSpell;
        realSpellId = nDisplayRealSpell;
        featId = nManeuverFeat;
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

        // A rejected or cancelled radial-child click must never leak its
        // subspell into the next ordinary spell selection. Resolve every
        // spell button from a clean state, then set this again only when the
        // current entry is actually a radial child.
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);

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

            // Mystery class tables are authoritative for their activation
            // feats. This also resolves blank radial-child rows to the nearest
            // owning parent in the selected class table instead of accepting a
            // cross-class spells.Master feat.
            if (classId == CLASS_TYPE_SHADOWCASTER
                || classId == CLASS_TYPE_SHADOWSMITH)
            {
                int nMysteryFeat = NUISpellbookGetClassActionFeatId(
                    classId,
                    spellbookId
                );
                if (nMysteryFeat > 0)
                    featId = nMysteryFeat;
            }

            if (classId == CLASS_TYPE_ARCHIVIST)
            {
                json jArchivistPayload = NuiGetEventPayload();
                int nArchivistButton = JsonGetInt(JsonObjectGet(jArchivistPayload, "mouse_btn"));
                int nStorageRow = NUISpellbookGetPreparedStorageRow(
                    classId, spellbookId, spellId
                );
                int nReady = persistant_array_get_int(
                    oPlayer,
                    "NewSpellbookMem_" + IntToString(classId),
                    nStorageRow
                );
                if (nArchivistButton == NUI_PAYLOAD_BUTTON_LEFT_CLICK && nReady <= 0)
                {
                    SendMessageToPC(oPlayer, "You have no remaining prepared copies of that Archivist spell.");
                    DelayCommand(0.40f, NUISpellbookApplyArchivistCastUpdate(
                        oPlayer,
                        NuiFindWindow(oPlayer, PRC_SPELLBOOK_NUI_WINDOW_ID),
                        GetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR),
                        GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR),
                        nStorageRow
                    ));
                    return;
                }
            }
        }
    }

    // Mouse-up events can bubble from an actionable button to a named layout
    // container. Only continue when one of the spell-button branches above
    // resolved a real feat; otherwise the default zero values would be treated
    // as spell row 0 and start an unrelated targeting action.
    if (featId <= 0)
        return;

    json jPayload = NuiGetEventPayload();
    int nButton = JsonGetInt(JsonObjectGet(jPayload, "mouse_btn"));

    // If right click, open the Spell Description NUI
    if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
    {
        int classId = (bEpicSpellButton || bDomainSpellButton)
                    ? CLASS_TYPE_BARBARIAN
                    : GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);
        CreateSpellDescriptionNUI(
            oPlayer,
            bBinderExploitButton ? 0 : featId,
            spellId,
            realSpellId,
            classId
        );
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
        return;
    }
    // If left click, operate normally
    if (nButton == NUI_PAYLOAD_BUTTON_LEFT_CLICK)
    {

        // Stances remain in the separate ToB meta row even while level 0 is
        // selected. Only a button from the readied-maneuver map may enable the
        // trigger's extra post-target readiness validation.
        if (!bReadiedManeuverButton)
            DeleteLocalInt(
                oPlayer,
                NUI_SPELLBOOK_READIED_MANEUVER_PENDING_VAR
            );
        if (!bSpecialSpellButton)
            NUISpellbookClearSpecialPending(oPlayer);
        NUISpellbookMoiClearPendingAction(oPlayer);
        if (!bArchmageSpellButton)
            NUISpellbookArchmageClearPending(oPlayer);

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

        int nSelectedClass = GetLocalInt(
            oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);
        if (FindSubString(sElement, PRC_SPELLBOOK_NUI_META_BUTTON_BASEID) == 0
            && NUISpellbookIsNativeSpontaneousClass(nSelectedClass)
            && NUISpellbookUsesNativeClassAdapter(oPlayer, nSelectedClass)
            && NUISpellbookActivateNativeSpontaneousMetamagic(
                oPlayer,
                nSelectedClass,
                spellId
            ))
        {
            // Rebuild the existing window root immediately so native spell
            // uses, tooltips, and grey state show the adjusted slot tier.
            ExecuteScript("prc_nui_sb_view", oPlayer);
            return;
        }

        if (bBinderExploitButton)
        {
            SetLocalInt(
                oPlayer,
                NUI_SPELLBOOK_SELECTED_SPELLID_VAR,
                nBinderExploitSpell
            );
        }
        else
            DeleteLocalInt(
                oPlayer,
                NUI_SPELLBOOK_SELECTED_SPELLID_VAR
            );

        if (bReadiedManeuverButton)
        {
            if (nReadiedManeuverSubSpell > 0)
                SetLocalInt(
                    oPlayer,
                    NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR,
                    nReadiedManeuverSubSpell
                );
            else
                DeleteLocalInt(
                    oPlayer,
                    NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR
                );
            SetLocalInt(
                oPlayer,
                NUI_SPELLBOOK_READIED_MANEUVER_PENDING_VAR,
                TRUE
            );
        }

        // We use the spell's FeatID to do actions, and we set the OnTarget action
        // to PRC_NUI_SPELLBOOK so the handler knows what the action is being done
        SetLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_FEATID_VAR, featId);

        string sRange = GetStringUpperCase(Get2DACache("spells", "Range", spellId));
        // If its a personal spell/feat than use it directly on the player.
        if (bSpecialForcePersonal || bArchmageForcePersonal || sRange == "P")
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
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_CAST_SPELL_VAR);
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
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_CAST_SPELL_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_METAMAGIC_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_DOMAIN_VAR);
    if (bWasPending)
    {
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
        DeleteLocalString(oPlayer, NUI_SPELLBOOK_ON_TARGET_ACTION_VAR);
    }
}

void ClearOneShotSpellbookMetamagic(object oPlayer)
{
    // The activation feats store their selection on the character rather than
    // on a spellbook. A one-shot armed on Sublime Chord must not survive a
    // class-tab change, be ignored by native Bard, then fire unexpectedly when
    // the player returns to Sublime Chord. Persistent (state 2) mode remains
    // deliberately character-wide.
    if (GetLocalInt(oPlayer, "PRC_metamagic_state") == 1
        && GetLocalInt(oPlayer, "MetamagicFeatAdjust"))
    {
        DeleteLocalInt(oPlayer, "PRC_metamagic_state");
        DeleteLocalInt(oPlayer, "MetamagicFeatAdjust");
    }
}

int CancelPendingSpellbookTarget(object oPlayer)
{
    int bPending = GetLocalString(
            oPlayer,
            NUI_SPELLBOOK_ON_TARGET_ACTION_VAR
        ) == "PRC_NUI_SPELLBOOK"
        || GetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR)
        || GetLocalInt(oPlayer, NUI_SPELLBOOK_NATIVE_CLASS_PENDING_VAR)
        || GetLocalInt(oPlayer, NUI_SPELLBOOK_SPECIAL_PENDING_VAR)
        || GetLocalInt(oPlayer, NUI_SPELLBOOK_INCARNUM_PENDING_VAR)
        || GetLocalInt(oPlayer, NUI_SPELLBOOK_ARCHMAGE_PENDING_VAR);

    if (!bPending)
        return FALSE;

    // Passing no valid object types is the engine-supported way to cancel an
    // active targeting cursor. Its OnPlayerTarget cancellation callback may
    // arrive after this event, so clear the server-side selection here too.
    EnterTargetingMode(oPlayer, 0);
    ClearPendingNativeDomainSelection(oPlayer);
    ClearPendingNativeClassSelection(oPlayer);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SPELLID_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_READIED_MANEUVER_PENDING_VAR);
    NUISpellbookClearSpecialPending(oPlayer);
    NUISpellbookMoiClearPendingAction(oPlayer);
    NUISpellbookArchmageClearPending(oPlayer);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
    DeleteLocalString(oPlayer, NUI_SPELLBOOK_ON_TARGET_ACTION_VAR);
    DeleteLocalObject(oPlayer, "TARGETING_OBJECT");
    DeleteLocalLocation(oPlayer, "TARGETING_POSITION");
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
    return TRUE;
}

void RequestSpellbookNavigationRefresh(object oPlayer, int bCancelledTarget)
{
    // Do not replace the live NUI root in the same client cycle that cancels
    // targeting. Archivist casts no longer hold navigation: their counts are
    // refreshed through binds and their tier range is independent of transient
    // NewSB cast locals.
    int nArchivistFence = GetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_ARCHIVIST_CAST_FENCE_VAR
    );

    // Recover cleanly from a fence/input lock left by an older build or an
    // interrupted session. No new Archivist cast creates these locals.
    if (nArchivistFence > 0)
    {
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_ARCHIVIST_CAST_FENCE_VAR);
        DeleteLocalInt(oPlayer, PRC_SPELLBOOK_NUI_NAVIGATION_PENDING_VAR);
        DeleteLocalInt(oPlayer, PRC_SPELLBOOK_NUI_INPUT_LOCK_VAR);
    }

    if (bCancelledTarget)
    {
        SetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_NAVIGATION_PENDING_VAR, TRUE);
        int nGeneration = GetLocalInt(
            oPlayer,
            PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR
        );
        if (nGeneration <= 0)
            nGeneration = 1;
        SetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_INPUT_LOCK_VAR, nGeneration);
        DelayCommand(0.20f, FinishSpellbookNavigationRefresh(oPlayer));
        return;
    }

    if (GetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_NAVIGATION_PENDING_VAR))
        return;

    ExecuteScript("prc_nui_sb_view", oPlayer);
}

void FinishSpellbookNavigationRefresh(object oPlayer)
{
    if (!GetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_NAVIGATION_PENDING_VAR))
        return;

    // A stale fence from an older build must never hold target-cancellation
    // navigation. Fresh casts no longer create one.
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_ARCHIVIST_CAST_FENCE_VAR);

    DeleteLocalInt(oPlayer, PRC_SPELLBOOK_NUI_NAVIGATION_PENDING_VAR);

    // Respect a player closing the window during the brief cancellation gap.
    // The next explicit /sb command can open it normally.
    if (!NuiFindWindow(oPlayer, PRC_SPELLBOOK_NUI_WINDOW_ID))
    {
        DeleteLocalInt(oPlayer, PRC_SPELLBOOK_NUI_INPUT_LOCK_VAR);
        return;
    }

    ExecuteScript("prc_nui_sb_view", oPlayer);
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
