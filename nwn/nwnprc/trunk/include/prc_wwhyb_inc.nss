// Template werewolf hybrid: appearance-only, with real equipment retained.
// This is NOT a PnP shift and must not set nPCShifted or own the PRC skin.
#include "prc_inc_shifting"

const string PRC_WW_HYB_ACTIVE = "PRC_WW_HybActive";
const string PRC_WW_HYB_SAVED = "PRC_WW_HybSaved";
const string PRC_WW_HYB_APPEARANCE = "PRC_WW_HybAppearance";
const string PRC_WW_HYB_OWNER = "PRC_WW_HybOwner";
const string PRC_WW_HYB_GENERATION = "PRC_WW_HybGeneration";
const string PRC_WW_HYB_TRAITS = "PRCWWHybridTraits";
const string PRC_WW_HYB_ITEM_OWNER = "PRC_WW_HybItemOwner";
const string PRC_WW_HYB_ITEM_SLOT = "PRC_WW_HybOriginalSlot";
const string PRC_WW_HYB_BITE = "PRC_WW_HybOwnedBite";
const string PRC_WW_HYB_SCENT_SAVED = "PRC_WW_HybScentSaved";
const int PRC_WW_HYB_APPEARANCE_ID = 171;

int PRCWWApplyHybrid(object oPC);
int PRCWWHasHybrid(object oPC);
int PRCWWHasHybridData(object oPC);
int PRCWWIsHybridSettling(object oPC);
void PRCWWRemoveHybrid(object oPC);
void PRCWWRefreshHybrid(object oPC);
void PRCWWHybEquip(object oPC, int nGeneration, int nAttempt);
void PRCWWHybRestore(object oPC, int nGeneration, string sPending, int nAttempt);

int PRCWWHybHasNativePoly(object oPC)
{
    effect eCheck = GetFirstEffect(oPC);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == EFFECT_TYPE_POLYMORPH) return TRUE;
        eCheck = GetNextEffect(oPC);
    }
    return FALSE;
}

int PRCWWHybHasOtherShape(object oPC)
{
    return PRCWWHybHasNativePoly(oPC)
        || GetPersistantLocalInt(oPC, SHIFTER_ISSHIFTED_MARKER)
        || GetLocalInt(oPC, SHIFTER_SHIFT_MUTEX)
        || GetLocalInt(oPC, "shifting"); // Legacy SetShift's entry mutex.
}

int PRCWWHasHybridData(object oPC)
{
    return GetIsObjectValid(oPC)
        && (GetPersistantLocalInt(oPC, PRC_WW_HYB_ACTIVE)
            || GetPersistantLocalInt(oPC, PRC_WW_HYB_SAVED));
}

int PRCWWHasHybrid(object oPC)
{
    return GetIsObjectValid(oPC)
        && GetPersistantLocalInt(oPC, PRC_WW_HYB_ACTIVE)
        && GetPersistantLocalInt(oPC, PRC_WW_HYB_SAVED)
        && GetAppearanceType(oPC) == PRC_WW_HYB_APPEARANCE_ID
        && !PRCWWHybHasOtherShape(oPC);
}

int PRCWWIsHybridSettling(object oPC)
{
    // Saved data remains until restoration actually finishes. This also
    // identifies an interrupted restore which RemoveHybrid must resume.
    return GetIsObjectValid(oPC)
        && !GetPersistantLocalInt(oPC, PRC_WW_HYB_ACTIVE)
        && GetPersistantLocalInt(oPC, PRC_WW_HYB_SAVED);
}

int PRCWWHybSlot(int nIndex)
{
    if(nIndex == 0) return INVENTORY_SLOT_CWEAPON_R;
    if(nIndex == 1) return INVENTORY_SLOT_CWEAPON_L;
    return INVENTORY_SLOT_CWEAPON_B;
}

int PRCWWHybOwnsItem(object oPC, object oItem)
{
    string sOwner = GetPersistantLocalString(oPC, PRC_WW_HYB_OWNER);
    return sOwner != "" && GetIsObjectValid(oItem)
        && GetItemPossessor(oItem) == oPC
        && GetLocalString(oItem, PRC_WW_HYB_ITEM_OWNER) == sOwner;
}

