// Added compatibility for PRC base classes
#include "inc_debug"
#include "prc_class_const"

// This script creates a treasure item based on the class of the
//PC who killed this creature

void main()
{
if(DEBUG) DoDebug("m1q0dmage7 running");
    string sItemTemplate;
    object oPC = GetLastKiller();
    object oMaster = GetMaster(oPC);
    if(GetIsObjectValid(oMaster))
    {
        oPC = oMaster;
    }
    if(GetLevelByClass(CLASS_TYPE_SORCERER,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_PSION,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_HEALER,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_WARLOCK,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_SHUGENJA,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_WARMAGE,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_SHADOWCASTER,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_WILDER,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_WITCH,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_WIZARD,oPC) > 0 )
    {
        sItemTemplate = "nw_wmgwn012"; //Wand of Sleep
    }
    else if(GetLevelByClass(CLASS_TYPE_DUSKBLADE,oPC) > 0 ||
            GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) > 0)
    {
        sItemTemplate = "NW_ASHMSW011"; //Shield of the Watch
    }
    else if(GetLevelByClass(CLASS_TYPE_BARD,oPC) > 0)
    {
        sItemTemplate = "NW_IT_MGLOVE005"; //Gloves of the Minstrel
    }
    else if(GetLevelByClass(CLASS_TYPE_DRUID,oPC) > 0 ||
            GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN,oPC) > 0)
    {
        sItemTemplate = "NW_ASHMSW010"; //Shield of Dawn
    }
    else if(GetLevelByClass(CLASS_TYPE_MONK,oPC) > 0)
    {
        sItemTemplate = "nw_it_mboots018"; //Boots of the sun soul
    }
    else if(GetLevelByClass(CLASS_TYPE_SAMURAI,oPC) > 0 ||
            GetLevelByClass(CLASS_TYPE_CW_SAMURAI,oPC) > 0 ||
	    GetLevelByClass(CLASS_TYPE_TRUENAMER,oPC) > 0 ||
            GetLevelByClass(CLASS_TYPE_SHAMAN,oPC) > 0 ||
	    GetLevelByClass(CLASS_TYPE_SCOUT,oPC) > 0 ||
            GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER,oPC) > 0 ||
            GetLevelByClass(CLASS_TYPE_RANGER,oPC) > 0)
    {
        sItemTemplate = "NW_IT_MBELT011"; //Archer's Belt
    }
    else if(GetLevelByClass(CLASS_TYPE_NINJA,oPC) > 0 ||
            GetLevelByClass(CLASS_TYPE_SWASHBUCKLER,oPC) > 0 ||
            GetLevelByClass(CLASS_TYPE_SOULKNIFE,oPC) > 0 ||
            GetLevelByClass(CLASS_TYPE_HEXBLADE,oPC) > 0 ||
            GetLevelByClass(CLASS_TYPE_BOWMAN,oPC) > 0 ||
            GetLevelByClass(CLASS_TYPE_PSYCHIC_ROGUE,oPC) > 0 ||
            GetLevelByClass(CLASS_TYPE_ROGUE,oPC) > 0)
    {
        sItemTemplate = "nw_it_mglove009"; //Gloves of Swordplay
    }
    else
    {
        sItemTemplate = "NW_AARCL006"; //HalfPlate
    }
    object oItem = CreateItemOnObject(sItemTemplate);
    SetIdentified(oItem,TRUE);
}
