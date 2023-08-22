/*
06/11/21 by Stratovarius

Unearthly Grace: A gloura gains a deflection bonus to Armor Class and all saving throws equal to its Charisma modifier
*/

#include "prc_inc_function"

void main()
{
    object oCaster = PRCGetSpellTargetObject(); 
    int nBonus = GetAbilityModifier(ABILITY_CHARISMA, oCaster);
    //FloatingTextStringOnCreature("Applying Unearthly Grace "+IntToString(nBonus), oCaster, FALSE);
    effect eLink = EffectLinkEffects(EffectACIncrease(nBonus, AC_DEFLECTION_BONUS), EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL));
    if (nBonus > 0) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oCaster, 9999.0);
}