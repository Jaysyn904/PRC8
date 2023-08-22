/*:://////////////////////////////////////////////
//:: Name Summon Monster - On Combat Round End
//:: FileName SMP_AI_Summ_CRE
//:://////////////////////////////////////////////
    On Combat Round End.

    This will get the thing to attack, and attack it. As summons usually have
    little or no spells, only cirtain things are checked for in the combat AI file
    executed.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_AI_INCLUDE"

void main()
{
    // Calls combat script
    SMPAI_SummonAttack();
}
