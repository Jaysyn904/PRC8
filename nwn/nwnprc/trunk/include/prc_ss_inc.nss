//::///////////////////////////////////////////////
//:: Silverstar shared runtime helpers
//:: prc_ss_inc
//::///////////////////////////////////////////////
// This file deliberately uses SS_CLASS_ID rather than CLASS_TYPE_SILVERSTAR.
// The build layer reassigns the hidden legacy Werewolf constant at row 173;
// keeping the private ID here also lets these isolated scripts compile against
// an otherwise untouched PRC 4.947 source tree.

#include "prc_inc_core"
#include "prc_inc_spells"
#include "prc_ss_cast"

const int SS_CLASS_ID = 173;

const int SS_FEAT_MOON_SPELLS       = 26428;
const int SS_FEAT_MOONS_HAND        = 26429;
const int SS_FEAT_TEARS             = 26430;
const int SS_FEAT_PROPHETS_SIGHT    = 26431;
const int SS_FEAT_SELUNITE_LYCAN    = 26432;
const int SS_FEAT_MOONS_HAND_2      = 26433;
const int SS_FEAT_MOONSHIELD        = 26434;
const int SS_FEAT_GREATER_MOON_HAND = 26435;
const int SS_FEAT_MOONFIRE          = 26436;
const int SS_FEAT_CASTER_CLERIC     = 26437;
const int SS_FEAT_CASTER_RANGER     = 26438;
const int SS_FEAT_SCENT             = 26439;
const int SS_FEAT_EPIC_SILVERSTAR    = 26440; // Passive class-11 epic marker.

// 19432 remains reserved by the existing Vampire implementation.
const int SS_ACTIVATE_SIGHT    = 19433;
const int SS_ACTIVATE_MOONFIRE = 19434;
const int SS_ACTIVATE_TEARS    = 19435;

const int SS_SPELL_DANCING_LIGHTS = 1499;
const int SS_SPELL_MOONFIRE       = 19403;

const string SS_MOONHAND_TAG = "Silverstar_MH";
const string SS_SIGHT_USED    = "Silverstar_SightUsed";
const string SS_MOONFIRE_USED = "Silverstar_MoonfireUsed";
const string SS_SIGHT_TAG     = "Silverstar_Sight";
const string SS_SCENT_TAG     = "Silverstar_Scent";

int SSGetClassLevel(object oCreature)
{
    if (!GetIsObjectValid(oCreature)) return 0;
    return GetLevelByClass(SS_CLASS_ID, oCreature);
}

int SSGetCasterLevel(object oCreature)
{
    // Prophet's Sight: "a cleric of her level" means character level here.
    // Moonfire has no explicit caster level and uses the normal SLA HD rule.
    int nCasterLevel = GetHitDice(oCreature);
    if (nCasterLevel < 1) nCasterLevel = 1;
    return nCasterLevel;
}

int SSGetDivineCasterLevel(object oCreature)
{
    int nClass = SSGetSelectedDivineClass(oCreature);
    if(!SSHasValidDivineSelection(oCreature, GetPrimaryDivineClass(oCreature)))
        return 1;
    int nCasterLevel = GetPrCAdjustedCasterLevel(nClass, oCreature);
    if (nCasterLevel < 1) nCasterLevel = 1;
    return nCasterLevel;
}

int SSGetDailyUses(object oCreature, string sKey)
{
    // The skin travels with an exported character; creature locals alone do
    // not. Native object locals also rewind correctly with a single-player
    // save, and do not require an external database or NWNX.
    int nUsed = GetLocalInt(oCreature, sKey);
    object oSkin = GetPCSkin(oCreature);
    int nSkinUsed = GetLocalInt(oSkin, sKey);
    if (nSkinUsed > nUsed) nUsed = nSkinUsed;
    return nUsed;
}

void SSSetDailyUses(object oCreature, string sKey, int nUsed)
{
    SetLocalInt(oCreature, sKey, nUsed);
    object oSkin = GetPCSkin(oCreature);
    if (GetIsObjectValid(oSkin)) SetLocalInt(oSkin, sKey, nUsed);
}

int SSGetCharismaDC(object oCreature, int nSpellLevel)
{
    return 10 + nSpellLevel
              + GetAbilityModifier(ABILITY_CHARISMA, oCreature);
}

int SSGetSightLimit(object oCreature)
{
    int nLevel = SSGetClassLevel(oCreature);
    if (nLevel >= 30) return 5;
    if (nLevel >= 23) return 4;
    if (nLevel >= 16) return 3;
    if (nLevel >= 8) return 2;
    if (nLevel >= 5) return 1;
    return 0;
}

