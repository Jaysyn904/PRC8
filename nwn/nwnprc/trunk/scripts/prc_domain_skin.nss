// Written by Stratovarius
// Applies the cast domain feats to the hide

#include "inc_newspellbook"
#include "prc_inc_domain"
#include "inc_dynconv"
#include "inc_nwnx_funcs"
#include "prc_inc_wpnrest"

void AddDomainPower(object oPC, object oSkin, int bFuncs)
{
    if(bFuncs)
    {
        if (GetHasFeat(FEAT_BONUS_DOMAIN_AIR, oPC)          && !PRC_Funcs_GetFeatKnown(oPC, FEAT_AIR_DOMAIN_POWER))           PRC_Funcs_AddFeat(oPC, FEAT_AIR_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_ANIMAL, oPC)       && !PRC_Funcs_GetFeatKnown(oPC, FEAT_ANIMAL_DOMAIN_POWER))        PRC_Funcs_AddFeat(oPC, FEAT_ANIMAL_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_DEATH, oPC)        && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DEATH_DOMAIN_POWER))         PRC_Funcs_AddFeat(oPC, FEAT_DEATH_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_DESTRUCTION, oPC)  && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DESTRUCTION_DOMAIN_POWER))   PRC_Funcs_AddFeat(oPC, FEAT_DESTRUCTION_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_EARTH, oPC)        && !PRC_Funcs_GetFeatKnown(oPC, FEAT_EARTH_DOMAIN_POWER))         PRC_Funcs_AddFeat(oPC, FEAT_EARTH_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_EVIL, oPC)         && !PRC_Funcs_GetFeatKnown(oPC, FEAT_EVIL_DOMAIN_POWER))          PRC_Funcs_AddFeat(oPC, FEAT_EVIL_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_FIRE, oPC)         && !PRC_Funcs_GetFeatKnown(oPC, FEAT_FIRE_DOMAIN_POWER))          PRC_Funcs_AddFeat(oPC, FEAT_FIRE_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_GOOD, oPC)         && !PRC_Funcs_GetFeatKnown(oPC, FEAT_GOOD_DOMAIN_POWER))          PRC_Funcs_AddFeat(oPC, FEAT_GOOD_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_HEALING, oPC)      && !PRC_Funcs_GetFeatKnown(oPC, FEAT_HEALING_DOMAIN_POWER))       PRC_Funcs_AddFeat(oPC, FEAT_HEALING_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_KNOWLEDGE, oPC)    && !PRC_Funcs_GetFeatKnown(oPC, FEAT_KNOWLEDGE_DOMAIN_POWER))     PRC_Funcs_AddFeat(oPC, FEAT_KNOWLEDGE_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_MAGIC, oPC)        && !PRC_Funcs_GetFeatKnown(oPC, FEAT_MAGIC_DOMAIN_POWER))         PRC_Funcs_AddFeat(oPC, FEAT_MAGIC_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_PLANT, oPC)        && !PRC_Funcs_GetFeatKnown(oPC, FEAT_PLANT_DOMAIN_POWER))         PRC_Funcs_AddFeat(oPC, FEAT_PLANT_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_PROTECTION, oPC)   && !PRC_Funcs_GetFeatKnown(oPC, FEAT_PROTECTION_DOMAIN_POWER))    PRC_Funcs_AddFeat(oPC, FEAT_PROTECTION_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_STRENGTH, oPC)     && !PRC_Funcs_GetFeatKnown(oPC, FEAT_STRENGTH_DOMAIN_POWER))      PRC_Funcs_AddFeat(oPC, FEAT_STRENGTH_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_SUN, oPC)          && !PRC_Funcs_GetFeatKnown(oPC, FEAT_SUN_DOMAIN_POWER))           PRC_Funcs_AddFeat(oPC, FEAT_SUN_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_TRAVEL, oPC)       && !PRC_Funcs_GetFeatKnown(oPC, FEAT_TRAVEL_DOMAIN_POWER))        PRC_Funcs_AddFeat(oPC, FEAT_TRAVEL_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_TRICKERY, oPC)     && !PRC_Funcs_GetFeatKnown(oPC, FEAT_TRICKERY_DOMAIN_POWER))      PRC_Funcs_AddFeat(oPC, FEAT_TRICKERY_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_WAR, oPC)          && !PRC_Funcs_GetFeatKnown(oPC, FEAT_WAR_DOMAIN_POWER))           PRC_Funcs_AddFeat(oPC, FEAT_WAR_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_WATER, oPC)        && !PRC_Funcs_GetFeatKnown(oPC, FEAT_WATER_DOMAIN_POWER))         PRC_Funcs_AddFeat(oPC, FEAT_WATER_DOMAIN_POWER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_DARKNESS, oPC)     && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_DARKNESS))      PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_DARKNESS);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_STORM, oPC)        && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_STORM))         PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_STORM);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_METAL, oPC)        && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_METAL))         PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_METAL);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_PORTAL, oPC)       && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_PORTAL))        PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_PORTAL);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_FORCE, oPC)        && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_FORCE))         PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_FORCE);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_SLIME, oPC)        && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_SLIME))         PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_SLIME);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_TYRANNY, oPC)      && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_TYRANNY))       PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_TYRANNY);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_DOMINATION, oPC)   && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_DOMINATION))    PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_DOMINATION);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_SPIDER, oPC)       && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_SPIDER))        PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_SPIDER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_UNDEATH, oPC)      && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_UNDEATH))       PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_UNDEATH);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_TIME, oPC)         && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_TIME))          PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_TIME);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_DWARF, oPC)        && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_DWARF))         PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_DWARF);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_CHARM, oPC)        && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_CHARM))         PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_CHARM);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_ELF, oPC)          && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_ELF))           PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_ELF);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_FAMILY, oPC)       && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_FAMILY))        PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_FAMILY);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_FATE, oPC)         && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_FATE))          PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_FATE);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_GNOME, oPC)        && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_GNOME))         PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_GNOME);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_ILLUSION, oPC)     && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_ILLUSION))      PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_ILLUSION);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_HATRED, oPC)       && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_HATRED))        PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_HATRED);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_HALFLING, oPC)     && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_HALFLING))      PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_HALFLING);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_NOBILITY, oPC)     && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_NOBILITY))      PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_NOBILITY);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_OCEAN, oPC)        && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_OCEAN))         PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_OCEAN);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_ORC, oPC)          && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_ORC))           PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_ORC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_RENEWAL, oPC)      && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_RENEWAL))       PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_RENEWAL);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_RETRIBUTION, oPC)  && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_RETRIBUTION))   PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_RETRIBUTION);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_RUNE, oPC)         && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_RUNE))          PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_RUNE);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_SPELLS, oPC)       && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_SPELLS))        PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_SPELLS);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_SCALEYKIND, oPC)   && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_SCALEYKIND))    PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_SCALEYKIND);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_BLIGHTBRINGER, oPC)&& !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_BLIGHTBRINGER)) PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_BLIGHTBRINGER);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_DRAGON, oPC)       && !PRC_Funcs_GetFeatKnown(oPC, FEAT_DOMAIN_POWER_DRAGON))        PRC_Funcs_AddFeat(oPC, FEAT_DOMAIN_POWER_DRAGON);
    }
    else
    {
        if (GetHasFeat(FEAT_BONUS_DOMAIN_AIR, oPC))           AddSkinFeat(FEAT_AIR_DOMAIN_POWER, IP_CONST_FEAT_AIR_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_ANIMAL, oPC))        AddSkinFeat(FEAT_ANIMAL_DOMAIN_POWER, IP_CONST_FEAT_ANIMAL_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_DEATH, oPC))         AddSkinFeat(FEAT_DEATH_DOMAIN_POWER, IP_CONST_FEAT_DEATH_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_DESTRUCTION, oPC))   AddSkinFeat(FEAT_DESTRUCTION_DOMAIN_POWER, IP_CONST_FEAT_DESTRUCTION_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_EARTH, oPC))         AddSkinFeat(FEAT_EARTH_DOMAIN_POWER, IP_CONST_FEAT_EARTH_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_EVIL, oPC))          AddSkinFeat(FEAT_EVIL_DOMAIN_POWER, IP_CONST_FEAT_EVIL_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_FIRE, oPC))          AddSkinFeat(FEAT_FIRE_DOMAIN_POWER, IP_CONST_FEAT_FIRE_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_GOOD, oPC))          AddSkinFeat(FEAT_GOOD_DOMAIN_POWER, IP_CONST_FEAT_GOOD_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_HEALING, oPC))       AddSkinFeat(FEAT_HEALING_DOMAIN_POWER, IP_CONST_FEAT_HEALING_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_KNOWLEDGE, oPC))     AddSkinFeat(FEAT_KNOWLEDGE_DOMAIN_POWER, IP_CONST_FEAT_KNOWLEDGE_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_MAGIC, oPC))         AddSkinFeat(FEAT_MAGIC_DOMAIN_POWER, IP_CONST_FEAT_MAGIC_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_PLANT, oPC))         AddSkinFeat(FEAT_PLANT_DOMAIN_POWER, IP_CONST_FEAT_PLANT_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_PROTECTION, oPC))    AddSkinFeat(FEAT_PROTECTION_DOMAIN_POWER, IP_CONST_FEAT_PROTECTION_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_STRENGTH, oPC))      AddSkinFeat(FEAT_STRENGTH_DOMAIN_POWER, IP_CONST_FEAT_STRENGTH_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_SUN, oPC))           AddSkinFeat(FEAT_SUN_DOMAIN_POWER, IP_CONST_FEAT_SUN_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_TRAVEL, oPC))        AddSkinFeat(FEAT_TRAVEL_DOMAIN_POWER, IP_CONST_FEAT_TRAVEL_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_TRICKERY, oPC))      AddSkinFeat(FEAT_TRICKERY_DOMAIN_POWER, IP_CONST_FEAT_TRICKERY_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_WAR, oPC))           AddSkinFeat(FEAT_WAR_DOMAIN_POWER, IP_CONST_FEAT_WAR_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_WATER, oPC))         AddSkinFeat(FEAT_WATER_DOMAIN_POWER, IP_CONST_FEAT_WATER_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_DARKNESS, oPC))      AddSkinFeat(FEAT_DOMAIN_POWER_DARKNESS, IP_CONST_FEAT_DARKNESS_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_STORM, oPC))         AddSkinFeat(FEAT_DOMAIN_POWER_STORM, IP_CONST_FEAT_STORM_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_METAL, oPC))         AddSkinFeat(FEAT_DOMAIN_POWER_METAL, IP_CONST_FEAT_METAL_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_PORTAL, oPC))        AddSkinFeat(FEAT_DOMAIN_POWER_PORTAL, IP_CONST_FEAT_PORTAL_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_FORCE, oPC))         AddSkinFeat(FEAT_DOMAIN_POWER_FORCE, IP_CONST_FEAT_FORCE_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_SLIME, oPC))         AddSkinFeat(FEAT_DOMAIN_POWER_SLIME, IP_CONST_FEAT_SLIME_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_TYRANNY, oPC))       AddSkinFeat(FEAT_DOMAIN_POWER_TYRANNY, IP_CONST_FEAT_TYRANNY_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_DOMINATION, oPC))    AddSkinFeat(FEAT_DOMAIN_POWER_DOMINATION, IP_CONST_FEAT_DOMINATION_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_SPIDER, oPC))        AddSkinFeat(FEAT_DOMAIN_POWER_SPIDER, IP_CONST_FEAT_SPIDER_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_UNDEATH, oPC))       AddSkinFeat(FEAT_DOMAIN_POWER_UNDEATH, IP_CONST_FEAT_UNDEATH_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_TIME, oPC))          AddSkinFeat(FEAT_DOMAIN_POWER_TIME, IP_CONST_FEAT_TIME_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_DWARF, oPC))         AddSkinFeat(FEAT_DOMAIN_POWER_DWARF, IP_CONST_FEAT_DWARF_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_CHARM, oPC))         AddSkinFeat(FEAT_DOMAIN_POWER_CHARM, IP_CONST_FEAT_CHARM_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_ELF, oPC))           AddSkinFeat(FEAT_DOMAIN_POWER_ELF, IP_CONST_FEAT_ELF_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_FAMILY, oPC))        AddSkinFeat(FEAT_DOMAIN_POWER_FAMILY, IP_CONST_FEAT_FAMILY_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_FATE, oPC))          AddSkinFeat(FEAT_DOMAIN_POWER_FATE, IP_CONST_FEAT_FATE_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_GNOME, oPC))         AddSkinFeat(FEAT_DOMAIN_POWER_GNOME, IP_CONST_FEAT_GNOME_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_ILLUSION, oPC))      AddSkinFeat(FEAT_DOMAIN_POWER_ILLUSION, IP_CONST_FEAT_ILLUSION_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_HATRED, oPC))        AddSkinFeat(FEAT_DOMAIN_POWER_HATRED, IP_CONST_FEAT_HATRED_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_HALFLING, oPC))      AddSkinFeat(FEAT_DOMAIN_POWER_HALFLING, IP_CONST_FEAT_HALFLING_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_NOBILITY, oPC))      AddSkinFeat(FEAT_DOMAIN_POWER_NOBILITY, IP_CONST_FEAT_NOBILITY_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_OCEAN, oPC))         AddSkinFeat(FEAT_DOMAIN_POWER_OCEAN, IP_CONST_FEAT_OCEAN_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_ORC, oPC))           AddSkinFeat(FEAT_DOMAIN_POWER_ORC, IP_CONST_FEAT_ORC_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_RENEWAL, oPC))       AddSkinFeat(FEAT_DOMAIN_POWER_RENEWAL, IP_CONST_FEAT_RENEWAL_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_RETRIBUTION, oPC))   AddSkinFeat(FEAT_DOMAIN_POWER_RETRIBUTION, IP_CONST_FEAT_RETRIBUTION_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_RUNE, oPC))          AddSkinFeat(FEAT_DOMAIN_POWER_RUNE, IP_CONST_FEAT_RUNE_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_SPELLS, oPC))        AddSkinFeat(FEAT_DOMAIN_POWER_SPELLS, IP_CONST_FEAT_SPELLS_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_SCALEYKIND, oPC))    AddSkinFeat(FEAT_DOMAIN_POWER_SCALEYKIND, IP_CONST_FEAT_SCALEYKIND_DOMAIN, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_BLIGHTBRINGER, oPC)) AddSkinFeat(FEAT_DOMAIN_POWER_BLIGHTBRINGER, IP_CONST_FEAT_BLIGHTBRINGER, oSkin, oPC);
        if (GetHasFeat(FEAT_BONUS_DOMAIN_DRAGON, oPC))        AddSkinFeat(FEAT_DOMAIN_POWER_DRAGON, IP_CONST_FEAT_DRAGON_DOMAIN, oSkin, oPC);
    }
}