// PRC owns regenerated fists; hybrid keeps its left-slot fist for gloves.
int PRCWWHybIsPRCFist(object oItem)
{
    string sRef = GetResRef(oItem);
    return sRef == "prc_unarmed_b" || sRef == "prc_unarmed_s"
        || sRef == "prc_unarmed_p" || sRef == "prc_unarmed_sp"
        || sRef == "nw_it_crewpb010";
}

// Local object references may not survive a character reload. Item locals
// travel with the actual item; fall back to the equipped slots and inventory.
object PRCWWHybFindItem(object oPC, int nOriginalSlot, int bBite)
{
    string sKey = "PRC_WW_HybItem_" + IntToString(nOriginalSlot);
    if(bBite) sKey = PRC_WW_HYB_BITE;
    object oItem = GetLocalObject(oPC, sKey);
    if(PRCWWHybOwnsItem(oPC, oItem)
        && GetLocalInt(oItem, PRC_WW_HYB_BITE) == bBite
        && (bBite || GetLocalInt(oItem, PRC_WW_HYB_ITEM_SLOT) == nOriginalSlot + 1))
        return oItem;
    int i;
    for(i = 0; i < 3; i++)
    {
        oItem = GetItemInSlot(PRCWWHybSlot(i), oPC);
        if(PRCWWHybOwnsItem(oPC, oItem)
            && GetLocalInt(oItem, PRC_WW_HYB_BITE) == bBite
            && (bBite || GetLocalInt(oItem, PRC_WW_HYB_ITEM_SLOT) == nOriginalSlot + 1))
        {
            SetLocalObject(oPC, sKey, oItem);
            return oItem;
        }
    }
    oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
        if(PRCWWHybOwnsItem(oPC, oItem)
            && GetLocalInt(oItem, PRC_WW_HYB_BITE) == bBite
            && (bBite || GetLocalInt(oItem, PRC_WW_HYB_ITEM_SLOT) == nOriginalSlot + 1))
        {
            SetLocalObject(oPC, sKey, oItem);
            return oItem;
        }
        oItem = GetNextItemInInventory(oPC);
    }
    return OBJECT_INVALID;
}

void PRCWWHybRemoveTraits(object oPC)
{
    effect eCheck = GetFirstEffect(oPC);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectTag(eCheck) == PRC_WW_HYB_TRAITS)
            RemoveEffect(oPC, eCheck);
        eCheck = GetNextEffect(oPC);
    }
}

int PRCWWHybSaveScentState(object oPC)
{
    object oSkin = GetPCSkin(oPC);
    if(!GetIsObjectValid(oSkin)) return FALSE;
    // race_skin materializes Scent into these shared contributions and a
    // Keen Senses IP, but never removes them when the borrowed feat ends.
    SetPersistantLocalInt(oPC, "PRC_WW_HybScentListen", GetLocalInt(oSkin, "Minot_Scent_Listen"));
    SetPersistantLocalInt(oPC, "PRC_WW_HybScentSearch", GetLocalInt(oSkin, "Minot_Scent_Search"));
    SetPersistantLocalInt(oPC, "PRC_WW_HybScentSpot", GetLocalInt(oSkin, "Minot_Scent_Spot"));
    int bHadKeen = FALSE;
    itemproperty ip = GetFirstItemProperty(oSkin);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT
            && GetItemPropertySubType(ip) == IP_CONST_FEAT_KEEN_SENSES)
            bHadKeen = TRUE;
        ip = GetNextItemProperty(oSkin);
    }
    SetPersistantLocalInt(oPC, "PRC_WW_HybHadKeen", bHadKeen);
    SetPersistantLocalInt(oPC, PRC_WW_HYB_SCENT_SAVED, TRUE);
    return TRUE;
}

