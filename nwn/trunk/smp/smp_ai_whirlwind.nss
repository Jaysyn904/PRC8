/*:://////////////////////////////////////////////
//:: Spell Name Whirlwind: Whirlwind Heartbeat
//:: Spell FileName SMP_AI_Whirlwind
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is the heartbeat for the actual creature.

    Destroys self:
    - If not got the spell's effects
    - No master

    Goes out of control:
    - If out of range. Delays deletion of the spell and will randomly choose
      somewhere to move to for that duration. Cannot be controlled.

    Else:
    - Will move to a stored location. If nearby already, we will randomise
      and go around it. Of course, next heartbeat, it will go back again...and
      repeat. Might change this behaviour.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    object oSelf = OBJECT_SELF;
    location lSelf = GetLocation(OBJECT_SELF);
    object oMaster = PHS_FirstCasterOfSpellEffect(PHS_SPELL_WHIRLWIND, oSelf);

    // Check if we have effects of this spell already
    if(GetHasSpellEffect(PHS_SPELL_WHIRLWIND, oSelf) ||
       !GetIsObjectValid(oMaster))
    {
        // Destroy self
        SetPlotFlag(oSelf, FALSE);
        DestroyObject(oSelf);
        return;
    }
    // Get stored loction
    location lTarget = GetLocalLocation(oSelf, "SMP_SPELL_WHIRLWIND_LOCATION");

    // Check if we can move any nearer
    if(GetDistanceBetweenLocations(lTarget, lSelf) > 3.5)
    {
        // Move there
        ClearAllActions();
        ActionForceMoveToLocation(lTarget, TRUE, 10.0);
        return;
    }
    // Else
    else
    {
        // Move around this spot.
        // Get a random point, and move there
        lTarget = PHS_GetRandomLocation(lTarget, 4);
        // Move there
        ClearAllActions();
        ActionForceMoveToLocation(lTarget, TRUE, 10.0);
        return;
    }
}
