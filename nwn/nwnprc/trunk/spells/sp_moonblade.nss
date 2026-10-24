#include "sp_moon_inc"
#include "prc_nui_consts"

const string MOONBLADE_TAG_PREFIX = "MBL_";
const int MOONBLADE_FULL_ATTACK_FEAT = 25145;
const string MOONBLADE_LOGOUT_CLEANUP =
    "PRC_MOONBLADE_LOGOUT_CLEANUP";

int MoonbladeStartsWith(string sText, string sPrefix)
{
    return GetStringLeft(sText, GetStringLength(sPrefix)) == sPrefix;
}

void MoonbladeRefreshNui(object oCaster)
{
    if(GetIsPC(oCaster)
        && NuiFindWindow(oCaster, PRC_SPELLBOOK_NUI_WINDOW_ID))
        ExecuteScript("prc_nui_sb_view", oCaster);
}

void MoonbladeExpire(object oBlade)
{
    if(!GetIsObjectValid(oBlade))
        return;

    object oCaster = GetLocalObject(oBlade, "PRC_MOONBLADE_CASTER");
    if(GetIsObjectValid(oCaster)
        && GetLocalObject(oCaster, "PRC_MOONBLADE_ACTIVE_BLADE") == oBlade)
    {
        DeleteLocalObject(oCaster, "PRC_MOONBLADE_ACTIVE_BLADE");
        DeleteLocalInt(oCaster, "PRC_MOONBLADE_FULL_ATTACK_ACTIVE");
        DeleteLocalInt(oCaster, "PRC_MOONBLADE_FULL_ATTACK_SERIAL");
        DelayCommand(0.0f, MoonbladeRefreshNui(oCaster));
    }

    SetItemCursedFlag(oBlade, FALSE);
    DestroyObject(oBlade);
}

void MoonbladeExpireByTag(string sBladeTag)
{
    object oBlade = GetObjectByTag(sBladeTag);
    if(GetIsObjectValid(oBlade)
        && GetLocalInt(oBlade, "PRC_MOONBLADE_SPELLID") > 0)
        MoonbladeExpire(oBlade);
}

void MoonbladeDestroyOwnedBlades(object oCaster)
{
    object oEquipped = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
    if(GetIsObjectValid(oEquipped)
        && MoonbladeStartsWith(GetTag(oEquipped), MOONBLADE_TAG_PREFIX))
    {
        SetItemCursedFlag(oEquipped, FALSE);
        DestroyObject(oEquipped);
    }

    object oItem = GetFirstItemInInventory(oCaster);
    while(GetIsObjectValid(oItem))
    {
        object oNext = GetNextItemInInventory(oCaster);
        if(MoonbladeStartsWith(GetTag(oItem), MOONBLADE_TAG_PREFIX))
        {
            SetItemCursedFlag(oItem, FALSE);
            DestroyObject(oItem);
        }
        oItem = oNext;
    }

    DeleteLocalObject(oCaster, "PRC_MOONBLADE_ACTIVE_BLADE");
    DeleteLocalInt(oCaster, "PRC_MOONBLADE_FULL_ATTACK_ACTIVE");
    DeleteLocalInt(oCaster, "PRC_MOONBLADE_FULL_ATTACK_SERIAL");
}

void MoonbladeRemoveOldControllers(object oCaster)
{
    int bRemoved = TRUE;
    while(bRemoved)
    {
        bRemoved = FALSE;
        effect eTest = GetFirstEffect(oCaster);
        while(GetIsEffectValid(eTest))
        {
            if(MoonbladeStartsWith(GetEffectTag(eTest), MOONBLADE_TAG_PREFIX))
            {
                RemoveEffect(oCaster, eTest);
                bRemoved = TRUE;
                break;
            }

            eTest = GetNextEffect(oCaster);
        }
    }
}