int PRCWWHybRestoreScentState(object oPC)
{
    // Only called after our traits and any covering form have ended. Older
    // saves without a snapshot cannot safely identify pre-existing bonuses.
    if(!GetPersistantLocalInt(oPC, PRC_WW_HYB_SCENT_SAVED)) return TRUE;
    if(!GetHasFeat(FEAT_ABILITY_SCENT, oPC)
        && !GetHasFeat(FEAT_NEZUMI_KEEN_SCENT, oPC))
    {
        object oSkin = GetPCSkin(oPC);
        if(!GetIsObjectValid(oSkin)) return FALSE;
        SetCompositeBonus(oSkin, "Minot_Scent_Listen",
            GetPersistantLocalInt(oPC, "PRC_WW_HybScentListen"), ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
        SetCompositeBonus(oSkin, "Minot_Scent_Search",
            GetPersistantLocalInt(oPC, "PRC_WW_HybScentSearch"), ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
        SetCompositeBonus(oSkin, "Minot_Scent_Spot",
            GetPersistantLocalInt(oPC, "PRC_WW_HybScentSpot"), ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
        if(!GetPersistantLocalInt(oPC, "PRC_WW_HybHadKeen"))
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_KEEN_SENSES, -1, -1);
    }
    DeletePersistantLocalInt(oPC, "PRC_WW_HybScentListen");
    DeletePersistantLocalInt(oPC, "PRC_WW_HybScentSearch");
    DeletePersistantLocalInt(oPC, "PRC_WW_HybScentSpot");
    DeletePersistantLocalInt(oPC, "PRC_WW_HybHadKeen");
    DeletePersistantLocalInt(oPC, PRC_WW_HYB_SCENT_SAVED);
    return TRUE;
}

void PRCWWHybEnsureTraits(object oPC)
{
    effect eCheck = GetFirstEffect(oPC);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectTag(eCheck) == PRC_WW_HYB_TRAITS) return;
        eCheck = GetNextEffect(oPC);
    }
    // No healing, ability replacement, global bonus-limit changes, AC,
    // skills or speed here. The caller owns the template skin deltas.
    effect eTraits = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
    eTraits = EffectLinkEffects(eTraits, EffectAbilityIncrease(ABILITY_DEXTERITY, 4));
    eTraits = EffectLinkEffects(eTraits, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
    eTraits = EffectLinkEffects(eTraits, EffectDamageReduction(15, DAMAGE_POWER_PLUS_ONE));
    eTraits = EffectLinkEffects(eTraits, EffectBonusFeat(FEAT_LOWLIGHTVISION));
    eTraits = EffectLinkEffects(eTraits, EffectBonusFeat(FEAT_ABILITY_SCENT));
    eTraits = EffectLinkEffects(eTraits, EffectBonusFeat(FEAT_BLIND_FIGHT));
    eTraits = EffectLinkEffects(eTraits, EffectBonusFeat(FEAT_IMPROVED_INITIATIVE));
    eTraits = EffectLinkEffects(eTraits, EffectBonusFeat(FEAT_WEAPON_FINESSE));
    eTraits = TagEffect(SupernaturalEffect(eTraits), PRC_WW_HYB_TRAITS);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTraits, oPC);
}

object PRCWWHybEnsureBite(object oPC)
{
    object oBite = PRCWWHybFindItem(oPC, INVENTORY_SLOT_CWEAPON_B, TRUE);
    if(!GetIsObjectValid(oBite))
    {
        oBite = CreateItemOnObject("tmp_wwbite", oPC);
        if(!GetIsObjectValid(oBite)) return OBJECT_INVALID;
        if(GetItemPossessor(oBite) != oPC)
        {
            // Creation can spill an item onto the ground when inventory
            // is full. This newly-created item is ours, not existing gear.
            DestroyObject(oBite);
            return OBJECT_INVALID;
        }
        SetLocalString(oBite, PRC_WW_HYB_ITEM_OWNER,
            GetPersistantLocalString(oPC, PRC_WW_HYB_OWNER));
        SetLocalInt(oBite, PRC_WW_HYB_BITE, TRUE);
        SetLocalObject(oPC, PRC_WW_HYB_BITE, oBite);
        SetDroppableFlag(oBite, FALSE);
        IPSafeAddItemProperty(oBite,
            ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1),
            0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        AddEventScript(oBite, EVENT_ITEM_ONHIT, "prc_wwcurse", TRUE, FALSE);
    }
    return oBite;
}

