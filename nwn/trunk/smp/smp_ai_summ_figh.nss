/*:://////////////////////////////////////////////
//:: Name AI Summon - Fight!
//:: FileName SMP_AI_SUMM_FIGH
//:://////////////////////////////////////////////
//:: Description
//:://////////////////////////////////////////////
    Combat!

    This is executed on the creature when combat should occur - at the end of
    a combat round or the start of battle normally.

    This will not fire if there is a custom AI file set to the variable
    PHS_SUMMON_AI_FILE. Should have a void main(). Targets are set to
    PHS_SUMMON_TEMP_TARGET.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "smp_ai_include"

void main()
{
    SpeakString("Fighting");

    // Get the target to attack
    object oTarget = SMPAI_GetTarget();

    // Stop what we are doing
    ClearAllActions();

    // If invalid, we don't do combat
    if(!GetIsObjectValid(oTarget))
    {
        // Follow master
        ActionForceFollowObject(GetMaster(), 5.0);
        return;
    }

    // We can attack them
    if(GetDistanceToObject(oTarget) > 4.0)
    {
        // Most damaging ranged
        ActionEquipMostDamagingRanged(oTarget);
    }
    else
    {
        // Most damaging melee
        ActionEquipMostDamagingMelee(oTarget);
    }
    // Attack!
    ActionAttack(oTarget);
}
