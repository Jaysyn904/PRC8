//::///////////////////////////////////////////////
//:: Name           Celestial template script
//:: FileName       tmp_m_celest
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Celestial Creature

    Celestial creatures dwell on the upper planes, the realms of good, although they resemble beings found on the 
    Material Plane. They are more regal and more beautiful than their earthly counterparts.

    Celestial creatures often come in metallic colors (usually silver, gold, or platinum). They can be mistaken 
    for half-celestials, more powerful creatures that are created when a celestial mates with a non-celestial 
    creature.

    "Celestial" is an inherited template that can be added to any corporeal aberration, animal, dragon, fey, giant, 
    humanoid, magical beast, monstrous humanoid, plant, or vermin of good or neutral alignment (referred to 
    hereafter as the base creature).

    A celestial creature uses all the base creature�s statistics and abilities except as noted here. Do not 
    recalculate the creature�s Hit Dice, base attack bonus, saves, or skill points if its type changes.
    Size and Type

    Animals or vermin with this template become magical beasts, but otherwise the creature type is unchanged. 
    Size is unchanged. Celestial creatures encountered on the Material Plane have the extraplanar subtype.

    Special Attacks
    A celestial creature retains all the special attacks of the base creature and also gains the following attack.

    Smite Evil (Su)
    Once per day a celestial creature can make a normal melee attack to deal extra damage equal to its HD (maximum 
    of +20) against an evil foe.

    Special Qualities
    A celestial creature retains all the special qualities of the base creature and also gains the following qualities.

        * Darkvision out to 60 feet.
        * Damage reduction (see the table below).
        * Resistance to acid, cold, and electricity (see the table below).
        * Spell resistance equal to HD + 5 (maximum 25).

    Hit Dice    Resistance to Acid, Cold, Electricity   Damage Reduction
    1-3         5                                       
    4-7         5                                       5/magic
    8-11        10                                      5/magic
    12 or more  10                                      10/magic

    If the base creature already has one or more of these special qualities, use the better value.

    If a celestial creature gains damage reduction, its natural weapons are treated as magic weapons for the 
    purpose of overcoming damage reduction.

    Abilities
    Same as the base creature, but Intelligence is at least 3.

    Environment
    Any good-aligned plane.

    Challenge Rating
    HD 3 or less, as base creature; HD 4 to 7, as base creature +1; HD 8 or more, as base creature +2.

    Alignment
    Always good (any).

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
    int bFuncs = GetPRCSwitch(PRC_NWNX_FUNCS);

    //darkvision
    ipIP = ItemPropertyDarkvision();
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    //SR
    int nSR = nHD+5;
    if(nSR > 25)
        nSR = 25;
    ipIP = ItemPropertyBonusSpellResistance(GetSRByValue(nSR));
    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    //DR
    if(nHD >= 4 && nHD <= 11)
    {
        ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_5_HP);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
    else if(nHD >= 12)
    {
        ipIP = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_10_HP);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
    //elemental resist
    if(nHD <= 7)
    {
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_5);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_5);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_5);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
    else if(nHD >= 8)
    {
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_10);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        ipIP = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_10);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
    if(bFuncs)
    {
        //smite evil
        if(!PRC_Funcs_GetFeatKnown(oPC, FEAT_TEMPLATE_CELESTIAL_SMITE_EVIL))
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_CELESTIAL_SMITE_EVIL);
        //marker feat
        if(!PRC_Funcs_GetFeatKnown(oPC, FEAT_TEMPLATE_CELESTIAL_MARKER))
            PRC_Funcs_AddFeat(oPC, FEAT_TEMPLATE_CELESTIAL_MARKER);
    }
    else
    {
        //smite evil
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_CELESTIAL_SMITE_EVIL);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        //marker feat
        ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_CELESTIAL_MARKER);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
}