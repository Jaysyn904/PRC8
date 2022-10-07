/*
    prc_coc_damage

    Applies damage bonus, copied from swashbuckler.

    By: Flaming_Sword
    Created: Oct 10, 2007
    Modified: Oct 11, 2007

*/

#include "prc_inc_spells"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    int iDamageType = (!GetIsObjectValid(oRight)) ? DAMAGE_TYPE_BASE_WEAPON : GetItemDamageType(oRight);
    int nInt = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
    int nBonus = (nInt > 5) ? nInt + 10 : nInt;     //more efficient int conversion

    PRCRemoveEffectsFromSpell(oPC, GetSpellId());

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(nBonus, iDamageType), oPC);
}