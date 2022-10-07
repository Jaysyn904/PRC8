/*
    ----------------
    Suppress Item

    true_utr_supitem
    ----------------

    12/8/06 by Stratovarius
*/ /** @file

    Suppress Item

    Level: Crafted Tool 4
    Range: 60 feet
    Target: One Magic Item
    Duration: 1 Round, up to five concentration
    Spell Resistance: Yes
    Metautterances: Extend

    Your focus on a magic item keeps it from functioning, turning it grey and rendering it useless.
    You prevent any magic properties of the item from functioning.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

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

void main()
{
/*
  Spellcast Hook Code
  Added 2006-7-19 by Stratovarius
  If you want to make changes to all utterances
  check true_utterhook to find out more

*/

    if (!TruePreUtterCastCode())
    {
    // If code within the PreUtterCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oTrueSpeaker = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    oTarget             = CraftedToolTarget(oTrueSpeaker, oTarget);
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_EXTEND, LEXICON_CRAFTED_TOOL);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        utter.fDur       = RoundsToSeconds(5);
        if(utter.bExtend) utter.fDur *= 2;

	int nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
	if (!nSRCheck)
        {  
        	// Convert back to rounds
        	int nBeats = FloatToInt(utter.fDur / 6.0);
		SuppressItem(oTrueSpeaker, oTarget, nBeats);
    	}
        
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        if (!nSRCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
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