void AddDomainFeat(object oPC, object oSkin, int bFuncs)
{

    if(DEBUG) DoDebug("Add Domain Feat is running");
    if(bFuncs)
    {
        if (GetHasFeat(FEAT_DOMAIN_POWER_DARKNESS, oPC)   && !PRC_Funcs_GetFeatKnown(oPC, FEAT_BLIND_FIGHT))             PRC_Funcs_AddFeat(oPC, FEAT_BLIND_FIGHT);
        if (GetHasFeat(FEAT_DOMAIN_POWER_DWARF, oPC)      && !PRC_Funcs_GetFeatKnown(oPC, FEAT_GREAT_FORTITUDE))         PRC_Funcs_AddFeat(oPC, FEAT_GREAT_FORTITUDE);
        if (GetHasFeat(FEAT_DOMAIN_POWER_ELF, oPC)        && !PRC_Funcs_GetFeatKnown(oPC, FEAT_POINT_BLANK_SHOT))        PRC_Funcs_AddFeat(oPC, FEAT_POINT_BLANK_SHOT);
        if (GetHasFeat(FEAT_DOMAIN_POWER_FATE, oPC)       && !PRC_Funcs_GetFeatKnown(oPC, FEAT_UNCANNY_DODGE_1))         PRC_Funcs_AddFeat(oPC, FEAT_UNCANNY_DODGE_1);
        if (GetHasFeat(FEAT_DOMAIN_POWER_RUNE, oPC)       && !PRC_Funcs_GetFeatKnown(oPC, FEAT_SCRIBE_SCROLL))           PRC_Funcs_AddFeat(oPC, FEAT_SCRIBE_SCROLL);
        if (GetHasFeat(FEAT_DOMAIN_POWER_TIME, oPC)       && !PRC_Funcs_GetFeatKnown(oPC, FEAT_IMPROVED_INITIATIVE))     PRC_Funcs_AddFeat(oPC, FEAT_IMPROVED_INITIATIVE);
        if (GetHasFeat(FEAT_DOMAIN_POWER_UNDEATH, oPC)    && !PRC_Funcs_GetFeatKnown(oPC, FEAT_EXTRA_TURNING))           PRC_Funcs_AddFeat(oPC, FEAT_EXTRA_TURNING);
        if (GetHasFeat(FEAT_DOMAIN_POWER_DOMINATION, oPC) && !PRC_Funcs_GetFeatKnown(oPC, FEAT_SPELL_FOCUS_ENCHANTMENT)) PRC_Funcs_AddFeat(oPC, FEAT_SPELL_FOCUS_ENCHANTMENT);
    }
    else
	{
		effect eBonusFeat;
		if (GetHasFeat(FEAT_DOMAIN_POWER_DARKNESS, oPC)) 
		{
			eBonusFeat = EffectBonusFeat(FEAT_BLIND_FIGHT); 		
			eBonusFeat = SupernaturalEffect(eBonusFeat);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonusFeat, oPC);
		}
		if (GetHasFeat(FEAT_DOMAIN_POWER_DWARF, oPC)) 
		{
			eBonusFeat = EffectBonusFeat(FEAT_GREAT_FORTITUDE); 		
			eBonusFeat = SupernaturalEffect(eBonusFeat);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonusFeat, oPC);
		}		
		if (GetHasFeat(FEAT_DOMAIN_POWER_ELF, oPC)) 
		{
			eBonusFeat = EffectBonusFeat(FEAT_POINT_BLANK_SHOT); 		
			eBonusFeat = SupernaturalEffect(eBonusFeat);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonusFeat, oPC);
		}		
		if (GetHasFeat(FEAT_DOMAIN_POWER_FATE, oPC)) 
		{
			eBonusFeat = EffectBonusFeat(FEAT_UNCANNY_DODGE_1); 		
			eBonusFeat = SupernaturalEffect(eBonusFeat);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonusFeat, oPC);
		}	
		if (GetHasFeat(FEAT_DOMAIN_POWER_TIME, oPC)) 
		{
			eBonusFeat = EffectBonusFeat(FEAT_IMPROVED_INITIATIVE); 		
			eBonusFeat = SupernaturalEffect(eBonusFeat);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonusFeat, oPC);
		}	
		if (GetHasFeat(FEAT_DOMAIN_POWER_UNDEATH, oPC)) 
		{
			eBonusFeat = EffectBonusFeat(FEAT_EXTRA_TURNING); 		
			eBonusFeat = SupernaturalEffect(eBonusFeat);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonusFeat, oPC);
		}	
		if (GetHasFeat(FEAT_DOMAIN_POWER_DOMINATION, oPC)) 
		{
			eBonusFeat = EffectBonusFeat(FEAT_SPELL_FOCUS_ENCHANTMENT); 		
			eBonusFeat = SupernaturalEffect(eBonusFeat);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonusFeat, oPC);
		}		
	}
