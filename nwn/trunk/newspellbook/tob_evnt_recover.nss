/*
    Recover all maneuvers through EvalPRCFeats
*/
#include "tob_inc_recovery"

void main()
{
    object oInitiator = OBJECT_SELF;
    if(GetIsBladeMagicUser(oInitiator))
    {
        RecoverExpendedManeuvers(oInitiator, MANEUVER_LIST_CRUSADER);
        RecoverExpendedManeuvers(oInitiator, MANEUVER_LIST_SWORDSAGE);
        RecoverExpendedManeuvers(oInitiator, MANEUVER_LIST_WARBLADE);
        RecoverPrCAbilities(oInitiator);
    }
}