#include "prc_inc_spells"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int iDamageType = (!GetIsObjectValid(oWeap)) ? DAMAGE_TYPE_BLUDGEONING : GetItemDamageType(oWeap);

    PRCRemoveEffectsFromSpell(oPC, GetSpellId());

    effect eDam = EffectDamageIncrease(DAMAGE_BONUS_1, iDamageType);
    effect eAtk = EffectAttackIncrease(1);
    effect eLink = EffectLinkEffects(eDam, eAtk);
    eLink = ExtraordinaryEffect(eLink);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}
