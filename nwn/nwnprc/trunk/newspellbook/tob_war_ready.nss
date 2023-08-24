/*
    Choose which maneuvers to ready for the WARBLADE
*/
#include "tob_inc_recovery"
#include "inc_dynconv"

void main()
{
    object oInitiator = OBJECT_SELF;
    if(!GetLocalInt(oInitiator, "ReadyManeuverWar") && !GetIsInCombat(oInitiator))
    {
        // Begin Conversation
        ClearReadiedManeuvers(oInitiator, MANEUVER_LIST_WARBLADE);
        SetLocalInt(oInitiator, "nClass", CLASS_TYPE_WARBLADE);
        StartDynamicConversation("tob_moverdy", oInitiator, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oInitiator);
        SetLocalInt(oInitiator, "ReadyManeuverWar", TRUE);
        DelayCommand(300.0f, DeleteLocalInt(oInitiator, "ReadyManeuverWar"));
    }
    else if (GetHasFeat(FEAT_ADAPTIVE_STYLE, oInitiator))
    {
        // Begin Conversation
        ClearReadiedManeuvers(oInitiator, MANEUVER_LIST_WARBLADE);
        SetLocalInt(oInitiator, "nClass", CLASS_TYPE_WARBLADE);
        StartDynamicConversation("tob_ft_rcrcnv", oInitiator, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oInitiator);
    }    
    else // Int already set
    {
        FloatingTextStringOnCreature("You may not ready maneuvers at this time", oInitiator);
        DelayCommand(300.0f, DeleteLocalInt(oInitiator, "ReadyManeuverWar")); // Just in case there are any errors
    }
}