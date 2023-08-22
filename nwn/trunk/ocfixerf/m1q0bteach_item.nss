// Added compatibility for PRC base classes
#include "inc_debug"
#include "prc_class_const"

void main()
{
if(DEBUG) DoDebug("m1q0bteach_item running");
    string sItemTemplate;
    object oPC = GetPCSpeaker();
    if(GetLocalInt(oPC,"NW_L_M1Q0Item2") == FALSE)
    {
        SetLocalInt(oPC,"NW_L_M1Q0Item2",TRUE);
        if(GetLevelByClass(CLASS_TYPE_DRUID,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_SWORDSAGE,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_SCOUT,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_TRUENAMER,oPC) > 0)
        {
            sItemTemplate = "NW_IT_MRING024"; //boots of fortitude
        }
        else if(GetLevelByClass(CLASS_TYPE_ROGUE,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_NINJA,oPC) > 0)
        {
            sItemTemplate = "nw_it_trap001"; //minor spike trap
        }
        else if(GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_MONK,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_SWASHBUCKLER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_WARBLADE,oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_TOTEMIST,oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_INCARNATE,oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_FACTOTUM,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_CRUSADER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_WARLOCK,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_BOWMAN,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_SOHEI,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_SHAMAN,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_HEALER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_HEXBLADE,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_CW_SAMURAI,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_PSYCHIC_ROGUE,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_SAMURAI,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_SOULKNIFE,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_ARCHIVIST,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_TEMPLAR,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_RANGER,oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_BINDER, oPC) > 0)
        {
            sItemTemplate = "NW_IT_MBOOTS010"; //boots of reflex
        }
        else if(GetLevelByClass(CLASS_TYPE_CLERIC,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_MYSTIC,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_FIGHTER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_MARSHAL,oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_SOULBORN,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_DUSKBLADE,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_SHUGENJA,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_KNIGHT,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_WARMAGE,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_ANTI_PALADIN,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_PSYWAR,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_BRAWLER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_PALADIN,oPC) > 0)
        {
            sItemTemplate = "nw_aarcl004"; //chain mail
        }
        else
        {
            sItemTemplate = "NW_WMGMRD006"; //wand of Frost
        }
        object oItem = CreateItemOnObject(sItemTemplate,oPC);
        SetIdentified(oItem,TRUE);
        if(GetLevelByClass(CLASS_TYPE_NINJA,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_ROGUE,oPC) > 0)
        {
            oItem = CreateItemOnObject(sItemTemplate,oPC);
            SetIdentified(oItem,TRUE);
        }
    }
}