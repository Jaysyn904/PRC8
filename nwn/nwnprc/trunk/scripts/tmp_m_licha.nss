//:://///////////////////////////////////////////////
//:: Name           Archich template maintain script
//:: FileName       tmp_m_archlich
//::
//:: Created By: 	Ceuthonymous & Primogenitor
//:: Created On: 	22/06/04
//:://///////////////////////////////////////////////
/*
    Creating An Archlich
    
    "Archlich" is an acquired template that can be added to any humanoid creature (referred to hereafter as the base creature), provided it can create the required phylactery.
    
    An archlich has all the base creature’s statistics and special abilities except as noted here.
    
    Size and Type
    
    The creature’s type changes to undead. Do not recalculate base attack bonus, saves, or skill points. Size is unchanged.
    
    Hit Dice
    
    Increase all current and future Hit Dice to d12s.
    
    Armor Class
    
    An archlich has a +5 natural armor bonus or the base creature’s natural armor bonus, whichever is better.
    
    Attack
    
    An archlich has a touch attack that it can use once per round. If the base creature can use weapons, the 
    archlich retains this ability. A creature with natural weapons retains those natural weapons. An archlich fighting without weapons uses either its touch attack or its primary natural weapon (if it has any). An archlich armed with a weapon uses its touch or a weapon, as it desires.
    
    Full Attack
    
    An archlich fighting without weapons uses either its touch attack (see above) or its natural weapons (if it has any). 
    If armed with a weapon, it usually uses the weapon as its primary attack along with a touch as a natural secondary attack, provided it has a way to make that attack (either a free hand or a natural weapon that it can use as a secondary attack).
    
    Damage
    
    An archlich without natural weapons has a touch attack that uses negative energy to deal 1d8+5 points of damage to living creatures; a Will save (DC 10 + ½ archlich’s HD + archlich’s Cha modifier) halves the damage. An archlich with natural weapons can use its touch attack or its natural weaponry, as it prefers. If it chooses the latter, it deals 1d8+5 points of extra damage on one natural weapon attack.
    
    Special Attacks
    
    An archlich retains all the base creature’s special attacks and gains those described below. Save DCs are equal to 10 + ½ archlich’s HD + archlich’s Cha modifier unless otherwise noted.
    
    Fear Aura (Su)
    
    Archliches are shrouded in a dreadful aura of death. Creatures of less than 5 HD in a 60-foot radius that look at the archlich must succeed on a Will save or be affected as though by a fear spell from a sorcerer of the archlich’s level. A creature that successfully saves cannot be affected again by the same archlich’s aura for 24 hours.
    
    Paralyzing Touch (Su)
    
    Any living creature an archlich hits with its touch attack must succeed on a Fortitude save or be permanently paralyzed. Remove paralysis or any spell that can remove a curse can free the victim (see the bestow curse spell description).
    
    The effect cannot be dispelled. Anyone paralyzed by an archlich seems dead, though a DC 20 Spot check or a DC 15 Heal check reveals that the victim is still alive..
	
	Animate Dead (Sp)
	
	Good liches can animate skeletons or zombies to serve them, using this spell-like ability at will as a sorcerer of its character level. In general, good liches have no interest in raising undead armies to serve them, but they use this power in self defence in the heat of battle.
    
    Spells
    
    An archlich can cast any spells it could cast while alive.
    
    Special Qualities
    
    An archlich retains all the base creature’s special qualities and gains those described below.
    
    Turn Resistance (Ex)
    
    An archlich has +4 turn resistance.
    
    Damage Reduction (Su)
    
    An archlich’s undead body is tough, giving the creature damage reduction 15/bludgeoning and magic. Its natural weapons are treated as magic weapons for the purpose of overcoming damage reduction.
    
    Immunities (Ex)
    
    Archliches have immunity to cold, electricity, polymorph (though they can use polymorph effects on themselves), and mind-affecting attacks. Many good liches cannot be turnes or destroyed by good or neutral clerics. When evil clerics attemp to rebuke or command them, they are turned or destroyed instead.
    
    Abilities
    
    Increase from the base creature as follows: Int +2, Wis +2, Cha +2. Being undead, an archlich has no Constitution score.
    
    Skills
    
    Archliches have a +8 racial bonus on Hide, Listen, Move Silently, Search, Sense Motive, and Spot checks. Otherwise same as the base creature. 

    
    Alignment: Any nonevil.
    
   
    Level Adjustment: Same as the base creature +4.

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
    SetCompositeBonus(oSkin, "Template_archlich_ac", nAC, ITEM_PROPERTY_AC_BONUS);

    int nTurnResist = 4;
    SetCompositeBonus(oSkin, "Template_archlich_turnresist", nTurnResist, ITEM_PROPERTY_TURN_RESISTANCE);

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
	
    SetCompositeBonus(oSkin, "Template_archlich_int", nAbilityBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
    SetCompositeBonus(oSkin, "Template_archlich_wis", nAbilityBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
    SetCompositeBonus(oSkin, "Template_archlich_cha", nAbilityBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);

    int nSkillBonus = 8;

    SetCompositeBonus(oSkin, "Template_archlich_Hide",     nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    SetCompositeBonus(oSkin, "Template_archlich_Listen",   nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
    SetCompositeBonus(oSkin, "Template_archlich_Persuade", nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
    SetCompositeBonus(oSkin, "Template_archlich_Silent",   nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
    SetCompositeBonus(oSkin, "Template_archlich_Search",   nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
    SetCompositeBonus(oSkin, "Template_archlich_Spot",     nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);

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
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_ARCHLICH_MARKER);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    //animate dead
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_ANIMATE_DEAD);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	//:: Projection
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_PROJECTION);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_END_PROJECTION);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    //:: Turning Immunity
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TURNING_IMMUNITY);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);	
    //:: Turn Undead
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_TURN_UNDEAD);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);		
	
	SetSubRace(oPC, "Undead (Augmented Humanoid)");
	
}