/*:://////////////////////////////////////////////
//:: Name Dazed Heartbeat
//:: FileName SMP_AIL_DAZED
//:://////////////////////////////////////////////
    This runs on an creature with the effect EffectDazed().

    Uses:
    - Calm Emotions dazes creatures. The spell states it surpresses confusion
      and fear effects. If they are attacked, it breaks it, however. We do
      that check in a special ailment include.


//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_AILMENT"

void main()
{
    // Check, but no return value on, the status of Calm Emotions
    SMP_AilmentCheckCalmEmotions();

    return;
}
