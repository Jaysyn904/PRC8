/*:://////////////////////////////////////////////
//:: Spell Name Find the Path
//:: Spell FileName phs_s_findthpthc
//:://////////////////////////////////////////////
    This is the find the paths heartbeat, "c" script.

    - Moves only if the master is in 10M.
    - Moves to the target object
    - Removes itself if the master is not valid (or is dead) or if the spell finnishes.
//:://////////////////////////////////////////////
    Creates a henchmen (should work fine with Hordes anyway) which will move
    with ActionMoveToObject and using an object a PC will set for location to
    move to.

    The object is set via. the spell conversation (however that is done) if they
    have the spell memorised.

    Note: 3 rounds to cast

    Need to add "henchmen" scripts and new creature. Make the creature eathreal,
    maybe, or just ignore.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// Destroys ourself.
void Go(string sMessage);

void main()
{
    // Heartbeat counter.
    int iHeartbeatsLeft = GetLocalInt(OBJECT_SELF, "PHS_SPELL_FIND_THE_PATH_DURATION_COUNTER");
    // Master
    object oMaster = GetMaster();

    // Stop before anything else.
    ClearAllActions();


    // Remove it by 1
    iHeartbeatsLeft--;

    // If the new amount is 1 or over, carry on moving, else stop.
    if(iHeartbeatsLeft >= 1 && GetIsObjectValid(oMaster))
    {
        // Set the amount
        SetLocalInt(OBJECT_SELF, "PHS_SPELL_FIND_THE_PATH_DURATION_COUNTER", iHeartbeatsLeft);

        // Make sure the master is within 10M
        if(GetDistanceToObject(oMaster) <= 10.0)
        {
            // Get the location to move to
            object oTarget = GetLocalObject(OBJECT_SELF, "PHS_SPELL_FIND_THE_PATH_OBJECT");

            if(GetIsObjectValid(oTarget))
            {
                ActionMoveToObject(oTarget, TRUE);
            }
            else
            {
                // Go - no location left.
                Go("Find the path Ended, No location to go to");
            }
        }
        return;
    }
    else
    {
        // Else, there are no heartbeats left - we go!
        // - Can be if we have no master
        Go("Find the Path finished");
        return;
    }
}

void Go(string sMessage)
{
    SendMessageToPC(GetMaster(), sMessage);
    // Else, there are no heartbeats left - we go!
    effect eGo = EffectVisualEffect(VFX_IMP_UNSUMMON);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eGo, GetLocation(OBJECT_SELF));
    SetPlotFlag(OBJECT_SELF, FALSE);
    SetImmortal(OBJECT_SELF, FALSE);
    DestroyObject(OBJECT_SELF);
}
