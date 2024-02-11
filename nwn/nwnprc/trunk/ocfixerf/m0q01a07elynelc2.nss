#include "prc_class_const"

void main()
{
    object oPC = GetPCSpeaker();
    if(GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC)
    || GetLevelByClass(CLASS_TYPE_MYSTIC, oPC)
    || GetLevelByClass(CLASS_TYPE_SHUGENJA, oPC))
    {
        // Give scroll of Cure Minor wounds
        object oScroll = CreateItemOnObject("x2_it_spdvscr001", oPC);
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
    SetLocalInt(GetModule(),"NW_G_M0Q01_PRIEST_TEST",1);
}

