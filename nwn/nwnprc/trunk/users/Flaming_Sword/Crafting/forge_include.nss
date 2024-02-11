/*
    forge_include

    Include file for forge scripts, currently restricted to equipable items

    By: Flaming_Sword
    Created: January 1, 2006
    Modified: January 12, 2006

    GetItemPropertySubType() returns 0 or 65535, not -1
        on no subtype as in Lexicon

    Item Cost = [BaseCost + 1000 * (Multiplier ^ 2 - NegMultiplier ^ 2) + SpellCosts] * Stack * BaseMult + AdditionalCost

    Multiplier = sum(ItemPropertyCost) (+ve)

    NegMultiplier = sum(ItemPropertyCost) (-ve)

    ItemPropertyCost = (PropertyCost + SubTypeCost) * CostValue

    NOT IMPLEMENTED
*/

#include "prc_alterations"

const int NUM_MAX_PROPERTIES            = 152;
const int NUM_MAX_SUBTYPES              = 256;
//const int NUM_MAX_FEAT_SUBTYPES         = 16384;    //because iprp_feats is frickin' huge
const int NUM_MAX_FEAT_SUBTYPES         = 397;      //because the above screwed the game

const int NUM_MAX_SPELL_SUBTYPES        = 540;      //restricted to bioware spells
                                                    //  to avoid crashes

//Returns TRUE if nBaseItem can have nItemProp
int ValidProperty(int nBaseItem, int nItemProp)
{
    int nPropColumn = StringToInt(Get2DACache("baseitems", "PropColumn", nBaseItem));
    string sReturn = "";
    string sPropCloumn = "";
    switch(nPropColumn)
    {
        case 0: sPropCloumn = "0_Melee"; break;
        case 1: sPropCloumn = "1_Ranged"; break;
        case 2: sPropCloumn = "2_Thrown"; break;
        case 3: sPropCloumn = "3_Staves"; break;
        case 4: sPropCloumn = "4_Rods"; break;
        case 5: sPropCloumn = "5_Ammo"; break;
        case 6: sPropCloumn = "6_Arm_Shld"; break;
        case 7: sPropCloumn = "7_Helm"; break;
        case 8: sPropCloumn = "8_Potions"; break;
        case 9: sPropCloumn = "9_Scrolls"; break;
        case 10: sPropCloumn = "10_Wands"; break;
        case 11: sPropCloumn = "11_Thieves"; break;
        case 12: sPropCloumn = "12_TrapKits"; break;
        case 13: sPropCloumn = "13_Hide"; break;
        case 14: sPropCloumn = "14_Claw"; break;
        case 15: sPropCloumn = "15_Misc_Uneq"; break;
        case 16: sPropCloumn = "16_Misc"; break;
        case 17: sPropCloumn = "17_No_Props"; break;
        case 18: sPropCloumn = "18_Containers"; break;
        case 19: sPropCloumn = "19_HealerKit"; break;
        case 20: sPropCloumn = "20_Torch"; break;
        case 21: sPropCloumn = "21_Glove"; break;
    }
    return(Get2DACache("itemprops", sPropCloumn, nItemProp) == "1");
}

//Adds action highlight to a conversation string
string ActionString(string sString)
{
    return "<cþ>" + sString + "</c>";
}

//Inserts a space at the end of a string if the string
//  is not empty
string InsertSpaceAfterString(string sString)
{
    if(sString != "")
        return sString + " ";
    else return "";
}

