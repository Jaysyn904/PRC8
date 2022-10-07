/*:://////////////////////////////////////////////
//:: Name Componants include file (gems, specific items of tags etc)
//:: FileName SMP_INC_COMPNENT
//:://////////////////////////////////////////////
    This include file is meant for spells needing
    an item to cast it. It will check the inventory
    for any item of the right value (using pre-set items).

    It checks, and removes the items. Use this line to check:

    if(SMP_SpellItemCheck(iID, sNAME, iVALUE))

    To check the spells ID.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: July+
//::////////////////////////////////////////////*/
/*
    (currently unused)
    NW_IT_GEM001 - 7 - Greenstone
    NW_IT_GEM007 - 8 - Malachite
    NW_IT_GEM002 - 10 - Fire Agate
    NW_IT_GEM004 - 20 - Phenalope
    NW_IT_GEM014 - 20 - Aventurine
    NW_IT_GEM003 - 40 - Amethyst
    NW_IT_GEM015 - 50 - Fluorspar
    NW_IT_GEM011 - 120 - Garnet
    NW_IT_GEM013 - 145 - Alexandrite
    NW_IT_GEM010 - 250 - Topaz
    NW_IT_GEM008 - 1000 - Sapphire
    NW_IT_GEM009 - 1500 - Fire Opal
    NW_IT_GEM005 - 2000 - Diamond  (THIS MAY BE USED DIRECTLY FOR PROT. SPELLS)
    NW_IT_GEM006 - 3000 - Ruby
    NW_IT_GEM012 - 4000 - Emerald
*/

#include "SMP_INC_ARRAY"

// SMP_INC_COMPNENT. MAIN CALL. This should use the others (in most cases!). This will use nSpellId
// to check for components in a custom 2da, as well as XP and focus items too.
// * Returns TRUE if check is passed.
int SMP_SpellComponentsHookCheck(object oCaster, int nSpellId);

// SMP_INC_COMPNENT. This is a break up of SMP_SpellComponentsHookCheck() for XP checks.
// * Returns TRUE if check is passed, and xp is removed.
int SMP_SpellComponentXPCheck(object oCaster, int nSpellId);

// SMP_INC_COMPNENT. This is a break up of SMP_SpellComponentsHookCheck() for
// physical component and gold checks.
// If bGoldOnly is TRUE, we only use the gold value, and the caster doesn't
// actually need the item.
// * Returns TRUE if check is passed, and gold/item is removed.
int SMP_SpellComponentGoldCheck(object oCaster, int nSpellId, int bGoldOnly = FALSE);

// SMP_INC_COMPNENT. This is a break up of SMP_SpellComponentsHookCheck() for focus checks.
// * Returns TRUE if check is passed.
int SMP_SpellComponentFocusCheck(object oCaster, int nSpellId);

// SMP_INC_COMPNENT. This will return TRUE if the caster has an item (gem) of that value.
// Can use more then one gem, if possible.
// * Returns TRUE if they are using an item!
// It will be destroyed in the process. The lowest (ones) are chosen. PCs only!
//    It also notified the gems destruction.
//    * sName is the spells name, nItemValue is the gem(s) value.
//    * If sGemName is used, it only looks at items with sGemName.
// Lines:
// PASS: "You have lost a material componant (" + GetName(oLowest) + ") required for casting " + sName + "."
// FAIL: "You have not got a gem, valued at " + IntToString(nItemValue) + " required for your spell. It has dispissiated."
int SMP_ComponentItemGemCheck(string sName, int nItemValue, string sGemName = "");
// SMP_INC_COMPNENT. Will perform a series of loops, trying to find nItemValue
// worth of sGemName gems, and if found, will destroy/remove them which it found.
// * TRUE if it finds, and destroys, the right gems.
int SMP_ComponentRemoveGemsOfValue(int nItemValue, string sGemName = "", object oTarget = OBJECT_SELF);

// SMP_INC_COMPNENT. Returns the lowest gem, used in protection from spells.
object SMP_ComponentLowestGemOfValue(int nItemValue, string sGemName, object oTarget);


