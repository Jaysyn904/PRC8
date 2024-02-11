/*:://////////////////////////////////////////////
//:: Spell Name Dancing Lights - Heartbeat
//:: Spell FileName sp_danclightc
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Moves them to a cirtain place depending on their tag.

    Basically, 1 is north, 2 east, 3 south, 4 west.

    Moves there. If caster gets out of 20M away, it winks out.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "prc_inc_spells"
//#include "PHS_AI_INCLUDE"

void main()
{
    // Check if caster is valid and in range
    object oCaster = GetLocalObject(OBJECT_SELF, "Caster");
    object oTarget = GetLocalObject(OBJECT_SELF, "Target");
    // Check if valid & in 20M & still got spell effects
    if(!GetIsObjectValid(oCaster) || (GetIsObjectValid(oTarget) &&
       (GetDistanceToObject(oTarget) > 20.0 ||
       !GetHasSpellEffect(SPELL_DANCING_LIGHTS, oTarget))) ||
       !GetHasSpellEffect(SPELL_DANCING_LIGHTS, OBJECT_SELF))
    {
        SetPlotFlag(OBJECT_SELF, FALSE);
        MyDestroyObject(OBJECT_SELF);
        return;
    }

    // If valid and so forth, move to respective position
    int nNumber = GetLocalInt(OBJECT_SELF, "DANCING_LIGHT_SET");

    vector vCaster = GetPosition(oTarget);
    float fNewX;
    float fNewY;
    // Check iNumber
    if(nNumber == FALSE)
    {
        SetPlotFlag(OBJECT_SELF, FALSE);
        MyDestroyObject(OBJECT_SELF);
        return;
    }
    // Move to position 1 = north
    else if(nNumber == 1)
    {
        // +1.5 in Y  /\
        fNewX = vCaster.x;
        fNewY = vCaster.y + 1.5;
    }
    // 2 = east
    else if(nNumber == 2)
    {
        // +1.5 in X  ->
        fNewX = vCaster.x + 1.5;
        fNewY = vCaster.y;
    }
    // 3 = south
    else if(nNumber == 3)
    {
        // -1.5 in Y  \/
        fNewX = vCaster.x;
        fNewY = vCaster.y - 1.5;
    }
    // 4 = west
    else if(nNumber == 4)
    {
        // -1.5 in X  <-
        fNewX = vCaster.x - 1.5;
        fNewY = vCaster.y;
    }
    else // Invalid if over 4
    {
        SetPlotFlag(OBJECT_SELF, FALSE);
        MyDestroyObject(OBJECT_SELF);
        return;
    }
    vector vTotal = Vector(fNewX, fNewY, vCaster.z);
    // Finalise location
    location lMove = Location(GetArea(OBJECT_SELF), vTotal, 0.0);

    // Move to location
    ClearAllActions();
    ActionMoveToLocation(lMove, TRUE);
    //Follow the target
    ActionForceFollowObject(oTarget, 1.5f);
}