//Returns a string describing the item
string ItemStats(object oItem)
{
    string sDesc = GetName(oItem) +
                    "\n\n" +
                    GetStringByStrRef(StringToInt(Get2DACache("baseitems", "Name", GetBaseItemType(oItem)))) +
                    "\n\n" +
                    "Price: " +
                    IntToString(GetGoldPieceValue(oItem)) +
                    "\n\n";

    itemproperty ip = GetFirstItemProperty(oItem);
    int nType;
    int nSubType;
    int nCostTable;
    int nCostTableValue;
    int nParam1;
    int nParam1Value;
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
        {
            int nType = GetItemPropertyType(ip);
            int nSubType = GetItemPropertySubType(ip);
            int nCostTable = GetItemPropertyCostTable(ip);
            int nCostTableValue = GetItemPropertyCostTableValue(ip);
            int nParam1 = GetItemPropertyParam1(ip);
            int nParam1Value = GetItemPropertyParam1Value(ip);
            sDesc += InsertSpaceAfterString(
                        GetStringByStrRef(StringToInt(Get2DACache("itempropdef", "GameStrRef", nType)))
                        );
            string sSubType = Get2DACache("itempropdef", "SubTypeResRef", nType);
            string sSubType2 = Get2DACache(sSubType, "Name", nSubType);
            if(sSubType2 != "")
                sDesc += InsertSpaceAfterString(GetStringByStrRef(StringToInt(sSubType2)));
            string sCostTable = Get2DACache("itempropdef", "CostTableResRef", nType);
            string sCostTable2 = Get2DACache("iprp_costtable", "Name", StringToInt(sCostTable));
            string sCostTable3 = Get2DACache(sCostTable2, "Name", nCostTableValue);
            if(sCostTable3 != "")
                sDesc += InsertSpaceAfterString(GetStringByStrRef(StringToInt(sCostTable3)));
            string sParam1 = Get2DACache("itempropdef", "Param1ResRef", nType);
            string sParam12 = Get2DACache("iprp_paramtable", "Name", StringToInt(sParam1));
            string sParam13 = Get2DACache(sParam12, "Name", nParam1Value);
            if(sParam13 != "")
                sDesc += InsertSpaceAfterString(GetStringByStrRef(StringToInt(sParam13)));
            sDesc += "\n";
        }
        ip = GetNextItemProperty(oItem);
    }
    return sDesc;
}

