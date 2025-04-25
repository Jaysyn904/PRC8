//::///////////////////////////////////////////////
//:: Name           Crypt Spawn maintain script
//:: FileName       tmp_m_cryptspawn
//:: 
//:://////////////////////////////////////////////

/*

*/
//:://////////////////////////////////////////////
//:: Created By: Jaysyn
//:: Created On: 2022/03/07
//:://////////////////////////////////////////////

/*CREATING A CRYPT SPAWN
“Crypt spawn” is a template that can be applied to any living creature (referred to hereafter as the “base creature”). The base creature’s type changes to “undead.” It uses all the base creature’s statistics and special abilities except as noted here.

Hit Dice: Increase to d12.

AC: A crypt spawn gains a natural armor bonus (see the table below). If the base creature already has natural armor, use the better value.

Hit Dice  Natural Armor
1–4 		+1
5–8 		+2
9–12 		+3
13–16 		+4
17+ 		+5

Special Qualities: A crypt spawn retains all the special qualities of the base creature and those listed below, and also gains the undead type.

Darkvision (Ex): A crypt spawn can see in complete darkness as if it were daylight.

Turn Resistance (Ex): A crypt spawn has +2 turn resistance.

Abilities: As an undead creature, a crypt spawn has no Constitution score.

Skills: A crypt spawn receives a +4 racial bonus on Intimidate checks. Otherwise as the base creature.

Climate/Terrain: Same as the base creature and underground.

Organization: Same as the base creature.

Challenge Rating: Same as the base creature +1.

Treasure: Same as the base creature.

Alignment: Usually evil.  Few nonevil beings are willing to submit to the undeath after death spell or become an undead creature.

Level Adjustment: Same as base creature +2

*/

#include "prc_inc_template"
//#include "prc_inc_natweap"
//#include "prc_inc_combat"

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	int iHD = GetHitDice(oPC);
	int nBonus;
	itemproperty ipIP;

	//:: Set Turn Resistance
	SetCompositeBonus(oSkin, "Template_Cryptspawn_turn", 2, ITEM_PROPERTY_TURN_RESISTANCE);
	
	//:: Add Intimidate bonus
    SetCompositeBonus(oSkin, "CryptspawnIntimidate", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);

	//:: Add Darkvision
	ipIP = ItemPropertyDarkvision();
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);	
		
	//:: Add Undead Qualities
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNDEAD_HD);
   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_ABILITY_DECREASE);
   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_CRITICAL);
   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_DEATH);
   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_DISEASE);
   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_MIND_SPELLS);
   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_PARALYSIS);
   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_POISON);
   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_SNEAKATTACK);
   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   	ipIP = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	
	//:: Set Natural AC Bonus.    
    if (iHD >= 17) {nBonus = 5;}
	
    else if (iHD >= 13) {nBonus = 4;}
	
    else if (iHD >= 9) {nBonus = 3;}
	
    else if (iHD >= 5) {nBonus = 2;}
	
    else if (iHD >= 1) {nBonus = 1;}
	
	SetCompositeBonus(oSkin, "Template_Cryptspawn_ac", nBonus, ITEM_PROPERTY_AC_BONUS);
	
	SetSubRace(oPC, "Undead (Augmented Humanoid)");
  
}