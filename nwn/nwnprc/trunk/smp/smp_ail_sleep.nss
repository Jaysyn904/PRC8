/*:://////////////////////////////////////////////
//:: Name Sleep Heartbeat
//:: FileName SMP_ail_sleep
//:://////////////////////////////////////////////
    This runs when a creature is asleep.

    Bioware just had "Commandable, Clear Actions, Uncommandable"

    I've added ZZzzz's :-)

    Random really.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: July+
//::////////////////////////////////////////////*/

#include "SMP_INC_AILMENT"

void main()
{
    // Makes them able to be commanded
    SetCommandable(TRUE);

    // Clears all the actions.
    ClearAllActions();

    // Randomly do sleep ZZzzz
    if(d6() == 1)
    {
        effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    }

    // Makes them unable to be commanded
    SetCommandable(FALSE);
}