void SSSyncFeatUses(object oCreature, int nFeat, int nRemaining, int nMaximum)
{
    // Check ownership even when the native counter has reached zero.
    if (!GetHasFeat(nFeat, oCreature, TRUE)) return;
    if (nRemaining < 0) nRemaining = 0;
    if (nRemaining > nMaximum) nRemaining = nMaximum;

    int nCurrent = GetFeatRemainingUses(nFeat, oCreature);
    // An older unlimited feat table must not create an unbounded loop.
    if (nCurrent < 0 || nCurrent > nMaximum) return;

    int nChanges = 0;
    while (nCurrent != nRemaining && nChanges < nMaximum)
    {
        if (nCurrent > nRemaining)
            DecrementRemainingFeatUses(oCreature, nFeat);
        else
            IncrementRemainingFeatUses(oCreature, nFeat);

        int nUpdated = GetFeatRemainingUses(nFeat, oCreature);
        if (nUpdated == nCurrent) return;
        nCurrent = nUpdated;
        nChanges++;
    }
}

void SSSyncDailyUses(object oCreature)
{
    if (!GetIsObjectValid(oCreature)) return;
    SSSyncFeatUses(oCreature, SS_FEAT_PROPHETS_SIGHT,
        SSGetSightLimit(oCreature) - SSGetDailyUses(oCreature, SS_SIGHT_USED), 5);

    int nMoonfireLimit = 0;
    if (SSGetClassLevel(oCreature) >= 10) nMoonfireLimit = 1;
    SSSyncFeatUses(oCreature, SS_FEAT_MOONFIRE,
        nMoonfireLimit - SSGetDailyUses(oCreature, SS_MOONFIRE_USED), 1);
}

void SSRefreshDailyUses(object oCreature)
{
    // Mirror the persisted expenditure, never grant a fresh daily allowance.
    // Repeat after native feat/rest bookkeeping so direct script execution and
    // engine activation both leave the same visible remaining-use count.
    SSSyncDailyUses(oCreature);
    DelayCommand(0.1, SSSyncDailyUses(oCreature));
}

void SSResetDailyUses(object oCreature)
{
    if (!GetIsObjectValid(oCreature)) return;
    SSSetDailyUses(oCreature, SS_SIGHT_USED, 0);
    SSSetDailyUses(oCreature, SS_MOONFIRE_USED, 0);
    SSRefreshDailyUses(oCreature);
}

void SSClearTaggedEffects(object oCreature, string sTag)
{
    int bRemoved = TRUE;
    while (bRemoved)
    {
        bRemoved = FALSE;
        effect eLoop = GetFirstEffect(oCreature);
        while (GetIsEffectValid(eLoop))
        {
            if (GetEffectTag(eLoop) == sTag)
            {
                RemoveEffect(oCreature, eLoop);
                bRemoved = TRUE;
                break;
            }
            eLoop = GetNextEffect(oCreature);
        }
    }
}

void SSRefreshScent(object oCreature)
{
    SSClearTaggedEffects(oCreature, SS_SCENT_TAG);
    if (!GetHasFeat(SS_FEAT_SCENT, oCreature))
    {
        DeleteLocalInt(oCreature, "SS_ScentLearned");
        DeleteLocalInt(GetPCSkin(oCreature), "SS_ScentLearned");
        return;
    }
    if (GetIsDead(oCreature) || SSGetClassLevel(oCreature) < 6
    || !GetHasFeat(SS_FEAT_SCENT, oCreature)
    || !GetHasFeat(FEAT_SHAPECHANGER, oCreature)
    || !(GetPersistantLocalInt(oCreature, "template_9")
      || GetPersistantLocalInt(oCreature, "template_19")))
        return;

    SetLocalInt(oCreature, "SS_ScentLearned", TRUE);
    SetLocalInt(GetPCSkin(oCreature), "SS_ScentLearned", TRUE);

    // Match PRC's sensory adaptation. Wolf/hybrid form already includes
    // the Scent skill bonus, so do not add the same benefit a second time.
    effect eScent = EffectBonusFeat(FEAT_KEEN_SENSE);
    if (!GetHasFeat(24070, oCreature)
    && !GetHasFeat(FEAT_ABILITY_SCENT, oCreature))
    {
        eScent = EffectLinkEffects(eScent, EffectSkillIncrease(SKILL_SPOT, 4));
        eScent = EffectLinkEffects(eScent, EffectSkillIncrease(SKILL_LISTEN, 4));
        eScent = EffectLinkEffects(eScent, EffectSkillIncrease(SKILL_SEARCH, 4));
    }
    eScent = TagEffect(ExtraordinaryEffect(eScent), SS_SCENT_TAG);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eScent, oCreature, 12.0);
}

