/*:://////////////////////////////////////////////
//:: Spell Name Symbol of XXX: On Enter 5M Thing
//:: Spell FileName PHS_S_Symbola
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Any of the symbols have a 5M entry area.

    They use the same AOE. This can not be deactivated - but if the one which
    does the effects goes, this one might as well!

    The first heartbeat sets what other AOE uses it, or something.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Reacts if something comes within 5M of the symbol - but isn't in the casters
    party.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE status
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    // Get


}
