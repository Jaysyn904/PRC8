/*:://////////////////////////////////////////////
//:: Name Summon Monster - On Physical Attacked
//:: FileName SMP_AI_Summ_PhyA
//:://////////////////////////////////////////////
    On Physical Attacked.

    Attacks the last attacker if we are not already in combat.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_AI_INCLUDE"

void main()
{
    // Delcare major variables
    object oSelf = OBJECT_SELF;
    object oAttacker = GetLastAttacker();

    // Check if in combat
    if(!GetIsInCombat() && !GetFactionEqual(oAttacker))
    {
        // Attack!
        SMPAI_SummonAttack(oAttacker);
    }
}
