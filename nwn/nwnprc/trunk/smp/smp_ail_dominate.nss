/*:://////////////////////////////////////////////
//:: Name NPC only Dominate Effect Heartbeat Script
//:: FileName SMP_ail_dominate
//:://////////////////////////////////////////////
    This runs for NPC's affected with EffectDomination(). The effect creator
    is thier master, and they are GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_DOMINATED

    Domination is impossible to impliment as per 3.5E - we're not adding
    henchmen here!

    // Create a Dominate effect
    effect EffectDominated()

    As AI script changing is impossible, we just determine a standard combat
    round.

    It always follows the master, of course, and as it is the default
    AI, it shouldn't kill the master.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: October
//::////////////////////////////////////////////*/

#include "NW_I0_GENERIC"
#include "SMP_INC_AILMENT"

void main()
{
    //Allow commands to be given to the target
    SetCommandable(TRUE);

    // Stop
    ClearAllActions();
    // Speak...
    SpeakString( "...your will is my command...");
    // Attack
    DetermineCombatRound();
    if(!GetIsInCombat(OBJECT_SELF))
    {
        // Follow after any actions.
        ActionForceFollowObject(GetMaster(), 5.0);
    }
    //Disable the ability to give commands
    SetCommandable(FALSE);
}