// SMP_INC_COMPNENT. Returns TRUE if they possess an item of sTag.
// * Returns TRUE if they are using an item!
// * If FALSE - debugs using sItemName and sSpellName.
// Lines:
// FAIL: "You cannot cast " + sSpellName + ", without " + sItemName + "."
int SMP_ComponentExactItem(string sTag, string sItemName, string sSpellName, int nAmount = 1);
// SMP_INC_COMPNENT. Gets the item of string sTag, if valid, it removes it for the spell to work.
// * Returns TRUE if they are using an item!
// * Use for material comnents which get used up
// * If FALSE - debugs using sItemName and sSpellName.
// * TRUE if it removes the item.
// FAIL: "You cannot cast " + sSpellName + ", without " + sItemName + "."
int SMP_ComponentExactItemRemove(string sTag, string sItemName, string sSpellName);

// SMP_INC_COMPNENT. Gets the item of string sTag, if valid, it removes it for the spell to work.
// Requires the caster to be a bard, sorceror or wizard.
// * Returns TRUE if they are using an item!
// * Use for material comnents which get used up
// * If FALSE - debugs using sItemName and sSpellName.
// * TRUE if it removes the item.
// FAIL: "You cannot cast " + sSpellName + ", without " + sItemName + "."
int SMP_ComponentArcaneExactItemRemove(string sTag, string sItemName, string sSpellName);
// SMP_INC_COMPNENT. Returns TRUE if they have the correct focus item of sTag.
// * Focus items are not removed, they just are required to concentrate ETC.
// * If FALSE - debugs using sItemName and sSpellName.
// Lines:
// FAIL: "You require the focus item " + sItemName + " to cast " + sSpellName + ".";
// PASS: "You focus with the item " + sItemName + " to cast " + sSpellName + ".";
int SMP_ComponentFocusItem(string sTag, string sItemName, string sSpellName);
// SMP_INC_COMPNENT. Removes the item of sTag. 1 of them anyway.
void SMP_ComponentItemRemove(string sTag);
// SMP_INC_COMPNENT. Removes the item oItem, by 1, or destroys oTarget
void SMP_ComponentItemRemoveBy1(object oItem);
// SMP_INC_COMPNENT. Removes many items of sTag.
// * Up to nAmount of sTagged items.
// DO NOT USE ON STACKED ITEMS.
void SMP_ComponentItemRemoveMany(string sTag, int nAmount);

// SMP_INC_COMPNENT. Basically creates the item on the caster. Can be put in a delay, used to
// CreateItemOnObject(sResRef, oTarget, nStackSize);
void SMP_ComponentActionCreateObject(string sResRef, int nStackSize = 1, object oTarget = OBJECT_SELF);

// SMP_INC_COMPNENT. Checks if they have an amount of XP that will not lose them a level
// * Returns TRUE if they *can* lose nXP
int SMP_ComponentXPCheck(int nXP, object oTarget);
// SMP_INC_COMPNENT. Removes nXP from oTarget. Make sure this can happen
// without level loss with SMP_XPCheck.
void SMP_ComponentXPRemove(int nXP, object oTarget);

// SMP_INC_COMPNENT. Check for, and remove, nGold from oTarget
// * Returns TRUE if it happens.
// NOTE: Does both checking, and removing. No error checks here!
int SMP_ComponentGoldRemove(int nGold, object oTarget);

