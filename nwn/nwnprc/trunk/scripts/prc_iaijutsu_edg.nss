/*
  Echo of the Edge
  prc_iaijutsu_edg
  works for 1 attack only
*/

#include "prc_inc_combat"


void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    int iMod = 0;

    int iCriticalMultiplier = GetWeaponCritcalMultiplier(oPC, oWeap);
    struct BonusDamage sWeaponBonusDamage = GetWeaponBonusDamage(oWeap, oTarget);
    struct BonusDamage sSpellBonusDamage = GetMagicalBonusDamage(oPC, oTarget);
    int iWeapDamage = GetWeaponDamagePerRound(oTarget, oPC, oWeap, 0);
    int iAttackBonus = GetAttackBonus(oTarget, oPC, oWeap, 0);
    int iWeapEnch = GetDamagePowerConstant(oWeap, oTarget, oPC);
    int iReturn = GetAttackRoll(oTarget, oPC, oWeap, 0, iAttackBonus, 0, TRUE, 0.0);

    if(GetBaseItemType(oWeap) == BASE_ITEM_KATANA
        || // Hack - Assume a Soulknife with Iaijutsu Master levels using bastard sword shape has it shaped like a katana
       (GetStringLeft(GetTag(oWeap), 14) == "prc_sk_mblade_" && GetBaseItemType(oWeap) == BASE_ITEM_BASTARDSWORD)
       )
    {
        if(iReturn == 2)
        {
            effect eDamage = GetAttackDamage(oTarget, oPC, oWeap, sWeaponBonusDamage, sSpellBonusDamage, 0, iWeapDamage, TRUE, 0, 0, iCriticalMultiplier);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
            FloatingTextStringOnCreature("Critical Echoes of the Edge",OBJECT_SELF);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
            FloatingTextStringOnCreature("Critical Echoes of the Edge",OBJECT_SELF);
            ActionAttack(oTarget);
        }

        if(iReturn == 1)
        {
            effect eDamage = GetAttackDamage(oTarget, oPC, oWeap, sWeaponBonusDamage, sSpellBonusDamage, 0, iWeapDamage, FALSE, 0, 0, iCriticalMultiplier);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
            FloatingTextStringOnCreature("Echoes of the Edge",OBJECT_SELF);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
            FloatingTextStringOnCreature("Echoes of the Edge",OBJECT_SELF);
            ActionAttack(oTarget);
        }
    }
}
