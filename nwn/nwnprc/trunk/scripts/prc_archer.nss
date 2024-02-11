#include "inc_newspellbook" 
#include "prc_inc_core"

void Equip(object oPC, int bBowSpec, object oSkin, int bXShot)
{
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    int iType = GetBaseItemType(oWeap);

    if(iType != BASE_ITEM_LONGBOW
    && iType != BASE_ITEM_SHORTBOW)
        return;

    SetCompositeAttackBonus(oPC, "ArcherBowSpec", bBowSpec);

    if(bXShot && !GetHasSpellEffect(SPELL_EXTRASHOT, oPC))
    {
        ActionCastSpellOnSelf(SPELL_EXTRASHOT);
    }
}

void UnEquip(object oPC, int bBowSpec, object oSkin, int bXShot)
{
    int iType = GetBaseItemType(GetItemLastUnequipped());

    if(iType != BASE_ITEM_LONGBOW
    && iType != BASE_ITEM_SHORTBOW)
        return;

    if(GetHasSpellEffect(SPELL_EXTRASHOT, oPC))
        PRCRemoveSpellEffects(SPELL_EXTRASHOT,oPC,oPC);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int iEquip = GetLocalInt(oPC,"ONEQUIP");

    int bBowSpec = GetHasFeat(FEAT_BOWSPEC9, oPC) ? 9 :
                   GetHasFeat(FEAT_BOWSPEC8, oPC) ? 8 :
                   GetHasFeat(FEAT_BOWSPEC7, oPC) ? 7 :
                   GetHasFeat(FEAT_BOWSPEC6, oPC) ? 6 :
                   GetHasFeat(FEAT_BOWSPEC5, oPC) ? 5 :
                   GetHasFeat(FEAT_BOWSPEC4, oPC) ? 4 :
                   GetHasFeat(FEAT_BOWSPEC3, oPC) ? 3 :
                   GetHasFeat(FEAT_BOWSPEC2, oPC) ? 2 :
                   0;

    int bXShot = GetHasFeat(FEAT_EXTRASHOT, oPC);

    SetCompositeAttackBonus(oPC, "ArcherBowSpec", 0);

    if (iEquip !=1) Equip(oPC, bBowSpec, oSkin, bXShot);
    if (iEquip ==1) UnEquip(oPC, bBowSpec, oSkin, bXShot);
}