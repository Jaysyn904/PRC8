/*:://////////////////////////////////////////////
//:: Spell Name Spike Stones - On Enter
//:: Spell FileName PHS_S_SpikeStonA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    On Enter.

    This sets the location currenlty occupied by the PC, so the heartbeat can
    do damage and so on.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE
    if(!PHS_CheckAOECreator()) return;

    // Get local to set on the person
    string sLocal = "PHS_SPIKE_STONE_LOCATION";
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    location lLocation = GetLocation(oTarget);

    // PvP check
    if(!GetIsReactionTypeFriendly(oTarget, oCaster))
    {
        // Set the location, if not already valid
        SetLocalLocation(oTarget, sLocal, lLocation);
    }
}