void main()
{
    // Mystara calls this branch before exporting a logging-out character.
    // Removing the controller also removes its linked temporary activation
    // feat, and the explicit inventory pass recovers blades left by older
    // versions of the spell.
    if(GetLocalInt(OBJECT_SELF, MOONBLADE_LOGOUT_CLEANUP))
    {
        MoonbladeRemoveOldControllers(OBJECT_SELF);
        MoonbladeDestroyOwnedBlades(OBJECT_SELF);
        return;
    }

    // The controller owns the created blade. Expiry, dispelling, and the PRC
    // duration-window dismiss action remove both the activation feat and item.
    effect eRun = GetLastRunScriptEffect();
    if(GetIsEffectValid(eRun)
        && MoonbladeStartsWith(GetEffectTag(eRun), MOONBLADE_TAG_PREFIX))
    {
        if(GetLastRunScriptEffectScriptType()
            == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_REMOVED)
            MoonbladeExpireByTag(GetEffectString(eRun, 0));
        return;
    }

    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSpellID = PRCGetSpellId();

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    if(!X2PreSpellCastCode())
    {
        PRCSetSchool();
        return;
    }

    // Clear the prior casting first. This also removes a stale Moon Blade
    // preserved by the former logout order, so it cannot block this cast.
    MoonbladeRemoveOldControllers(oCaster);
    MoonbladeDestroyOwnedBlades(oCaster);

    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster)))
    {
        FloatingTextStringOnCreature("Moon Blade requires an empty main hand.", oCaster, FALSE);
        PRCSetSchool();
        return;
    }

    float fDuration = PRCGetMetaMagicDuration(MinutesToSeconds(nCasterLevel));
    int nSerial = GetLocalInt(oCaster, "PRC_MoonbladeSerial") + 1;
    SetLocalInt(oCaster, "PRC_MoonbladeSerial", nSerial);
    string sBladeTag = MOONBLADE_TAG_PREFIX + ObjectToString(oCaster)
        + "_" + IntToString(nSerial);

    object oBlade = CreateItemOnObject("nw_wswss001", oCaster);
    if(!GetIsObjectValid(oBlade))
    {
        FloatingTextStringOnCreature("Moon Blade failed to create a weapon.", oCaster, FALSE);
        PRCSetSchool();
        return;
    }

    SetTag(oBlade, sBladeTag);
    SetName(oBlade, "Moon Blade");
    SetIdentified(oBlade, TRUE);
    SetDroppableFlag(oBlade, FALSE);
    SetItemCursedFlag(oBlade, TRUE);

    SetLocalObject(oBlade, "PRC_MOONBLADE_CASTER", oCaster);
    SetLocalInt(oBlade, "PRC_MOONBLADE_CL", nCasterLevel);
    SetLocalInt(oBlade, "PRC_MOONBLADE_METAMAGIC", nMetaMagic);
    SetLocalInt(oBlade, "PRC_MOONBLADE_SPELLID", nSpellID);
    SetLocalObject(oCaster, "PRC_MOONBLADE_ACTIVE_BLADE", oBlade);

    // The visible weapon supplies the attack animations but no mundane
    // damage. Its temporary feat launches one scripted full-attack round in
    // which every iterative attack is resolved against touch AC.
    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(),
        oBlade, fDuration);
    AddItemProperty(DURATION_TYPE_TEMPORARY,
        ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), oBlade, fDuration);

    effect eController = EffectRunScript("", "sp_moonblade", "", 0.0f,
        sBladeTag);
    eController = EffectLinkEffects(eController,
        EffectBonusFeat(MOONBLADE_FULL_ATTACK_FEAT));
    eController = SetEffectSpellId(eController, nSpellID);
    eController = SetEffectCasterLevel(eController, nCasterLevel);
    eController = SetEffectCreator(eController, oCaster);
    eController = TagEffect(eController, sBladeTag);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eController, oCaster,
        fDuration, TRUE, nSpellID, nCasterLevel, oCaster);

    AssignCommand(oCaster, ActionEquipItem(oBlade, INVENTORY_SLOT_RIGHTHAND));
    SPApplyEffectToObject(DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_HOLY_AID), oCaster);

    // Fallback only. Normal cleanup is driven by the removable controller.
    DelayCommand(fDuration + 0.1f, MoonbladeExpire(oBlade));
    DelayCommand(0.1f, MoonbladeRefreshNui(oCaster));

    PRCSetSchool();
}
