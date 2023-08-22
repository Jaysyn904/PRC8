//::///////////////////////////////////////////////
//:: Crafted Tool Target Choice
//:: true_ct_targtchc
//::///////////////////////////////////////////////
/** @file
    Chooses the target for Crafted Tool

    @author Stratovarius
    @date   Created - 2006.08.5
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "true_inc_trufunc"

// Just takes the slot and returns the name
string SlotToName(int nSlot)
{
    if      (nSlot == INVENTORY_SLOT_ARMS)      return "Gloves";
    else if (nSlot == INVENTORY_SLOT_BELT)      return "Belt";
    else if (nSlot == INVENTORY_SLOT_BOOTS)     return "Boots";
    else if (nSlot == INVENTORY_SLOT_CHEST)     return "Armour";
    else if (nSlot == INVENTORY_SLOT_CLOAK)     return "Cloak";
    else if (nSlot == INVENTORY_SLOT_HEAD)      return "Helmet";
    else if (nSlot == INVENTORY_SLOT_LEFTHAND)  return "Left Hand";
    else if (nSlot == INVENTORY_SLOT_LEFTRING)  return "Left Ring";
    else if (nSlot == INVENTORY_SLOT_NECK)      return "Amulet";
    else if (nSlot == INVENTORY_SLOT_RIGHTHAND) return "Right Hand";
    else if (nSlot == INVENTORY_SLOT_RIGHTRING) return "Right Ring";
    
    // if its not a slot
    return "";
}

void main()
{
    object oPC = OBJECT_SELF;
    int nTargetSlot;

    if (PRCGetSpellId() == CRAFTED_TOOL_QUICKSLOT1) nTargetSlot = GetLocalInt(oPC, "TrueQuickSlot1");
    if (PRCGetSpellId() == CRAFTED_TOOL_QUICKSLOT2) nTargetSlot = GetLocalInt(oPC, "TrueQuickSlot2");
    if (PRCGetSpellId() == CRAFTED_TOOL_QUICKSLOT3) nTargetSlot = GetLocalInt(oPC, "TrueQuickSlot3");
    if (PRCGetSpellId() == CRAFTED_TOOL_QUICKSLOT4) nTargetSlot = GetLocalInt(oPC, "TrueQuickSlot4");
    
    FloatingTextStringOnCreature("You are targeting " + SlotToName(nTargetSlot), oPC, FALSE);
    SetLocalInt(oPC, "TrueCraftedToolTargetSlot", nTargetSlot);
}