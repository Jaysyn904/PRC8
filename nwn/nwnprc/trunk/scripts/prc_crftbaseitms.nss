#include "prc_alterations"

void GiveCraftingBaseItem(object oPC, string sResRef)
{
    object oItem = CreateItemOnObject(sResRef, oPC);
    if(GetItemPossessor(oItem) != oPC)
        DestroyObject(oItem); //not enough room in inventory
    else
    {
        SetItemCursedFlag(oItem, TRUE); //curse it so it cant be sold etc
        SetDroppableFlag(oItem, FALSE); // nondroppable so it doesnt show on NPCs
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    int bHasPotion,
        bHasScroll,
        bHasWand,
        bHasRod,
        bHasStaff;
    int bHasPotionFeat = GetHasFeat(FEAT_BREW_POTION, oPC),
        bHasScrollFeat = GetHasFeat(FEAT_SCRIBE_SCROLL, oPC),
        bHasWandFeat   = GetHasFeat(FEAT_CRAFT_WAND, oPC),
        bHasRodFeat    = GetHasFeat(FEAT_CRAFT_ROD, oPC),
        bHasStaffFeat  = GetHasFeat(FEAT_CRAFT_STAFF, oPC);

    if(bHasPotionFeat || bHasScrollFeat || bHasWandFeat || bHasRodFeat || bHasStaffFeat)
    {
        object oTest = GetFirstItemInInventory(oPC);
        while(GetIsObjectValid(oTest)
            //&& (!bHasPotion || !bHasScroll || !bHasWand)
            )
        {
            string sResRef = GetResRef(oTest);
            if(GetStringLeft(sResRef, 10) == "x2_it_cfm_") // A minor optimization - most items will fail this test  - Ornedan
            {
                if(sResRef == "x2_it_cfm_pbottl")
                    bHasPotion = TRUE;
                else if(sResRef == "x2_it_cfm_bscrl")
                    bHasScroll = TRUE;
                else if(sResRef == "x2_it_cfm_wand")
                    bHasWand = TRUE;
            }
            if(sResRef == "craft_staff")
                bHasStaff = TRUE;
            else if(sResRef == "craft_rod")
                bHasRod = TRUE;
            oTest = GetNextItemInInventory(oPC);
        }
        //check for equipable items in slots
        if(!bHasStaff)
        {
            oTest = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
            string sResRef = GetResRef(oTest);
            if(sResRef == "craft_staff")
                    bHasStaff = TRUE;
        }
        if(bHasPotionFeat && !bHasPotion)
            GiveCraftingBaseItem(oPC, "x2_it_cfm_pbottl");
        if(bHasScrollFeat && !bHasScroll)
            GiveCraftingBaseItem(oPC, "x2_it_cfm_bscrl");
        if(bHasWandFeat && !bHasWand)
            GiveCraftingBaseItem(oPC, "x2_it_cfm_wand");
        if(bHasRodFeat && !bHasRod)
            GiveCraftingBaseItem(oPC, "craft_rod");
        if(bHasStaffFeat && !bHasStaff)
            GiveCraftingBaseItem(oPC, "craft_staff");
    }
}