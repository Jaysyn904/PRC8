//::///////////////////////////////////////////////
//:: Warpriest
//:: MassHaste
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_WARPRIEST);
    int nDC    = GetLevelByClass(CLASS_TYPE_WARPRIEST) + GetAbilityModifier(ABILITY_CHARISMA) + 10; 
    DoRacialSLA(SPELL_MASS_HASTE, nLevel, nDC);
}

