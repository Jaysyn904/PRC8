//::///////////////////////////////////////////////
//:: Name           Fiendish template script
//:: FileName       tmp_m_fiend
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Fiendish Creature

    Fiendish creatures dwell on the lower planes, the realms of evil, although they resemble beings found on 
    the Material Plane. They are more fearsome in appearance than their earthly counterparts.

    Creating A Fiendish Creature

    "Fiendish" is an inherited template that can be added to any corporeal aberration, animal, dragon, fey, 
    giant, humanoid, magical beast, monstrous humanoid, ooze, plant, or vermin of nongood alignment 
    (referred to hereafter as the base creature).

    A fiendish creature uses all the base creature’s statistics and abilities except as noted here. Do not 
    recalculate the creature’s Hit Dice, base attack bonus, saves, or skill points if its type changes.
    Size and Type

    Animals or vermin with this template become magical beasts, but otherwise the creature type is unchanged. 
    Size is unchanged. Fiendish creatures encountered on the Material Plane have the extraplanar subtype.
    Special Attacks

    A fiendish creature retains all the special attacks of the base creature and also gains the following 
    special attack.

    Smite Good (Su)
    Once per day the creature can make a normal melee attack to deal extra damage equal to its HD total 
    (maximum of +20) against a good foe.

    Special Qualities
    A fiendish creature retains all the special qualities of the base creature and also gains the following.

    Hit Dice    Resistance to Cold and Fire     Damage Reduction
    1-3         5   
    4-7         5                               5/magic
    8-11        10                              5/magic
    12 or more  10                              10/magic

        * Darkvision out to 60 feet.
        * Damage reduction (see table).
        * Resistance to cold and fire (see table).
        * Spell resistance equal to the creature’s HD + 5 (maximum 25).

    If the base creature already has one or more of these special qualities, use the better value.

    If a fiendish creature gains damage reduction, its natural weapons are treated as magic weapons for 
    the purpose of overcoming damage reduction.

    Abilities
    Same as the base creature, but Intelligence is at least 3.

    Environment
    Any evil-aligned plane.

    Challenge Rating
    HD 3 or less, as base creature; HD 4 to 7, as base creature +1; HD 8 or more, as base creature +2.

    Alignment
    Always evil (any).

    Level Adjustment
    Same as the base creature +2. 

*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 18/04/06
//:://////////////////////////////////////////////

#include "prc_inc_template"
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

    //darkvision
    ipIP = ItemPropertyDarkvision();
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    //SR
    int nSR = nHD+5;
    if(nSR > 25)
        nSR = 25;
    ipIP = ItemPropertyBonusSpellResistance(GetSRByValue(nSR));
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    //DR
    if(nHD >= 4 && nHD <= 11)
    {
        ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_5_HP);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
    else if(nHD >= 12)
    {
        ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_10_HP);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
    //elemental resist
    if(nHD <= 7)
    {
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_5);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_5);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
    else if(nHD >= 8)
    {
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_10);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
    if(bFuncs)
    {
        //smite good
        if(!PRC_Funcs_GetFeatKnown(oPC, FEAT_TEMPLATE_FIENDISH_SMITE_GOOD))
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_FIENDISH_SMITE_GOOD);
        //marker feat
        if(!PRC_Funcs_GetFeatKnown(oPC, FEAT_TEMPLATE_FIENDISH_MARKER))
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_FIENDISH_MARKER);
    }
    else
    {
        //smite good
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_FIENDISH_SMITE_GOOD);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        //marker feat
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_FIENDISH_MARKER);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
}