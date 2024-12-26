/** @file
    This handles subraces and race restricted items.
    Drow should be able to use Elven only items for example.
*/
#include "prc_racial_const"
#include "prc_alterations"
//#include "psi_inc_manifest"

const string ARRAY_NAME = "PRC_Racial_IPs";

void AddRaceIP(object oItem, int iIP)
{
    if(array_get_string(oItem, ARRAY_NAME, iIP) == "")
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLimitUseByRace(iIP), oItem);
        array_set_string(oItem, ARRAY_NAME, iIP, "1");
    }
}

void AddRacialRestrictions(object oItem)
{
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_ABERRATION) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_DRIDER);
        AddRaceIP(oItem, RACIAL_TYPE_ELAN);
        AddRaceIP(oItem, RACIAL_TYPE_ILLITHID);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_CONSTRUCT) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_WARFORGED);
        AddRaceIP(oItem, RACIAL_TYPE_WARFORGED_CHARGER);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_DRAGON) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_BAAZ);
        AddRaceIP(oItem, RACIAL_TYPE_BOZAK);
        AddRaceIP(oItem, RACIAL_TYPE_KAPAK);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_DWARF) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_ARC_DWARF);
        AddRaceIP(oItem, RACIAL_TYPE_DS_DWARF);
        AddRaceIP(oItem, RACIAL_TYPE_DARK_DWARF);
        AddRaceIP(oItem, RACIAL_TYPE_DUERGAR);
        AddRaceIP(oItem, RACIAL_TYPE_FIREBLOOD_DWARF);
        AddRaceIP(oItem, RACIAL_TYPE_GOLD_DWARF);
        AddRaceIP(oItem, RACIAL_TYPE_GULLY_DWARF);
        AddRaceIP(oItem, RACIAL_TYPE_KOROBKURU);
        AddRaceIP(oItem, RACIAL_TYPE_MUL);
        AddRaceIP(oItem, RACIAL_TYPE_URDINNIR);
        AddRaceIP(oItem, RACIAL_TYPE_WILD_DWARF);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_ELF) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_AQELF);
        AddRaceIP(oItem, RACIAL_TYPE_DS_ELF);
        AddRaceIP(oItem, RACIAL_TYPE_AVARIEL);
        AddRaceIP(oItem, RACIAL_TYPE_DROW_FEMALE);
        AddRaceIP(oItem, RACIAL_TYPE_DROW_MALE);
        AddRaceIP(oItem, RACIAL_TYPE_FEYRI);
        AddRaceIP(oItem, RACIAL_TYPE_FORESTLORD_ELF);
        AddRaceIP(oItem, RACIAL_TYPE_KAGONESTI_ELF);
        AddRaceIP(oItem, RACIAL_TYPE_SILVANESTI_ELF);
        AddRaceIP(oItem, RACIAL_TYPE_SNOW_ELF);
        AddRaceIP(oItem, RACIAL_TYPE_SUN_ELF);
        AddRaceIP(oItem, RACIAL_TYPE_WILD_ELF);
        AddRaceIP(oItem, RACIAL_TYPE_WOOD_ELF);
		AddRaceIP(oItem, RACIAL_TYPE_GREY_ELF);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_FEY) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_BROWNIE);
        AddRaceIP(oItem, RACIAL_TYPE_GRIG);
        AddRaceIP(oItem, RACIAL_TYPE_NIXIE);
        AddRaceIP(oItem, RACIAL_TYPE_NYMPH);
        AddRaceIP(oItem, RACIAL_TYPE_PIXIE);
        AddRaceIP(oItem, RACIAL_TYPE_SATYR);
		AddRaceIP(oItem, RACIAL_TYPE_HYBSIL);
		AddRaceIP(oItem, RACIAL_TYPE_GLOURA);
		AddRaceIP(oItem, RACIAL_TYPE_JAEBRIN);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_GIANT) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_DS_HALFGIANT);
        AddRaceIP(oItem, RACIAL_TYPE_PH_HALFGIANT);
        AddRaceIP(oItem, RACIAL_TYPE_HALFOGRE);
        AddRaceIP(oItem, RACIAL_TYPE_KRYNN_HOGRE);
        AddRaceIP(oItem, RACIAL_TYPE_OGRE);
        AddRaceIP(oItem, RACIAL_TYPE_TROLL);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_GNOME) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_FOR_GNOME);
        AddRaceIP(oItem, RACIAL_TYPE_ROCK_GNOME);
        AddRaceIP(oItem, RACIAL_TYPE_STONEHUNTER_GNOME);
        AddRaceIP(oItem, RACIAL_TYPE_DEEP_GNOME);
        AddRaceIP(oItem, RACIAL_TYPE_TINK_GNOME);
        AddRaceIP(oItem, RACIAL_TYPE_WHISPER_GNOME);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_HUMANOID_GOBLINOID) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_BUGBEAR);
        AddRaceIP(oItem, RACIAL_TYPE_GOBLIN);
        AddRaceIP(oItem, RACIAL_TYPE_HOBGOBLIN);
        AddRaceIP(oItem, RACIAL_TYPE_SUNSCORCH_HOBGOBLIN);
        AddRaceIP(oItem, RACIAL_TYPE_TASLOI);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_HALFELF) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_DS_HALFELF);
        AddRaceIP(oItem, RACIAL_TYPE_HALFDROW);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_HALFLING) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_DS_HALFLING);
        AddRaceIP(oItem, RACIAL_TYPE_DEEP_HALFLING);
        AddRaceIP(oItem, RACIAL_TYPE_GHOSTWISE_HALFLING);
        AddRaceIP(oItem, RACIAL_TYPE_GLIMMERSKIN_HALFING);
        AddRaceIP(oItem, RACIAL_TYPE_KENDER);
        AddRaceIP(oItem, RACIAL_TYPE_STRONGHEART_HALFLING);
        AddRaceIP(oItem, RACIAL_TYPE_TALLFELLOW_HALFLING);
        AddRaceIP(oItem, RACIAL_TYPE_TUNDRA_HALFLING);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_HUMAN) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_AASIMAR);
        AddRaceIP(oItem, RACIAL_TYPE_AIR_GEN);
        AddRaceIP(oItem, RACIAL_TYPE_IMASKARI);
        AddRaceIP(oItem, RACIAL_TYPE_EARTH_GEN);
        AddRaceIP(oItem, RACIAL_TYPE_FIRE_GEN);
        AddRaceIP(oItem, RACIAL_TYPE_GITHYANKI);
        AddRaceIP(oItem, RACIAL_TYPE_GITHZERAI);
        AddRaceIP(oItem, RACIAL_TYPE_KALASHTAR);
        AddRaceIP(oItem, RACIAL_TYPE_EMPTY_VESSEL);
        AddRaceIP(oItem, RACIAL_TYPE_MAENADS);
        AddRaceIP(oItem, RACIAL_TYPE_SILVERBROW_HUMAN);
        AddRaceIP(oItem, RACIAL_TYPE_KRINTH);
        AddRaceIP(oItem, RACIAL_TYPE_SPIRIT_FOLK);
        AddRaceIP(oItem, RACIAL_TYPE_TIEFLING);
        AddRaceIP(oItem, RACIAL_TYPE_WATER_GEN);
        AddRaceIP(oItem, RACIAL_TYPE_XEPH);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_HUMANOID_MONSTROUS) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_CATFOLK);
        AddRaceIP(oItem, RACIAL_TYPE_DROMITE);
        AddRaceIP(oItem, RACIAL_TYPE_FLIND);
        AddRaceIP(oItem, RACIAL_TYPE_GNOLL);
        AddRaceIP(oItem, RACIAL_TYPE_KRYNN_MINOTAUR);
        AddRaceIP(oItem, RACIAL_TYPE_MINOTAUR);
        AddRaceIP(oItem, RACIAL_TYPE_NEZUMI);
        AddRaceIP(oItem, RACIAL_TYPE_WEMIC);
        AddRaceIP(oItem, RACIAL_TYPE_PURE_YUAN);
        AddRaceIP(oItem, RACIAL_TYPE_ARKAMOI);
        AddRaceIP(oItem, RACIAL_TYPE_LASHEMOI);
        AddRaceIP(oItem, RACIAL_TYPE_TURLEMOI);
        AddRaceIP(oItem, RACIAL_TYPE_HADRIMOI);
        AddRaceIP(oItem, RACIAL_TYPE_REDSPAWN_ARCANISS);
        AddRaceIP(oItem, RACIAL_TYPE_MARRULURK);
        AddRaceIP(oItem, RACIAL_TYPE_MARRUSAULT);
        AddRaceIP(oItem, RACIAL_TYPE_MARRUTACT);
        AddRaceIP(oItem, RACIAL_TYPE_HOBGOBLIN_WARSOUL);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_HALFORC) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_FROSTBLOOD_ORC);
        AddRaceIP(oItem, RACIAL_TYPE_GRAYORC);
        AddRaceIP(oItem, RACIAL_TYPE_ORC);
        AddRaceIP(oItem, RACIAL_TYPE_OROG);
        AddRaceIP(oItem, RACIAL_TYPE_SCRO);
        AddRaceIP(oItem, RACIAL_TYPE_TANARUKK);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_OUTSIDER) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_AASIMAR);
        AddRaceIP(oItem, RACIAL_TYPE_AIR_GEN);
        AddRaceIP(oItem, RACIAL_TYPE_AZER);
		AddRaceIP(oItem, RACIAL_TYPE_BARIAUR);
        AddRaceIP(oItem, RACIAL_TYPE_BLADELING);
        AddRaceIP(oItem, RACIAL_TYPE_BRALANI);
        AddRaceIP(oItem, RACIAL_TYPE_BUOMMANS);
        AddRaceIP(oItem, RACIAL_TYPE_CHAOND);
        AddRaceIP(oItem, RACIAL_TYPE_EARTH_GEN);
        AddRaceIP(oItem, RACIAL_TYPE_FEYRI);
        AddRaceIP(oItem, RACIAL_TYPE_FIRE_GEN);
        AddRaceIP(oItem, RACIAL_TYPE_GITHYANKI);
        AddRaceIP(oItem, RACIAL_TYPE_GITHZERAI);
        AddRaceIP(oItem, RACIAL_TYPE_HOUND_ARCHON);
        AddRaceIP(oItem, RACIAL_TYPE_KHAASTA);
        AddRaceIP(oItem, RACIAL_TYPE_NATHRI);
        AddRaceIP(oItem, RACIAL_TYPE_NAZTHARUNE_RAKSHASA);
        AddRaceIP(oItem, RACIAL_TYPE_NERAPHIM);
        AddRaceIP(oItem, RACIAL_TYPE_RAKSHASA);
        AddRaceIP(oItem, RACIAL_TYPE_SHADOWSWYFT);
        AddRaceIP(oItem, RACIAL_TYPE_TANARUKK);
        AddRaceIP(oItem, RACIAL_TYPE_TIEFLING);
        AddRaceIP(oItem, RACIAL_TYPE_TULADHARA);
        AddRaceIP(oItem, RACIAL_TYPE_WATER_GEN);
        AddRaceIP(oItem, RACIAL_TYPE_ZAKYA_RAKSHASA);
        AddRaceIP(oItem, RACIAL_TYPE_ZENYRTHRI);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_PLANT) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_VOLODNI);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_HUMANOID_REPTILIAN) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_ASABI);
        AddRaceIP(oItem, RACIAL_TYPE_DRAGONKIN);
        AddRaceIP(oItem, RACIAL_TYPE_KOBOLD);
        AddRaceIP(oItem, RACIAL_TYPE_LIZARDFOLK);
        AddRaceIP(oItem, RACIAL_TYPE_POISON_DUSK);
        AddRaceIP(oItem, RACIAL_TYPE_PTERRAN);
        AddRaceIP(oItem, RACIAL_TYPE_VILETOOTH_LIZARDFOLK);
		AddRaceIP(oItem, RACIAL_TYPE_MUCKDWELLER);
    }
    if(array_get_string(oItem, ARRAY_NAME, RACIAL_TYPE_SHAPECHANGER) != "")
    {
        AddRaceIP(oItem, RACIAL_TYPE_CHANGELING);
        AddRaceIP(oItem, RACIAL_TYPE_IRDA);
        AddRaceIP(oItem, RACIAL_TYPE_SHIFTER);
		AddRaceIP(oItem, RACIAL_TYPE_ARANEA);
    }

    //clean up
    array_delete(oItem, ARRAY_NAME);
}

