//:://////////////////////////////////////////////
//:: prc_uni_shift
//:: Universal class script for classes that allow shifting
//:: (to prevent having to duplicate and install a script like this for each such class)
//:://////////////////////////////////////////////

#include "prc_inc_shifting"
#include "prc_spell_const"
#include "prc_inc_onhit"

const string SCRIPT_NAME = "prc_uni_shift";
const string SHIFTER_LEVELLING_ARRAY = "PRC_Shifter_Levelling_Array";
const string SHIFTER_SHAPE_LEARNED_LEVEL = "PRC_Shifter_AutoGranted";

void HandleShapeLearning(object oPC)
{
    if (GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oPC))
    {
        if(!persistant_array_exists(oPC, SHIFTER_LEVELLING_ARRAY))
            persistant_array_create(oPC, SHIFTER_LEVELLING_ARRAY);

        int nLearnedLevel = GetPersistantLocalInt(oPC, SHIFTER_SHAPE_LEARNED_LEVEL);
        int nShifterLevel = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oPC);
        int nCharacteLevel = GetHitDice(oPC);
        int i;
        for(i = nLearnedLevel; i < nShifterLevel; i++)
            persistant_array_set_int(oPC, SHIFTER_LEVELLING_ARRAY, i, nCharacteLevel - (nShifterLevel-1-i));
    }
}

void AddEvents(object oPC)
{
    if (AddEventScript(oPC, EVENT_ONPLAYERLEVELUP, SCRIPT_NAME, TRUE, FALSE))
    {
        //If we're just adding the level up script, run the level-up function to let it "catch up" if necessary:
        //the level-up event hook may not be called for Shifter level 1 because the PC isn't a Shifter until
        //after the level-up for that level has been completed.
        HandleShapeLearning(oPC);
    }
    AddEventScript(oPC, EVENT_ONPLAYERLEVELDOWN, SCRIPT_NAME, TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONHIT, SCRIPT_NAME, TRUE, FALSE);    
}

void HandleEquip(object oPC, object oEquippedItem)
{
    int bAddOnHitUniquePower = FALSE;
    
    if (oEquippedItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC))
        bAddOnHitUniquePower = TRUE;
    else if (oEquippedItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC))
        bAddOnHitUniquePower = TRUE;
    else if (oEquippedItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC))
        bAddOnHitUniquePower = TRUE;
    else if (oEquippedItem == GetItemInSlot(INVENTORY_SLOT_ARMS, oPC))
    {
        //Gloves or bracers (this doesn't actually work for bracers, however: 
        //apparently you can't add an OnHit: Cast Spell property to bracers)
        bAddOnHitUniquePower = TRUE;
    }
    else if (oEquippedItem == GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC))
        bAddOnHitUniquePower = TRUE;
    
    if (bAddOnHitUniquePower && !GetLocalInt(oPC, "prc_uni_shift_suppress_onhit"))
        Add_OnHitUniquePower(oEquippedItem, SCRIPT_NAME);
}

void HandleUnequip(object oPC, object oUnequippedItem)
{
    //Just call the remove function. If we haven't added, the signature check will prevent the remove.
    Remove_OnHitUniquePower(oUnequippedItem, SCRIPT_NAME);
}

void HandleOnHit(object oPC, object oItem, object oTarget)
{
    //Fire all OnHit properties on creature items and skin
    //(normally just the first will fire)
    
    //NOTE: this event only fires for items to which the shifting code 
    //has added the item property On Hit Cast Spell: Unique Power
    
    if (GetLocalInt(oItem, PRC_CUSTOM_ONHIT_SIGNATURE + SCRIPT_NAME))
    {
        if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, oPC) && oItem != GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC))
        {
            SetLocalInt(oItem, "PRC_SOULEATER_ONHIT_ENERGYDRAIN", TRUE);
            DelayCommand(0.0f, DeleteLocalInt(oItem, "PRC_SOULEATER_ONHIT_ENERGYDRAIN"));
            CastSpellAtObject(SPELL_SE_ENERGY_DRAIN, oTarget, METAMAGIC_NONE, 0, 0, 0, oItem, oPC);
        }

        ApplyAllOnHitCastSpellsOnItemExcludingSubType(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, oTarget, oItem, oPC);
           //NOTE: may not work correctly with spells not converted to use PRC functions (as detailed in prc_inc_onhit.nss)?
    }
}

void HandleDefault(object oPC)
{
    AddEvents(oPC);

    if(GetLocalInt(oPC,"ONEQUIP")) //2 = equip, 1 = unequip
    {
        if (GetLocalInt(oPC,"ONEQUIP") == 2)
            HandleEquip(oPC, GetItemLastEquipped());
        else if (GetLocalInt(oPC,"ONEQUIP") == 1)
            HandleUnequip(oPC, GetItemLastUnequipped());
    }
    else if(GetLocalInt(oPC,"ONREST"))
    {
        HandleShapeLearning(oPC); //Do this on resting in case it fails to fire where it should for some reason
        HandleApplyShiftEffects(oPC);
    }

    HandleTrueShape(oPC);
    HandleApplyShiftTemplate(oPC);
}

void main()
{
    int nEvent = GetRunningEvent();
    if(nEvent == FALSE) //We aren't being called from any event, instead from EvalPRCFeats
        HandleDefault(OBJECT_SELF);
    else if(nEvent == EVENT_ONPLAYERLEVELUP)
        HandleShapeLearning(GetPCLevellingUp());
    else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
        HandleShapeLearning(OBJECT_SELF);
    else if(nEvent == EVENT_ONHIT)
        HandleOnHit(OBJECT_SELF, PRCGetSpellCastItem(), PRCGetSpellTargetObject());
}