void PRCWWHybEquip(object oPC, int nGeneration, int nAttempt)
{
    if(!PRCWWHasHybrid(oPC)
        || GetLocalInt(oPC, PRC_WW_HYB_GENERATION) != nGeneration) return;
    object oBite = PRCWWHybFindItem(oPC, INVENTORY_SLOT_CWEAPON_B, TRUE);
    if(!GetIsObjectValid(oBite)) return;
    int bDone = TRUE;
    int i;
    for(i = 0; i < 3; i++)
    {
        int nSlot = PRCWWHybSlot(i);
        object oCurrent = GetItemInSlot(nSlot, oPC);
        if(GetIsObjectValid(oCurrent) && oCurrent != oBite)
        {
            if(!PRCWWHybOwnsItem(oPC, oCurrent)
                && PRCWWHybIsPRCFist(oCurrent))
            {
                // The left fist carries glove damage. Clearing it makes PRC
                // recreate it and starts an acquire/destroy loop.
                if(nSlot == INVENTORY_SLOT_CWEAPON_L) continue;
                DestroyObject(oCurrent);
                bDone = FALSE;
                continue;
            }
            // Other systems retain ownership of their equipment.
            if(PRCWWHybOwnsItem(oPC, oCurrent)
                && GetLocalInt(oCurrent, PRC_WW_HYB_ITEM_SLOT) == nSlot + 1)
                AssignCommand(oPC, ActionUnequipItem(oCurrent));
            bDone = FALSE;
        }
    }
    object oCurrentBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
    if(!GetIsObjectValid(oCurrentBite) || PRCWWHybOwnsItem(oPC, oCurrentBite))
    {
        if(oCurrentBite != oBite)
        {
            AssignCommand(oPC, ActionEquipItem(oBite, INVENTORY_SLOT_CWEAPON_B));
            bDone = FALSE;
        }
    }
    else bDone = FALSE;
    if(!bDone && nAttempt < 10)
        DelayCommand(0.2, PRCWWHybEquip(oPC, nGeneration, nAttempt + 1));
}

void PRCWWRefreshHybrid(object oPC)
{
    if(GetIsObjectValid(oPC) && PRCWWHasHybridData(oPC)
        && PRCWWHybHasOtherShape(oPC))
    {
        // A native/PnP shape can temporarily cover this form. Suspend only
        // our effects: its body, items and action queue belong to that shape.
        PRCWWHybRemoveTraits(oPC);
        return;
    }
    if(!PRCWWHasHybrid(oPC)) return;
    PRCWWHybEnsureTraits(oPC);
    if(GetIsObjectValid(PRCWWHybEnsureBite(oPC)))
        PRCWWHybEquip(oPC, GetLocalInt(oPC, PRC_WW_HYB_GENERATION), 0);
}

int PRCWWApplyHybrid(object oPC)
{
    // Check BEFORE saved-active recovery: recovery must not clobber a
    // different PnP appearance or a transformation still in progress.
    if(!GetIsObjectValid(oPC) || PRCWWHybHasOtherShape(oPC)) return FALSE;
    if(PRCWWIsHybridSettling(oPC))
    {
        PRCWWRemoveHybrid(oPC);
        return FALSE;
    }
    if(PRCWWHasHybridData(oPC))
    {
        // Never replace the saved humanoid appearance with a reconnect's
        // already-shifted appearance, including malformed partial state.
        if(!GetPersistantLocalInt(oPC, PRC_WW_HYB_ACTIVE)
            || !GetPersistantLocalInt(oPC, PRC_WW_HYB_SAVED)) return FALSE;
        SetCreatureAppearanceType(oPC, PRC_WW_HYB_APPEARANCE_ID);
        PRCWWRefreshHybrid(oPC);
        return PRCWWHasHybrid(oPC);
    }
    // Match the PnP shifter's space preflight before asking the engine to
    // put the three preserved creature-slot originals into inventory.
    object oProbe1 = CreateItemOnObject("pnp_shft_tstpkup", oPC);
    object oProbe2 = CreateItemOnObject("pnp_shft_tstpkup", oPC);
    object oProbe3 = CreateItemOnObject("pnp_shft_tstpkup", oPC);
    int bSpace = GetItemPossessor(oProbe1) == oPC
        && GetItemPossessor(oProbe2) == oPC && GetItemPossessor(oProbe3) == oPC;
    if(GetIsObjectValid(oProbe1)) DestroyObject(oProbe1);
    if(GetIsObjectValid(oProbe2)) DestroyObject(oProbe2);
    if(GetIsObjectValid(oProbe3)) DestroyObject(oProbe3);
    if(!bSpace) return FALSE;

    string sOwner = ObjectToString(oPC) + ":" + IntToString(Random(2000000000));
    SetPersistantLocalString(oPC, PRC_WW_HYB_OWNER, sOwner);
    if(!GetIsObjectValid(PRCWWHybEnsureBite(oPC)))
    {
        DeletePersistantLocalString(oPC, PRC_WW_HYB_OWNER);
        return FALSE;
    }
    if(!PRCWWHybSaveScentState(oPC)) return FALSE;
    SetPersistantLocalAppearancevalues(oPC, PRC_WW_HYB_APPEARANCE, GetAppearanceData(oPC));
    SetPersistantLocalInt(oPC, PRC_WW_HYB_SAVED, TRUE);
    int i;
    for(i = 0; i < 3; i++)
    {
        int nSlot = PRCWWHybSlot(i);
        object oOriginal = GetItemInSlot(nSlot, oPC);
        if(GetIsObjectValid(oOriginal))
        {
            SetLocalString(oOriginal, PRC_WW_HYB_ITEM_OWNER, sOwner);
            SetLocalInt(oOriginal, PRC_WW_HYB_ITEM_SLOT, nSlot + 1);
            SetLocalObject(oPC, "PRC_WW_HybItem_" + IntToString(nSlot), oOriginal);
        }
    }
    SetLocalInt(oPC, PRC_WW_HYB_GENERATION,
        GetLocalInt(oPC, PRC_WW_HYB_GENERATION) + 1);
    // As in PRC appearance shifting, cancel earlier queued equipment
    // actions once at the form boundary, never from the refresh callback.
    AssignCommand(oPC, ClearAllActions(TRUE));
    SetPersistantLocalInt(oPC, PRC_WW_HYB_ACTIVE, TRUE);
    SetCreatureAppearanceType(oPC, PRC_WW_HYB_APPEARANCE_ID);
    SetCreatureWingType(0, oPC);
    SetCreatureTailType(0, oPC);
    SetPortraitId(oPC, 316);
    PRCWWRefreshHybrid(oPC);
    return PRCWWHasHybrid(oPC);
}

