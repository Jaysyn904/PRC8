//::///////////////////////////////////////////////
//:: Name           Mineral Warrior template script
//:: FileName       tmp_m_mineral
//:: 
//:://////////////////////////////////////////////
/*A mineral warrior is a creature that has undergone a transformation into a creature of living stone. Many creatures embrace 
this change willingly, but evil Underdark races sometimes force it on others.

Creating a Mineral Warrior “Mineral warrior” (also called “stony”) is an acquired template that can be added to any 
corporeal creature that is not a construct, undead, or an elemental (referred to hereafter as the base creature). 
A mineral warrior uses all the base creature’s statistics and special abilities except as noted here. 

Size and Type: The creature’s type remains the same, but it gains the earth subtype. 

Size is unchanged. 

Speed: A mineral warrior gains a burrow speed equal to onehalf the base creature’s highest speed. The base creature loses 
its fly ability, if any. 

Armor Class: Natural armor improves by +3. 

Special Attacks: A mineral warrior retains all the special attacks of the base creature and also gains the earth strike
attack. 

Earth Strike (Ex): Once per day, the mineral warrior can make an exceptionally vicious attack against any foe that stands on
stone or earth. The mineral warrior adds its Constitution bonus to its attack roll and deals 1 extra point of damage per
racial Hit Die. 

Special Qualities: A mineral warrior has all the special qualities of the base creature, plus the following. 
Darkvision (Ex): A mineral warrior has darkvision out to 60 feet or the base creature’s darkvision, whichever is better. 
Damage Reduction (Ex): A mineral warrior gains damage reduction 8/adamantine. If it already has damage reduction, it retains 
both versions and uses the best one that applies. 

Abilities: Change from the base creature as follows: +2 Strength, +4 Con, –2 Int (minimum 1), –2 Wis, –2 Cha. 
Environment: Same as the base creature and underground. 

Challenge Rating: Same as the base creature +1. 
Level Adjustment: Same as the base creature +1. 
Sample Mineral Warrior: Stony Devil.
*/
#include "prc_inc_template"

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	itemproperty ipIP;

	//natural armor
	int nAC = 3;
	SetCompositeBonus(oSkin, "Template_mineral_ac", nAC, ITEM_PROPERTY_AC_BONUS);

	//darkvision
    ipIP = ItemPropertyDarkvision();
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	
	//DamageReduction
	ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_8_HP); 
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	
	//Ability Changes
	SetCompositeBonus(oSkin, "Template_mineral_str",  2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);
	SetCompositeBonus(oSkin, "Template_mineral_con",  4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
	SetCompositeBonus(oSkin, "Template_mineral_int", -2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
	SetCompositeBonus(oSkin, "Template_mineral_wis", -2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
	SetCompositeBonus(oSkin, "Template_mineral_cha", -2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);
	
	//Earth Strike
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EARTH_STRIKE);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}    