// MAIN CALL. This should use the others (in most cases!). This will use nSpellId
// to check for components in a custom 2da, and XP too.
// * Returns TRUE if check is passed.
int SMP_SpellComponentsHookCheck(object oCaster, int nSpellId)
{
    // Item focus check
    string sTag = SMP_ArrayGetString(SMP_2DA_NAME_SMP_COMPONENTS, "FocusTag", nSpellId);
    string sItemName = GetStringByStrRef(SMP_ArrayGetInteger(SMP_2DA_NAME_SMP_COMPONENTS, "ComponentName", nSpellId));
    string sSpellName = SMP_ArrayGetSpellName(nSpellId);
    if(sTag != "")
    {
        if(SMP_ComponentFocusItem(sTag, sItemName, sSpellName))
        {
            // Cannot cast - no focus present.
            return FALSE;
        }
    }

    // Check XP first.
    // Got it?
    int nXP = SMP_ArrayGetInteger(SMP_2DA_NAME_SMP_COMPONENTS, "BaseXPCost", nSpellId);
    if(nXP > 0)
    {
        if(!SMP_ComponentXPCheck(nXP, oCaster))
        {
            // Return FALSE
            return FALSE;
        }
    }
    // Check component too.
    sTag = SMP_ArrayGetString(SMP_2DA_NAME_SMP_COMPONENTS, "ComponentTag", nSpellId);
    // Check sTag
    if(sTag != "")
    {
        // Got it?
        if(!SMP_ComponentExactItem(sTag, sItemName, sSpellName))
        {
            return FALSE;
        }
    }
    // Got both then? Then remove both!
    if(sTag != "")
    {
        SMP_ComponentItemRemove(sTag);
    }
    if(nXP > 0)
    {
        SMP_ComponentXPRemove(nXP, oCaster);
    }
    return TRUE;
}

// This is a break up of SMP_SpellComponentsHookCheck() for XP checks.
// * Returns TRUE if check is passed, and xp is removed.
int SMP_SpellComponentXPCheck(object oCaster, int nSpellId)
{
    // Got it?
    int nXP = SMP_ArrayGetInteger(SMP_2DA_NAME_SMP_COMPONENTS, "BaseXPCost", nSpellId);
    if(nXP > 0)
    {
        // Check for amount
        if(!SMP_ComponentXPCheck(nXP, oCaster))
        {
            // Return FALSE
            return FALSE;
        }
        // Else, remove it
        SMP_ComponentXPRemove(nXP, oCaster);
        return TRUE;
    }
    // Not got it, or something like it isn't needed.
    return FALSE;
}

// This is a break up of SMP_SpellComponentsHookCheck() for physical component
// and gold checks.
// If bGoldOnly is TRUE, we only use the gold value, and the caster doesn't
// actually need the item.
// * Returns TRUE if check is passed, and gold/item is removed.
int SMP_SpellComponentGoldCheck(object oCaster, int nSpellId, int bGoldOnly = FALSE)
{
    // Gold only?
    if(bGoldOnly == TRUE)
    {
        // Check for gold amounts
        int nGold = SMP_ArrayGetInteger(SMP_2DA_NAME_SMP_COMPONENTS, "ComponentCost", nSpellId);
        if(nGold > 0)
        {
            // Check for gold
            if(!SMP_ComponentGoldRemove(nGold, oCaster))
            {
                // Error: Return FALSE
                return FALSE;
            }
        }
        // Else, return TRUE
        return TRUE;
    }
    else
    {
        // Check component.
        string sTag = SMP_ArrayGetString(SMP_2DA_NAME_SMP_COMPONENTS, "ComponentTag", nSpellId);
        // Check sTag
        if(sTag != "")
        {
            // Got it?
            string sItemName = GetStringByStrRef(SMP_ArrayGetInteger(SMP_2DA_NAME_SMP_COMPONENTS, "ComponentName", nSpellId));
            string sSpellName = SMP_ArrayGetSpellName(nSpellId);
            if(!SMP_ComponentExactItem(sTag, sItemName, sSpellName))
            {
                return FALSE;
            }
            SMP_ComponentItemRemove(sTag);
        }
        // No item, or item removed, return TRUE
        return TRUE;
    }
    // Error? Not got it, return FALSE
    return FALSE;
}

// This is a break up of SMP_SpellComponentsHookCheck() for focus checks.
// * Returns TRUE if check is passed.
int SMP_SpellComponentFocusCheck(object oCaster, int nSpellId)
{
    // Item focus check
    string sTag = SMP_ArrayGetString(SMP_2DA_NAME_SMP_COMPONENTS, "FocusTag", nSpellId);
    string sItemName = GetStringByStrRef(SMP_ArrayGetInteger(SMP_2DA_NAME_SMP_COMPONENTS, "ComponentName", nSpellId));
    string sSpellName = SMP_ArrayGetSpellName(nSpellId);
    if(sTag != "")
    {
        if(SMP_ComponentFocusItem(sTag, sItemName, sSpellName))
        {
            // Cannot cast - no focus present.
            return FALSE;
        }
    }
    // Passed check
    return TRUE;
}