/*     {
        if (GetHasFeat(FEAT_DOMAIN_POWER_DARKNESS, oPC))      AddSkinFeat(FEAT_BLIND_FIGHT, IP_CONST_FEAT_BLINDFIGHT, oSkin, oPC);
        if (GetHasFeat(FEAT_DOMAIN_POWER_DWARF, oPC))         AddSkinFeat(FEAT_GREAT_FORTITUDE, IP_CONST_FEAT_GREAT_FORTITUDE, oSkin, oPC);
        if (GetHasFeat(FEAT_DOMAIN_POWER_ELF, oPC))           AddSkinFeat(FEAT_POINT_BLANK_SHOT, IP_CONST_FEAT_POINTBLANK, oSkin, oPC);
        if (GetHasFeat(FEAT_DOMAIN_POWER_FATE, oPC))          AddSkinFeat(FEAT_UNCANNY_DODGE_1, IP_CONST_FEAT_UNCANNY_DODGE1, oSkin, oPC);
        if (GetHasFeat(FEAT_DOMAIN_POWER_RUNE, oPC))          AddSkinFeat(FEAT_SCRIBE_SCROLL, IP_CONST_FEAT_SCRIBE_SCROLL, oSkin, oPC);
        if (GetHasFeat(FEAT_DOMAIN_POWER_TIME, oPC))          AddSkinFeat(FEAT_IMPROVED_INITIATIVE, IP_CONST_FEAT_IMPROVED_INIT, oSkin, oPC);
        if (GetHasFeat(FEAT_DOMAIN_POWER_UNDEATH, oPC))       AddSkinFeat(FEAT_EXTRA_TURNING, IP_CONST_FEAT_EXTRA_TURNING, oSkin, oPC);
        if (GetHasFeat(FEAT_DOMAIN_POWER_DOMINATION, oPC))    AddSkinFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, IP_CONST_FEAT_SPELLFOCUSENC, oSkin, oPC);
    } */
    // +2 Conc and Spellcraft
    if (GetHasFeat(FEAT_DOMAIN_POWER_SPELLS, oPC))
    {
        SetCompositeBonus(oSkin, "SpellDomainPowerConc", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_CONCENTRATION);
        SetCompositeBonus(oSkin, "SpellDomainPowerSpell", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPELLCRAFT);
    }

    // Electrical resist 5
    if (GetHasFeat(FEAT_DOMAIN_POWER_STORM, oPC))
    {
        itemproperty ipIP =ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_5);
        IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }
    if (GetHasFeat(FEAT_WAR_DOMAIN_POWER, oPC))
    {
        int nWarFocus = GetPersistantLocalInt(oPC, "WarDomainWeaponPersistent");
        // If they've already chosen a weapon, reapply the feats if they dont have it
        if (nWarFocus)
        {
            if(bFuncs)
            {
                if (!PRC_Funcs_GetFeatKnown(oPC, nWarFocus)) PRC_Funcs_AddFeat(oPC, nWarFocus);
                if (!PRC_Funcs_GetFeatKnown(oPC, FEAT_WEAPON_PROFICIENCY_MARTIAL)) PRC_Funcs_AddFeat(oPC, FEAT_WEAPON_PROFICIENCY_MARTIAL);
            }
            else
            {
				effect  eMWP	= EffectBonusFeat(GetWeaponProfFeatByType(FocusToWeapProf(nWarFocus)));
				effect 	eWF 	= EffectBonusFeat(nWarFocus);
				
						eWF		= EffectLinkEffects(eWF, eMWP);
				
						eWF 	= UnyieldingEffect(eWF);
						eWF 	= TagEffect(eWF, "WAR_DOMAIN_WEAPON_FOCUS");
				
				SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eWF, oPC);
				
				//int nWarWFIprop = FeatToIprop(nWarFocus);
                //AddSkinFeat(nWarFocus, nWarWFIprop, oSkin, oPC);
                //AddSkinFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, IP_CONST_FEAT_WEAPON_PROF_MARTIAL, oSkin, oPC);
            }
        }
        else
        {
             DelayCommand(1.5, StartDynamicConversation("prc_domain_war", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC));
        }

    }
    if (GetHasFeat(FEAT_DOMAIN_POWER_METAL, oPC))
    {
        int nWFocus = GetPersistantLocalInt(oPC, "MetalDomainWeaponPersistent");
        // If they've already chosen a weapon, reapply the feats if they dont have it
        if (nWFocus)
        {
            if(bFuncs)
            {
                if (!PRC_Funcs_GetFeatKnown(oPC, nWFocus)) PRC_Funcs_AddFeat(oPC, nWFocus);
                if (!PRC_Funcs_GetFeatKnown(oPC, FEAT_WEAPON_PROFICIENCY_MARTIAL)) PRC_Funcs_AddFeat(oPC, FEAT_WEAPON_PROFICIENCY_MARTIAL);
            }
            else
            {
                int nWFIprop = FeatToIprop(nWFocus);
                AddSkinFeat(nWFocus, nWFIprop, oSkin, oPC);
                AddSkinFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, IP_CONST_FEAT_WEAPON_PROF_MARTIAL, oSkin, oPC);
            }
        }
        else
        {
             DelayCommand(1.5, StartDynamicConversation("prc_domain_metal", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC));
        }

    }// +2 Bluff and Intimidate - since adding to class skills isn't allowed
    if (GetHasFeat(FEAT_DOMAIN_POWER_DRAGON, oPC))
    {
        SetCompositeBonus(oSkin, "DragonDomainBluff", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
        SetCompositeBonus(oSkin, "DragonDomainIntim", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
    }
/*
    // Domain powers that need to be created
    if (GetHasFeat(FEAT_BONUS_DOMAIN_ANIMAL, oPC))        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_ANIMAL_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    // Domain Powers that grant Turning or something affecting Turning
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SCALEYKIND, oPC))    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SCALEYKIND_DOMAIN ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SLIME, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SLIME_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SPIDER, oPC))        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SPIDER_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_AIR, oPC))           IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_AIR_DOMAIN        ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_EARTH, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EARTH_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_FIRE, oPC))          IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FIRE_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_PLANT, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_PLANT_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_WATER, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WATER_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    // Domains below here do not have possible Domain Powers in NWN
    if (GetHasFeat(FEAT_BONUS_DOMAIN_PORTAL, oPC))        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_PORTAL_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_OCEAN, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_OCEAN_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_FORCE, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FORCE_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_MAGIC, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_MAGIC_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_TRICKERY, oPC))      IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TRICKERY_DOMAIN   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
*/
}


void main()
{

    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int bFuncs = GetPRCSwitch(PRC_NWNX_FUNCS);
    if(DEBUG) DoDebug("PRC Domain Skin is running");

    // This is above the check to stop because AddDomainFeat needs this to run beforehand.
    // Puts the domain power feats on the skin for the appropriate domains.
    AddDomainPower(oPC, oSkin, bFuncs);

    // This is above the check to stop because all domains, including ones pick at level of a cleric use this
    // Puts the bonus feats that some domains grant on the skin for the appropriate domains.
    AddDomainFeat(oPC, oSkin, bFuncs);

    // Stops the script from running if the PC has no bonus domains
    // Looks in the first slot for a bonus domain, exits if there is none
    // The first domain begins at 1
    if (GetBonusDomain(oPC, 1) <= 0)
    {
        if(DEBUG) DoDebug("You have no bonus domains, exiting prc_domain_skin");
        return;
    }

    // The prereq variables use 0 as true and 1 as false, becuase they are used in class prereqs
    // It uses allspell because there are some feats that allow a wizard or other arcane caster to take domains.
    AddSkinFeat(FEAT_CHECK_DOMAIN_SLOTS, IP_CONST_FEAT_CHECK_DOMAIN_SLOTS, oSkin, oPC);

    if(GetLocalInt(oPC, "PRC_AllSpell1") == 0)
        AddSkinFeat(FEAT_CAST_DOMAIN_LEVEL_ONE, IP_CONST_FEAT_CAST_DOMAIN_LEVEL_ONE, oSkin, oPC);
    if(GetLocalInt(oPC, "PRC_AllSpell2") == 0)
        AddSkinFeat(FEAT_CAST_DOMAIN_LEVEL_TWO, IP_CONST_FEAT_CAST_DOMAIN_LEVEL_TWO, oSkin, oPC);
    if(GetLocalInt(oPC, "PRC_AllSpell3") == 0)
        AddSkinFeat(FEAT_CAST_DOMAIN_LEVEL_THREE, IP_CONST_FEAT_CAST_DOMAIN_LEVEL_THREE, oSkin, oPC);
    if(GetLocalInt(oPC, "PRC_AllSpell4") == 0)
        AddSkinFeat(FEAT_CAST_DOMAIN_LEVEL_FOUR, IP_CONST_FEAT_CAST_DOMAIN_LEVEL_FOUR, oSkin, oPC);
    if(GetLocalInt(oPC, "PRC_AllSpell5") == 0)
        AddSkinFeat(FEAT_CAST_DOMAIN_LEVEL_FIVE, IP_CONST_FEAT_CAST_DOMAIN_LEVEL_FIVE, oSkin, oPC);
    if(GetLocalInt(oPC, "PRC_AllSpell6") == 0)
        AddSkinFeat(FEAT_CAST_DOMAIN_LEVEL_SIX, IP_CONST_FEAT_CAST_DOMAIN_LEVEL_SIX, oSkin, oPC);
    if(GetLocalInt(oPC, "PRC_AllSpell7") == 0)
        AddSkinFeat(FEAT_CAST_DOMAIN_LEVEL_SEVEN, IP_CONST_FEAT_CAST_DOMAIN_LEVEL_SEVEN, oSkin, oPC);
    if(GetLocalInt(oPC, "PRC_AllSpell8") == 0)
        AddSkinFeat(FEAT_CAST_DOMAIN_LEVEL_EIGHT, IP_CONST_FEAT_CAST_DOMAIN_LEVEL_EIGHT, oSkin, oPC);
    if(GetLocalInt(oPC, "PRC_AllSpell9") == 0)
        AddSkinFeat(FEAT_CAST_DOMAIN_LEVEL_NINE, IP_CONST_FEAT_CAST_DOMAIN_LEVEL_NINE, oSkin, oPC);
}