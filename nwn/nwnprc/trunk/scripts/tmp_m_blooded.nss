//::///////////////////////////////////////////////
//:: Name           Blooded One template script
//:: FileName       tmp_m_blooded
//:: 
//:://////////////////////////////////////////////
/*“Blooded” is a template that can be added to any humanoid (referred to hereafter as the “base creature”). It uses all the base creature’s statistics and special abilities, except as listed here.
AC: Natural armor improves by +2.
Special Attacks: A blooded one retains all the special attacks of the base creature, and also gains the following special attack. 
War Cry (Ex): Once per day, a blooded one can scream a special war cry. This causes all blooded ones within 30 feet (including itself) to gain a +1 morale bonus on all attack and damage rolls for 2d4 rounds. 
This effect does not stack with other war cries. 
Abilities: Adjust from the base creature as follows: Str +2, Con +4, Int –2.
Feats: Same as the base creature, except that a blooded one gains Combat Reflexes.
Level Adjustment: Same as the base creature +1.
*/

#include "prc_inc_template"

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	itemproperty ipIP;

	//natural armor
	int nAC = 2;
	SetCompositeBonus(oSkin, "Template_Blooded_ac", nAC, ITEM_PROPERTY_AC_BONUS);
	
	//Ability Changes
	SetCompositeBonus(oSkin, "Template_Blooded_str",  2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);
	SetCompositeBonus(oSkin, "Template_Blooded_con",  4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
	SetCompositeBonus(oSkin, "Template_Blooded_int", -2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
	
	//Power Attack
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_POWERATTACK);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    
	//Template Ability
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_BLOODED_WAR_CRY);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);    
}    