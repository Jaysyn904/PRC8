// Added compatibility for PRC base classes
#include "inc_debug"
#include "prc_class_const"

void main()
{
if(DEBUG) DoDebug("m1q0dchest1 running");
    string sItemTemplate;
    object oPC = GetLastOpenedBy();
    if(GetIsObjectValid(oPC) == FALSE)
    {
        oPC = GetLastAttacker();
    }
    if(GetLocalInt(oPC,"NW_L_M1Q0Item3") == FALSE)
    {
        SetLocalInt(oPC,"NW_L_M1Q0Item3",TRUE);
        if(GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_BOWMAN,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_WARBLADE,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_SWORDSAGE,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_DUSKBLADE,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_SOHEI,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_KNIGHT,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER,oPC) > 0 ||
           GetLevelByClass(CLASS_TYPE_RANGER,oPC) > 0)
        {
            sItemTemplate = "NW_AARCL010"; // breastplate
        }
        else if(GetLevelByClass(CLASS_TYPE_BARD,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_SAMURAI,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_CRUSADER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_CW_SAMURAI,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_SCOUT,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_SWASHBUCKLER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_MYSTIC,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_ARCHIVIST,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_TEMPLAR,oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_TOTEMIST,oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_SOULBORN,oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_INCARNATE,oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_FACTOTUM,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_CLERIC,oPC) > 0 ||
				GetLevelByClass(CLASS_TYPE_BINDER, oPC) > 0)
        {
            sItemTemplate = "NW_IT_MNECK024"; //amulet of will
        }
     /*   else if(GetLevelByClass(CLASS_TYPE_SORCERER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_PSION,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_HEALER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_WILDER,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_WIZARD,oPC) > 0)
        {
            sItemTemplate = "NW_IT_MBELT011"; //archer's belt
        }*/
        else if(GetLevelByClass(CLASS_TYPE_DRUID,oPC) > 0 ||
                GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN,oPC) > 0)
        {
            sItemTemplate = "nw_aarcl012"; //chainshirt
        }
        else if(GetLevelByClass(CLASS_TYPE_ROGUE,oPC) > 0 || GetLevelByClass(CLASS_TYPE_PSYCHIC_ROGUE,oPC) > 0)
        {
            sItemTemplate = "NW_IT_MBOOTS010";
        }
        else
        {
            sItemTemplate = "NW_IT_MRING024"; // ring of fortitude
        }
        object oItem = CreateItemOnObject(sItemTemplate);
        SetIdentified(oItem,TRUE);
    }
}
