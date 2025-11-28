//::///////////////////////////////////////////////
//:: Warforged Armor Restrictions
//:: race_warforged.nss
//::///////////////////////////////////////////////
/*
    Handles restrictions on warforged armor-equipping
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 12, 2008
//:: Updated by: Jaysyn
//:: Updated on: 2025-11-25 10:48:32
//:://////////////////////////////////////////////
#include "prc_alterations"

void CreateWarforgedArmor(object oPC)
{
    object oArmor;
    object oHelm;
    //object oFeatHide = CreateItemOnObject("prc_wf_feats", oPC);

    if(GetHasFeat(FEAT_IRONWOOD_PLATING, oPC))
    {
        oArmor = CreateItemOnObject("prc_wf_woodbody", oPC);
        oHelm = CreateItemOnObject("prc_wf_helmwood", oPC);
    }
    else if(GetHasFeat(FEAT_MITHRIL_PLATING, oPC))
    {
        oArmor = CreateItemOnObject("prc_wf_mithbody", oPC);
        oHelm = CreateItemOnObject("prc_wf_helmmith", oPC);
    }
    else if(GetHasFeat(FEAT_ADAMANTINE_PLATING, oPC))
    {
        oArmor = CreateItemOnObject("prc_wf_admtbody", oPC);
        oHelm = CreateItemOnObject("prc_wf_helmadmt", oPC);
    }
    else if(GetHasFeat(FEAT_UNARMORED_BODY, oPC))
    {
        oArmor = CreateItemOnObject("prc_wf_unacbody", oPC);
        oHelm = CreateItemOnObject("prc_wf_helmhead", oPC);
    }
    else if(GetHasFeat(FEAT_COMPOSITE_PLATING, oPC))
    {
        oArmor = CreateItemOnObject("prc_wf_compbody", oPC);
        oHelm = CreateItemOnObject("prc_wf_helmhead", oPC);
    }

    SetDroppableFlag(oArmor, FALSE);
    SetItemCursedFlag(oArmor, TRUE);
    SetDroppableFlag(oHelm, FALSE);
    SetItemCursedFlag(oHelm, TRUE);        

    //:: Force equip
    DelayCommand(1.0, AssignCommand(oPC, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST)));
    DelayCommand(1.0, AssignCommand(oPC, ActionEquipItem(oHelm, INVENTORY_SLOT_HEAD)));
}

void DoWarforgedCheck(object oPC)
{
    if(!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC)))
        AssignCommand(oPC, ActionEquipItem(GetItemPossessedBy(oPC, "prc_wf_helmhead"), INVENTORY_SLOT_HEAD));

    if(!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)))
        AssignCommand(oPC, ActionEquipItem(GetItemPossessedBy(oPC, "prc_wf_unacbody"), INVENTORY_SLOT_CHEST));
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("race_warforged running, event: " + IntToString(nEvent));

    //:: Init the PC.
    object oPC = OBJECT_SELF;
    object oItem;
    object oArmor;
    object oSkin;

    //:: We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
         oPC = OBJECT_SELF;
         int nArmorExists = GetIsObjectValid(GetItemPossessedBy(oPC, "prc_wf_unacbody"))
                         || GetIsObjectValid(GetItemPossessedBy(oPC, "prc_wf_woodbody"))
                         || GetIsObjectValid(GetItemPossessedBy(oPC, "prc_wf_mithbody"))
                         || GetIsObjectValid(GetItemPossessedBy(oPC, "prc_wf_admtbody"))
                         || GetIsObjectValid(GetItemPossessedBy(oPC, "prc_wf_compbody"));
        //:: Hook in the events
        if(DEBUG) DoDebug("race_warforged: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONHEARTBEAT, "race_warforged", TRUE, FALSE);
        //may not be needed, put in just in case(ala HotU start)
        AddEventScript(oPC, EVENT_ONUNAQUIREITEM, "race_warforged", TRUE, FALSE);

        if(!nArmorExists)
        {
            CreateWarforgedArmor(oPC);
        }
    }
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
        oSkin = GetPCSkin(oPC);

        if(DEBUG) DoDebug("race_warforged - OnHeartbeat");

        if(GetHasFeat(FEAT_IRONWOOD_PLATING, oPC))
        {
            if (!GetHasFeat(FEAT_ARMOR_PROFICIENCY_LIGHT, oPC))
            {
                //Add proficiency
                itemproperty ipIP = ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_LIGHT);
                IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
                if(DEBUG) DoDebug("race_warforged - ironwood - adding item property "+ItemPropertyToString(ipIP));
            }    
            //:: Force equip
            oItem = GetItemPossessedBy(oPC, "prc_wf_woodbody");
            if (oItem != GetItemInSlot(INVENTORY_SLOT_CHEST, oPC))
                AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST)); 
        }
        else if(GetHasFeat(FEAT_MITHRIL_PLATING, oPC))
        {
            if (!GetHasFeat(FEAT_ARMOR_PROFICIENCY_LIGHT, oPC))
            {
                //Add proficiency
                itemproperty ipIP = ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_LIGHT);
                IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
                if(DEBUG) DoDebug("race_warforged - mithril - adding item property "+ItemPropertyToString(ipIP));
            }    
            //:: Force equip
            oItem = GetItemPossessedBy(oPC, "prc_wf_mithbody");
            if (oItem != GetItemInSlot(INVENTORY_SLOT_CHEST, oPC))
                AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST)); 
        }        
        else if(GetHasFeat(FEAT_ADAMANTINE_PLATING, oPC))
        {
            if (!GetHasFeat(FEAT_ARMOR_PROFICIENCY_HEAVY, oPC))
            {
                //Add proficiency
                itemproperty ipIP = ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_HEAVY);
                IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
                if(DEBUG) DoDebug("race_warforged - adamantine - adding item property "+ItemPropertyToString(ipIP));
            }    
            //:: Force equip
            oItem = GetItemPossessedBy(oPC, "prc_wf_admtbody");
            if (oItem != GetItemInSlot(INVENTORY_SLOT_CHEST, oPC))
                AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST)); 
        }  
        else if(GetHasFeat(FEAT_COMPOSITE_PLATING, oPC))
        {
            //:: Force equip
            oItem = GetItemPossessedBy(oPC, "prc_wf_compbody");
            if (oItem != GetItemInSlot(INVENTORY_SLOT_CHEST, oPC))
                AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));            
        }

        //:: Delay a bit to make sure they are appropriately dressed
        DelayCommand(0.5f, DoWarforgedCheck(oPC)); 
    }
    else if(nEvent == EVENT_ONUNAQUIREITEM)
    {
        if(DEBUG) DoDebug("race_warforged: OnUnAcquire");
        object oItem = GetModuleItemLost();
        if(GetStringLeft(GetTag(oItem), 7) == "prc_wf_")
        {
            if(DEBUG) DoDebug("Destroying lost warforged stuff");
            MyDestroyObject(oItem);
        }

        //recreates armor after 1 second to avoid triggering any infinite loops from HotU-type scripts
        DelayCommand(1.0, CreateWarforgedArmor(oPC));
    }
}