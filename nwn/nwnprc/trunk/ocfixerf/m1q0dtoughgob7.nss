// Added compatibility for PRC base classes
#include "prc_class_const"
#include "prc_alterations"

//This will create a tresure item based on the class of the PC
//that killed this creature
void main()
{
    string sItemTemplate;
    object oPC = GetLastKiller();
    object oMaster = GetMaster(oPC);
    int nStack = 1;
    if(GetIsObjectValid(oMaster))
    {
        oPC = oMaster;
    }
    if(GetLevelByClass(CLASS_TYPE_CLERIC,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_MYSTIC,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_TRUENAMER,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_WARLOCK,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_SHAMAN,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_HEALER,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_WITCH,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_ARCHIVIST,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_TEMPLAR,oPC) > 0 ||
       GetLevelByClass(CLASS_TYPE_DRUID,oPC) > 0 )
    {
        sItemTemplate = "NW_IT_MGLOVE004"; //Gloves of concentration
    }
    else if(GetLevelByClass(CLASS_TYPE_SORCERER,oPC) > 0 ||
          GetLevelByClass(CLASS_TYPE_WARMAGE,oPC) > 0 ||
          GetLevelByClass(CLASS_TYPE_SHADOWCASTER,oPC) > 0 ||
          GetLevelByClass(CLASS_TYPE_WIZARD,oPC) > 0 )
    {
        sItemTemplate = "m1q0wmgwn"; //Wand of Fire
    }
    else if(GetLevelByClass(CLASS_TYPE_BARD,oPC) > 0)
    {
        sItemTemplate = "NW_ASHMSW011"; //Shield of the dawn
    }
    else if(GetLevelByClass(CLASS_TYPE_MONK,oPC) > 0)
    {
        sItemTemplate = "NW_MAARCL098"; //Cloak of Protection vs Chaos
    }
    else if(GetLevelByClass(CLASS_TYPE_BOWMAN,oPC) > 0 ||
      GetLevelByClass(CLASS_TYPE_SCOUT,oPC) > 0 ||
      GetLevelByClass(CLASS_TYPE_PSYCHIC_ROGUE,oPC) > 0 ||
      GetLevelByClass(CLASS_TYPE_ROGUE,oPC) > 0)
    {
        sItemTemplate = "nw_wammar004"; //Arrows of peircing
        nStack = 10;
    }
    else
    {
        sItemTemplate = "NW_IT_MGLOVE008"; //Gloves of discipline
    }
    object oItem = CreateItemOnObject(sItemTemplate,OBJECT_SELF,nStack);
    SetIdentified(oItem,TRUE);


}
