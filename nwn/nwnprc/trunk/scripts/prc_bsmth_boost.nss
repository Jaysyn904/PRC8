//::
//:: prc_bsmith_boost.nss | BATTLESMITH_BOOST
//:: 

#include "prc_inc_spells"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int nArmour = GetBaseAC(oArmour);
    int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
    int nAC = 0;
    
    if (GetLevelByClass(CLASS_TYPE_BATTLESMITH, oPC) >= 4)
        nAC = 2;
	
	else if (GetLevelByClass(CLASS_TYPE_BATTLESMITH, oPC) >= 2)
        nAC = 1;	
    
    PRCRemoveEffectsFromSpell(oPC, GetSpellId());
    
    if (GetBaseItemType(oWeap) == BASE_ITEM_WARHAMMER)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nWis), DAMAGE_TYPE_BLUDGEONING)), oPC);

    if (nArmour >= 6) // Heavy armor only
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectACIncrease(nAC, AC_DODGE_BONUS)), oPC);
        
    if (DEBUG) DoDebug("prc_bsmth_boost: Wisdom Modifier "+IntToString(nWis)+", AC Bonus "+IntToString(nAC));
}