// This will return TRUE if the caster has an item (gem) of that value.
// Can use more then one gem, if possible.
// * Returns TRUE if they are using an item!
// It will be destroyed in the process. The lowest (ones) are chosen. PCs only!
//    It also notified the gems destruction.
//    * sName is the spells name, nItemValue is the gem(s) value.
//    * If sGemName is used, it only looks at items with sGemName.
// Lines:
// PASS: "You have lost a material componant (" + GetName(oLowest) + ") required for casting " + sName + "."
// FAIL: "You have not got a gem, valued at " + IntToString(nItemValue) + " required for your spell. It has dispissiated."
int SMP_ComponentItemGemCheck(string sName, int nItemValue, string sGemName = "")
{
    // NPC's ignore it
    if(!GetIsPC(OBJECT_SELF)) return TRUE;
//        SendMessageToPC(OBJECT_SELF, "NPC Detected, does not use material componants");

    // Remove if we can, the right value gems
    if(SMP_ComponentRemoveGemsOfValue(nItemValue, sGemName))
    {
        // Display message, and return that they have done it.
        FloatingTextStringOnCreature("*You have lost gems, valued at " + IntToString(nItemValue) + ", required for casting " + sName + "*", OBJECT_SELF, FALSE);
        return TRUE;
    }
    // Else no item (or not enough) of the right value. Message it.
    FloatingTextStringOnCreature("*You have not gems, valued at " + IntToString(nItemValue) + ", required for " + sName + ". It has dispissiated*", OBJECT_SELF, FALSE);
    return FALSE;
}
// Will perform a series of loops, trying to find nItemValue worth of sGemName
// gems, and if found, will destroy/remove them which it found.
// * TRUE if it finds, and destroys, the right gems.
int SMP_ComponentRemoveGemsOfValue(int nItemValue, string sGemName = "", object oTarget = OBJECT_SELF)
{
    object oReturn = OBJECT_INVALID;
    object oGem = GetFirstItemInInventory(oTarget);
    int nValue, nValuePerGem, nCnt, nStacksUsed, nStack, nTotalSoFarValue,
        nNeeded, nLoopValue, nUsed, bBreak;
    while(GetIsObjectValid(oGem) && nTotalSoFarValue < nItemValue)
    {
        // Only check gems which can be sold.
        if(GetBaseItemType(oGem) == BASE_ITEM_GEM &&
          !GetPlotFlag(oGem) && GetIdentified(oGem) &&
        // Gem name
          (sGemName == "" || GetName(oGem) == sGemName))
        {
            // Get the gem(s) value
            nValue = GetGoldPieceValue(oGem);
            nStack = GetItemStackSize(oGem);
            bBreak = FALSE;
            nUsed = FALSE;

            // Get how many we need from this stack (or all of them!)
            // * Will these add enough to finish it?
            if(nValue + nTotalSoFarValue > nItemValue)
            {
                // Check how many we need
                nValuePerGem = nStack/nValue;

                // Is one enough?
                nNeeded = nItemValue - nTotalSoFarValue;

                // Check in loop
                for(nCnt = 1; (nCnt <= nStack && bBreak != TRUE); nCnt++)
                {
                    nLoopValue += nValuePerGem;

                    // Add value, and check
                    if(nLoopValue >= nNeeded)
                    {
                        nUsed = nCnt;
                        bBreak = TRUE;
                    }
                }
                // Check nUsed.
                if(nUsed != FALSE)
                {
                    // nLoop value is now nValue
                    nValue = nLoopValue;
                    // We used some, or all.
                    SetLocalInt(oGem, "SMP_GEM_TO_REMOVE", nUsed);
                }
                else
                {
                    // Use them all
                    SetLocalInt(oGem, "SMP_GEM_TO_REMOVE", nStack);
                }
            }
            else
            {
                // Use them all
                SetLocalInt(oGem, "SMP_GEM_TO_REMOVE", nStack);
            }
            // Correct gem, set to the local array, (might not be enough though)
            nStacksUsed++;
            SetLocalObject(OBJECT_SELF, "SMP_GEM_ARRAY" + IntToString(nStacksUsed), oGem);

            // Add the amount to the total we have found
            nTotalSoFarValue += nValue;
        }
        oGem = GetNextItemInInventory(oTarget);
    }
    // Check now - did we suceed?
    if(nTotalSoFarValue >= nItemValue)
    {
        // Passed - remove the gems
        for(nCnt = 1; nCnt <= nStacksUsed; nCnt++)
        {
            // Get the gem
            oGem = GetLocalObject(OBJECT_SELF, "SMP_GEM_ARRAY" + IntToString(nCnt));
            DeleteLocalObject(OBJECT_SELF, "SMP_GEM_ARRAY" + IntToString(nCnt));

            // Either remove them all, or some of them...
            nStack = GetItemStackSize(oGem);
            nUsed = GetLocalInt(oGem, "SMP_GEM_TO_REMOVE");
            DeleteLocalInt(oGem, "SMP_GEM_TO_REMOVE");

            // Check nStack to remove
            if(nStack == nUsed)
            {
                // Destroy that gem
                DestroyObject(oGem);
            }
            else
            {
                // Remove just some
                SetItemStackSize(oGem, nStack - nUsed);
            }
        }
        // Passed
        return TRUE;
    }
    else
    {
        // Failed - delete array anyway
        for(nCnt = 1; nCnt <= nStacksUsed; nCnt++)
        {
            // Get the gem
            oGem = GetLocalObject(OBJECT_SELF, "SMP_GEM_ARRAY" + IntToString(nCnt));
            DeleteLocalObject(OBJECT_SELF, "SMP_GEM_ARRAY" + IntToString(nCnt));

            // Delete local on the gem
            DeleteLocalInt(oGem, "SMP_GEM_TO_REMOVE");
        }
        // Failed
        return FALSE;
    }
    return FALSE;
}
// Returns the lowest gem, used in protection from spells.
object SMP_ComponentLowestGemOfValue(int nItemValue, string sGemName, object oTarget)
{
    object oReturn = OBJECT_INVALID;
    object oLowest = GetFirstItemInInventory(oTarget);
    int nValue, nStack, nLowestValue = 100000000;
    while(GetIsObjectValid(oLowest))
    {
        // Only check gems which can be sold.
        if(GetBaseItemType(oLowest) == BASE_ITEM_GEM &&
          !GetPlotFlag(oLowest) && GetIdentified(oLowest) &&
        // Gem name
          (sGemName == "" || GetName(oLowest) == sGemName))
        {
            // Get the right value for seperate gems.
            nStack = GetNumStackedItems(oLowest);
            nValue = GetGoldPieceValue(oLowest)/nStack;
            if(nValue >= nItemValue && nValue < nLowestValue)
            {
                nLowestValue = nValue;
                oReturn = oLowest;
            }
        }
        oLowest = GetNextItemInInventory(oTarget);
    }
    return oReturn;
}

