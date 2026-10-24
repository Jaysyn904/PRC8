#include "sp_moon_inc"
#include "prc_inc_combat"

const string MOONBLADE_FULL_ATTACK_ACTIVE =
    "PRC_MOONBLADE_FULL_ATTACK_ACTIVE";
const string MOONBLADE_FULL_ATTACK_SERIAL =
    "PRC_MOONBLADE_FULL_ATTACK_SERIAL";
// Keep these values aligned with the Moon Blade bindings in the development
// prc_nui_consts include. The release spell compile intentionally uses the
// stock PRC include tree, where those project-specific constants do not exist.
const string MOONBLADE_SPELLBOOK_NUI_WINDOW_ID = "prcSpellbookNui";
const string MOONBLADE_NUI_ENABLED_BIND = "sbMbE";
const string MOONBLADE_NUI_READY_BIND = "sbMbR";

void MoonbladeSetNuiReady(object oCaster, int bReady)
{
    int nToken = NuiFindWindow(oCaster, MOONBLADE_SPELLBOOK_NUI_WINDOW_ID);
    if(nToken <= 0)
        return;

    NuiSetBind(oCaster, nToken,
        MOONBLADE_NUI_ENABLED_BIND, JsonBool(bReady));
    NuiSetBind(oCaster, nToken,
        MOONBLADE_NUI_READY_BIND, JsonBool(bReady));
}

void MoonbladeClearFullAttackLock(object oCaster, object oBlade, int nSerial)
{
    if(!GetIsObjectValid(oCaster)
        || GetLocalObject(oCaster, "PRC_MOONBLADE_ACTIVE_BLADE") != oBlade
        || GetLocalInt(oCaster, MOONBLADE_FULL_ATTACK_SERIAL) != nSerial)
        return;

    DeleteLocalInt(oCaster, MOONBLADE_FULL_ATTACK_ACTIVE);
    MoonbladeSetNuiReady(oCaster, TRUE);
}

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    if(!GetIsObjectValid(oTarget)
        || GetObjectType(oTarget) != OBJECT_TYPE_CREATURE
        || GetIsDead(oTarget)
        || oTarget == oCaster)
    {
        FloatingTextStringOnCreature(
            "Moon Blade requires a living creature target.", oCaster,
            FALSE);
        return;
    }

    object oBlade = GetLocalObject(oCaster,
        "PRC_MOONBLADE_ACTIVE_BLADE");
    int nSpellID = GetLocalInt(oBlade, "PRC_MOONBLADE_SPELLID");
    if(!GetIsObjectValid(oBlade)
        || nSpellID < 1
        || GetLocalObject(oBlade, "PRC_MOONBLADE_CASTER") != oCaster
        || GetItemPossessor(oBlade) != oCaster
        || GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster) != oBlade)
    {
        FloatingTextStringOnCreature(
            "Moon Blade must be active and equipped in your main hand.",
            oCaster, FALSE);
        return;
    }

    if(GetLocalInt(oCaster, MOONBLADE_FULL_ATTACK_ACTIVE))
    {
        FloatingTextStringOnCreature(
            "Moon Blade: Full Attack is usable once per round.", oCaster,
            FALSE);
        return;
    }

    if(!MoonbladeIsInMeleeRange(oCaster, oTarget))
    {
        FloatingTextStringOnCreature(
            "Moon Blade target is outside melee range.", oCaster,
            FALSE);
        return;
    }

    int nSerial = GetLocalInt(oCaster, MOONBLADE_FULL_ATTACK_SERIAL) + 1;
    SetLocalInt(oCaster, MOONBLADE_FULL_ATTACK_SERIAL, nSerial);
    SetLocalInt(oCaster, MOONBLADE_FULL_ATTACK_ACTIVE, TRUE);
    MoonbladeSetNuiReady(oCaster, FALSE);
    DelayCommand(RoundsToSeconds(1),
        MoonbladeClearFullAttackLock(oCaster, oBlade, nSerial));

    // The PRC attack routine spends the caster's full attack sequence over the
    // round. Spell-touch mode suppresses normal weapon damage, and the linked
    // run-script effect applies Moon Blade damage after every successful hit.
    effect eHit = EffectRunScript("sp_moonblade_h", "", "", 0.0f,
        GetTag(oBlade));
    eHit = SetEffectCreator(eHit, oCaster);
    eHit = SetEffectSpellId(eHit, nSpellID);
    eHit = TagEffect(eHit, "MBH_" + GetTag(oBlade));

    // EffectRunScript does not dispatch its OnApplied handler when PRC's
    // attack helper applies it as an instantaneous effect.  Keep it alive
    // briefly so every successful touch invokes sp_moonblade_h.
    PerformAttackRound(oTarget, oCaster, eHit, 0.1f,
        0, 0, DAMAGE_TYPE_UNTYPED, TRUE,
        "", "", TRUE, TOUCH_ATTACK_MELEE_SPELL, FALSE,
        PRC_COMBATMODE_ABORT_WHEN_OUT_OF_RANGE);
}