//Extra function for speed, minimises 2da reads
int MaxListSize(string sTable)
{
    sTable = GetStringLowerCase(sTable); //sanity check

    if(sTable == "classes")
        return 256;
    if(sTable == "disease")
        return 53;
    if(sTable == "iprp_abilities")
        return 6;
    if(sTable == "iprp_aligngrp")
        return 6;
    if(sTable == "iprp_alignment")
        return 9;
    if(sTable == "iprp_ammocost")
        return 16;
    if(sTable == "iprp_ammotype")
        return 3;
    if(sTable == "iprp_amount")
        return 5;
    if(sTable == "iprp_aoe")
        return 6;
    if(sTable == "iprp_arcspell")
        return 20;
    if(sTable == "iprp_bladecost")
        return 6;
    if(sTable == "iprp_bonuscost")
        return 13;
    if(sTable == "iprp_casterlvl")
        return 61;
    if(sTable == "iprp_chargecost")
        return 14;
    if(sTable == "iprp_color")
        return 7;
    if(sTable == "iprp_combatdam")
        return 3;
    if(sTable == "iprp_damagecost")
        return 81;
    if(sTable == "iprp_damagetype")
        return 14;
    if(sTable == "iprp_damvulcost")
        return 8;
    if(sTable == "iprp_decvalue1")
        return 10;
    if(sTable == "iprp_decvalue2")
        return 10;
    if(sTable == "iprp_feats")
        return NUM_MAX_FEAT_SUBTYPES;
    if(sTable == "iprp_immuncost")
        return 8;
    if(sTable == "iprp_immunity")
        return 10;
    if(sTable == "iprp_incvalue1")
        return 10;
    if(sTable == "iprp_incvalue2")
        return 10;
    if(sTable == "iprp_kitcost")
        return 51;
    if(sTable == "iprp_lightcost")
        return 5;
    if(sTable == "iprp_meleecost")
        return 21;
    if(sTable == "iprp_monstcost")
        return 58;
    if(sTable == "iprp_monsterhit")
        return 10;
    if(sTable == "iprp_metamagic")
        return 7;
    if(sTable == "iprp_monstcost")
        return 59;
    if(sTable == "iprp_neg10cost")
        return 11;
    if(sTable == "iprp_neg5cost")
        return 11;
    if(sTable == "iprp_onhit")
        return 26;
    if(sTable == "iprp_onhitcost")
        return 71;
    if(sTable == "iprp_onhitdur")
        return 28;
    if(sTable == "iprp_onhitspell")
        return 210;
    if(sTable == "iprp_poison")
        return 6;
    if(sTable == "iprp_protection")
        return 20;
    if(sTable == "iprp_redcost")
        return 6;
    if(sTable == "iprp_resistcost")
        return 25;
    if(sTable == "iprp_saveelement")
        return 22;
    if(sTable == "iprp_savingthrow")
        return 4;
    if(sTable == "iprp_skillcost")
        return 51;
    if(sTable == "iprp_soakcost")
        return 51;
    if(sTable == "iprp_speed_dec")
        return 10;
    if(sTable == "iprp_speed_enh")
        return 10;
    if(sTable == "iprp_spellcost")
        return 244;
    if(sTable == "iprp_spells")
        return NUM_MAX_SPELL_SUBTYPES;
    if(sTable == "iprp_spellcstr")
        return 40;
    if(sTable == "iprp_spelllvcost")
        return 10;
    if(sTable == "iprp_spelllvlimm")
        return 10;
    if(sTable == "iprp_spellshl")
        return 8;
    if(sTable == "iprp_srcost")
        return 62;
    if(sTable == "iprp_trapcost")
        return 12;
    if(sTable == "iprp_traps")
        return 5;
    if(sTable == "iprp_visualfx")
        return 7;
    if(sTable == "iprp_walk")
        return 2;
    if(sTable == "iprp_weightcost")
        return 6;
    if(sTable == "iprp_weightinc")
        return 6;
    if(sTable == "poison")
        return 147;
    if(sTable == "racialtypes")
        return 256;
    if(sTable == "skills")
        return 29;

    if(DEBUG) DoDebug("MaxListSize: Unrecognised 2da file: " + sTable);
    return NUM_MAX_SUBTYPES;
}

