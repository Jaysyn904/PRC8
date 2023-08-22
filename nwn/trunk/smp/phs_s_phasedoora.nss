/*:://////////////////////////////////////////////
//:: Spell Name Phase Door: "Clicked On"
//:: Spell FileName PHS_S_PhaseDoorA
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

#include "PHS_INC_SPELLS"

void main()
{
    // Master is checked in the HB.
    object oSelf = OBJECT_SELF;
    int nCharges = GetLocalInt(oSelf, "PHS_PHASE_DOOR_CHARGES");

    // This simply moves the clicker to the destination, and uses up a charge.
    object oClicker = GetLastSpeaker();

    // Get destination
    object oDestination = GetLocalObject(oSelf, "PHS_PHASE_DOOR_TARGET");

    // Move them if valid
    if(GetIsObjectValid(oDestination) && nCharges > 0)
    {
        // Decrease the integers on destination AND this source
        nCharges--;

        SetLocalInt(oSelf, "PHS_PHASE_DOOR_CHARGES", nCharges);
        SetLocalInt(oDestination, "PHS_PHASE_DOOR_CHARGES", nCharges);

        // Move them
        AssignCommand(oClicker, JumpToObject(oDestination));
    }
}
