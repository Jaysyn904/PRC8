#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_alterations"

void AddIPEnh(object oWeap, int iCost, int iLvl)
{
    itemproperty ip;
    if(GetItemHasItemProperty(oWeap, ITEM_PROPERTY_ENHANCEMENT_BONUS))
    {
        int iValue;
        ip = GetFirstItemProperty(oWeap);
        int iBreak = FALSE;
        int iNew;

        while (GetIsItemPropertyValid(ip) && !iBreak)
        {
            if(GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
            {
                iValue = GetItemPropertyCostTableValue(ip);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(iValue + iCost), oWeap, HoursToSeconds(iLvl));
                iBreak = TRUE;
            }
            ip = GetNextItemProperty(oWeap);
        }
    }
    else
    {
        ip = ItemPropertyEnhancementBonus(iCost);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ip, oWeap, HoursToSeconds(iLvl));
    }
}

int Activpower(object oWeap,int iType,int iRace,int iLvl,int iVicious)
{
    if(!iType)
        return iVicious;

    switch(iType)
    {
        case TEMPUS_ABILITY_ENHANC1:
            AddIPEnh(oWeap,1, iLvl);
            break;
        case TEMPUS_ABILITY_ENHANC2:
            AddIPEnh(oWeap,2, iLvl);
            break;
        case TEMPUS_ABILITY_ENHANC3:
            AddIPEnh(oWeap,3, iLvl);
            break;
        case TEMPUS_ABILITY_FIRE1D6:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_1d6),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_COLD1D6:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d6),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_ELEC1D6:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEBONUS_1d6),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_KEEN:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyKeen(),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_ANARCHIC:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL,IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_2d6),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_AXIOMATIC:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC,IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_2d6),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_HOLY:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_2d6),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_UNHOLY:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD,IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_2d6),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_DISRUPTION:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitProps(IP_CONST_ONHIT_SLAYRACE,IP_CONST_ONHIT_SAVEDC_14,IP_CONST_RACIALTYPE_UNDEAD),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_WOUNDING:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitProps(IP_CONST_ONHIT_WOUNDING,IP_CONST_ONHIT_SAVEDC_26,IP_CONST_RACIALTYPE_UNDEAD),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_VAMPIRE:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVampiricRegeneration(10),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_VICIOUS:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonusVsRace(iRace,IP_CONST_DAMAGETYPE_SLASHING,IP_CONST_DAMAGEBONUS_2d6),oWeap,HoursToSeconds(iLvl));
            if(!iVicious)
                AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,2),oWeap,HoursToSeconds(iLvl));
            iVicious++;
            break;
        case TEMPUS_ABILITY_BARSKIN:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_BARKSKIN_3,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_CONECOLD:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_CONE_OF_COLD_9,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_DARKNESS:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_DARKNESS_3,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_FIREBALL:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_FIREBALL_5,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_HASTE:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_HASTE_5,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_IMPROVINV:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_LIGHTBOLT:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHTNING_BOLT_5,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_MAGICMISSILE:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGIC_MISSILE_5,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,HoursToSeconds(iLvl));
            break;
        case TEMPUS_ABILITY_WEB:
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyCastSpell(IP_CONST_CASTSPELL_WEB_3,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),oWeap,HoursToSeconds(iLvl));
            break;
    }

    return iVicious;
}

void main()
{
    object oPC = OBJECT_SELF;
    int iLvl = GetLevelByClass(CLASS_TYPE_TEMPUS, oPC);
    if(iLvl < 2)
        return;

    object oSkin = GetPCSkin(oPC);
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int iSave = GetLocalInt(oPC, "WeapEchant1");
    int iType = GetBaseItemType(oWeap);

    int iFeat = iLvl > 9 ? FEAT_ENCHANT_WEAPON3:
                iLvl > 5 ? FEAT_ENCHANT_WEAPON2:
                FEAT_ENCHANT_WEAPON1;

    if(!iSave || iType != GetLocalInt(oSkin, "FEAT_WEAP_TEMPUS"))
    {
        int iPower = iLvl > 9 ? 3:
                     iLvl > 5 ? 2:
                     1;

        DeleteLocalInt(oPC, "WeapEchant1");
        DeleteLocalInt(oPC, "WeapEchant2");
        DeleteLocalInt(oPC, "WeapEchant3");
        DeleteLocalInt(oPC, "WeapEchantRace1");
        DeleteLocalInt(oPC, "WeapEchantRace2");
        DeleteLocalInt(oPC, "WeapEchantRace3");
        SetLocalInt(oPC, "TempusPower", iPower);
        ActionStartConversation(oPC, "cv_tempus");
        IncrementRemainingFeatUses(oPC, iFeat);
        return;
    }

    if(!IPGetWeaponEnhancementBonus(oWeap) || GetHasSpellEffect(TEMPUS_ENCHANT_WEAPON, oWeap))
    {
        IncrementRemainingFeatUses(oPC, iFeat);
        return;
    }

    int iVicious;
    iVicious = Activpower(oWeap, GetLocalInt(oPC, "WeapEchant1"), GetLocalInt(oPC, "WeapEchantRace1"), iLvl, iVicious);
    iVicious = Activpower(oWeap, GetLocalInt(oPC, "WeapEchant2"), GetLocalInt(oPC, "WeapEchantRace2"), iLvl, iVicious);
    iVicious = Activpower(oWeap, GetLocalInt(oPC, "WeapEchant3"), GetLocalInt(oPC, "WeapEchantRace3"), iLvl, iVicious);
}