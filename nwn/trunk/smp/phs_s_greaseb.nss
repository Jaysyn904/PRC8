/*:://////////////////////////////////////////////
//:: Spell Name Grease: On Exit
//:: Spell FileName PHS_S_GreaseB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Grease will knockdown creatures (falling them) each round.

    The dexterity check replaces this text:

    A creature can walk within or through the area of grease at half normal speed
    with a DC 10 Balance check. Failure means it can’t move that round (and must
    then make a Reflex save or fall), while failure by 5 or more means it falls
    (see the Balance skill for details).

    Which only applies if they are doing ACTION_MOVETOPOINT.

    On Exit:
    - Removes the 50% (half speed) movement penalty.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_GREASE);
}
