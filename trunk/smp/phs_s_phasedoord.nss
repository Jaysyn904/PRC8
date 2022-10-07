/*:://////////////////////////////////////////////
//:: Spell Name Phase Door: Let us see them
//:: Spell FileName PHS_S_PhaseDoorD
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses a creature who invisiblieses themselves.

    Each creature (an entrance, point 1, and an exit, point 2) will be created.

    A power will remove the invisibility off it. They should have a visual
    from the spell. The invisiblity will be applied as thier own (undispellable)
    effect.

    Click on one for conversation, it takes you to the other.

    One of the creatures is the "master" of the two, and is set to the caster.
    Thats all, else, if one exsists and one doesn't, they both go.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// This is the "power" which will remove the invisibility off the doors.

#include "PHS_INC_SPELLS"

void main()
{
    // Loop all doors in the area
    object oPerson = OBJECT_SELF;
    object oMaster, oOther;

    // Loop doors
    int nCnt = 1;
    object oDoor = GetNearestObjectByTag("PHS_PHASEDOOR", oPerson, nCnt);
    while(GetIsObjectValid(oDoor))
    {
        // Find the closest who's master is a member of our party
        oMaster = GetMaster(oDoor);
        if(GetFactionEqual(oMaster, oPerson))
        {
            // First, get the other door
            oOther = GetLocalObject(oDoor, "PHS_PHASE_DOOR_TARGET");

            // If both do not have the invisbility, will not work
            if(!PHS_GetHasEffect(EFFECT_TYPE_INVISIBILITY, oDoor) &&
               !PHS_GetHasEffect(EFFECT_TYPE_INVISIBILITY, oDoor))
            {
                // Message "failure"
                FloatingTextStringOnCreature("*Nearest Phase Door is already visible*", oDoor, FALSE);
            }
            else
            {
                // Remove the invisiblity off them
                PHS_RemoveSpecificEffect(EFFECT_TYPE_INVISIBILITY, oDoor, SUBTYPE_SUPERNATURAL);
                PHS_RemoveSpecificEffect(EFFECT_TYPE_INVISIBILITY, oOther, SUBTYPE_SUPERNATURAL);

                // Set a local for the rounds for invisibility
                SetLocalInt(oDoor, "PHS_SPELL_PHASE_DOOR_INVIS_ROUNDS", 4);
                SetLocalInt(oOther, "PHS_SPELL_PHASE_DOOR_INVIS_ROUNDS", 4);
            }
            // Stop
            return;
        }
        // Loop doors
        nCnt++;
        oDoor = GetNearestObjectByTag("PHS_PHASEDOOR", oPerson, nCnt);
    }
}
