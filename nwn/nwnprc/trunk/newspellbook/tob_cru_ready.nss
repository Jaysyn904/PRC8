/*
    Choose which maneuvers to ready for the Crusader
*/
#include "prc_nui_mr_inc"
#include "inc_dynconv"

void main()
{
    object oInitiator = OBJECT_SELF;
    if(!GetLocalInt(oInitiator, "ReadyManeuverCru") && !GetIsInCombat(oInitiator))
    {
        ManeuverReadyOpenEditor(
            oInitiator,
            CLASS_TYPE_CRUSADER,
            PRC_MANEUVER_READY_MODE_NORMAL
        );
    }
    else if (GetHasFeat(FEAT_ADAPTIVE_STYLE, oInitiator))
    {
        // Preserve Adaptive Style's existing forced-conversation timing and
        // combat behavior. The staged NUI is only ordinary readying.
        ClearReadiedManeuvers(oInitiator, MANEUVER_LIST_CRUSADER);
        SetLocalInt(oInitiator, "nClass", CLASS_TYPE_CRUSADER);
        StartDynamicConversation("tob_ft_rcrcnv", oInitiator, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oInitiator);
    }    
    else // Int already set
    {
        FloatingTextStringOnCreature("You may not ready maneuvers at this time", oInitiator);
    }
}
