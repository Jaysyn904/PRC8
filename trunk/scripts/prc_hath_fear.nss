//::///////////////////////////////////////////////
//:: Hathran
//:: Fear
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_HATHRAN);
    int nDC    = GetLevelByClass(CLASS_TYPE_HATHRAN) + GetAbilityModifier(ABILITY_CHARISMA) + 10; 
    DoRacialSLA(SPELL_FEAR, nLevel, nDC);
}

