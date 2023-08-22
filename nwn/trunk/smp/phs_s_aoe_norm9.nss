/*:://////////////////////////////////////////////
//:: Spell Name AOE - Heartbeat - Normal Magical Trap AOE, level 9.
//:: Spell FileName PHS_S_AOE_Norm9
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Checks for PC's (rogues) nearby. May detect this magical trap - DC is
    25 + spell level.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    int nLevel = 9;

    // Detect traps! Who is near enough?
    PHS_MagicalTrapsDetect(nLevel);
}
