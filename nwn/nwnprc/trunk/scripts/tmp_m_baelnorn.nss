//:://///////////////////////////////////////////////
//:: Name           Baelnorn template maintain script
//:: FileName       tmp_m_baelnorn
//::
//:: Created By: 	Jaysyn
//:: Created On: 	2025-07-31 11:46:41
//:://///////////////////////////////////////////////
/*
    Creating A Baelnorn
    
    "Baelnorn" is an acquired template that can be added to any elf (referred to hereafter as the base creature)
    
    An Baelnorn has all the base creature’s statistics and special abilities except as noted here.
    
    Size and Type
    
    The creature’s type changes to undead. Do not recalculate base attack bonus, saves, or skill points. Size is unchanged.
    
    Hit Dice
    
    Increase all current and future Hit Dice to d12s.
    
    Armor Class
    
    An Baelnorn has a +5 natural armor bonus or the base creature’s natural armor bonus, whichever is better.
    
    Attack
    
    An Baelnorn has a touch attack that it can use once per round. If the base creature can use weapons, the 
    Baelnorn retains this ability. A creature with natural weapons retains those natural weapons. An Baelnorn fighting without weapons uses either its touch attack or its primary natural weapon (if it has any). An Baelnorn armed with a weapon uses its touch or a weapon, as it desires.
    
    Full Attack
    
    An Baelnorn fighting without weapons uses either its touch attack (see above) or its natural weapons (if it has any). 
    If armed with a weapon, it usually uses the weapon as its primary attack along with a touch as a natural secondary attack, provided it has a way to make that attack (either a free hand or a natural weapon that it can use as a secondary attack).
    
    Damage
    
    An Baelnorn without natural weapons has a touch attack that uses negative energy to deal 1d8+5 points of damage to living creatures; a Will save (DC 10 + ½ Baelnorn’s HD + Baelnorn’s Cha modifier) halves the damage. An Baelnorn with natural weapons can use its touch attack or its natural weaponry, as it prefers. If it chooses the latter, it deals 1d8+5 points of extra damage on one natural weapon attack.
    
    Special Attacks
    
    An Baelnorn retains all the base creature’s special attacks and gains those described below. Save DCs are equal to 10 + ½ Baelnorn’s HD + Baelnorn’s Cha modifier unless otherwise noted.
    
    Paralyzing Touch (Su): Any living creature an Baelnorn hits with its touch attack must succeed on a Fortitude save or be permanently paralyzed. Remove paralysis or any spell that can remove a curse can free the victim (see the bestow curse spell description).
    
    The effect cannot be dispelled. Anyone paralyzed by an Baelnorn seems dead, though a DC 20 Spot check or a DC 15 Heal check reveals that the victim is still alive..
	
	Projection (Su): Three times per day, for up to 1 hour at a time, a baelnorn can send a wraithlike likeness of itself up to one mile from the baelnorn’s actual location. The baelnorn can see through this projection and into the  Ethereal Plane as well, can hear and speak through it, and even cast spells through it. The link between the baelnorn and the projection transcends physical and all known magical barriers, and can even cross between the Material and the Ethereal planes.  The projection is AC 20, has a fly speed of 20 feet (perfect maneuverability), and has the hit points of the baelnorn, but it cannot carry solid objects and it has none of the baelnorn’s special attacks or qualities.  If the projection takes damage, the baelnorn takes half the damage (round down); the projection vanishes if it loses all its hit points. It cannot be turned or magically dispelled. A projection can push against or move small things, so it may push its finger through sand or ashes to write a message, or turn a page of an open book, but it cannot carry things. The baelnorn can have only one projection in operation at a time.
	
    Spells
    
    An Baelnorn can cast any spells it could cast while alive.
    
    Special Qualities
    
    An Baelnorn retains all the base creature’s special qualities and gains those described below.
    
    Turn Resistance (Ex)
    
    An Baelnorn has +4 turn resistance.
    
    Damage Reduction (Su)
    
    An Baelnorn’s undead body is tough, giving the creature damage reduction 15/bludgeoning and magic. Its natural weapons are treated as magic weapons for the purpose of overcoming damage reduction.
    
    Immunities (Ex)
    
    Baelnorns have immunity to cold, electricity, polymorph (though they can use polymorph effects on themselves), and mind-affecting attacks. Many baelnorns cannot be turnes or destroyed by good or neutral clerics. When evil clerics attemp to rebuke or command them, they are turned or destroyed instead.
    
    Abilities
    
    Increase from the base creature as follows: Int +2, Wis +2, Cha +2. Being undead, an Baelnorn has no Constitution score.
    
    Skills
    
    Baelnorns have a +8 racial bonus on Hide, Listen, Move Silently, Search, Sense Motive, and Spot checks. Otherwise same as the base creature. 

    
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
    SetCompositeBonus(oSkin, "Template_Baelnorn_ac", nAC, ITEM_PROPERTY_AC_BONUS);

    int nTurnResist = 4;
    SetCompositeBonus(oSkin, "Template_Baelnorn_turnresist", nTurnResist, ITEM_PROPERTY_TURN_RESISTANCE);

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
	
    SetCompositeBonus(oSkin, "Template_Baelnorn_int", nAbilityBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
    SetCompositeBonus(oSkin, "Template_Baelnorn_wis", nAbilityBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
    SetCompositeBonus(oSkin, "Template_Baelnorn_cha", nAbilityBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);

    int nSkillBonus = 8;

    SetCompositeBonus(oSkin, "Template_Baelnorn_Hide",     nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    SetCompositeBonus(oSkin, "Template_Baelnorn_Listen",   nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
    SetCompositeBonus(oSkin, "Template_Baelnorn_Persuade", nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
    SetCompositeBonus(oSkin, "Template_Baelnorn_Silent",   nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
    SetCompositeBonus(oSkin, "Template_Baelnorn_Search",   nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
    SetCompositeBonus(oSkin, "Template_Baelnorn_Spot",     nSkillBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);

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

	//marker feats
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_BAELNORN_MARKER);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

	//:: Projection
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_PROJECTION);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_END_PROJECTION);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    //:: Turn Undead
	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_TURN_UNDEAD);
	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);		
	
	SetSubRace(oPC, "Undead Elf (Augmented Humanoid)");
	
}