// Returns TRUE if they possess an item of sTag.
// * If FALSE - debugs using sItemName and sSpellName.
// Lines:
// FAIL: "You cannot cast " + sSpellName + ", without " + sItemName + "."
int SMP_ComponentExactItem(string sTag, string sItemName, string sSpellName, int nAmount = 1)
{
    // Scrolls ETC need no components.
    if(GetIsObjectValid(GetSpellCastItem())) return TRUE;

    // NPC's ignore it
    if(!GetIsPC(OBJECT_SELF)) return TRUE;

    // Only 1?
    if(nAmount == 1)
    {
        // Check item
        if(!GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, sTag)))
        {
            // Not got it! Debug message
            SendMessageToPC(OBJECT_SELF, "You cannot cast " + sSpellName + ", without " + sItemName + ".");
            return FALSE;
        }
    }
    else
    {
        // More then 1. Loop inventory and count.
        int nTotal = 0;
        object oInventory = GetFirstItemInInventory();
        while(GetIsObjectValid(oInventory) && nTotal <= nAmount)
        {
            // It the item?
            if(GetTag(oInventory) == sTag)
            {
                // Add one to total
                nTotal++;
            }
            // Next item in our inventory
            oInventory = GetNextItemInInventory();
        }
        // Got the amount?
        if(nTotal < nAmount)
        {
            // Nope! not got enough.
            SendMessageToPC(OBJECT_SELF, "You cannot cast " + sSpellName + ", without " + IntToString(nAmount) + " " + sItemName + "'s.");
            return FALSE;
        }
    }
    return TRUE;
}

