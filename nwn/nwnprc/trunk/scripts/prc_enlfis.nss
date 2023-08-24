#include "prc_inc_unarmed"

void main()
{
    object oPC = OBJECT_SELF;
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int nItemL = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
    int iShield = nItemL == BASE_ITEM_TOWERSHIELD
               || nItemL == BASE_ITEM_LARGESHIELD
               || nItemL == BASE_ITEM_SMALLSHIELD;

    PRCRemoveEffectsFromSpell(oPC, SPELL_SACREDSPEED);

    if(GetBaseAC(oArmor) < 4 && !iShield)
        ActionCastSpellOnSelf(SPELL_SACREDSPEED);

    //Evaluate The Unarmed Strike Feats
    SetLocalInt(oPC, CALL_UNARMED_FEATS, TRUE);

    //Evaluate Fists
    SetLocalInt(oPC, CALL_UNARMED_FISTS, TRUE);
}