
void CleanCopy(object oImage)
{
    SetLootable(oImage, FALSE);
    // remove inventory contents
    object oItem = GetFirstItemInInventory(oImage);
    while(GetIsObjectValid(oItem))
    {
        SetPlotFlag(oItem,FALSE);
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(GetIsObjectValid(oItem2))
            {
                object oItem3 = GetFirstItemInInventory(oItem2);
                while(GetIsObjectValid(oItem3))
                {
                    SetPlotFlag(oItem3,FALSE);
                    DestroyObject(oItem3);
                    oItem3 = GetNextItemInInventory(oItem2);
                }
                SetPlotFlag(oItem2,FALSE);
                DestroyObject(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oImage);
    }
    // remove non-visible equipped items
    int i;
    for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
    {
        oItem = GetItemInSlot(i, oImage);
        if(GetIsObjectValid(oItem))
        {
            if(i == INVENTORY_SLOT_HEAD || i == INVENTORY_SLOT_CHEST ||
                i == INVENTORY_SLOT_RIGHTHAND || i == INVENTORY_SLOT_LEFTHAND ||
                i == INVENTORY_SLOT_CLOAK) // visible equipped items
            {
                SetDroppableFlag(oItem, FALSE);
                SetItemCursedFlag(oItem, TRUE);
                // remove all item properties
                itemproperty ipLoop=GetFirstItemProperty(oItem);
                while (GetIsItemPropertyValid(ipLoop))
                {
                    RemoveItemProperty(oItem, ipLoop);
                    ipLoop=GetNextItemProperty(oItem);
                }
            }
            else // can't see it so destroy
            {
                SetPlotFlag(oItem,FALSE);
                DestroyObject(oItem);
            }
        }
    }
    TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

void main()
{
    object oPC = OBJECT_SELF;
    //ClearAllActions();
    //DeleteLocalInt(oPC, "FleeTheScene");

    string sImage = "PC_IMAGE"+ObjectToString(oPC)+"mirror";

    effect eGhost = EffectCutsceneGhost();
    effect eImage = EffectLinkEffects(eGhost, EffectCutsceneParalyze());
           eImage = EffectLinkEffects(eImage, EffectConcealment(100));
           eImage = EffectLinkEffects(eImage, EffectMissChance(100));
           eImage = EffectLinkEffects(eImage, EffectSpellLevelAbsorption(9));
           eImage = SupernaturalEffect(eImage);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGhost, oPC, 0.05f);

    // make, then clean up
    object oImage = CopyObject(oPC, GetLocation(oPC), OBJECT_INVALID, sImage);
    CleanCopy(oImage);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImage, oImage);

    //Spellfail :)
    SetLocalInt(oImage, "DarkDiscorporation", TRUE);

    SetImmortal(oImage, TRUE);
    ChangeToStandardFaction(oImage, STANDARD_FACTION_DEFENDER);
    SetIsTemporaryFriend(oPC, oImage, FALSE);
    DestroyObject(oImage, RoundsToSeconds(1));
}
