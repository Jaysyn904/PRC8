/*:://////////////////////////////////////////////
//:: Name Summon Monster - On Damaged
//:: FileName SMP_AI_Summ_Dam
//:://////////////////////////////////////////////
    On Damaged, Basic event.

    Attacks the last damager if we are not already in combat.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_AI_INCLUDE"

void main()
{
    // Might run another script instead.
    if(SMPAI_RunEventAIScript(EVENT_DAMAGED)) return;

    // Delcare major variables
    object oSelf = OBJECT_SELF;
    object oDamager = GetLastDamager();
    //int nDamage = GetTotalDamageDealt();

    // Check if in combat
    if(!GetIsInCombat() && !GetFactionEqual(oDamager))
    {
        // Attack!
        SMPAI_SummonAttack(oDamager);
    }
}
