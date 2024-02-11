//::///////////////////////////////////////////////
//:: Name      Starmantle Onhit: Destroy Non-magical weapons
//:: FileName  prc_evnt_strmtl.nss
//:://////////////////////////////////////////////
/*
The starmantle renders the wearer impervious to 
non-magical weapon attacks and transforms any 
non-magical weapon or missile that strikes it 
into harmless light, destroying it forever. 
Contact with the starmantle does not destroy 
magic weapons or missiles, but the starmantle's 
wearer is entitled to a Reflex saving throw 
(DC 15) each time he is struck by such a weapon;
success indicates that the wearer takes only 
half damage from the weapon (rounded down).

Author:    Tenjac
Created:   7/17/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//------------------------------------------------------------------------------
// AN, 2003
// Returns TRUE if oItem has any item property that classifies it as magical item
//------------------------------------------------------------------------------
// fluffyamoeba - minor optimisation to remove itemprops that will never be on a melee weapon from the check
int PRCGetIsMagicalMeleeWeapon(object oItem)
{
    return GetItemHasItemProperty(oItem, ITEM_PROPERTY_ABILITY_BONUS)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_BONUS_FEAT)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_CAST_SPELL)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_REDUCTION)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_RESISTANCE)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_VULNERABILITY)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DARKVISION)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ABILITY_SCORE)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_AC)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_DAMAGE)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SAVING_THROWS)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_FREEDOM_OF_MOVEMENT)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_HASTE)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_HOLY_AVENGER)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMPROVED_EVASION)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_KEEN)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_LIGHT)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_MASSIVE_CRITICALS)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_MIGHTY)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_MIND_BLANK)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_MONSTER_DAMAGE)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_NO_DAMAGE)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_ON_HIT_PROPERTIES)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_ON_MONSTER_HIT)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_POISON)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_REGENERATION)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_REGENERATION_VAMPIRIC)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_SKILL_BONUS)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_SPELL_RESISTANCE)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_TRUE_SEEING)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_TURN_RESISTANCE)
         || GetItemHasItemProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL);
}

#include "prc_inc_spells"

void main()
{
    //Get attacker that hit
    object oSpellOrigin = OBJECT_SELF;
    object oSpellTarget = PRCGetSpellTargetObject(oSpellOrigin);
    object oWeaponR     = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSpellTarget);
    object oWeaponL     = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSpellTarget);

/*
// motu99: obsolate - is handled in PRCGetSpellCastItem 
    // Scripted combat system
    if(!GetIsObjectValid(oItem))
    {
        oItem = GetLocalObject(oSpellOrigin, "PRC_CombatSystem_OnHitCastSpell_Item");
    }
*/
    //If non-magical weapon in right hand
    if(GetIsObjectValid(oWeaponR) && IPGetIsMeleeWeapon(oWeaponR) && !PRCGetIsMagicalMeleeWeapon(oWeaponR))
    {
        DestroyObject(oWeaponR);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), oSpellTarget);
        return;
    }

    //if non-magical weapon in left hand
    else if(GetIsObjectValid(oWeaponL) && IPGetIsMeleeWeapon(oWeaponL) && !PRCGetIsMagicalMeleeWeapon(oWeaponL))
    {
        DestroyObject(oWeaponL);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISPEL), oSpellTarget);
        return;
    }
    //Magical now handled as damage reduction
}