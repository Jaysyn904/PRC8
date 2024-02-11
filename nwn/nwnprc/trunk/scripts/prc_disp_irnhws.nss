#include "prc_alterations"
void main()
{
    object oPC = OBJECT_SELF;
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

    int nDuration = GetAbilityModifier(ABILITY_CONSTITUTION,oPC);

    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    itemproperty pIron = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, DAMAGE_BONUS_3);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oPC,RoundsToSeconds(nDuration));
    AddItemProperty(DURATION_TYPE_TEMPORARY,pIron,oWeap,RoundsToSeconds(nDuration));

}