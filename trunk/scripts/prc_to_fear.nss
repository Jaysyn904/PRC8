//::///////////////////////////////////////////////
//:: Thrall of Orcus Touch of Fear
//:: prc_to_fear
//:://////////////////////////////////////////////
//:: Causes an area of fear that reduces Will Saves
//:: and applies the frightened effect.
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_ORCUS);
    int nDC    =  GetLevelByClass(CLASS_TYPE_ORCUS) + GetAbilityModifier(ABILITY_CHARISMA) + 10; 
    DoRacialSLA(SPELL_FEAR, nLevel, nDC);
}

