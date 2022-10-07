#include "prc_alterations"

//Applies Katana Finesse to the character as an effect
void KatanaFinesse(object oPC)
{
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oWeap2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

    int bKatFin = GetHasFeat(FEAT_KATANA_FINESSE, oPC);
    int bStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
    int bDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
    int bKatFinBon = (bDex > bStr) ? bDex - bStr : 0;
    int iUseR = FALSE;
    int iUseL = FALSE;

    if(bKatFin && bKatFinBon &&
       (GetBaseItemType(oWeap) == BASE_ITEM_KATANA
         || // Hack - Assume a Soulknife with Iaijutsu Master levels using bastard sword shape has it shaped like a katana
        (GetStringLeft(GetTag(oWeap), 14) == "prc_sk_mblade_" && GetBaseItemType(oWeap) == BASE_ITEM_BASTARDSWORD)
        )
       )
    {
        iUseR = TRUE;
        if (!GetLocalInt(oPC, "KatanaFinesseOnR")) SendMessageToPC(oPC, "Katana Finesse On -- Main Hand.");
        SetLocalInt(oPC, "KatanaFinesseOnR", TRUE);
    }
    else
    {
        if (GetLocalInt(oPC, "KatanaFinesseOnR")) SendMessageToPC(oPC, "Katana Finesse Off -- Main Hand.");
        DeleteLocalInt(oPC, "KatanaFinesseOnR");
    }

    if(bKatFin && bKatFinBon &&
       (GetBaseItemType(oWeap2) == BASE_ITEM_KATANA
         || // Hack - Assume a Soulknife with Iaijutsu Master levels using bastard sword shape has it shaped like a katana
        (GetStringLeft(GetTag(oWeap2), 14) == "prc_sk_mblade_" && GetBaseItemType(oWeap) == BASE_ITEM_BASTARDSWORD)
        )
       )
    {
        iUseL = TRUE;
        if (!GetLocalInt(oPC, "KatanaFinesseOnL")) SendMessageToPC(oPC, "Katana Finesse On -- Off Hand.");
        SetLocalInt(oPC, "KatanaFinesseOnL", TRUE);
    }
    else
    {
        if (GetLocalInt(oPC, "KatanaFinesseOnL")) SendMessageToPC(oPC, "Katana Finesse Off -- Off Hand.");
        DeleteLocalInt(oPC, "KatanaFinesseOnL");
    }

    if (iUseR)
        SetCompositeAttackBonus(oPC, "KatanaFinesseR", bKatFinBon, ATTACK_BONUS_ONHAND);
    if (iUseL)
        SetCompositeAttackBonus(oPC, "KatanaFinesseL", bKatFinBon, ATTACK_BONUS_OFFHAND);

if (iUseR == FALSE)
        SetCompositeAttackBonus(oPC, "KatanaFinesseR", 0, ATTACK_BONUS_ONHAND);
    if (iUseL == FALSE)
        SetCompositeAttackBonus(oPC, "KatanaFinesseL", 0, ATTACK_BONUS_OFFHAND);
}

void main()
{

    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    object oUnequip = GetItemLastUnequipped();
    object oKatana = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    //Determine which feats the character has
    int bCanDef = GetHasFeat(FEAT_CANNY_DEFENSE, oPC);
    int bEpicCD = GetHasFeat(FEAT_EPIC_IAIJUTSU, oPC);
    int bKatFin = GetHasFeat(FEAT_KATANA_FINESSE, oPC);
    
    int iIntBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
        iIntBonus = bEpicCD ? iIntBonus * 2 : iIntBonus;     

    //Apply bonuses accordingly
    if(bCanDef > 0 && GetBaseAC(oArmor) == 0 && GetBaseItemType(oKatana) == BASE_ITEM_KATANA)
        SetCompositeBonus(oSkin, "Iaijutsu_AC", iIntBonus, ITEM_PROPERTY_AC_BONUS);
    else
        SetCompositeBonus(oSkin, "Iaijutsu_AC", 0, ITEM_PROPERTY_AC_BONUS);

    //int bStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
    //int bDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
    //int bKatFinBon = (bDex > bStr) ? bDex - bStr : 0;

    //SetCompositeAttackBonus(oPC, "KatanaFinesseR", 0, ATTACK_BONUS_ONHAND);
    //SetCompositeAttackBonus(oPC, "KatanaFinesseL", 0, ATTACK_BONUS_OFFHAND);

    KatanaFinesse(oPC);
}