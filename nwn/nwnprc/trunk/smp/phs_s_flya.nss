/*:://////////////////////////////////////////////
//:: Spell Name Fly - Fly
//:: Spell FileName PHS_S_FlyA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Flying.

    Item Range: 20M

    For "Fly".
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    location lCaster = GetLocation(oCaster);
    object oArea = GetArea(oCaster);

    // Duration takes 1 round, 6 seconds, plus Distance/10 to fly there.
    float fDuration = 6.0 + GetDistanceBetweenLocations(lTarget, lCaster) / 10;

    // Declare effects
    effect eDur = EffectDisappearAppear(lTarget, 1);

    // Must have the effects of any of the flying spells
    if(!GetHasSpellEffect(PHS_SPELL_FLY, oCaster))
    {
        FloatingTextStringOnCreature("*You cannot fly using this without fly cast on you*", oCaster, FALSE);
        return;
    }

    // Make sure we can teleport
    if(!PHS_CannotTeleport(oCaster, lTarget))
    {
        // Must be outdoors not underground
        if(GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND &&
           GetIsAreaInterior(oArea) == FALSE)
        {
            // Jump to the target location with visual effects
            PHS_ApplyDuration(oCaster, eDur, fDuration);
        }
    }
}