void PRCWWHybRestoreBodyParts(object oPC, struct appearancevalues a)
{
    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, a.nBodyPart_RightFoot, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, a.nBodyPart_LeftFoot, oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, a.nBodyPart_RightShin, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, a.nBodyPart_LeftShin, oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, a.nBodyPart_RightThigh, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, a.nBodyPart_LeftThight, oPC);
    SetCreatureBodyPart(CREATURE_PART_PELVIS, a.nBodyPart_Pelvis, oPC);
    SetCreatureBodyPart(CREATURE_PART_TORSO, a.nBodyPart_Torso, oPC);
    SetCreatureBodyPart(CREATURE_PART_BELT, a.nBodyPart_Belt, oPC);
    SetCreatureBodyPart(CREATURE_PART_NECK, a.nBodyPart_Neck, oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, a.nBodyPart_RightForearm, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, a.nBodyPart_LeftForearm, oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, a.nBodyPart_RightBicep, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, a.nBodyPart_LeftBicep, oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER, a.nBodyPart_RightShoulder, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER, a.nBodyPart_LeftShoulder, oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, a.nBodyPart_RightHand, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, a.nBodyPart_LeftHand, oPC);
    SetCreatureBodyPart(CREATURE_PART_HEAD, a.nBodyPart_Head, oPC);
}

