/*:://////////////////////////////////////////////
//:: Spell Name Rope Trick: Area On Enter
//:: Spell FileName PHS_S_RopeTrickA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    New area(s) used for this "trick".

    The people can look out of the area briefly (using a cutscene style thing)
    and pull up the rope too.

    The rope is a placable.

    The place just holds things, up to 8 "things", and will not take any more.

    Anyone can go up.

    Note: The actual people inside the area are counted via. the area's On Enter
    (using a count of objects, as to not specifically just add/remove one), and
    the On Exit (same script). If at any time more then X creatures are in,
    then the last one to enter (and so on backwards) are removed.

    It is also checked when they click the rope, but NPC's are, well, harder.

    Main script: Creates the rope at the location. Cannot be created in a rope
    area already!
    Enter (A) script: Checks, as above, and boots entering things.
    Exit (B) script: As above, and boots things that have entered if too many.
    Heartbeat (C) script: Will check the duration of the spell (the caster is
            checked for the spells effects, if no caster or no effect, area goes)
    Rope Used (D) script: Placable On Used event, will converse with a person.
    Window Used (E) script: Window/Entrance inside the rope trick area, can see
            out (Cutscene) and move down/retract the rope or put it back.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // On Enter of the area
    // Will check the amount of creatures in the area.
    // Will set the new enterer as a person.

}