void main()
{
    //object oCreature = GetModuleItemAcquiredBy();
    object oItem = GetModuleItemAcquired();
    //int nRace = GetRacialType(oCreature);

    // Only do this once per item
    if(GetLocalInt(oItem, "PRC_RacialRestrictionsExpanded"))
        return;

    // Ignore tokens and creature items
    int nBaseItem  = GetBaseItemType(oItem);
    string sResRef = GetStringLowerCase(GetResRef(oItem));

    if(nBaseItem == BASE_ITEM_CBLUDGWEAPON
    || nBaseItem == BASE_ITEM_CPIERCWEAPON
    || nBaseItem == BASE_ITEM_CREATUREITEM
    || nBaseItem == BASE_ITEM_CSLASHWEAPON
    || nBaseItem == BASE_ITEM_CSLSHPRCWEAP
    || sResRef == "hidetoken"
    || sResRef == "prc_maniftoken")
        return;

    if(array_exists(oItem, ARRAY_NAME))
        array_delete(oItem, ARRAY_NAME);
    array_create(oItem, ARRAY_NAME);

    SetLocalInt(oItem, "PRC_RacialRestrictionsExpanded", TRUE);

    // Loop over all itemproperties, looking for racial restrictions
    int bModifyItem = FALSE;
    itemproperty ipTest = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE)
        {
            int nIPRace = GetItemPropertySubType(ipTest);
            array_set_string(oItem, ARRAY_NAME, nIPRace, "1");
            bModifyItem = TRUE;
        }
        ipTest = GetNextItemProperty(oItem);
    }

    if(bModifyItem)
        DelayCommand(0.0f, AddRacialRestrictions(oItem));
}