void PRCWWHybRestore(object oPC, int nGeneration, string sPending, int nAttempt)
{
    if(!GetIsObjectValid(oPC)
        || GetLocalInt(oPC, PRC_WW_HYB_GENERATION) != nGeneration
        || !PRCWWIsHybridSettling(oPC))
    {
        if(GetLocalInt(GetModule(), sPending) == nGeneration)
            DeleteLocalInt(GetModule(), sPending);
        return;
    }
    // Never overwrite a third party's native or PnP shape. Keep our recovery
    // data intact; a subsequent cleanup call can resume after it ends.
    if(PRCWWHybHasOtherShape(oPC))
    {
        DeleteLocalInt(GetModule(), sPending);
        return;
    }
    struct appearancevalues a = GetPersistantLocalAppearancevalues(oPC, PRC_WW_HYB_APPEARANCE);
    if(GetAppearanceType(oPC) != a.nAppearanceType)
    {
        DeleteLocalInt(GetModule(), sPending);
        return;
    }
    PRCWWHybRestoreBodyParts(oPC, a);
    int bDone = TRUE;
    int i;
    for(i = 0; i < 3; i++)
    {
        int nSlot = PRCWWHybSlot(i);
        object oOriginal = PRCWWHybFindItem(oPC, nSlot, FALSE);
        if(GetIsObjectValid(oOriginal) && GetItemInSlot(nSlot, oPC) != oOriginal)
        {
            // ActionEquipItem preserves any displaced item in inventory.
            AssignCommand(oPC, ActionEquipItem(oOriginal, nSlot));
            bDone = FALSE;
        }
    }
    if(!bDone)
    {
        if(nAttempt < 10)
            DelayCommand(0.2, PRCWWHybRestore(oPC, nGeneration, sPending, nAttempt + 1));
        else
            DeleteLocalInt(GetModule(), sPending);
        return;
    }
    if(!PRCWWHybRestoreScentState(oPC))
    {
        DeleteLocalInt(GetModule(), sPending);
        return;
    }
    // Do not clear original-item markers until the actual originals are
    // equipped. They are the reconnect fallback when object refs are stale.
    for(i = 0; i < 3; i++)
    {
        int nSlot = PRCWWHybSlot(i);
        object oOriginal = PRCWWHybFindItem(oPC, nSlot, FALSE);
        if(GetIsObjectValid(oOriginal))
        {
            DeleteLocalString(oOriginal, PRC_WW_HYB_ITEM_OWNER);
            DeleteLocalInt(oOriginal, PRC_WW_HYB_ITEM_SLOT);
        }
        DeleteLocalObject(oPC, "PRC_WW_HybItem_" + IntToString(nSlot));
    }
    DeletePersistantLocalAppearancevalues(oPC, PRC_WW_HYB_APPEARANCE);
    DeletePersistantLocalInt(oPC, PRC_WW_HYB_SAVED);
    DeletePersistantLocalString(oPC, PRC_WW_HYB_OWNER);
    DeleteLocalInt(GetModule(), sPending);
}

void PRCWWRemoveHybrid(object oPC)
{
    if(!GetIsObjectValid(oPC)) return;
    string sPending = "PRC_WW_HybRestore_" + ObjectToString(oPC);
    int nGeneration = GetLocalInt(oPC, PRC_WW_HYB_GENERATION);
    if(PRCWWIsHybridSettling(oPC) && nGeneration > 0
        && GetLocalInt(GetModule(), sPending) == nGeneration) return;

    int bHadHybridData = PRCWWHasHybridData(oPC);
    nGeneration++;
    SetLocalInt(oPC, PRC_WW_HYB_GENERATION, nGeneration);
    DeletePersistantLocalInt(oPC, PRC_WW_HYB_ACTIVE);
    PRCWWHybRemoveTraits(oPC);
    // Explicit removal can be requested while another form covers hybrid.
    // Preserve the saved state for later, without disturbing that form.
    if(PRCWWHybHasOtherShape(oPC)) return;
    if(bHadHybridData) AssignCommand(oPC, ClearAllActions(TRUE));
    object oBite = PRCWWHybFindItem(oPC, INVENTORY_SLOT_CWEAPON_B, TRUE);
    // Ownership marker, not resref, authorizes destruction. Original
    // creature weapons and all normal equipment are never destroyed.
    if(GetIsObjectValid(oBite)) DestroyObject(oBite);
    DeleteLocalObject(oPC, PRC_WW_HYB_BITE);
    if(!GetPersistantLocalInt(oPC, PRC_WW_HYB_SAVED)) return;

    struct appearancevalues a = GetPersistantLocalAppearancevalues(oPC, PRC_WW_HYB_APPEARANCE);
    SetCreatureAppearanceType(oPC, a.nAppearanceType);
    SetCreatureWingType(a.nWingType, oPC);
    SetCreatureTailType(a.nTailType, oPC);
    SetFootstepType(a.nFootStepType, oPC);
    if(a.nPortraitID != PORTRAIT_INVALID) SetPortraitId(oPC, a.nPortraitID);
    else SetPortraitResRef(oPC, a.sPortraitResRef);
    // Mirror PRC's one-second body-part settling, but guard the whole
    // callback. The module marker is runtime-only, allowing reload recovery.
    SetLocalInt(GetModule(), sPending, nGeneration);
    DelayCommand(1.0, PRCWWHybRestore(oPC, nGeneration, sPending, 0));
}
