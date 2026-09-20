//::///////////////////////////////////////////////
//:: PRC Spellbook OnTrigger Script
//:: prc_nui_sc_trggr
//:://////////////////////////////////////////////
/*
    This is the OnTarget action script used to make spell attacks with the
    selected spell from the PRC Spellbook NUI
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 24.05.2005
//:://////////////////////////////////////////////

#include "prc_nui_consts"
#include "prc_nui_sb_inc"
#include "prc_nui_moi_inc"
#include "prc_nui_arch_inc"

// feat.2da row 9259 is Exploit Vestige. Its Constant column incorrectly names
// Sudden Empower, so this NUI integration must use the authoritative row ID.
const int NUI_SPELLBOOK_ANIMA_EXPLOIT_FEAT = 9259;

// Native spontaneous metamagic needs PRC_METAMAGIC_ADJUSTMENT while the
// engine-owned cast enters its spell hook.  The normal queued cleanup can be
// discarded by a spell that starts a conversation with ClearAllActions(TRUE),
// so arm an independent delayed cleanup immediately before the cast action.
// Generations keep an older delayed cleanup from touching a newer NUI cast.
const string NUI_SPELLBOOK_NATIVE_META_GENERATION_VAR = "NUI_NativeMetaGeneration";
const string NUI_SPELLBOOK_NATIVE_META_ACTIVE_VAR = "NUI_NativeMetaActive";

int ValidateBinderExploitPending(object oPlayer, int nFeat)
{
    int nSpell = GetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_SELECTED_SPELLID_VAR
    );
    if (nSpell <= 0)
        return TRUE;

    return nFeat == NUI_SPELLBOOK_ANIMA_EXPLOIT_FEAT
        && GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
            == PRC_SPELLBOOK_MODE_CLASS
        && GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR)
            == CLASS_TYPE_BINDER
        && GetLevelByClass(CLASS_TYPE_BINDER, oPlayer) > 0
        && GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oPlayer) >= 2
        && GetHasFeat(NUI_SPELLBOOK_ANIMA_EXPLOIT_FEAT, oPlayer)
        && nSpell > 0
        && nSpell == GetLocalInt(oPlayer, "ExploitVestigeSpell")
        && GetLocalInt(oPlayer, "ExploitVestige") > 0
        && GetFeatRemainingUses(
            NUI_SPELLBOOK_ANIMA_EXPLOIT_FEAT,
            oPlayer
        ) > 0
        && GetPrimaryArcaneClass(oPlayer) != CLASS_TYPE_INVALID;
}

// Factotum and Runescarred actions are launched through their existing feat
// wrappers, but the NUI selection can sit in targeting mode while the live
// resource or persisted rune changes.  Revalidate the complete mapped entry
// at the last possible moment.  Runescar's legacy scripts also require this
// transient tier local, which does not survive a relog/module reload.
int NUISpellbookPrepareSpecialPendingAction(object oPlayer, int nFeat)
{
    if (!GetLocalInt(oPlayer, NUI_SPELLBOOK_SPECIAL_PENDING_VAR))
        return TRUE;

    if (!NUISpellbookValidateSpecialPending(oPlayer, nFeat))
    {
        SendMessageToPC(
            oPlayer,
            "That spellbook action is no longer available."
        );
        NUISpellbookClearSpecialPending(oPlayer);
        return FALSE;
    }

    json jEntry = GetLocalJson(
        oPlayer,
        NUI_SPELLBOOK_SPECIAL_PENDING_ENTRY_VAR
    );
    if (JsonGetInt(JsonObjectGet(jEntry, "y"))
        == NUI_SPELLBOOK_SPECIAL_ACTION_RUNESCAR_CAST)
    {
        int nSpell = JsonGetInt(JsonObjectGet(jEntry, "s"));
        int nTier = NUISpellbookGetRunescarSpellTier(nSpell);
        if (nSpell <= 0 || nTier <= 0)
        {
            NUISpellbookClearSpecialPending(oPlayer);
            return FALSE;
        }

        SetLocalInt(
            oPlayer,
            "Runescar_spell_level_" + IntToString(nSpell),
            nTier
        );
    }

    return TRUE;
}

void ClearPendingNativeDomainSpell()
{
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_CLASS_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_LEVEL_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_INDEX_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_SPELL_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_CAST_SPELL_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_METAMAGIC_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
}

void CastPendingNativeDomainSpell()
{
    int nClass = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_CLASS_VAR);
    int nLevel = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_LEVEL_VAR);
    int nIndex = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_INDEX_VAR);
    int nSpell = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_SPELL_VAR);
    int nCastSpell = GetLocalInt(
        OBJECT_SELF,
        NUI_SPELLBOOK_NATIVE_DOMAIN_CAST_SPELL_VAR
    );
    int nMetamagic = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_METAMAGIC_VAR);

    if (nClass == CLASS_TYPE_INVALID
        || GetLevelByClass(nClass, OBJECT_SELF) <= 0
        || nLevel < 1
        || nLevel > 9
        || StringToInt(Get2DACache("classes", "MemorizesSpells", nClass)) != TRUE)
    {
        SendMessageToPC(OBJECT_SELF, "That native domain spell class is no longer available.");
        ClearPendingNativeDomainSpell();
        return;
    }

    if (GetLocalInt(OBJECT_SELF, "DomainCast"))
    {
        SendMessageToPC(OBJECT_SELF, "Finish the pending bonus-domain spell selection before casting a native domain spell.");
        ClearPendingNativeDomainSpell();
        return;
    }

    int nCount = GetMemorizedSpellCountByLevel(OBJECT_SELF, nClass, nLevel);
    if (nIndex < 0
        || nIndex >= nCount
        || nSpell < 0
        || nMetamagic < METAMAGIC_NONE
        || !NUISpellbookNativeCastSpellIsValid(nSpell, nCastSpell)
        || GetMemorizedSpellId(OBJECT_SELF, nClass, nLevel, nIndex) != nSpell
        || GetMemorizedSpellIsDomainSpell(OBJECT_SELF, nClass, nLevel, nIndex) != TRUE
        || GetMemorizedSpellReady(OBJECT_SELF, nClass, nLevel, nIndex) != TRUE
        || GetMemorizedSpellMetaMagic(OBJECT_SELF, nClass, nLevel, nIndex) != nMetamagic)
    {
        SendMessageToPC(OBJECT_SELF, "That native domain spell slot changed or is no longer ready.");
        ClearPendingNativeDomainSpell();
        return;
    }

    int bPersonal = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
    object oTarget = bPersonal ? OBJECT_SELF : GetLocalObject(OBJECT_SELF, "TARGETING_OBJECT");
    location lTarget = GetLocalLocation(OBJECT_SELF, "TARGETING_POSITION");
    int bObjectTarget = GetIsObjectValid(oTarget) && GetObjectType(oTarget);
    int bLocationTarget = GetIsObjectValid(GetAreaFromLocation(lTarget));

    if (!bObjectTarget && !bLocationTarget)
    {
        SendMessageToPC(OBJECT_SELF, "No valid target was selected; the native domain spell was not spent.");
        ClearPendingNativeDomainSpell();
        return;
    }

    // nLevel identifies the prepared slot. The engine's nDomainLevel argument
    // instead expects the spell's unmodified level on the domain list; passing
    // the adjusted slot circle makes every metamagic domain cast miss its
    // prepared domain entry.
    int nDomainLevel = nLevel - GetMetaMagicSpellLevelAdjustment(nMetamagic);
    if (nDomainLevel < 1 || nDomainLevel > 9)
    {
        SendMessageToPC(OBJECT_SELF, "That prepared domain spell has an invalid base level.");
        ClearPendingNativeDomainSpell();
        return;
    }

    // 8193.36+ can queue a real, non-cheat cast from a specific class and
    // domain level. The engine therefore owns component checks, interruption,
    // caster statistics and slot consumption exactly as it does for the native
    // spellbook. The exact owner-slot tuple was revalidated above; nCastSpell
    // is either that owner or one of its stock radial children. nDomainLevel
    // prevents an ordinary prepared copy of the same owner from being spent.
    if (bObjectTarget)
    {
        ActionCastSpellAtObject(
            nCastSpell,
            oTarget,
            nMetamagic,
            FALSE,
            nDomainLevel,
            PROJECTILE_PATH_TYPE_DEFAULT,
            FALSE,
            nClass,
            FALSE
        );
    }
    else
    {
        ActionCastSpellAtLocation(
            nCastSpell,
            lTarget,
            nMetamagic,
            FALSE,
            PROJECTILE_PATH_TYPE_DEFAULT,
            FALSE,
            nClass,
            FALSE,
            nDomainLevel
        );
    }

    ClearPendingNativeDomainSpell();
}

void ClearPendingNativeClassSpell()
{
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_PENDING_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_CAST_TYPE_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_CLASS_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_LEVEL_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_SPELL_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_CAST_SPELL_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_METAMAGIC_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_DOMAIN_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
}

void NUISpellbookClearNativeMetamagicAdjustment(
    int nGeneration,
    int nMetamagic
)
{
    if (GetLocalInt(
            OBJECT_SELF,
            NUI_SPELLBOOK_NATIVE_META_ACTIVE_VAR
        ) != nGeneration)
        return;

    // Do not erase a value another system replaced while this cast was
    // resolving.  The generation marker may still be retired safely.
    if (GetLocalInt(OBJECT_SELF, PRC_METAMAGIC_ADJUSTMENT) == nMetamagic)
        DeleteLocalInt(OBJECT_SELF, PRC_METAMAGIC_ADJUSTMENT);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_META_ACTIVE_VAR);
}

void NUISpellbookWaitToClearNativeMetamagicAdjustment(
    int nGeneration,
    int nMetamagic,
    int nAttempts
)
{
    if (GetLocalInt(
            OBJECT_SELF,
            NUI_SPELLBOOK_NATIVE_META_ACTIVE_VAR
        ) != nGeneration)
        return;

    int nAction = GetCurrentAction(OBJECT_SELF);
    if ((nAction == ACTION_CASTSPELL || nAction == ACTION_ITEMCASTSPELL)
        && nAttempts < 60)
    {
        DelayCommand(
            0.5f,
            NUISpellbookWaitToClearNativeMetamagicAdjustment(
                nGeneration,
                nMetamagic,
                nAttempts + 1
            )
        );
        return;
    }

    // Queue the guarded clear instead of deleting the shared PRC local from a
    // timer.  This puts it behind any newer non-NUI cast setup already in the
    // creature's action queue.  Retry because a spell-side ClearAllActions may
    // also discard this newly queued cleanup before it executes.
    ActionDoCommand(NUISpellbookClearNativeMetamagicAdjustment(
        nGeneration,
        nMetamagic
    ));
    if (nAttempts < 60)
    {
        DelayCommand(
            1.0f,
            NUISpellbookWaitToClearNativeMetamagicAdjustment(
                nGeneration,
                nMetamagic,
                nAttempts + 1
            )
        );
    }
}

void NUISpellbookArmNativeMetamagicAdjustment(
    int nGeneration,
    int nMetamagic
)
{
    SetLocalInt(OBJECT_SELF, PRC_METAMAGIC_ADJUSTMENT, nMetamagic);
    SetLocalInt(
        OBJECT_SELF,
        NUI_SPELLBOOK_NATIVE_META_ACTIVE_VAR,
        nGeneration
    );

    // This DelayCommand is registered before the cast.  It therefore survives
    // a ClearAllActions(TRUE) issued by the spell's own impact/conversation.
    DelayCommand(
        1.0f,
        NUISpellbookWaitToClearNativeMetamagicAdjustment(
            nGeneration,
            nMetamagic,
            0
        )
    );
}

void CastPendingNativeClassSpell()
{
    int nCastType = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_CAST_TYPE_VAR);
    int nClass = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_CLASS_VAR);
    int nLevel = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_LEVEL_VAR);
    int nSpell = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_SPELL_VAR);
    int nCastSpell = GetLocalInt(
        OBJECT_SELF,
        NUI_SPELLBOOK_NATIVE_CLASS_CAST_SPELL_VAR
    );
    int nMetamagic = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_METAMAGIC_VAR);
    int bDomain = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_DOMAIN_VAR);

    if (!NUISpellbookUsesNativeClassAdapter(OBJECT_SELF, nClass)
        || nLevel < 0 || nLevel > 9 || nSpell < 0
        || nMetamagic < METAMAGIC_NONE
        || !NUISpellbookNativeCastSpellIsValid(nSpell, nCastSpell))
    {
        SendMessageToPC(OBJECT_SELF, "That native spellbook entry is no longer valid.");
        ClearPendingNativeClassSpell();
        return;
    }

    if (GetLocalInt(OBJECT_SELF, "DomainCast")
        || GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR))
    {
        SendMessageToPC(OBJECT_SELF, "Finish the pending domain spell selection first.");
        ClearPendingNativeClassSpell();
        return;
    }

    if (nCastType == NUI_SPELLBOOK_NATIVE_CAST_PREPARED)
    {
        if (!NUISpellbookIsNativePreparedClass(nClass)
            || NUISpellbookNativePreparedCount(OBJECT_SELF, nClass, nLevel,
                nSpell, nMetamagic, bDomain, TRUE) <= 0)
        {
            SendMessageToPC(OBJECT_SELF, "That prepared spell changed or is no longer ready.");
            ClearPendingNativeClassSpell();
            return;
        }
    }
    else if (nCastType == NUI_SPELLBOOK_NATIVE_CAST_SPONTANEOUS)
    {
        bDomain = FALSE;
        if (!NUISpellbookIsNativeSpontaneousClass(nClass)
            || !NUISpellbookNativeKnownAtLevel(OBJECT_SELF, nClass, nLevel, nSpell))
        {
            SendMessageToPC(OBJECT_SELF, "That known spell or its remaining slot is no longer available.");
            ClearPendingNativeClassSpell();
            return;
        }
        if (!NUISpellbookNativeSpontaneousMetamagicIsValid(
                OBJECT_SELF, nClass, nLevel, nSpell, nMetamagic)
            || GetSpellUsesLeft(
                OBJECT_SELF, nClass, nSpell, nMetamagic) <= 0)
        {
            string sUnavailable = (nClass == CLASS_TYPE_BARD
                    || nClass == CLASS_TYPE_SORCERER)
                && nMetamagic != METAMAGIC_NONE
                ? "That native spontaneous spell or its metamagic-adjusted slot is no longer available."
                : "That known native spell or its remaining slot is no longer available.";
            SendMessageToPC(OBJECT_SELF, sUnavailable);
            ClearPendingNativeClassSpell();
            return;
        }
    }
    else
    {
        ClearPendingNativeClassSpell();
        return;
    }

    int bPersonal = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
    object oTarget = bPersonal ? OBJECT_SELF : GetLocalObject(OBJECT_SELF, "TARGETING_OBJECT");
    location lTarget = GetLocalLocation(OBJECT_SELF, "TARGETING_POSITION");
    int bObjectTarget = GetIsObjectValid(oTarget) && GetObjectType(oTarget);
    int bLocationTarget = GetIsObjectValid(GetAreaFromLocation(lTarget));

    if (!bObjectTarget && !bLocationTarget)
    {
        SendMessageToPC(OBJECT_SELF, "No valid target was selected; the native spell was not spent.");
        ClearPendingNativeClassSpell();
        return;
    }

    int nDomainLevel = bDomain
                     ? nLevel - GetMetaMagicSpellLevelAdjustment(nMetamagic)
                     : 0;
    if (bDomain && (nDomainLevel < 1 || nDomainLevel > 9))
    {
        SendMessageToPC(OBJECT_SELF, "That prepared domain spell has an invalid base level.");
        ClearPendingNativeClassSpell();
        return;
    }
    int bNativeSpontaneousMetamagic = nCastType
            == NUI_SPELLBOOK_NATIVE_CAST_SPONTANEOUS
        && (nClass == CLASS_TYPE_BARD || nClass == CLASS_TYPE_SORCERER)
        && nMetamagic != METAMAGIC_NONE;
    if (bNativeSpontaneousMetamagic)
    {
        int nMetaGeneration = GetLocalInt(
            OBJECT_SELF,
            NUI_SPELLBOOK_NATIVE_META_GENERATION_VAR
        ) + 1;
        if (nMetaGeneration <= 0)
            nMetaGeneration = 1;
        SetLocalInt(
            OBJECT_SELF,
            NUI_SPELLBOOK_NATIVE_META_GENERATION_VAR,
            nMetaGeneration
        );
        ActionDoCommand(NUISpellbookArmNativeMetamagicAdjustment(
            nMetaGeneration,
            nMetamagic
        ));
    }

    if (bObjectTarget)
    {
        ActionCastSpellAtObject(
            nCastSpell, oTarget, nMetamagic, FALSE, nDomainLevel,
            PROJECTILE_PATH_TYPE_DEFAULT, FALSE, nClass, FALSE
        );
    }
    else
    {
        ActionCastSpellAtLocation(
            nCastSpell, lTarget, nMetamagic, FALSE,
            PROJECTILE_PATH_TYPE_DEFAULT, FALSE, nClass, FALSE, nDomainLevel
        );
    }

    if (bNativeSpontaneousMetamagic)
    {
        int nMetaGeneration = GetLocalInt(
            OBJECT_SELF,
            NUI_SPELLBOOK_NATIVE_META_GENERATION_VAR
        );
        ActionDoCommand(NUISpellbookClearNativeMetamagicAdjustment(
            nMetaGeneration,
            nMetamagic
        ));
        if (GetLocalInt(OBJECT_SELF, "PRC_metamagic_state") == 1
            && GetLocalInt(OBJECT_SELF, "MetamagicFeatAdjust") == nMetamagic)
            SetLocalInt(OBJECT_SELF, "MetamagicFeatAdjust", 0);
    }

    ClearPendingNativeClassSpell();
}

void main()
{
    if (GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR))
    {
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
        CastPendingNativeDomainSpell();
        NUISpellbookClearSpecialPending(OBJECT_SELF);
        NUISpellbookMoiClearPendingAction(OBJECT_SELF);
        NUISpellbookArchmageClearPending(OBJECT_SELF);
        return;
    }

    if (GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_PENDING_VAR))
    {
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
        CastPendingNativeClassSpell();
        NUISpellbookClearSpecialPending(OBJECT_SELF);
        NUISpellbookMoiClearPendingAction(OBJECT_SELF);
        NUISpellbookArchmageClearPending(OBJECT_SELF);
        return;
    }

    // Incarnum owns its complete mapped action, live revalidation and target
    // dispatch.  Once it consumes a pending callback, never fall through to
    // the generic selected-feat path.
    if (NUISpellbookMoiTriggerPendingAction(OBJECT_SELF))
    {
        NUISpellbookClearSpecialPending(OBJECT_SELF);
        NUISpellbookArchmageClearPending(OBJECT_SELF);
        return;
    }

    // Get the selected PRC spell we are going to cast
    int featId = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_FEATID_VAR);

    // A cancelled or stale targeting callback must never queue feat 0.
    if (featId <= 0)
    {
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SPELLID_VAR);
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_READIED_MANEUVER_PENDING_VAR);
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
        NUISpellbookClearSpecialPending(OBJECT_SELF);
        NUISpellbookMoiClearPendingAction(OBJECT_SELF);
        NUISpellbookArchmageClearPending(OBJECT_SELF);
        return;
    }

    // The stored bonus spell controls the NUI target geometry, while feat 9259
    // remains the actual action. Revalidate the exact pact snapshot after the
    // player chooses a target so a rest or pact change cannot retarget a
    // different spell through stale NUI state.
    if (!ValidateBinderExploitPending(OBJECT_SELF, featId))
    {
        SendMessageToPC(
            OBJECT_SELF,
            "That Exploit Vestige action is no longer available."
        );
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SPELLID_VAR);
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
        DeleteLocalInt(
            OBJECT_SELF,
            NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR
        );
        DeleteLocalInt(
            OBJECT_SELF,
            NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT
        );
        DeleteLocalInt(
            OBJECT_SELF,
            NUI_SPELLBOOK_READIED_MANEUVER_PENDING_VAR
        );
        NUISpellbookClearSpecialPending(OBJECT_SELF);
        NUISpellbookMoiClearPendingAction(OBJECT_SELF);
        NUISpellbookArchmageClearPending(OBJECT_SELF);
        return;
    }

    // High Arcana choices may wait in targeting mode while the SLA assignment,
    // owned feat, or selected class changes. Reject the stale snapshot before
    // queuing its authoritative feat action.
    if (!NUISpellbookArchmageValidatePending(OBJECT_SELF, featId))
    {
        SendMessageToPC(
            OBJECT_SELF,
            "That High Arcana action is no longer available."
        );
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
        DeleteLocalInt(
            OBJECT_SELF,
            NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR
        );
        DeleteLocalInt(
            OBJECT_SELF,
            NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT
        );
        DeleteLocalInt(
            OBJECT_SELF,
            NUI_SPELLBOOK_READIED_MANEUVER_PENDING_VAR
        );
        NUISpellbookClearSpecialPending(OBJECT_SELF);
        NUISpellbookMoiClearPendingAction(OBJECT_SELF);
        NUISpellbookArchmageClearPending(OBJECT_SELF);
        return;
    }

    // A targeted maneuver can become expended, withheld, or recovery-locked
    // after its button was clicked but before the player chooses a target.
    // Re-resolve the live level-0 map and reject it here; UseManeuver remains
    // the final authority when the queued class wrapper actually executes.
    if (GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_READIED_MANEUVER_PENDING_VAR))
    {
        int nSelectedClass = GetLocalInt(
            OBJECT_SELF,
            PRC_SPELLBOOK_SELECTED_CLASSID_VAR
        );
        json jMap = GetLocalJson(
            OBJECT_SELF,
            NUI_SPELLBOOK_READIED_MANEUVER_BUTTON_MAP_VAR
        );
        int nManeuver = -1;
        int i;
        if (GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                == PRC_SPELLBOOK_MODE_CLASS
            && GetLocalInt(OBJECT_SELF, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR) == 0
            && NUISpellbookIsInitiatorClass(nSelectedClass)
            && jMap != JsonNull())
        {
            for (i = 0; i < JsonGetLength(jMap); i++)
            {
                json jEntry = JsonArrayGet(jMap, i);
                if (JsonGetInt(JsonObjectGet(jEntry, "c")) == nSelectedClass
                    && JsonGetInt(JsonObjectGet(jEntry, "f")) == featId
                    && JsonGetInt(JsonObjectGet(jEntry, "p"))
                        == StringToInt(Get2DACache("feat", "SPELLID", featId))
                    && JsonGetInt(JsonObjectGet(jEntry, "u"))
                        == GetLocalInt(
                            OBJECT_SELF,
                            NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR
                        ))
                {
                    nManeuver = JsonGetInt(JsonObjectGet(jEntry, "m"));
                    break;
                }
            }
        }

        string sStatus = nManeuver > 0
            ? NUISpellbookGetReadiedManeuverStatus(
                OBJECT_SELF,
                nSelectedClass,
                nManeuver
            )
            : "No longer readied";
        if (sStatus != "Ready")
        {
            if (nManeuver > 0)
            {
                SendMessageToPC(
                    OBJECT_SELF,
                    GetManeuverName(nManeuver)
                        + " is not currently available (" + sStatus + ")."
                );
            }
            else
                SendMessageToPC(OBJECT_SELF, "That readied maneuver is no longer available.");

            NUISpellbookRefreshReadiedManeuverButtons(
                OBJECT_SELF,
                NuiFindWindow(OBJECT_SELF, PRC_SPELLBOOK_NUI_WINDOW_ID)
            );
            DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
            DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
            DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
            DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_READIED_MANEUVER_PENDING_VAR);
            NUISpellbookClearSpecialPending(OBJECT_SELF);
            NUISpellbookMoiClearPendingAction(OBJECT_SELF);
            NUISpellbookArchmageClearPending(OBJECT_SELF);
            return;
        }
    }

    // Expel Vestige removes the owner spell effect before its granted skin
    // feats expire. Revalidate the live owner at trigger time so a target mode
    // opened immediately before expulsion cannot cast a stale Binder ability.
    if (featId >= 9030 && featId <= 9104 && !IsBinderFeatActive(OBJECT_SELF, featId))
    {
        SendMessageToPC(OBJECT_SELF, "That vestige is no longer bound.");
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_READIED_MANEUVER_PENDING_VAR);
        NUISpellbookClearSpecialPending(OBJECT_SELF);
        NUISpellbookMoiClearPendingAction(OBJECT_SELF);
        NUISpellbookArchmageClearPending(OBJECT_SELF);
        return;
    }

    // if the spell has a master feat this is it. This will return 0 if not set.
    int subSpellID = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);

    int isPersonalFeat = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);

    // if this is a personal feat then this was called directly since we never entered
    // targetting and this should be applied immediatly to the executing player.
    if (isPersonalFeat)
    {
        if (!NUISpellbookPrepareSpecialPendingAction(OBJECT_SELF, featId))
        {
            DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
            DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
            DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
            DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_READIED_MANEUVER_PENDING_VAR);
            NUISpellbookMoiClearPendingAction(OBJECT_SELF);
            NUISpellbookArchmageClearPending(OBJECT_SELF);
            return;
        }

        ActionUseFeat(featId, OBJECT_SELF, subSpellID);
        // we want to remove this just in case of weird cases.
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
    }
    else
    {

        // Get the target and location data we are casting at
        object oTarget = GetLocalObject(OBJECT_SELF, "TARGETING_OBJECT");
        location spellLocation = GetLocalLocation(OBJECT_SELF, "TARGETING_POSITION");

        // if the object is valid and isn't empty then cast spell at target
        if (GetIsObjectValid(oTarget) && GetObjectType(oTarget))
            spellLocation = LOCATION_INVALID;
        // otherwise if the area is a valid location to cast at, cast at location
        else if (GetIsObjectValid(GetAreaFromLocation(spellLocation)))
            oTarget = OBJECT_INVALID;

        if (!NUISpellbookPrepareSpecialPendingAction(OBJECT_SELF, featId))
        {
            DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
            DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
            DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
            DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_READIED_MANEUVER_PENDING_VAR);
            NUISpellbookMoiClearPendingAction(OBJECT_SELF);
            NUISpellbookArchmageClearPending(OBJECT_SELF);
            return;
        }

        ActionUseFeat(featId, oTarget, subSpellID, spellLocation);
    }

    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SPELLID_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_READIED_MANEUVER_PENDING_VAR);
    NUISpellbookClearSpecialPending(OBJECT_SELF);
    NUISpellbookMoiClearPendingAction(OBJECT_SELF);
    NUISpellbookArchmageClearPending(OBJECT_SELF);
}
