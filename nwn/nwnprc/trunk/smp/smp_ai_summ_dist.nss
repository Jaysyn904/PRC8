/*:://////////////////////////////////////////////
//:: Name Summon Monster - On Disturbed
//:: FileName SMP_AI_Summ_Dist
//:://////////////////////////////////////////////
    On Disturbed.

    Attacks the last pickpocket if we are not already in combat.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_AI_INCLUDE"

void main()
{
    // Delcare major variables
    object oSelf = OBJECT_SELF;
    object oPickpocket = GetLastDisturbed();

    // Check if in combat
    if(!GetIsInCombat() && !GetFactionEqual(oPickpocket))
    {
        // Attack!
        SMPAI_SummonAttack(oPickpocket);
    }
}
