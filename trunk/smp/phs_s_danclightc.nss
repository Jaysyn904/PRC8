/*:://////////////////////////////////////////////
//:: Spell Name Dancing Lights - Heartbeat
//:: Spell FileName PHS_S_DanclightC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Moves them to a cirtain place depending on their tag.

    Basically, 1 is north, 2 east, 3 south, 4 west.

    Moves there. If caster gets out of 20M away, it winks out.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"
#include "PHS_AI_INCLUDE"

void main()
{
    // Check if caster is valid and in range
    object oCaster = GetLocalObject(OBJECT_SELF, PHS_MASTER);
    // Check if valid & in 20M & still got spell effects
    if(!GetIsObjectValid(oCaster) || GetDistanceToObject(oCaster) > 20.0 ||
       !GetHasSpellEffect(PHS_SPELL_DANCING_LIGHTS, oCaster))
    {
        PHSAI_DestroySelf();
        return;
    }
    // Set up us if not already
    if(!GetLocalInt(OBJECT_SELF, "DO_ONCE"))
    {
        SetLocalInt(OBJECT_SELF, "DO_ONCE", TRUE);
        // Ghost effect
        effect eGhost = SupernaturalEffect(EffectCutsceneGhost());
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, OBJECT_SELF);
    }

    // If valid and so forth, move to respective position
    int nNumber = GetLocalInt(OBJECT_SELF, "PHS_DANCING_LIGHT_SET");

    vector vCaster = GetPosition(oCaster);
    float fNewX;
    float fNewY;
    // Check iNumber
    if(nNumber == FALSE)
    {
        PHSAI_DestroySelf();
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
        PHSAI_DestroySelf();
        return;
    }
    vector vTotal = Vector(fNewX, fNewY, vCaster.z);
    // Finalise location
    location lMove = Location(GetArea(oCaster), vTotal, 0.0);

    // Move to location
    ClearAllActions();
    ActionMoveToLocation(lMove, TRUE);
}
