//:://////////////////////////////////////////////
//:: FileName: "ss_ep_dreamscape"
/*   Purpose: Dreamscape - This is a PLOT spell. A module builder MUST take
        this spell into consideration when designing their module, or else they
        should exclude it. It depends completely on the builder placing
        something relevant into the module for it. Read comments in coding for
        hints and details.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
//#include "x2_inc_spellhook"
#include "inc_epicspells"

void NoValidWP(object oPC);

void TeleportPartyToLocation(object oPC, location lWP);

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_DREAMSC))
    {
        // Declarations.
        location lDestination;
        location lWP;
        object oWP;
        // Check for how many "successful" castings there have been. It is up
        // to the MODULE BUILDER to increment or decrement this number!!!!
        int nNumCasts = GetLocalInt(OBJECT_SELF, "nDreamscapeCount");
        // Where will the Dreamscape take you this time?
        switch (nNumCasts)
        {
            case 0: oWP = GetWaypointByTag("YOUR_WAYPOINTS_TAG");
                    if (oWP == OBJECT_INVALID) // There is no WP by that TAG.
                    {
                        // Start up a conversation instead.
                        NoValidWP(OBJECT_SELF);
                        break;
                    }
                    lWP = GetLocation(oWP);
                    TeleportPartyToLocation(OBJECT_SELF, lWP);
                    break;
            // I have added extra cases. It will never reach them unless you
            // increment the local int "nDreamscapeCount" somewhere along the
            // way. If you do not do this, the case will ALWAYS be zero.
            case 1: oWP = GetWaypointByTag("YOUR_WAYPOINTS_TAG");
                    if (oWP == OBJECT_INVALID) // There is no WP by that TAG.
                    {
                        // Start up a conversation instead.
                        NoValidWP(OBJECT_SELF);
                        break;
                    }
                    lWP = GetLocation(oWP);
                    TeleportPartyToLocation(OBJECT_SELF, lWP);
                    break;
            case 2: oWP = GetWaypointByTag("YOUR_WAYPOINTS_TAG");
                    if (oWP == OBJECT_INVALID) // There is no WP by that TAG.
                    {
                        // Start up a conversation instead.
                        NoValidWP(OBJECT_SELF);
                        break;
                    }
                    lWP = GetLocation(oWP);
                    TeleportPartyToLocation(OBJECT_SELF, lWP);
                    break;
            case 3: oWP = GetWaypointByTag("YOUR_WAYPOINTS_TAG");
                    if (oWP == OBJECT_INVALID) // There is no WP by that TAG.
                    {
                        // Start up a conversation instead.
                        NoValidWP(OBJECT_SELF);
                        break;
                    }
                    lWP = GetLocation(oWP);
                    TeleportPartyToLocation(OBJECT_SELF, lWP);
                    break;
            case 4: oWP = GetWaypointByTag("YOUR_WAYPOINTS_TAG");
                    if (oWP == OBJECT_INVALID) // There is no WP by that TAG.
                    {
                        // Start up a conversation instead.
                        NoValidWP(OBJECT_SELF);
                        break;
                    }
                    lWP = GetLocation(oWP);
                    TeleportPartyToLocation(OBJECT_SELF, lWP);
                    break;
            case 5: oWP = GetWaypointByTag("YOUR_WAYPOINTS_TAG");
                    if (oWP == OBJECT_INVALID) // There is no WP by that TAG.
                    {
                        // Start up a conversation instead.
                        NoValidWP(OBJECT_SELF);
                        break;
                    }
                    lWP = GetLocation(oWP);
                    TeleportPartyToLocation(OBJECT_SELF, lWP);
                    break;
            case 6: oWP = GetWaypointByTag("YOUR_WAYPOINTS_TAG");
                    if (oWP == OBJECT_INVALID) // There is no WP by that TAG.
                    {
                        // Start up a conversation instead.
                        NoValidWP(OBJECT_SELF);
                        break;
                    }
                    lWP = GetLocation(oWP);
                    TeleportPartyToLocation(OBJECT_SELF, lWP);
                    break;
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

void NoValidWP(object oPC)
{
    // This is the back-up plan. If there is no waypoint to go to, maybe you
    // have an event happening in a conversation that will send them somewhere.
    ActionStartConversation(OBJECT_SELF, "ss_dreamscape", TRUE, FALSE);
}

void TeleportPartyToLocation(object oPC, location lWP)
{
    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    // Cycle through all party members and teleport them to the waypoint.
    object oMem = GetFirstFactionMember(oPC, FALSE);
    while (oMem != OBJECT_INVALID)
    {
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oMem);
        FloatingTextStringOnCreature("*begins to dream...*", oMem);
        DelayCommand(3.0, AssignCommand(oMem, JumpToLocation(lWP)));
        oMem = GetNextFactionMember(oPC, FALSE);
    }
}
