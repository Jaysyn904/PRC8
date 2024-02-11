// Dread Necromancer passive abilities.

#include "prc_inc_template"

void DNDamageResist(object oPC, int nLevel)
{
    object oSkin = GetPCSkin(oPC);
    if(GetLocalInt(oSkin, "DNDamageResist") == TRUE) return;

    int nDR;
    if (nLevel >= 15)      nDR = IP_CONST_DAMAGERESIST_8;
    else if (nLevel >= 11) nDR = IP_CONST_DAMAGERESIST_6;
    else if (nLevel >= 7)  nDR = IP_CONST_DAMAGERESIST_4;
    else if (nLevel >= 2)  nDR = IP_CONST_DAMAGERESIST_2;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PIERCING, nDR), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SLASHING, nDR), oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_BLUDGEONING, nDR), oSkin);
    SetLocalInt(oSkin, "DNDamageResist", TRUE);
}

// Armour Spell Fail reduction
/*void ReducedASF(object oCreature)
{
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
    object oSkin = GetPCSkin(oCreature);
    int nAC = GetBaseAC(oArmor);
    int nClass = GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oCreature);
    int iBonus = GetLocalInt(oSkin, "DreadNecroArmour");
    int nASF = -1;
    itemproperty ip;

    // First thing is to remove old ASF (in case armor is changed.)
    if (iBonus != -1)
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, iBonus, 1, "DreadNecroArmour");

    // As long as they meet the requirements, just give em max ASF reduction
    // I know it could cause problems if they have increased ASF, but thats unlikely
    else if (3 >= nAC)
        nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT;

    // Apply the ASF to the skin.
    ip = ItemPropertyArcaneSpellFailure(nASF); 

    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oSkin);
    SetLocalInt(oSkin, "DreadNecroArmour", nASF);
}*/

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    int nClass = GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oPC);

    //if (GetIsPC(oPC)) ReducedASF(oPC);
    if(nClass > 1) DNDamageResist(oPC, nClass);
    if(nClass > 19) ApplyTemplateToObject(TEMPLATE_LICH, oPC);
}
