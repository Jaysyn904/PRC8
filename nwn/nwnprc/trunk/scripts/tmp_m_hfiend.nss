//::///////////////////////////////////////////////
//:: Name           Half-Fiend template script
//:: FileName       tmp_m_hfiend
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Half-Fiend

    No matter its form, a half-fiend is always hideous to behold, having dark scales, horns, glowing red eyes, 
    bat wings, a fetid odor, or some other obvious sign that it is tainted with evil.

    Creating A Half-Fiend

    "Half-fiend" is an inherited template that can be added to any living, corporeal creature with an 
    Intelligence score of 4 or more and nongood alignment (referred to hereafter as the base creature).

    A half-fiend uses all the base creature's statistics and special abilities except as noted here.

    Size and Type
    The creature's type changes to outsider. Do not recalculate Hit Dice, base attack bonus, or saves. 
    Size is unchanged. Half-fiends are normally native outsiders.
    Speed

    A half-fiend has bat wings. Unless the base creature has a better fly speed, the creature can fly 
    at the base creature's base land speed (average maneuverability).

    Armor Class
    Natural armor improves by +1 (this stacks with any natural armor bonus the base creature has).

    Attack
    A half-fiend has two claw attacks and a bite attack, and the claws are the primary natural weapon. 
    If the base creature can use weapons, the half-fiend retains this ability. A half-fiend fighting without weapons uses a claw when making an attack action. When it has a weapon, it usually uses the weapon instead.

    Full Attack
    A half-fiend fighting without weapons uses both claws and its bite when making a full attack. If 
    armed with a weapon, it usually uses the weapon as its primary attack and its bite as a natural 
    secondary attack. If it has a hand free, it uses a claw as an additional natural secondary attack.

    Damage
    Half-fiends have bite and claw attacks. If the base creature does not have these attack forms, use 
    the damage values in the table. Otherwise, use the values in the table or the base creature's damage 
    values, whichever are greater.

    Size    Bite Damage  Claw Damage
    Fine        1       '
    Diminutive  1d2     1
    Tiny        1d3     1d2
    Small       1d4     1d3
    Medium      1d6     1d4
    Large       1d8     1d6
    Huge        2d6     1d8
    Gargantuan  3d6     2d6
    Colossal    4d6     3d6

    Special Attacks
    A half-fiend retains all the special attacks of the base creature and gains the following special attack.

    Smite Good (Su)
    Once per day the creature can make a normal melee attack to deal extra damage equal to its HD 
    (maximum of +20) against a good foe.

    Spell-Like Abilities
    A half-fiend with an Intelligence or Wisdom score of 8 or higher has spell-like abilities depending 
    on its Hit Dice, as indicated on the table. The abilities are cumulative. Unless otherwise noted, 
    an ability is usable once per day. Caster level equals the creature's HD, and the save DC is Charisma-based.

    HD      Abilities
    1-2     Darkness 3/day
    3-4     Desecrate
    5-6     Unholy blight
    7-8     Poison 3/day
    9-10    Contagion
    11-12   Blasphemy
    13-14   Unholy aura 3/day, unhallow
    15-16   Horrid wilting
    17-18   Summon monster IX (fiends only)
    19-20   Destruction

    Special Qualities
    A half-fiend has all the special qualities of the base creature, plus the following special qualities.

        * Darkvision out to 60 feet.
        * Immunity to poison.
        * Resistance to acid 10, cold 10, electricity 10, and fire 10.
        * Damage reduction: 5/magic (if HD 11 or less) or 10/magic (if HD 12 or more).
        * A half-fiend's natural weapons are treated as magic weapons for the purpose of overcoming damage reduction.
        * Spell resistance equal to creature's HD + 10 (maximum 35).

    Abilities
    Increase from the base creature as follows: Str +4, Dex +4, Con +2, Int +4, Cha +2.

    Skills
    A half-fiend gains skill points as an outsider and has skill points equal to (8 + Int modifier) ' (HD + 3). 
    Do not include Hit Dice from class levels in this calculation the half-fiend gains outsider skill points 
    only for its racial Hit Dice, and gains the normal amount of skill points for its class levels. Treat skills 
    from the base creature's list as class skills, and other skills as cross-class.

    Challenge Rating
    HD 4 or less, as base creature +1; HD 5 to 10, as base creature +2; HD 11 or more, as base creature +3.

    Alignment
    Always evil (any).

    Level Adjustment
    +4. 


*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 18/04/06
//:://////////////////////////////////////////////