void SSClearMoonHandProperties(object oItem)
{
    if (!GetIsObjectValid(oItem)
    || GetObjectType(oItem) != OBJECT_TYPE_ITEM)
        return;

    // Restart enumeration after each removal. This avoids iterator invalidation
    // and guarantees both the enhancement and shock properties are removed.
    int bRemoved = TRUE;
    while (bRemoved)
    {
        bRemoved = FALSE;
        itemproperty ipLoop = GetFirstItemProperty(oItem);
        while (GetIsItemPropertyValid(ipLoop))
        {
            if (GetItemPropertyTag(ipLoop) == SS_MOONHAND_TAG)
            {
                RemoveItemProperty(oItem, ipLoop);
                bRemoved = TRUE;
                break;
            }

            ipLoop = GetNextItemProperty(oItem);
        }
    }
}

int SSGetMoonHandEnhancement(int nSilverstarLevel)
{
    if (nSilverstarLevel >= 30) return 6;
    if (nSilverstarLevel >= 25) return 5;
    if (nSilverstarLevel >= 20) return 4;
    if (nSilverstarLevel >= 15) return 3;
    if (nSilverstarLevel >= 6) return 2;
    if (nSilverstarLevel >= 3) return 1;
    return 0;
}

void SSApplyMoonHand(object oItem, int nSilverstarLevel)
{
    if (!GetIsObjectValid(oItem)
    || GetObjectType(oItem) != OBJECT_TYPE_ITEM)
        return;

    // Remove only Silverstar's properties. Intrinsic and other scripted
    // properties are never touched.
    SSClearMoonHandProperties(oItem);

    if (nSilverstarLevel < 3
    || GetBaseItemType(oItem) != BASE_ITEM_HEAVY_MACE)
        return;

    int nEnhancement = SSGetMoonHandEnhancement(nSilverstarLevel);

    int bNeedsEnhancement = TRUE;
    int bNeedsShock = TRUE;
    int bNeedsBurstHook = TRUE;
    itemproperty ipExisting = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ipExisting))
    {
        int nType = GetItemPropertyType(ipExisting);
        int nValue = GetItemPropertyCostTableValue(ipExisting);
        int bLastsUntilRefresh =
            GetItemPropertyDurationType(ipExisting) == DURATION_TYPE_PERMANENT
            || GetItemPropertyDurationRemaining(ipExisting) >= 12;
        if (nType == ITEM_PROPERTY_ENHANCEMENT_BONUS
        && nValue >= nEnhancement && bLastsUntilRefresh)
            bNeedsEnhancement = FALSE;
        // Standard electrical dice at least 1d6 already supply shock. Never
        // remove the original property or duplicate an existing shock rider.
        if (nType == ITEM_PROPERTY_DAMAGE_BONUS
        && GetItemPropertySubType(ipExisting) == IP_CONST_DAMAGETYPE_ELECTRICAL
        && nValue >= IP_CONST_DAMAGEBONUS_1d6 && nValue <= IP_CONST_DAMAGEBONUS_2d12
        && bLastsUntilRefresh)
            bNeedsShock = FALSE;
        // Share an existing Unique Power event rather than dispatching PRC's
        // entire on-hit handler twice. Never take ownership of that property.
        if (nType == ITEM_PROPERTY_ONHITCASTSPELL
        && GetItemPropertySubType(ipExisting) == IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER)
            bNeedsBurstHook = FALSE;
        ipExisting = GetNextItemProperty(oItem);
    }

    itemproperty ipEnhancement =
        TagItemProperty(ItemPropertyEnhancementBonus(nEnhancement),
                        SS_MOONHAND_TAG);
    itemproperty ipShock =
        TagItemProperty(ItemPropertyDamageBonus(
                            IP_CONST_DAMAGETYPE_ELECTRICAL,
                            IP_CONST_DAMAGEBONUS_1d6),
                        SS_MOONHAND_TAG);

    // The heartbeat refreshes these before they expire. A short duration is
    // intentional: it prevents a bonus from leaking through a missed transfer
    // or drop event.
    if (bNeedsEnhancement)
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipEnhancement, oItem, 12.0);
    if (bNeedsShock)
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipShock, oItem, 12.0);
    if (nSilverstarLevel >= 9 && bNeedsBurstHook)
    {
        itemproperty ipBurst = TagItemProperty(ItemPropertyOnHitCastSpell(
            IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), SS_MOONHAND_TAG);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipBurst, oItem, 12.0);
    }
}

void SSRefreshMoonHands(object oCreature)
{
    if (!GetIsObjectValid(oCreature)) return;

    int nLevel = SSGetClassLevel(oCreature);
    if (GetIsDead(oCreature)) nLevel = 0;
    SSApplyMoonHand(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature),
                    nLevel);
    SSApplyMoonHand(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature),
                    nLevel);
}

void SSClearEquippedMoonHands(object oCreature)
{
    if (!GetIsObjectValid(oCreature)) return;

    SSClearMoonHandProperties(
        GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature));
    SSClearMoonHandProperties(
        GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature));
}
