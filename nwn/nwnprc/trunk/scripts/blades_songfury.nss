#include "prc_alterations"

void main()
{
    object oTarget = OBJECT_SELF;

    if(GetHasFeatEffect(FEAT_SONG_OF_FURY, oTarget))
    {
        PRCRemoveSpellEffects(SPELL_SONG_OF_FURY, oTarget, oTarget);
        return;
    }

    // Light armor only?
    //if(GetBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget)) > 3)
    //    return;

    // nothing in left hand
    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget)))
        return;

    // only rapier or longsword in right hand
    int nWeapType = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget));
    if(nWeapType != BASE_ITEM_RAPIER
    && nWeapType != BASE_ITEM_LONGSWORD
    && nWeapType != BASE_ITEM_ELVEN_THINBLADE)
        return;

    effect eLink = EffectLinkEffects(EffectAttackDecrease(2), EffectModifyAttacks(1));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_BARD_SONG));

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eLink), oTarget);
}