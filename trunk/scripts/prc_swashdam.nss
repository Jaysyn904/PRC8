#include "prc_inc_spells"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    int iDamageType = (!GetIsObjectValid(oRight)) ? DAMAGE_TYPE_BASE_WEAPON : GetItemDamageType(oRight);
    int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
    int nBonus = (nInt > 5) ? nInt + 10 : nInt;     //more efficient int conversion
    
    //cap damage at 20 or else it will go into dice territory
    if(nBonus > 30)
    {	
	    nBonus = 30;	
    }

    PRCRemoveEffectsFromSpell(oPC, GetSpellId());
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(nBonus, iDamageType), oPC);
}