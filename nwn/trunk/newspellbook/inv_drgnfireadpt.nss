//::///////////////////////////////////////////////
//:: Dragonfire Adept
//:: inv_drgnfireadpt.nss
//::///////////////////////////////////////////////
/*
    Handles the passive bonuses for Dragonfire Adepts
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Jan 24, 2007
//:://////////////////////////////////////////////

#include "prc_class_const"
#include "inc_item_props"

void main()
{
    int nClass = GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT);

    int nScales = (nClass + 8) / 5;
    if(nScales > 1)
        SetCompositeBonus(GetPCSkin(OBJECT_SELF), "DFA_AC", nScales, ITEM_PROPERTY_AC_BONUS);

    //Reduction
    if(nClass > 5)
    {
        effect eReduction;
        if(nClass > 35)      eReduction = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE);
        else if(nClass > 25) eReduction = EffectDamageReduction(7, DAMAGE_POWER_PLUS_FIVE);
        else if(nClass > 15) eReduction = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE);
        else                 eReduction = EffectDamageReduction(2, DAMAGE_POWER_PLUS_ONE);

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eReduction), OBJECT_SELF);
    }
}