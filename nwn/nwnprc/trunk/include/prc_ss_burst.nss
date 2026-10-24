// Greater Moon's Hand: approved portable PRC approximation.
// Stormlord and Blood in the Water both reroll a threat check on each hit;
// neither supplies the engine's actual critical result. Do not use BITW's
// decay timestamp or the unscoped PRCCombat_CriticalHit target local here.
#include "prc_ss_inc"
#include "prc_inc_combat"

int SSCanMoonBurst(object oAttacker, object oTarget, object oWeapon)
{
    if (!GetIsObjectValid(oAttacker) || !GetIsObjectValid(oTarget)
    || !GetIsObjectValid(oWeapon)
    || GetObjectType(oAttacker) != OBJECT_TYPE_CREATURE
    || GetObjectType(oTarget) != OBJECT_TYPE_CREATURE
    || GetObjectType(oWeapon) != OBJECT_TYPE_ITEM
    || GetIsDead(oAttacker) || GetIsDead(oTarget)
    || SSGetClassLevel(oAttacker) < 9
    || !GetHasFeat(SS_FEAT_GREATER_MOON_HAND, oAttacker)
    || GetBaseItemType(oWeapon) != BASE_ITEM_HEAVY_MACE
    || GetItemPossessor(oWeapon) != oAttacker
    || (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAttacker) != oWeapon
        && GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oAttacker) != oWeapon)
    || oAttacker == oTarget || !GetIsEnemy(oAttacker, oTarget))
        return FALSE;

    // Retain Stormlord's critical-immunity exclusion for this adaptation.
    return !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT);
}

int SSMoonBurstThreat(object oAttacker, object oWeapon)
{
    // Same helper as Blood in the Water: base threat, weapon-specific Improved
    // Critical, Keen, and applicable Weapon Master bonuses.
    return GetWeaponCriticalRange(oAttacker, oWeapon);
}

int SSMoonBurstDice(object oAttacker, object oWeapon)
{
    // A normal x2 heavy mace bursts for 1d10, not Stormlord's x3 spear's 2d10.
    return GetWeaponCritcalMultiplier(oAttacker, oWeapon) - 1;
}

int SSMoonBurstRollSucceeds(object oAttacker, object oWeapon, int nRoll)
{
    return nRoll >= 1 && nRoll <= 20
        && nRoll >= SSMoonBurstThreat(oAttacker, oWeapon);
}

int SSApplyMoonBurst(object oAttacker, object oTarget, object oWeapon)
{
    if (!SSCanMoonBurst(oAttacker, oTarget, oWeapon)) return 0;
    if (!SSMoonBurstRollSucceeds(oAttacker, oWeapon, d20())) return 0;
    int nDice = SSMoonBurstDice(oAttacker, oWeapon);
    if (nDice < 1) return 0;
    int nDamage = d10(nDice);
    // Electrical damage only. Stormlord's thundering/sonic rider is unrelated.
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
        SupernaturalEffect(EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL,
                                       DAMAGE_POWER_NORMAL)), oTarget);
    // Do not print "Critical Hit": this proc is not an actual critical result.
    return nDamage;
}