// Gets the item of string sTag, if valid, it removes it for the spell to work.
// * Use for material comnents which get used up
// * If FALSE - debugs using sItemName and sSpellName.
// * TRUE if it removes the item.
// FAIL: "You cannot cast " + sSpellName + ", without " + sItemName + "."
int SMP_ComponentExactItemRemove(string sTag, string sItemName, string sSpellName)
{
    // Scrolls ETC need no components.
    if(GetIsObjectValid(GetSpellCastItem())) return TRUE;

    // NPC's ignore it
    if(!GetIsPC(OBJECT_SELF)) return TRUE;

    object oItem = GetItemPossessedBy(OBJECT_SELF, sTag);
    int nStack = GetItemStackSize(oItem);
    // Check item
    if(!GetIsObjectValid(oItem))
    {
        // Not got it! Debug message
        SendMessageToPC(OBJECT_SELF, "You cannot cast " + sSpellName + ", without " + sItemName + ".");
        return FALSE;
    }
    // Remove item
    SMP_ComponentItemRemoveBy1(oItem);
    return TRUE;
}
// Gets the item of string sTag, if valid, it removes it for the spell to work.
// Requires the caster to be a bard, sorceror or wizard.
// * Returns TRUE if they are using an item!
// * Use for material comnents which get used up
// * If FALSE - debugs using sItemName and sSpellName.
// * TRUE if it removes the item.
// FAIL: "You cannot cast " + sSpellName + ", without " + sItemName + "."
int SMP_ComponentArcaneExactItemRemove(string sTag, string sItemName, string sSpellName)
{
    // Scrolls ETC need no components.
    if(GetIsObjectValid(GetSpellCastItem())) return TRUE;

    // NPC's ignore it
    if(!GetIsPC(OBJECT_SELF)) return TRUE;

    // Wizards needed for this spell
    switch(GetLastSpellCastClass())
    {
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_BARD:
        {
            // Do nothing if this class.
        }
        break;
        default:
        {
            // Default, anything else, to not need a componenet
            return TRUE;
        }
        break;
    }
    object oItem = GetItemPossessedBy(OBJECT_SELF, sTag);
    int nStack = GetItemStackSize(oItem);
    // Check item
    if(!GetIsObjectValid(oItem))
    {
        // Not got it! Debug message
        SendMessageToPC(OBJECT_SELF, "You cannot cast " + sSpellName + ", without " + sItemName + ".");
        return FALSE;
    }
    // Remove item
    SMP_ComponentItemRemoveBy1(oItem);
    return TRUE;
}


// Returns TRUE if they have the correct focus item of sTag.
// * Focus items are not removed, they just are required to concentrate ETC.
// * If FALSE - debugs using sItemName and sSpellName.
// Lines:
// FAIL: "You require the focus item " + sItemName + " to cast " + sSpellName + ".";
// PASS: "You focus with the item " + sItemName + " to cast " + sSpellName + ".";
int SMP_ComponentFocusItem(string sTag, string sItemName, string sSpellName)
{
    // NPC's ignore it
    if(!GetIsPC(OBJECT_SELF)) return TRUE;

    object oItem = GetItemPossessedBy(OBJECT_SELF, sTag);
    int nStack = GetItemStackSize(oItem);
    // Check item
    if(!GetIsObjectValid(oItem))
    {
        // Not got it! Debug message
        SendMessageToPC(OBJECT_SELF, "You require the focus item " + sItemName + " to cast " + sSpellName + ".");
        return FALSE;
    }
    // "Use" item
    SendMessageToPC(OBJECT_SELF, "You focus with the item " + sItemName + " to cast " + sSpellName + ".");
    return TRUE;
}

