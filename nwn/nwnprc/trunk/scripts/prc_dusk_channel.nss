//::///////////////////////////////////////////////
//:: Name       Duskblade Channel
//:: FileName   prc_dusk_channel
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is the instant feat to toggle it on/off
*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor   
//:: Created On: 23/09/06
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_ipfeat_const"

void DisableDuskbladeChanneling()
{
    object oPC = OBJECT_SELF;
    int nValue = GetLocalInt(oPC, "DuskbladeChannelActive");
    //not on, abort
    if(!nValue)
        return;
    //its on, turn it off    
    DeleteLocalInt(oPC, "DuskbladeChannelActive");
    //remove bonusfeats
    object oSkin = GetPCSkin(oPC);
    itemproperty ipTest = GetFirstItemProperty(oSkin);
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT
            && (GetItemPropertySubType(ipTest) == IP_CONST_IMP_CC
                || GetItemPropertySubType(ipTest) == IP_CONST_FEAT_EPIC_AUTO_QUICKEN_I
                || GetItemPropertySubType(ipTest) == IP_CONST_FEAT_EPIC_AUTO_QUICKEN_II
                || GetItemPropertySubType(ipTest) == IP_CONST_FEAT_EPIC_AUTO_QUICKEN_III))
        {
            RemoveItemProperty(oSkin, ipTest);
        }
        ipTest = GetNextItemProperty(oSkin);
    }
    //send a message
    FloatingTextStringOnCreature("Duskblade Channeling Deactivated", oPC, FALSE);
}

void main()
{
    //get current value
    object oPC = OBJECT_SELF;
    int nValue = GetLocalInt(oPC, "DuskbladeChannelActive");
    if(nValue)
    {
        DisableDuskbladeChanneling();
    }   
    else
    {
        //its off, turn it on
        SetLocalInt(oPC, "DuskbladeChannelActive", TRUE);
        object oSkin = GetPCSkin(oPC);
        //give Epic Combat Casting to avoid AoOs
        itemproperty ipTest = PRCItemPropertyBonusFeat(IP_CONST_IMP_CC);
        IPSafeAddItemProperty(oSkin, ipTest, 60.0);
        //auto-quicken all spells so the casting and attacking is the same action
        ipTest = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_QUICKEN_I);
        IPSafeAddItemProperty(oSkin, ipTest, 60.0);
        ipTest = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_QUICKEN_II);
        IPSafeAddItemProperty(oSkin, ipTest, 60.0);
        ipTest = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_QUICKEN_III);
        IPSafeAddItemProperty(oSkin, ipTest, 60.0);
        //send a message
        FloatingTextStringOnCreature("Duskblade Channeling Activated", oPC, FALSE);
        
        //disable after 1 minute
        DelayCommand(60.0, DisableDuskbladeChanneling());
    }
}