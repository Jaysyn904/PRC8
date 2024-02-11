/*
31/1/21 by Stratovarius

Psion-Killer Mask
Descriptor: None
Classes: Totemist
Chakra: Brow (totem)
Saving Throw: None

Chakra Bind (Totem)

Your face is covered in crystal facets that now grow down to your chest and shoulders. As the crystal covers your face, you can almost taste and smell the psionic energy in the air, and if you extend your crystal tongue, the air tastes sweet and strong -- almost like a liqueur.

You can emit a crimson ray from the mouth of your psion-killer mask to make a ranged touch attack as a standard action. 

If you hit with the ray, you deal no damage but temporarily suppress the opponent's primary weapon, if any, for ten rounds.
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void SuppressItem(object oTrueSpeaker, object oTarget, int nBeats);

object GetChest(object oCreature)
{
    object oChest = GetObjectByTag("npf_chest" + ObjectToString(oCreature));
    if(oChest == OBJECT_INVALID)
    {
        object oWP = GetWaypointByTag("npf_wp_chest_sp");
        oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "npf_keep_chest", GetLocation(oWP), FALSE,
                    "npf_chest" + ObjectToString(oCreature));
    }
    return oChest;
}

void RemoveAllProperties(object oItem, object oPC)
{
    if(DEBUG) DoDebug("ture_utr_supitem: About to remove properties from item: " + DebugObject2Str(oItem));

    if(oItem == OBJECT_INVALID)
        return;

    int nType = GetBaseItemType(oItem);
    if(nType == BASE_ITEM_TORCH
    || nType == BASE_ITEM_TRAPKIT
    || nType == BASE_ITEM_HEALERSKIT
    || nType == BASE_ITEM_GRENADE
    || nType == BASE_ITEM_THIEVESTOOLS
    || nType == BASE_ITEM_CRAFTMATERIALMED
    || nType == BASE_ITEM_CRAFTMATERIALSML
    || nType == 112)//craftbase
        return;

    object oWP = GetWaypointByTag("npf_wp_chest_sp");

    // Generate UID
    int nKey = GetLocalInt(GetModule(), "PRC_NullPsionicsField_Item_UID_Counter") + 1;
               SetLocalInt(GetModule(), "PRC_NullPsionicsField_Item_UID_Counter", nKey);
    string sKey = IntToString(nKey);
    if(DEBUG) DoDebug("prc_pow_npfent: Removing itemproperties from item " + DebugObject2Str(oItem) + " with key value of '" + sKey + "' of creature " + DebugObject2Str(oPC));

    //object oChest = GetChest(oPC);
    //object oCopy = CopyObject(oItem, GetLocation(oChest), oChest);

    // copying  original item to a secluded waypoint in the area
    // and giving it a tag that contains the key string
    object oCopy = CopyObject(oItem, GetLocation(oWP), OBJECT_INVALID, "npf_item" + sKey);

    //storing the key value on the original item (key value would point to the copy item)
    SetLocalString(oItem, "PRC_NullPsionicsField_Item_UID", sKey);

    //SetLocalObject(oItem, "ITEM_CHEST", oChest); // so the chest can be found
    //SetLocalObject(oChest, sKey, oCopy); // and referenced in the chest

    // Stripping original item from all properties
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
        RemoveItemProperty(oItem, ip);
        ip = GetNextItemProperty(oItem);
    }
}

void RestoreAllProperties(object oItem, object oPC, int nSlot = -1)
{
    if(DEBUG) DoDebug("psi_pow_npfext: Attempting to restore itemproperties to: " + DebugObject2Str(oItem));
    
    if(oPC != OBJECT_INVALID) // this is a pc object that has an item in inventory slot or normal inventory
    {
        if(oItem == OBJECT_INVALID)
            oItem = GetItemInSlot(nSlot, oPC);
        if(oItem == OBJECT_INVALID)
            return;
    }
    //object oChest = GetLocalObject(oItem, "ITEM_CHEST");
    // getting the key value - this points to the tag of the copy item
    string sKey = GetLocalString(oItem, "PRC_NullPsionicsField_Item_UID");
    // retrieving the copy item that is in this area
    object oOriginalItem = GetObjectByTag("npf_item" + sKey);
    if(DEBUG) DoDebug("psi_pow_npfext: Restoring itemproperties to item: " + DebugObject2Str(oItem) + " with key value of '" + sKey + "' for creature " + DebugObject2Str(oPC));

    //object oOriginalItem = GetLocalObject(oChest, sKey);

    object oNewItem;
    if(oOriginalItem != OBJECT_INVALID) // item has not been restored yet
    {
        // replace current item with original
        IPCopyItemProperties(oOriginalItem, oItem);
        DestroyObject(oOriginalItem); // destroy dup item on player
        //DeleteLocalObject(oChest, GetResRef(oItem)); // so it won't be restored again
        DeleteLocalString(oItem, "PRC_NullPsionicsField_Item_UID");
    }
}

void SuppressItem(object oTrueSpeaker, object oTarget, int nBeats)
{
	// Break if they fail concentration or it runs out
	if (GetBreakConcentrationCheck(oTrueSpeaker) || nBeats == 0) return;

	// Remove and restore the properties
	RemoveAllProperties(oTarget, GetItemPossessor(oTarget));
	// Has to run before RemoveAll is called again
	DelayCommand(5.8, RestoreAllProperties(oTarget, GetItemPossessor(oTarget)));
	
	// Apply VFX
	effect eImp = EffectVisualEffect(VFX_IMP_PULSE_BOMB);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, GetItemPossessor(oTarget));
	
	DelayCommand(6.0, SuppressItem(oTrueSpeaker, oTarget, nBeats - 1));
}

void main()
{
	object oMeldshaper = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
    if(PRCDoRangedTouchAttack(oTarget))
    {
    	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    	if (GetIsObjectValid(oItem))
    		SuppressItem(oMeldshaper, oItem, 10);
    }
}

