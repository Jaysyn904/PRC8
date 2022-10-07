/*
    Choose which maneuvers to ready for the Crusader
*/
#include "tob_inc_recovery"
#include "inc_dynconv"

void main()
{
    object oInitiator = OBJECT_SELF;
    if(!GetLocalInt(oInitiator, "ReadyManeuverCru") && !GetIsInCombat(oInitiator))
    {
        // Begin Conversation
        ClearReadiedManeuvers(oInitiator, MANEUVER_LIST_CRUSADER);
        SetLocalInt(oInitiator, "nClass", CLASS_TYPE_CRUSADER);
        StartDynamicConversation("tob_moverdy", oInitiator, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oInitiator);
        SetLocalInt(oInitiator, "ReadyManeuverCru", TRUE);
        DelayCommand(300.0f, DeleteLocalInt(oInitiator, "ReadyManeuverCru"));
    }
    else if (GetHasFeat(FEAT_ADAPTIVE_STYLE, oInitiator))
    {
        // Begin Conversation
        ClearReadiedManeuvers(oInitiator, MANEUVER_LIST_CRUSADER);
        SetLocalInt(oInitiator, "nClass", CLASS_TYPE_CRUSADER);
        StartDynamicConversation("tob_ft_rcrcnv", oInitiator, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oInitiator);
    }    
    else // Int already set
    {
        FloatingTextStringOnCreature("You may not ready maneuvers at this time", oInitiator);
        DelayCommand(300.0f, DeleteLocalInt(oInitiator, "ReadyManeuverCru")); // Just in case there are any errors
    }
}