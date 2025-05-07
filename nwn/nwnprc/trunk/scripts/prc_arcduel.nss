#include "prc_alterations"
#include "inc_utility"

int GetADWeaponAttackBonus(object oWeap)
{
    if (!GetIsObjectValid(oWeap)) return 0;

    object oKotC = GetItemPossessor(oWeap);
    itemproperty ip = GetFirstItemProperty(oWeap);
    int iTotal = 0;
    int iValue = 0;

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_ATTACK_BONUS ||
            GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
        {
            iValue = GetItemPropertyCostTableValue(ip);
            iTotal = (iValue > iTotal) ? iValue : iTotal;
        }
        else if (GetItemPropertyType(ip) == ITEM_PROPERTY_HOLY_AVENGER &&
                 GetLevelByClass(CLASS_TYPE_PALADIN, oKotC))
        {
            iValue = 5;
            iTotal = (iValue > iTotal) ? iValue : iTotal;
        }
        ip = GetNextItemProperty(oWeap);
    }

    return iTotal;
}


// * Applies the Arcane Duelist's AC bonus as a CompositeBonus on object's skin.
void ApparentDefense(object oPC, object oSkin)
{
    if(GetLocalInt(oSkin, "ADDef") == GetAbilityModifier(ABILITY_CHARISMA, oPC)) return;

    SetCompositeBonus(oSkin, "ADDef", GetAbilityModifier(ABILITY_CHARISMA, oPC), ITEM_PROPERTY_AC_BONUS);
}


// * Removes the Arcane Duelist's Enchant Chosen Weapon bonus
void RemoveEnchantCW(object oPC, object oWeap)
{
      if (GetLocalInt(oWeap, "ADEnchant"))
      {
         SetCompositeBonusT(oWeap, "ADEnchant", 0, ITEM_PROPERTY_ENHANCEMENT_BONUS);
      }
}

/* 	Enchant Chosen Weapon (Ex): The arcane duelist's chosen melee 
	weapon acts as if it has an enhancement bonus, even if it does 
	not. If it does have an enhancement bonus, the arcane duelist 
	adds this bonus to the weapon as an effective bonus. This can 
	bring a weapon's effective enhancement bonus above +5. However, 
	no weapon can have more than a +10 total effective bonus, so this 
	class-granted effective bonus cannot be added to a weapon if the 
	addition would increase the weapon's total effective bonus above 
	+10. This class-granted bonus works only for the arcane duelist 
	when wielding her chosen melee weapon. The enhancement bonus is 
	+1 at 1st level, and rises to +2 at 4th level, +3 at 6th level, 
	and +4 at 8th level. 
	
	Enchant Chosen Weapon: The epic Arcane Duelist's Chosen Weapon 
	bonus continues to increase by +1 every other level and the 
	maximum enhancement to the Chosen Weapon is increased to +20.*/

// * Applies the Arcane Duelist's Enchant Chosen Weapon bonus
void EnchantCW(object oPC, object oWeap)
{
    if (!GetIsObjectValid(oPC) || !GetIsObjectValid(oWeap))
        return;

    int nADLevel = GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC);
    int nBonus = 0;
    int nExistingBonus = GetADWeaponAttackBonus(oWeap);
    int nEffectiveBonus;
    int nMaxBonus;

    if (nADLevel < 1)
        return; // No Arcane Duelist levels, no bonus.

    // Base scaling
    if (nADLevel >= 1) nBonus += 1;
    if (nADLevel >= 4) nBonus += 1;
    if (nADLevel >= 6) nBonus += 1;
    if (nADLevel >= 8) nBonus += 1;
    if (nADLevel >= 10) nBonus += 1;

    // Epic scaling
    if (GetHasFeat(FEAT_EPIC_ARCANE_DUELIST, oPC))
    {
        nBonus += (nADLevel - 10) / 2;
        nMaxBonus = 10;
    }
    else
    {
        nMaxBonus = 10;
    }

    // Cap the total effective bonus
    nEffectiveBonus = nExistingBonus + nBonus;
    if (nEffectiveBonus > nMaxBonus)
    {
        nBonus -= (nEffectiveBonus - nMaxBonus);
    }

    if (nBonus > 0)
    {
        // Apply only if there's still a bonus left to apply
        DelayCommand(0.1, SetCompositeBonusT(oWeap, "ADEnchant", nBonus, ITEM_PROPERTY_ENHANCEMENT_BONUS));
    }
}


/* void EnchantCW(object oPC, object oWeap)
{
	int iBonus = GetADWeaponAttackBonus(oWeap);
	int iEpicAD = GetHasFeat(FEAT_EPIC_ARCANE_DUELIST);

	if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 1)
		iBonus += 1;

	if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 4)
		iBonus += 1;

	if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 6)
		iBonus += 1;

	if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 8)
		iBonus += 1;
	 
	if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 10)
		iBonus += 1;

	//SendMessageToPC(oPC, "Enchant Chosen Weapon has been run");
	DelayCommand(0.1,SetCompositeBonusT(oWeap, "ADEnchant", iBonus, ITEM_PROPERTY_ENHANCEMENT_BONUS));
}
 */
void main()
{
  object oPC = OBJECT_SELF;
  object oSkin = GetPCSkin(oPC);
  object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

  if (GetHasFeat(FEAT_AD_APPARENT_DEFENSE, oPC)) ApparentDefense(oPC, oSkin);

  if (GetLocalInt(oWeap,"CHOSEN_WEAPON") == 2)
    EnchantCW(oPC, oWeap);

  if (GetLocalInt(oPC,"ONEQUIP") == 1)
        RemoveEnchantCW(oPC, GetItemLastUnequipped());
}
