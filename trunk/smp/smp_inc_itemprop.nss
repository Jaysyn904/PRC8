/*:://////////////////////////////////////////////
//:: Name Magical Item Properties Include
//:: FileName SMP_INC_ITEMPROP
//:://////////////////////////////////////////////
    This holds all the things for applying, removing and checking magical item
    propreties.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "x2_inc_itemprop"
#include "SMP_INC_ARRAY"


// SMP_INC_ITEMPROP. Check if oItem is enchanted.
int SMP_IP_GetIsEnchanted(object oItem);

// SMP_INC_ITEMPROP. We apply eVis on oItem, if its not possessed by something,
// else, the possessor of oItem is the target.
void SMP_IP_ApplyImactVisualAtItemLocation(effect eVis, object oItem);

// SMP_INC_ITEMPROP. Returns the amount of any ITEM_PROPERTY_DECREASED_AC,
// used for Rusting Grasp.
// * Only uses the Armor decreasing ones. ItemPropertyDecreaseAC();
int SMP_IP_GetArmorEnchantedPenalties(object oItem);

// SMP_INC_ITEMPROP. This will return the total bonus damage, minus any penalties, on oItem
int SMP_IP_GetItemBonusDamage(object oItem);

// SMP_INC_ITEMPROP. Adds the restrictions to oItem, in the form of class
// restrictions, on who can use oItem if it had nSpellId on it. This means,
// basically, that It'll add properties "Only you cna use this" if the class
// has the spell on thier list.
void SMP_IP_AddRestrictionsForSpell(object oItem, int nSpellId);

// WeaponType values:
// 0   None
// 1   Piercing
// 2   Bludgeoning
// 3   Slashing
// 4   Slashing and Piercing

// SMP_INC_ITEMPROP. This is partly taken from x2_inc_itemprop - but why reinvent the wheel?
// * Returns TRUE if oItem is a weapon that deals damage of any type
int SMP_IP_GetIsWeapon(object oItem);
// SMP_INC_ITEMPROP. This is partly taken from x2_inc_itemprop - but why reinvent the wheel?
// * Returns TRUE if oItem is a bludgeoning weapon.
int SMP_IP_GetIsBludgeoningWeapon(object oItem);
// SMP_INC_ITEMPROP. This is partly taken from x2_inc_itemprop - but why reinvent the wheel?
// * Returns TRUE if oItem is a slashing weapon.
// Will NOT return true if it is BOTH slashing and piercing.
int SMP_IP_GetIsSlashingWeapon(object oItem);
// SMP_INC_ITEMPROP. This is partly taken from x2_inc_itemprop - but why reinvent the wheel?
// * Returns TRUE if oItem is a piercing weapon.
// Will NOT return true if it is BOTH slashing and piercing.
int SMP_IP_GetIsPiercingWeapon(object oItem);
// SMP_INC_ITEMPROP. This is partly taken from x2_inc_itemprop - but why reinvent the wheel?
// * Returns TRUE if oItem is a piercing OR slashing weapon.
// Uses parts of SMP_IP_GetIsSlashingWeapon, SMP_IP_GetIsPiercingWeapon, plus
// another check. One 2da lookup.
int SMP_IP_GetIsPiercingOrSlashingWeapon(object oItem);

// SMP_INC_ITEMPROP. Checks for the highest caster level, that can use oCastItem,
// such as a Mage activating a Staff of Abjuration. It will return 0 if no
// classes are found that can activate the item oCastItem - meaning it was used
// by UMD or has no restrictions.
// * Returns the level of the caster used to use the magical item oCastItem, or zero.
int SMP_SpellItemHighestLevelActivator(object oCastItem, object oCaster);


// Check if oItem is enchanted.
int SMP_IP_GetIsEnchanted(object oItem)
{
    // Check with GetItemHasProperty.
    // - Checks for magical enchantments.
    // - Misses out ones that could be considered mundane. Of course, if it has, say,
    //   keen ANY AC bonus, it will be considered magical
    if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ABILITY_BONUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ARCANE_SPELL_FAILURE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_BONUS_FEAT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_CAST_SPELL) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_REDUCTION) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_RESISTANCE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_VULNERABILITY) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DARKVISION) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ABILITY_SCORE) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_AC) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_DAMAGE) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SAVING_THROWS) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_FREEDOM_OF_MOVEMENT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_HASTE) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_HEALERS_KIT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_HOLY_AVENGER) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMPROVED_EVASION) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_KEEN) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_LIGHT) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_MASSIVE_CRITICALS) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_MIGHTY) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_MIND_BLANK) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_MONSTER_DAMAGE) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_NO_DAMAGE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ON_HIT_PROPERTIES) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ON_MONSTER_HIT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_POISON) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_REGENERATION) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_REGENERATION_VAMPIRIC) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_SKILL_BONUS) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_SPECIAL_WALK) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_SPELL_RESISTANCE) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_THIEVES_TOOLS) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_TRAP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_TRUE_SEEING) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_TURN_RESISTANCE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_UNLIMITED_AMMUNITION))

//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_USE_LIMITATION_TILESET) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_VISUALEFFECT) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_WEIGHT_INCREASE) ||

    {
        return TRUE;
    }
    return FALSE;
}

// We apply eVis on oItem, if its not possessed by something, else, the possessor
// of oItem is the target.
void SMP_IP_ApplyImactVisualAtItemLocation(effect eVis, object oItem)
{
    // Apply visuals to the possessor...
    object oPossessor = GetItemPossessor(oItem);
    if(GetIsObjectValid(oPossessor))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPossessor);
    }
    else
    {
        // Or the item directly on the ground...
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oItem);

    }
}

// Returns the amount of any ITEM_PROPERTY_DECREASED_AC, used for Rusting
// Grasp.
// * Only uses the Armor decreasing ones. ItemPropertyDecreaseAC();
int SMP_IP_GetArmorEnchantedPenalties(object oItem)
{
    // Check for the item property at all
    int nReturn = FALSE;
    if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_AC))
    {
        // Loop IP's
        itemproperty IP_Check = GetFirstItemProperty(oItem);
        while(GetIsItemPropertyValid(IP_Check))
        {
            // Get if AC decrease
            if(GetItemPropertyType(IP_Check) == ITEM_PROPERTY_DECREASED_AC)
            {
                // Must be armor AC
                if(GetItemPropertySubType(IP_Check) == IP_CONST_ACMODIFIERTYPE_ARMOR)
                {
                    // Get the cost parmater
                    nReturn += GetItemPropertyCostTableValue(IP_Check);
                }
            }
            // Get next
            IP_Check = GetNextItemProperty(oItem);
        }
    }
    return nReturn;
}

// This will return the total bonus damage, minus any penalties, on oItem
int SMP_IP_GetItemBonusDamage(object oItem)
{
    // Check for the item property at all
    int nReturn = FALSE;
    int nBad, nGood, nType;
    if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_DAMAGE))
    {
        // Loop IP's
        itemproperty IP_Check = GetFirstItemProperty(oItem);
        while(GetIsItemPropertyValid(IP_Check))
        {
            // Get if Damage decrease
            nType = GetItemPropertyType(IP_Check);
            if(nType == ITEM_PROPERTY_DECREASED_AC)
            {
                // Get the cost parmater
                nBad += GetItemPropertyCostTableValue(IP_Check);
            }
            else if(nType == ITEM_PROPERTY_DAMAGE_BONUS)
            {
                // Get the cost parmater
                nGood += GetItemPropertyCostTableValue(IP_Check);
            }
            // Get next
            IP_Check = GetNextItemProperty(oItem);
        }
    }
    nReturn = nGood - nBad;
    return nReturn;
}

// This is partly taken from x2_inc_itemprop - but why reinvent the wheel?
// * Returns TRUE if oItem is a weapon that deals damage of any type
int SMP_IP_GetIsWeapon(object oItem)
{
    int nItemType = GetBaseItemType(oItem);
    int nWeapon = (StringToInt(Get2DAString("baseitems", "WeaponType", nItemType)));
    // 0 = none
    return (nWeapon != 0);
}
// This is partly taken from x2_inc_itemprop - but why reinvent the wheel?
// * Returns TRUE if oItem is a bludgeoning weapon.
int SMP_IP_GetIsBludgeoningWeapon(object oItem)
{
    int nItemType = GetBaseItemType(oItem);
    int nWeapon = (StringToInt(Get2DAString("baseitems", "WeaponType", nItemType)));
    // 2 = bludgeoning
    return (nWeapon == 2);
}

// This is partly taken from x2_inc_itemprop - but why reinvent the wheel?
// * Returns TRUE if oItem is a slashing weapon.
// Will NOT return true if it is BOTH slashing and piercing.
int SMP_IP_GetIsSlashingWeapon(object oItem)
{
    int nItemType = GetBaseItemType(oItem);
    int nWeapon = (StringToInt(Get2DAString("baseitems", "WeaponType", nItemType)));
    // 3 = slashing
    return (nWeapon == 3);
}

// This is partly taken from x2_inc_itemprop - but why reinvent the wheel?
// * Returns TRUE if oItem is a piercing weapon.
// Will NOT return true if it is BOTH slashing and piercing.
int SMP_IP_GetIsPiercingWeapon(object oItem)
{
    int nItemType = GetBaseItemType(oItem);
    int nWeapon = (StringToInt(Get2DAString("baseitems", "WeaponType", nItemType)));
    // 1 = piercing
    return (nWeapon == 1);
}

// This is partly taken from x2_inc_itemprop - but why reinvent the wheel?
// * Returns TRUE if oItem is a piercing OR slashing weapon.
// Uses parts of SMP_IP_GetIsSlashingWeapon, SMP_IP_GetIsPiercingWeapon, plus
// another check. One 2da lookup.
int SMP_IP_GetIsPiercingOrSlashingWeapon(object oItem)
{
    int nItemType = GetBaseItemType(oItem);
    int nWeapon = (StringToInt(Get2DAString("baseitems", "WeaponType", nItemType)));
    // 1 = piercing, 3 = slashing, 4 = both.
    if(nWeapon == 1 || nWeapon == 3 || nWeapon == 4)
    {
        return TRUE;
    }
    return FALSE;
}


// Adds the restrictions to oItem, in the form of class restrictions, on
// who can use oItem if it had nSpellId on it. This means, basically, that
// It'll add properties "Only you cna use this" if the class has the spell on
// thier list.
void SMP_IP_AddRestrictionsForSpell(object oItem, int nSpellId)
{
    // Create the appropriate restrictions
    itemproperty IP_Restrict;

    // Add each item property to which can cast the spell.
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_BARD) != -1)
    {
        // Bard can cast it...add property.
        IP_Restrict = ItemPropertyLimitUseByClass(CLASS_TYPE_BARD);
        AddItemProperty(DURATION_TYPE_PERMANENT, IP_Restrict, oItem);
    }
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_CLERIC) != -1)
    {
        // Cleric
        IP_Restrict = ItemPropertyLimitUseByClass(CLASS_TYPE_CLERIC);
        AddItemProperty(DURATION_TYPE_PERMANENT, IP_Restrict, oItem);
    }
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_DRUID) != -1)
    {
        // Druid
        IP_Restrict = ItemPropertyLimitUseByClass(CLASS_TYPE_DRUID);
        AddItemProperty(DURATION_TYPE_PERMANENT, IP_Restrict, oItem);
    }
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_PALADIN) != -1)
    {
        // Paladin
        IP_Restrict = ItemPropertyLimitUseByClass(CLASS_TYPE_PALADIN);
        AddItemProperty(DURATION_TYPE_PERMANENT, IP_Restrict, oItem);
    }
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_RANGER) != -1)
    {
        // Ranger
        IP_Restrict = ItemPropertyLimitUseByClass(CLASS_TYPE_RANGER);
        AddItemProperty(DURATION_TYPE_PERMANENT, IP_Restrict, oItem);
    }
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_SORCERER) != -1)
    {
        // Sorceror
        IP_Restrict = ItemPropertyLimitUseByClass(CLASS_TYPE_SORCERER);
        AddItemProperty(DURATION_TYPE_PERMANENT, IP_Restrict, oItem);
    }
    if(SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_WIZARD) != -1)
    {
        // Wizard
        IP_Restrict = ItemPropertyLimitUseByClass(CLASS_TYPE_WIZARD);
        AddItemProperty(DURATION_TYPE_PERMANENT, IP_Restrict, oItem);
    }
}

// Checks for the highest caster level, that can use oCastItem, such as a Mage
// activating a Staff of Abjuration. It will return 0 if no classes are found
// that can activate the item oCastItem - meaning it was used by UMD or has
// no restrictions.
int SMP_SpellItemHighestLevelActivator(object oCastItem, object oCaster)
{
    // Is this scroll being used as a class item?
    int nLevel, nHighestLevel, nClass, nHighestClass = CLASS_TYPE_INVALID;
    itemproperty IP_Check = GetFirstItemProperty(oCastItem);
    while(GetIsItemPropertyValid(IP_Check))
    {
        // Check if it is class-restricted
        if(GetItemPropertyType(IP_Check) == ITEM_PROPERTY_USE_LIMITATION_CLASS)
        {
            // Check if we have the class.
            // Note:
            // int IP_CONST_CLASS_BARBARIAN                            = 0;
            // int IP_CONST_CLASS_BARD                                 = 1;
            // int IP_CONST_CLASS_CLERIC                               = 2;
            // int IP_CONST_CLASS_DRUID                                = 3;
            // int IP_CONST_CLASS_FIGHTER                              = 4;
            // int IP_CONST_CLASS_MONK                                 = 5;
            // int IP_CONST_CLASS_PALADIN                              = 6;
            // int IP_CONST_CLASS_RANGER                               = 7;
            // int IP_CONST_CLASS_ROGUE                                = 8;
            // int IP_CONST_CLASS_SORCERER                             = 9;
            // int IP_CONST_CLASS_WIZARD                               = 10;
            // Same as the classes.2da file constants. We check check this.
            nLevel = GetLevelByClass(GetItemPropertySubType(IP_Check), oCaster);
            if(nLevel > nHighestLevel)
            {
                nHighestLevel = nLevel;
                nHighestClass = nClass;
            }
        }
        // Next property
        IP_Check = GetNextItemProperty(oCastItem);
    }
    // Return TRUE only if we have a class to return. Returns the level
    if(nHighestClass != CLASS_TYPE_INVALID)
    {
        return nHighestClass;
    }
    // Return 0.
    return FALSE;
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
