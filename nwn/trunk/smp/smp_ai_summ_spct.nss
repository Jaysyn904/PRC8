/*:://////////////////////////////////////////////
//:: Name Summon Monster - On Spell Cast At
//:: FileName SMP_AI_Summ_SpCt
//:://////////////////////////////////////////////
    On Spell Cast At.

    Attacks the last damager if we are not already in combat.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_AI_INCLUDE"

void main()
{
    // Delcare major variables
    object oSelf = OBJECT_SELF;
    object oCaster = GetLastSpellCaster();
    int bHarmful = GetLastSpellHarmful();

    // Check if in combat
    if(!GetIsInCombat() && !GetFactionEqual(oCaster))
    {
        // If it is hostile, attack anyone
        if(bHarmful || GetIsEnemy(oCaster))
        {
            // Attack!
            SMPAI_SummonAttack(oCaster);
        }
    }
}
