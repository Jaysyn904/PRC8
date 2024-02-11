/*:://////////////////////////////////////////////
//:: Name Summon Monster - On Spawn
//:: FileName SMP_AI_Summ_Spwn
//:://////////////////////////////////////////////
    On Spawn.

    Most local variables (AI script, default settings, ETC) are set
    directly.

    Listening patterns are set here.

    Notes on Summoned Creatures:

    - AI:
    The AI is very basic. Cirtain special integers can be set for spells and
    feats, or even the custom AI file set to the string PHSAI_SUMMON_AI_FILE.

    - Listening:
    Most monsters will not be able to pick locks, but may bash them, and traps
    can be set to walk over or not (as the default AI does).

    They will only listen to a masters orders.

    - Attacking:
    The master can make them force attack a cirtain target (probably via. a new
    spell like-unique-power
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_AI_INCLUDE"

void main()
{
    // Get ourself
    object oSelf = OBJECT_SELF;

    // Set our destroyable status to FALSE for 0.001 seconds.
    SetIsDestroyable(FALSE);
    DelayCommand(0.001, SetIsDestroyable(TRUE, FALSE, FALSE));

    // Sets up the special henchmen listening patterns
    SetListening(OBJECT_SELF, TRUE);
    SetAssociateListenPatterns();
}
