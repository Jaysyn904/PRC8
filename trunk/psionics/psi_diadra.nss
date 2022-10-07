//:://////////////////////////////////////////////////////////////
//:: Diamond Dragon
//:: psi_diadra.nss
//:://///////////////////////////////////////////////////////////
//:: Applies the passive bonuses from Diamond Dragon, and handles
//:: cleanup from the Channel Wings and Tail feats.
//:://///////////////////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 15, 2007
//:://///////////////////////////////////////////////////////////

#include "prc_ipfeat_const"
#include "prc_x2_itemprop"
#include "inc_item_props"

//removes channeled wings after relogging or server restart
void WingCorrection(object oPC, int nEvent)
{
    if(GetCreatureWingType(oPC) != PRC_WING_TYPE_DRAGON_SILVER) 
        return;
    int nChanneled = GetPersistantLocalInt(oPC, "ChannelingWings");
    if(nChanneled)
    {
        SetPersistantLocalInt(oPC, "ChannelingWings", FALSE);
        SetCreatureWingType(CREATURE_WING_TYPE_NONE, oPC);
    }

}

//removes channeled tails after relogging or server restart
void TailCorrection(object oPC, int nEvent)
{
    if(GetCreatureWingType(oPC) != PRC_TAIL_TYPE_DRAGON_SILVER) 
        return;
    int nChanneled = GetPersistantLocalInt(oPC, "ChannelingTail");
    if(nChanneled)
    {
        SetPersistantLocalInt(oPC, "ChannelingTail", FALSE);
        SetCreatureTailType(CREATURE_TAIL_TYPE_NONE, oPC);
    }
}

void main()
{

    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("psi_diadra running, event: " + IntToString(nEvent));

    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    //No event, being called from PRCEvalFeats
    if(nEvent == FALSE)
    {
        //hook the script in to automatically check for tails or wings that need removing
        AddEventScript(oPC, EVENT_ONCLIENTENTER, "psi_diadra", TRUE, FALSE);

        //Dragon Augmentation feat handling
        int iTest, nBonus, nDiff;

        //Strength Augmentation feats
        iTest = GetPersistantLocalInt(oPC, "NWNX_DiaDragStr");
        nBonus = GetHasFeat(FEAT_DRAGON_AUGMENT_STR_1, oPC) ? 1 : 0;
        nBonus = GetHasFeat(FEAT_DRAGON_AUGMENT_STR_2, oPC) ? 2 : nBonus;
        nBonus = GetHasFeat(FEAT_DRAGON_AUGMENT_STR_3, oPC) ? 3 : nBonus;
        nDiff = nBonus - iTest;

        if(nDiff != 0)
             SetCompositeBonus(oSkin, "DrAug_STR", nBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);

        //Dex Augmentation feats
        iTest = GetPersistantLocalInt(oPC, "NWNX_DiaDragDex");
        nBonus = GetHasFeat(FEAT_DRAGON_AUGMENT_DEX_1, oPC) ? 1 : 0;
        nBonus = GetHasFeat(FEAT_DRAGON_AUGMENT_DEX_2, oPC) ? 2 : nBonus;
        nBonus = GetHasFeat(FEAT_DRAGON_AUGMENT_DEX_3, oPC) ? 3 : nBonus;
        nDiff = nBonus - iTest;

        if(nDiff != 0)
             SetCompositeBonus(oSkin, "DrAug_DEX", nBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_DEX);

        //Con Augmentation feats
        iTest = GetPersistantLocalInt(oPC, "NWNX_DiaDragCon");
        nBonus = GetHasFeat(FEAT_DRAGON_AUGMENT_CON_1, oPC) ? 1 : 0;
        nBonus = GetHasFeat(FEAT_DRAGON_AUGMENT_CON_2, oPC) ? 2 : nBonus;
        nBonus = GetHasFeat(FEAT_DRAGON_AUGMENT_CON_3, oPC) ? 3 : nBonus;
        nDiff = nBonus - iTest;

        if(nDiff != 0)
             SetCompositeBonus(oSkin, "DrAug_CON", nBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
    }

    //Every heartbeat, perform wing and tail status checks to see if they expired
    if(nEvent == EVENT_ONCLIENTENTER)
    {
        WingCorrection(oPC, nEvent);
        TailCorrection(oPC, nEvent);
    }
}
