//::///////////////////////////////////////////////
//:: Name           Curst template script
//:: FileName       tmp_m_curst
//:: 
//:://////////////////////////////////////////////
/*Creating An Curst
"Curst" is a template that can be added to any humanoid creature (referred to hereafter as the "base creature"). It uses all the base creature's statistics and special abilities except as noted here.

Armor Class: The curst's natural armor bonus improves by 3 over that of the base creature.

Attack: A curst retains all the attacks of the base creature and also gains a slam attack if it didn't already have one. If the base creature can use weapons, the curst retains this ability. A curst fighting without weapons uses either its slam attack or its primary natural weapon (if it has any) when making an attack action. When it has a weapon, it usually uses that instead.

Full Attack: A curst fighting without weapons uses either its slam attack (see above) or its natural weapons (if it has any). If armed with a weapon, it usually uses the weapon as its primary attack along with a slam or other natural weapon as a natural secondary attack.

Damage: A curst has a slam attack. If the base creature does not have this attack form, use the appropriate damage value from the table below according to the curst's size. A creature that has other kinds of natural weapons retains its old damage values or uses the appropriate value from the table below, whichever is better.

Size	Base Damage
Small	1d3
Medium	1d4
Large	1d6
Special Qualities: A curst retains all the special qualities of the base creature and gains those described below.

Fast Healing (Ex): A curst heals 1 point of damage each round so long as it has at least 1 hit point. If reduced to 0 or fewer hit points, it falls to the ground paralyzed, and its fast healing stops. After 1 hour, the curst makes a DC 20 level check. If the check succeeds, the curst regains 1 hit point, its fast healing resumes, and it is no longer paralyzed. If the check fails, the curst must make another check at the same DC 24 hours later, and every 24 hours thereafter until it succeeds and begins to recover hit points again. Thus, even a dismembered curst eventually recovers from its injuries.

Immunity to Cold and Fire (Ex): A curst takes no damage from cold or fire attacks.

Madness (Ex): A curst whose Wisdom score is 1 or 2 is afflicted with bouts of madness. In combat, it has a 5% chance each round to behave erratically. On any round when this occurs, the curst takes no action.

Spell Resistance (Ex): A curst has spell resistance equal to 12 + its character level.

Turning Immunity (Ex): Cursts cannot be turned, rebuked, destroyed, or commanded.

Unkillable (Ex): Only two ways exist to destroy a curst permanently. One is to destroy its body (by total immersion in acid, or a disintegrate or undeath to death spell, for example). The other is to remove the curse that keeps it from dying. The caster of the remove curse spell must succeed on a caster level check (DC 10 + the curst's HD) to successfully remove the curse.

Abilities: Change from the base creature as follows: Str +2, Int -4 (minimum 3), Wis -6 (minimum 1), Cha -2 (minimum 1). As an undead creature, a curst has no Constitution score. A curst whose Wisdom score is reduced to 1 or 2 gains the madness special quality (see above).

Skills: Same as the base creature. Do not reduce existing skill ranks because of the drop in Intelligence, but apply the new Intelligence modifier normally to any Intelligence-based skill checks and to the number of skill points gained when the curst, gains new levels.

Organization: Solitary.

Challenge Rating: Same as the base creature +1.

Alignment: Often chaotic (any).

Advancement: By character class.

Level Adjustment: +3.

In The Realms
During the Time of Troubles, many folk slain within wild magic zones became cursts, and many members of Waterdeep's guard and watch spontaneously transformed into cursts while battling the minions of Myrkul. A powerful curst is known to frequent the Tower of Skulls, a temple to Kelemvor located in Ormath, on the Shining Plains. Once a high-level fighter in Turmish, this curst - whose name is unknown - now hopes to find liberation from his undead state through the mercy of the Lord of the Dead.

Sample Curst: Curst.
*/

#include "prc_inc_template"
#include "prc_inc_natweap"

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	int nHD = GetHitDice(oPC);
	itemproperty ipIP;

	//natural armor
	int nAC = 3;
	SetCompositeBonus(oSkin, "Template_curst_ac", nAC, ITEM_PROPERTY_AC_BONUS);

	//Spell resistance 
	int nSR = nHD+12;
	ipIP = ItemPropertyBonusSpellResistance(GetSRByValue(nSR));
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

	//fast healing
	SetCompositeBonus(oSkin, "Curst_FastHealing", 1, ITEM_PROPERTY_REGENERATION);

	//Ability modifies

	SetCompositeBonus(oSkin, "Template_curst_str",  2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);
	SetCompositeBonus(oSkin, "Template_curst_int", -4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
	SetCompositeBonus(oSkin, "Template_curst_wis", -6, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
	SetCompositeBonus(oSkin, "Template_curst_cha", -2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);
	
	//feats
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_CREATURE);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	
	//Slam attack 
    string sResRef;
    int nSize = PRCGetCreatureSize(oPC);
    //primary weapon
    sResRef = "prc_warf_slam";
    sResRef += GetAffixForSize(nSize);
    AddNaturalPrimaryWeapon(oPC, sResRef, 1);

	//cold and fire immunity
	ipIP = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	ipIP = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

	//turn immunity
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TURNING_IMMUNITY);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_TO_REBUKING);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	
	//make curst undead
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
	
	SetSubRace(oPC, "Undead (Augmented Humanoid)");
}