//Makes an item property from values - total pain in the arse, need 1 per itemprop
itemproperty ConstructIP(int nType, int nSubTypeValue = 0, int nCostTableValue = 0, int nParam1Value = 0)
{
    itemproperty ip;
    switch(nType)
    {
        case ITEM_PROPERTY_ABILITY_BONUS:
        {
            ip = ItemPropertyAbilityBonus(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_AC_BONUS:
        {
            ip = ItemPropertyACBonus(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:
        {
            ip = ItemPropertyACBonusVsAlign(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:
        {
            ip = ItemPropertyACBonusVsDmgType(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
        {
            ip = ItemPropertyACBonusVsRace(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:
        {
            ip = ItemPropertyACBonusVsSAlign(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ENHANCEMENT_BONUS:
        {
            ip = ItemPropertyEnhancementBonus(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
        {
            ip = ItemPropertyEnhancementBonusVsAlign(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
        {
            ip = ItemPropertyEnhancementBonusVsRace(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
        {
            ip = ItemPropertyEnhancementBonusVsSAlign(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
        {
            ip = ItemPropertyEnhancementPenalty(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:
        {
            ip = ItemPropertyWeightReduction(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_BONUS_FEAT:
        {
            ip = PRCItemPropertyBonusFeat(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
        {
            ip = ItemPropertyBonusLevelSpell(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_CAST_SPELL:
        {
            ip = ItemPropertyCastSpell(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DAMAGE_BONUS:
        {
            ip = ItemPropertyDamageBonus(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
        {
            ip = ItemPropertyDamageBonusVsAlign(nSubTypeValue, nCostTableValue, nParam1Value);
            break;
        }
        case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
        {
            ip = ItemPropertyDamageBonusVsRace(nSubTypeValue, nCostTableValue, nParam1Value);
            break;
        }
        case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
        {
            ip = ItemPropertyDamageBonusVsSAlign(nSubTypeValue, nCostTableValue, nParam1Value);
            break;
        }
        case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
        {
            ip = ItemPropertyDamageImmunity(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DECREASED_DAMAGE:
        {
            ip = ItemPropertyDamagePenalty(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DAMAGE_REDUCTION:
        {
            ip = ItemPropertyDamageReduction(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DAMAGE_RESISTANCE:
        {
            ip = ItemPropertyDamageResistance(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DAMAGE_VULNERABILITY:
        {
            ip = ItemPropertyDamageVulnerability(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DARKVISION:
        {
            ip = ItemPropertyDarkvision();
            break;
        }
        case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
        {
            ip = ItemPropertyDecreaseAbility(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DECREASED_AC:
        {
            ip = ItemPropertyDecreaseAC(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:
        {
            ip = ItemPropertyDecreaseSkill(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:
        {
            ip = ItemPropertyWeightReduction(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:
        {
            ip = ItemPropertyExtraMeleeDamageType(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:
        {
            ip = ItemPropertyExtraRangeDamageType(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_HASTE:
        {
            ip = ItemPropertyHaste();
            break;
        }
        case ITEM_PROPERTY_HOLY_AVENGER:
        {
            ip = ItemPropertyHolyAvenger();
            break;
        }
        case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:
        {
            ip = ItemPropertyImmunityMisc(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_IMPROVED_EVASION:
        {
            ip = ItemPropertyImprovedEvasion();
            break;
        }
        case ITEM_PROPERTY_SPELL_RESISTANCE:
        {
            ip = ItemPropertyBonusSpellResistance(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_SAVING_THROW_BONUS:
        {
            ip = ItemPropertyBonusSavingThrowVsX(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
        {
            ip = ItemPropertyBonusSavingThrow(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_KEEN:
        {
            ip = ItemPropertyKeen();
            break;
        }
        case ITEM_PROPERTY_LIGHT:
        {
            ip = ItemPropertyLight(nCostTableValue, nParam1Value);
            break;
        }
        case ITEM_PROPERTY_MIGHTY:
        {
            ip = ItemPropertyMaxRangeStrengthMod(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_NO_DAMAGE:
        {
            ip = ItemPropertyNoDamage();
            break;
        }
        case ITEM_PROPERTY_ON_HIT_PROPERTIES:
        {
            //if(nParam1Value == -1) nParam1Value = 0;
            ip = ItemPropertyOnHitProps(nSubTypeValue, nCostTableValue, nParam1Value);
            break;
        }
        case ITEM_PROPERTY_DECREASED_SAVING_THROWS:
        {
            ip = ItemPropertyReducedSavingThrowVsX(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:
        {
            ip = ItemPropertyReducedSavingThrow(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_REGENERATION:
        {
            ip = ItemPropertyRegeneration(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_SKILL_BONUS:
        {
            ip = ItemPropertySkillBonus(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:
        {
            ip = ItemPropertySpellImmunitySpecific(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:
        {
            ip = ItemPropertySpellImmunitySchool(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_THIEVES_TOOLS:
        {
            ip = ItemPropertyThievesTools(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ATTACK_BONUS:
        {
            ip = ItemPropertyAttackBonus(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
        {
            ip = ItemPropertyAttackBonusVsAlign(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
        {
            ip = ItemPropertyAttackBonusVsRace(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
        {
            ip = ItemPropertyAttackBonusVsSAlign(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
        {
            ip = ItemPropertyAttackPenalty(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_UNLIMITED_AMMUNITION:
        {   //IP_CONST_UNLIMITEDAMMO_* is costtablevalue, not subtype
            ip = ItemPropertyUnlimitedAmmo(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:
        {
            ip = ItemPropertyLimitUseByAlign(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_CLASS:
        {
            ip = ItemPropertyLimitUseByClass(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:
        {
            ip = ItemPropertyLimitUseByRace(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:
        {
            ip = ItemPropertyLimitUseBySAlign(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
        {
            ip = ItemPropertyVampiricRegeneration(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_TRAP:
        {
            ip = ItemPropertyTrap(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_TRUE_SEEING:
        {
            ip = ItemPropertyTrueSeeing();
            break;
        }
        case ITEM_PROPERTY_ON_MONSTER_HIT:
        {
            ip = ItemPropertyOnMonsterHitProperties(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_TURN_RESISTANCE:
        {
            ip = ItemPropertyTurnResistance(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_MASSIVE_CRITICALS:
        {
            ip = ItemPropertyMassiveCritical(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:
        {
            ip = ItemPropertyFreeAction();
            break;
        }
        case ITEM_PROPERTY_MONSTER_DAMAGE:
        {
            ip = ItemPropertyMonsterDamage(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:
        {   //+1 because the function is bugged
            ip = ItemPropertyImmunityToSpellLevel(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_SPECIAL_WALK:
        {
            ip = ItemPropertySpecialWalk(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_HEALERS_KIT:
        {
            ip = ItemPropertyHealersKit(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_WEIGHT_INCREASE:
        {
            ip = ItemPropertyWeightIncrease(nParam1Value);
            break;
        }
        case ITEM_PROPERTY_ONHITCASTSPELL:
        {
            ip = ItemPropertyOnHitCastSpell(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_VISUALEFFECT:
        {
            ip = ItemPropertyVisualEffect(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_ARCANE_SPELL_FAILURE:
        {
            ip = ItemPropertyArcaneSpellFailure(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_ABILITY_SCORE:
        {
            ip = ItemPropertyLimitUseByAbility(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_SKILL_RANKS:
        {
            ip = ItemPropertyLimitUseBySkill(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_SPELL_LEVEL:
        {
            ip = ItemPropertyLimitUseBySpellcasting(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_ARCANE_SPELL_LEVEL:
        {
            ip = ItemPropertyLimitUseByArcaneSpellcasting(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_DIVINE_SPELL_LEVEL:
        {
            ip = ItemPropertyLimitUseByDivineSpellcasting(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_SNEAK_ATTACK:
        {
            ip = ItemPropertyLimitUseBySneakAttackDice(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_USE_LIMITATION_GENDER:
        {   //no Use Limitation: Gender function entry
            //ip = ItemPropertyAbilityBonus(nSubTypeValue);
            break;
        }
        case ITEM_PROPERTY_SPEED_INCREASE:
        {   //no Speed Increase function entry
            //ip = ItemPropertyAbilityBonus(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_SPEED_DECREASE:
        {   //no Speed Decrease function entry
            //ip = ItemPropertyAbilityBonus(nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_AREA_OF_EFFECT:
        {
            ip = ItemPropertyAreaOfEffect(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_CAST_SPELL_CASTER_LEVEL:
        {
            ip = ItemPropertyCastSpellCasterLevel(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_CAST_SPELL_METAMAGIC:
        {
            ip = ItemPropertyCastSpellMetamagic(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_CAST_SPELL_DC:
        {
            ip = ItemPropertyCastSpellDC(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_PNP_HOLY_AVENGER:
        {
            ip = ItemPropertyPnPHolyAvenger();
            break;
        }

        //ROOM FOR MORE - 89 so far, need increase/decrease cost
        /*
        case ITEM_PROPERTY_ABILITY_BONUS:
        {
            ip = ItemPropertyAbilityBonus(nSubTypeValue, nCostTableValue);
            break;
        }
        case ITEM_PROPERTY_ABILITY_BONUS:
        {
            ip = ItemPropertyAbilityBonus(nSubTypeValue, nCostTableValue);
            break;
        }
        */
    }
    return ip;
}
