//::///////////////////////////////////////////////
//:: Warpriest
//:: HealingCircle
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_newspellbook"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_WARPRIEST);
    int nDC    = GetLevelByClass(CLASS_TYPE_WARPRIEST) + GetAbilityModifier(ABILITY_CHARISMA) + 10; 
    DoRacialSLA(SPELL_HEALING_CIRCLE, nLevel, nDC);
}

