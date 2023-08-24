#include "prc_inc_unarmed"


void RemoveExtraAttacks(object oCreature)
{
    if (GetHasSpellEffect(SPELL_BRAWLER_EXTRA_ATT))
    {
        PRCRemoveSpellEffects(SPELL_BRAWLER_EXTRA_ATT, oCreature, oCreature);
        if (GetLocalInt(oCreature, "BrawlerAttacks"))
        {
            FloatingTextStringOnCreature("*Extra unarmed attacks disabled*", oCreature, FALSE);
            DeleteLocalInt(oCreature, "BrawlerAttacks");
        }
    }
}

void BrawlerDamageReduction(object oCreature)
{
    object oSkin = GetPCSkin(oCreature);

    if (GetHasFeat(FEAT_BRAWLER_DAMAGE_REDUCTION_3, oCreature) && !GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_3))
        AddItemProperty(DURATION_TYPE_PERMANENT,PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DR_3),oSkin);
    if (GetHasFeat(FEAT_BRAWLER_DAMAGE_REDUCTION_6, oCreature) && !GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_6))
        AddItemProperty(DURATION_TYPE_PERMANENT,PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DR_6),oSkin);
    if (GetHasFeat(FEAT_BRAWLER_DAMAGE_REDUCTION_9, oCreature) && !GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_9))
        AddItemProperty(DURATION_TYPE_PERMANENT,PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DR_9),oSkin);
}

void BrawlerBlocking(object oCreature)
{
    object oRighthand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
    object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
    object oWeapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature);
    int iBlocking = 0;

    if (GetIsObjectValid(oRighthand) ||
        (GetIsObjectValid(oLefthand) && GetBaseItemType(oLefthand) != BASE_ITEM_TORCH)
       )
    {
        if (GetLocalInt(oCreature, "BrawlerBlockingOn"))
            DelayCommand(1.0, FloatingTextStringOnCreature("*Brawler Blocking disabled*", oCreature, FALSE));
        DeleteLocalInt(oCreature, "BrawlerBlockingOn");
        return;
    }

    if (GetHasFeat(FEAT_BRAWLER_BLOCK_5, oCreature))
        iBlocking = 5;
    else if (GetHasFeat(FEAT_BRAWLER_BLOCK_4, oCreature))
        iBlocking = 4;
    else if (GetHasFeat(FEAT_BRAWLER_BLOCK_3, oCreature))
        iBlocking = 3;
    else if (GetHasFeat(FEAT_BRAWLER_BLOCK_2, oCreature))
        iBlocking = 2;
    else if (GetHasFeat(FEAT_BRAWLER_BLOCK_1, oCreature))
        iBlocking = 1;

    if (iBlocking)
    {
        string str = IntToString(iBlocking);
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyACBonus(iBlocking),oWeapL);
        if (!GetLocalInt(oCreature, "BrawlerBlockingOn"))
            DelayCommand(1.0, FloatingTextStringOnCreature("*Brawler Blocking +"+str+" Enabled*", oCreature, FALSE));
        SetLocalInt(oCreature, "BrawlerBlockingOn", TRUE);
    }
}

void main ()
{
    object oPC = OBJECT_SELF;

    // We cannot add stuff to the creature weapons until they have been evaluated,
    // so we request their evaluation, and wait for it to happen.
    if(!GetLocalInt(OBJECT_SELF, UNARMED_CALLBACK))
    {
        PrintString("prc_brawler first call");
        //Evaluate DR
        BrawlerDamageReduction(oPC);

        //Evaluate The Unarmed Strike Feats
        //UnarmedFeats(oPC);
        SetLocalInt(OBJECT_SELF, CALL_UNARMED_FEATS, TRUE);

        //Evaluate Fists
        //UnarmedFists(oPC);
        SetLocalInt(OBJECT_SELF, CALL_UNARMED_FISTS, TRUE);

        // Request callback once the feat & fist evaluation is done
        AddEventScript(oPC, CALLBACKHOOK_UNARMED, "prc_brawler", FALSE, FALSE);
    }
    else
    {
        PrintString("prc_brawler callback");
        //Evaluate Brawler Blocking
        BrawlerBlocking(oPC);

        //Extra Attacks OFF if equipping of weapons or shield is done or if monk levels are taken.
        object oRighthand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

        /* Redundant checks - these are also made by the spell
        int iRighthand = GetIsObjectValid(oRighthand);
        int iLefthand = GetIsObjectValid(oLefthand) && GetBaseItemType(oLefthand) != BASE_ITEM_TORCH;
        int iMonk = GetLevelByClass(CLASS_TYPE_MONK, oPC);

        if (iRighthand || iLefthand || iMonk)
            RemoveExtraAttacks(oPC);
        else
        */
        ActionCastSpellOnSelf(SPELL_BRAWLER_EXTRA_ATT);
    }
}
