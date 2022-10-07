/*
    prc_coc_heal

    Heals damage bonus if sneak/critical immune, copied from swashbuckler.

    By: Flaming_Sword
    Created: Oct 10, 2007
    Modified: Oct 27, 2007

*/

#include "prc_alterations"

void main()
{
    object oWeap = GetSpellCastItem();
    object oTarget = PRCGetSpellTargetObject();

    int HealInt = GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)
               || GetIsImmune(oTarget, IMMUNITY_TYPE_SNEAK_ATTACK);

    int nBase = GetBaseItemType(oWeap);       //baseitem type checking
    int bBase = nBase == BASE_ITEM_LONGSWORD
              || nBase == BASE_ITEM_RAPIER
              || nBase == BASE_ITEM_ELF_LIGHTBLADE
              || nBase == BASE_ITEM_ELF_THINBLADE
              || nBase == BASE_ITEM_ELF_COURTBLADE
              || nBase == BASE_ITEM_SCIMITAR;

    //heal if immune to sneak and critical - dex bonus
    if(HealInt || !bBase)
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetAbilityModifier(ABILITY_DEXTERITY, OBJECT_SELF)), oTarget);
}
