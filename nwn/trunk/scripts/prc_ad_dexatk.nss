
#include "prc_inc_clsfunc"

void main()
{
object oPC = OBJECT_SELF;
object oWeapon = GetLocalObject(oPC, "CHOSEN_WEAPON");
int iType = GetBaseItemType(oWeapon);

if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != oWeapon)
{
    FloatingTextStringOnCreature("You must have your chosen weapon equipped in your main hand.", oPC, FALSE);
    return;
}

    int iWeaponType = GetBaseItemType(oWeapon);
    int iNumDice = StringToInt(Get2DACache("baseitems","NumDice",iWeaponType));
    int iDieToRoll = StringToInt(Get2DACache("baseitems","DieToRoll",iWeaponType));
    int iAttack = iNumDice * iDieToRoll - 1;

    effect eAttackIncrease = EffectAttackIncrease(iAttack,ATTACK_BONUS_MISC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttackIncrease, oPC);

    FloatingTextStringOnCreature("Dexterous Attack Mode Activated", oPC, FALSE);
    DelayCommand(6.0, CheckCombatDexAttack(oPC));
}
