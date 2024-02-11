#include "prc_feat_const"

void main()
{
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);

    if (oWeap!= OBJECT_INVALID) return;

    effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_1d4, DAMAGE_TYPE_BLUDGEONING);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eDamage), OBJECT_SELF,RoundsToSeconds(2));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), OBJECT_SELF);

}
