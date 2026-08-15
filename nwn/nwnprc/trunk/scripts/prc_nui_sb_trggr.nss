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

void ClearPendingNativeDomainSpell()
{
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_CLASS_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_LEVEL_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_INDEX_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_SPELL_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_METAMAGIC_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
}

void CastPendingNativeDomainSpell()
{
    int nClass = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_CLASS_VAR);
    int nLevel = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_LEVEL_VAR);
    int nIndex = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_INDEX_VAR);
    int nSpell = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_SPELL_VAR);
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
        || GetMemorizedSpellId(OBJECT_SELF, nClass, nLevel, nIndex) != nSpell
        || GetMemorizedSpellIsDomainSpell(OBJECT_SELF, nClass, nLevel, nIndex) != TRUE
        || GetMemorizedSpellReady(OBJECT_SELF, nClass, nLevel, nIndex) != TRUE
        || GetMemorizedSpellMetaMagic(OBJECT_SELF, nClass, nLevel, nIndex) != nMetamagic)
    {
        SendMessageToPC(OBJECT_SELF, "That native domain spell slot changed or is no longer ready.");
        ClearPendingNativeDomainSpell();
        return;
    }

    if (Get2DACache("spells", "SubRadSpell1", nSpell) != "")
    {
        SendMessageToPC(OBJECT_SELF, "This domain spell has multiple choices; cast it from the native spellbook.");
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

    // 8193.36+ can queue a real, non-cheat cast from a specific class and
    // domain level. The engine therefore owns component checks, interruption,
    // caster statistics and slot consumption exactly as it does for the native
    // spellbook. Spell and metamagic identify the prepared copy; nDomainLevel
    // prevents an ordinary prepared copy of the same spell from being spent.
    if (bObjectTarget)
    {
        ActionCastSpellAtObject(
            nSpell,
            oTarget,
            nMetamagic,
            FALSE,
            nLevel,
            PROJECTILE_PATH_TYPE_DEFAULT,
            FALSE,
            nClass,
            FALSE
        );
    }
    else
    {
        ActionCastSpellAtLocation(
            nSpell,
            lTarget,
            nMetamagic,
            FALSE,
            PROJECTILE_PATH_TYPE_DEFAULT,
            FALSE,
            nClass,
            FALSE,
            nLevel
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
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_METAMAGIC_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_DOMAIN_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
}

void CastPendingNativeClassSpell()
{
    int nCastType = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_CAST_TYPE_VAR);
    int nClass = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_CLASS_VAR);
    int nLevel = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_LEVEL_VAR);
    int nSpell = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_SPELL_VAR);
    int nMetamagic = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_METAMAGIC_VAR);
    int bDomain = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_DOMAIN_VAR);

    if (!NUISpellbookUsesNativeClassAdapter(OBJECT_SELF, nClass)
        || nLevel < 0 || nLevel > 9 || nSpell < 0
        || nMetamagic < METAMAGIC_NONE)
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

    if (Get2DACache("spells", "SubRadSpell1", nSpell) != "")
    {
        SendMessageToPC(OBJECT_SELF, "This spell has multiple choices; cast it from the native spellbook.");
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
        nMetamagic = METAMAGIC_NONE;
        bDomain = FALSE;
        if (!NUISpellbookIsNativeSpontaneousClass(nClass)
            || !NUISpellbookNativeKnownAtLevel(OBJECT_SELF, nClass, nLevel, nSpell)
            || GetSpellUsesLeft(OBJECT_SELF, nClass, nSpell) <= 0)
        {
            SendMessageToPC(OBJECT_SELF, "That known spell or its remaining slot is no longer available.");
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

    int nDomainLevel = bDomain ? nLevel : 0;
    if (bObjectTarget)
    {
        ActionCastSpellAtObject(
            nSpell, oTarget, nMetamagic, FALSE, nDomainLevel,
            PROJECTILE_PATH_TYPE_DEFAULT, FALSE, nClass, FALSE
        );
    }
    else
    {
        ActionCastSpellAtLocation(
            nSpell, lTarget, nMetamagic, FALSE,
            PROJECTILE_PATH_TYPE_DEFAULT, FALSE, nClass, FALSE, nDomainLevel
        );
    }

    ClearPendingNativeClassSpell();
}

void main()
{
    if (GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_DOMAIN_PENDING_VAR))
    {
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
        CastPendingNativeDomainSpell();
        return;
    }

    if (GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_NATIVE_CLASS_PENDING_VAR))
    {
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
        CastPendingNativeClassSpell();
        return;
    }

    // Get the selected PRC spell we are going to cast
    int featId = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_FEATID_VAR);

    // A cancelled or stale targeting callback must never queue feat 0.
    if (featId <= 0)
    {
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
        DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_DOMAIN_PREFERRED_CLASS_VAR);
        return;
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
        return;
    }

    // if the spell has a master feat this is it. This will return 0 if not set.
    int subSpellID = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);

    int isPersonalFeat = GetLocalInt(OBJECT_SELF, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);

    // if this is a personal feat then this was called directly since we never entered
    // targetting and this should be applied immediatly to the executing player.
    if (isPersonalFeat)
    {
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

        ActionUseFeat(featId, oTarget, subSpellID, spellLocation);
    }

    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
    DeleteLocalInt(OBJECT_SELF, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
}
