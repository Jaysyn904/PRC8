// Added compatibility for PRC base classes
#include "inc_debug"
#include "prc_class_const"

void GiveItem(string sTemplate);

void main()
{
if(DEBUG) DoDebug("m1q0dchest2 running");
    string sItemTemplate1;
    string sItemTemplate2;
    string sItemTemplate3;
    string sItemTemplate4;
    object oPC = GetLastOpenedBy();
    if(GetIsObjectValid(oPC) == FALSE)
    {
        oPC = GetLastAttacker();
    }
    if(GetLocalInt(oPC,"NW_L_M1Q0Item4") == FALSE)
    {
        SetLocalInt(oPC,"NW_L_M1Q0Item4",TRUE);
        if(GetLevelByClass(CLASS_TYPE_CLERIC,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_FIGHTER,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_MYSTIC,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_WARBLADE,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_SWORDSAGE,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_CRUSADER,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_SOHEI,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_KNIGHT,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_ANTI_PALADIN,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_PSYWAR,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_BRAWLER,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_MARSHAL,oPC) > 0 ||
		   GetLevelByClass(CLASS_TYPE_SOULBORN,oPC) > 0 ||
		   GetLevelByClass(CLASS_TYPE_PALADIN,oPC) > 0)
        {
            sItemTemplate1 = "NW_AARCL005"; //Splintmail
        }
        else if(GetLevelByClass(CLASS_TYPE_BOWMAN,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_HEXBLADE,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_WARLOCK,oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_FACTOTUM,oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_TOTEMIST,oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_INCARNATE,oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_BINDER, oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) > 0)
        {
            sItemTemplate1 = "NW_IT_MBELT010"; //Brawler's belt
        }
        else if(GetLevelByClass(CLASS_TYPE_DRUID,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_SHAMAN,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_SAMURAI,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_CW_SAMURAI,oPC) > 0)
        {
            sItemTemplate1 = "NW_AARCL010"; //Breastplate
        }
        else if(GetLevelByClass(CLASS_TYPE_MONK,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_TRUENAMER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_PSION,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_WILDER,oPC) > 0)
        {
            sItemTemplate1 = "NW_IT_MNECK024"; //Amulet of will
        }
        else if(GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_SCOUT,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_SHUGENJA,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_HEALER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_WITCH,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_ARCHIVIST,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_TEMPLAR,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_RANGER,oPC) > 0)
        {
            sItemTemplate1 = "NW_MAARCL097"; //Cloak of prot vs. evil
        }
        else if(GetLevelByClass(CLASS_TYPE_ROGUE,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_PSYCHIC_ROGUE,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_NINJA,oPC) > 0)
        {
            sItemTemplate1 = "NW_IT_TRAP002"; // average spike trap
            sItemTemplate2 = "NW_IT_TRAP029"; // minor cold trap
            sItemTemplate3 = "NW_IT_TRAP029"; // minor cold trap
        }
        else
        {
            sItemTemplate1 = "NW_IT_SPARSCR108"; //Sleep scoll
            sItemTemplate2 = "NW_IT_SPARSCR104"; //Mage Armor
            sItemTemplate3 = "NW_IT_SPARSCR110"; //Color spray
            sItemTemplate4 = "NW_IT_SPARSCR105"; //Summon creature 1
        }
        GiveItem(sItemTemplate1);
        GiveItem(sItemTemplate2);
        GiveItem(sItemTemplate3);
        GiveItem(sItemTemplate4);
    }
}

void GiveItem(string sTemplate)
{
    object oItem = CreateItemOnObject(sTemplate);
    SetIdentified(oItem,TRUE);
    return;
}