// Removes the item of sTag. 1 of them anyway.
void SMP_ComponentItemRemove(string sTag)
{
    object oItem = GetItemPossessedBy(OBJECT_SELF, sTag);
    int nStack = GetItemStackSize(oItem);
    // Check item
    if(GetIsObjectValid(oItem))
    {
        // Remove item
        if(nStack > 1)
        {
            // Take one only off the stack
            nStack--;
            SetItemStackSize(oItem, nStack);
        }
        else
        {
            // Delete item otherwise
            DestroyObject(oItem);
        }
    }
}

// Removes the item oItem, by 1, or destroys oTarget
void SMP_ComponentItemRemoveBy1(object oItem)
{
    int nStack = GetItemStackSize(oItem);
    // Remove item
    if(nStack > 1)
    {
        // Take one only off the stack
        nStack--;
        SetItemStackSize(oItem, nStack);
    }
    else
    {
        // Delete item otherwise
        DestroyObject(oItem);
    }
}

// Basically creates the item on the caster. Can be put in a delay, used to
// CreateItemOnObject(sResRef, oTarget, nStackSize);
void SMP_ComponentActionCreateObject(string sResRef, int nStackSize = 1, object oTarget = OBJECT_SELF)
{
    CreateItemOnObject(sResRef, oTarget, nStackSize);
}


// Checks if they have an amount of XP that will not lose them a level
// * Returns TRUE if they *can* lose nXP
int SMP_ComponentXPCheck(int nXP, object oTarget)
{
    // NPC's ignore it
    if(!GetIsPC(OBJECT_SELF)) return TRUE;

    int nTargetXP = GetXP(oTarget);

    // Make sure it won't go below 0 anyway
    if(nTargetXP - nXP < FALSE)
    {
        return FALSE;
    }

    int nHD = GetHitDice(oTarget);
    // * You can not lose a level (Bioware thing here...)
    int nMin = ((nHD * (nHD - 1)) / 2) * 1000;

    // Make sure that nTargetXP - nXP is not under nMin.
    if(nTargetXP - nXP >= nMin)
    {
        return TRUE;
    }
    return FALSE;
}
// Removes nXP from oTarget. Make sure this can happen without level loss with
// SMP_XPCheck.
void SMP_ComponentXPRemove(int nXP, object oTarget)
{
    // NPC's ignore it
    if(!GetIsPC(OBJECT_SELF)) return;

    // Get what they already have.
    int nCurrent = GetXP(oTarget);
    // Minus
    int nNew = nCurrent - nXP;

    // Set it
    SetXP(oTarget, nNew);
}

// Check for, and remove, nGold from oTarget
// * Returns TRUE if it happens.
int SMP_ComponentGoldRemove(int nGold, object oTarget)
{
    // Check if we have nGold or more
    if(GetGold(oTarget) >= nGold)
    {
        // Remove nGold
        TakeGoldFromCreature(nGold, oTarget, TRUE);
    }
    // not removed, return FALSE.
    return FALSE;
}

// Removes many items of sTag.
// * Up to nAmount of sTagged items.
void SMP_ComponentItemRemoveMany(string sTag, int nAmount)
{
    // More then 1. Loop inventory and count.
    int nTotal = 0;
    object oInventory = GetFirstItemInInventory();
    while(GetIsObjectValid(oInventory) && nTotal <= nAmount)
    {
        // It the item?
        if(GetTag(oInventory) == sTag)
        {
            // Remove it
            SetPlotFlag(oInventory, FALSE);
            DestroyObject(oInventory);
        }
        // Next item in our inventory
        oInventory = GetNextItemInInventory();
    }
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
