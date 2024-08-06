//:://///////////////////////////////////////////////
//:: Name           Archich template maintain script
//:: FileName       tmp_m_archlich
//::
//:: Created By: 	Jaysyn
//:: Created On: 	24/08/06
//:://///////////////////////////////////////////////
/*
    Creating An Alhoon

An alhoon conforms to all the normal rules for adding the lich template to a humanoid, except asnoted below.

	Size and Type: The creature's type changes to undead (augmented aberration). Do not recalculate base attack bonus, saves, or skill points. Size is unchanged.
	
	Armor Class: An alhoon's natural armor bonus improves from +3 to +5.
*/

//:://////////////////////////////////////////////

#include "prc_inc_template"

void main()
{

    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    itemproperty ipIP;

    int nAC = 5;
    SetCompositeBonus(oSkin, "Template_alhoon_ac", nAC, ITEM_PROPERTY_AC_BONUS);

    int nTurnResist = 4;
    SetCompositeBonus(oSkin, "Template_alhoon_turnresist", nTurnResist, ITEM_PROPERTY_TURN_RESISTANCE);

	ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_15_HP);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    ipIP = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	
    ipIP = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    // Bugfix
    ipIP = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);    

    int nAbilityBonus = 2;
	
    SetCompositeBonus(oSkin, "Template_alhoon_int", nAbilityBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
    SetCompositeBonus(oSkin, "Template_alhoon_wis", nAbilityBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
    SetCompositeBonus(oSkin, "Template_alhoon_cha", nAbilityBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);

    int nSkillBonus = 8;

    SetCompositeBonus(oSkin, "Template_alhoon_Hide",     nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    SetCompositeBonus(oSkin, "Template_alhoon_Listen",   nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
    SetCompositeBonus(oSkin, "Template_alhoon_Persuade", nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
    SetCompositeBonus(oSkin, "Template_alhoon_Silent",   nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
    SetCompositeBonus(oSkin, "Template_alhoon_Search",   nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
    SetCompositeBonus(oSkin, "Template_alhoon_Spot",     nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);

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

    if(DEBUG) DoDebug("You have feat Undead HD = "+IntToString(GetHasFeat(FEAT_UNDEAD_HD, oPC)));
    
	//appearance
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_LICH_APPEARANCE);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	//touch/natural attack & paralyzing touch
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_LICH_PARALYZING_TOUCH);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	//fear aura
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_LICH_FEAR_AURA);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	//marker feats
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_LICH_MARKER);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	
	SetSubRace(oPC, "Undead (Augmented Aberration)");
	
}