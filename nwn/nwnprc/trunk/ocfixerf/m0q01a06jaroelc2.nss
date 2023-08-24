// Added compatibility for PRC base classes
#include "prc_class_const"

void main()
{
    object oPC = GetPCSpeaker();
    if(GetLevelByClass(CLASS_TYPE_ARTIFICER, oPC)
    || GetLevelByClass(CLASS_TYPE_BEGUILER, oPC)
    || GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, oPC)
    || GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oPC)
    || GetLevelByClass(CLASS_TYPE_DUSKBLADE, oPC)
    || GetLevelByClass(CLASS_TYPE_HEXBLADE, oPC)
    || GetLevelByClass(CLASS_TYPE_PSION, oPC)
    || GetLevelByClass(CLASS_TYPE_PSYWAR, oPC)
    || GetLevelByClass(CLASS_TYPE_WARLOCK, oPC)
    || GetLevelByClass(CLASS_TYPE_WARMAGE, oPC)
    || GetLevelByClass(CLASS_TYPE_WILDER, oPC)
    || GetLevelByClass(CLASS_TYPE_WITCH, oPC))
    {
        // "PRC note: Though Jaroo will not say so, you may pass his test by using a spell or a power to destroy the statue."
        FloatingTextStrRefOnCreature(0x01000000 + 49455 , oPC, FALSE);

        // Give Ray of Frost scroll
        object oScroll = CreateItemOnObject("nw_it_sparscr002", oPC);
        // Remove all class restrictions from the scroll
        itemproperty ipTest = GetFirstItemProperty(oScroll);
        while(GetIsItemPropertyValid(ipTest))
        {
            if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_CLASS)
                RemoveItemProperty(oScroll, ipTest);

            ipTest = GetNextItemProperty(oScroll);
        }
    }
    SetLocalInt(OBJECT_SELF,"NW_L_TALKLEVEL",2);
}