#include "pnp_shft_poly"
#include "prc_inc_template"
#include "prc_inc_natweap"
#include "inc_nwnx_funcs"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    itemproperty ipIP;
	
	int nNWNxEE = GetPRCSwitch(PRC_NWNXEE_ENABLED);
	int nPRCx	= GetPRCSwitch(PRC_PRCX_ENABLED);
    int bFuncs = (nNWNxEE && nPRCx);
	
    int iTest = GetPersistantLocalInt(oPC, "NWNX_Template_hfiend");

    //wings
    DoWings(oPC, PRC_WING_TYPE_DRAGON_BLACK);

    if(bFuncs && !iTest)
    {
        SetPersistantLocalInt(oPC, "NWNX_Template_hfiend", 1);
        //ability mods
        PRC_Funcs_ModAbilityScore(oPC, ABILITY_STRENGTH, 4);
        PRC_Funcs_ModAbilityScore(oPC, ABILITY_DEXTERITY, 4);
        PRC_Funcs_ModAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
        PRC_Funcs_ModAbilityScore(oPC, ABILITY_INTELLIGENCE, 4);
        PRC_Funcs_ModAbilityScore(oPC, ABILITY_CHARISMA, 2);
        //feats
        //smite good
        PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_HALF_FIENDISH_SMITE_GOOD);
        //marker feat
        PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_HALF_FIENDISH_MARKER);
        //weapon proficiency creature
        PRC_Funcs_AddFeat(oPC, FEAT_WEAPON_PROFICIENCY_CREATURE);
    }
    else if(!bFuncs && !iTest)
    {
        //ability mods
        SetCompositeBonus(oSkin, "Template_hfiend_str", 4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);
        SetCompositeBonus(oSkin, "Template_hfiend_dex", 4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_DEX);
        SetCompositeBonus(oSkin, "Template_hfiend_con", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
        SetCompositeBonus(oSkin, "Template_hfiend_int", 4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
        SetCompositeBonus(oSkin, "Template_hfiend_cha", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);
        //feats
        //smite good
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_FIENDISH_SMITE_GOOD);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        //marker feat
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_FIENDISH_MARKER);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        //weapon proficiency creature
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_CREATURE);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }

    //naturalAC
    SetCompositeBonus(oSkin, "Template_hfiend_natAC", 1, ITEM_PROPERTY_AC_BONUS); 
    //darkvision
    ipIP = ItemPropertyDarkvision();
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    //immunity to poison
    ipIP = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    //resistance to acid 10 cold 10 elec 10 fire 10
    ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_10);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_10);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_10);
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    //damage reduction 5/+1 or 10/+1
    if(nHD <= 11)
    {
        ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_5_HP);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
    else if(nHD >= 12)
    {
        ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_10_HP);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
    //SR
    int nSR = nHD+10;
    if(nSR > 35)
        nSR = 35;
    ipIP = ItemPropertyBonusSpellResistance(GetSRByValue(nSR));
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    //natural weapons
    int nSize = PRCGetCreatureSize(oPC);
    //bite
    string sResRef = "prc_rdd_bite_";
    sResRef += GetAffixForSize(nSize);
    AddNaturalSecondaryWeapon(oPC, sResRef);
    //claws
    sResRef = "prc_claw_1d6l_";
    sResRef += GetAffixForSize(nSize);
    AddNaturalPrimaryWeapon(oPC, sResRef, 2);
    //SLAs
    if(GetAbilityScore(oPC,ABILITY_WISDOM, TRUE) >= 8 
        || GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) >= 8)
    {
        //darkness 3/day
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_FIENDISH_DARKNESS);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        if(nHD >= 3)
        {
            //desecrate 1/day
//TO BE ADDED
        }
        if(nHD >= 5)
        {
            //unholy blight 1/day
//TO BE ADDED
        }
        if(nHD >= 7)
        {
            //poison 3/day
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_FIENDISH_POISON);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(nHD >= 9)
        {
            //contagion 1/day
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_FIENDISH_CONTAGION);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(nHD >= 11)
        {
            //blashpemy 1/day
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_FIENDISH_BLASPHEMY);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(nHD >= 13)
        {
            //unholy aura 3/day
//TO BE ADDED
            //unhallow 1/day
//TO BE ADDED
        }
        if(nHD >= 15)
        {
            //horrid wilting 1/day
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_FIENDISH_HORRID_WILTING);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(nHD >= 17)
        {
            //summon monster IX 1/day
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_FIENDISH_SUMMON_IX);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(nHD >= 19)
        {
            //destuction 1/day
            ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_HALF_FIENDISH_DESTRUCTION);
            IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
}

