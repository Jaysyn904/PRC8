/*:://////////////////////////////////////////////
//:: Spell Name Maze : Heartbeat area
//:: Spell FileName PHS_S_MazeC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    On Heartbeat

    We can easily make them check intelligence every 6 seconds VIA heartbeat,
    this is NOT the script in the area on heartbeat, but rather is executed
    on an entering object every 6 seconds until it gets from 600 to 0...10 turns
    of round checking.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Delcare Major Variables
    object oTarget = OBJECT_SELF;

    // Jump out if they are not in the maze area
    if(!PHS_IsInMazeArea(oTarget))
    {
        SetCommandable(TRUE, oTarget);
        // Remove the spells effects (the visual mostly)
        PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_MAZE, oTarget);
        return;
    }

    // First, move the coutner down by 1 round
    int iCounter = GetLocalInt(oTarget, PHS_S_MAZE_ROUND_COUNTER);
    iCounter--;
    // Set new counter value
    SetLocalInt(oTarget, PHS_S_MAZE_ROUND_COUNTER, iCounter);

    // We make a hidden intelligence check :-)
    int iIntelligence = GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget);

    // DC of 20. OR we have been here 600 checks before...
    if(iIntelligence + d20() >= 20 || iCounter <= 0)
    {
        // PASS
        // - Execute jump out script. The script is also used for freedom.
        ExecuteScript("phs_s_mazed", oTarget);
    }
    else
    {
        // FAIL
        // - Continue to execute the script
        DelayCommand(6.0, ExecuteScript("phs_s_mazec", oTarget));
    }
}
