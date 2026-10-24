//::///////////////////////////////////////////////
//:: Silverstar class event handler
//:: prc_silverstar
//::///////////////////////////////////////////////

#include "prc_ss_inc"

void SSRegisterEventHooks(object oPC)
{
    // Permanent hooks survive the one-shot event queue. FALSE in the final
    // argument makes every registration duplicate-safe.
    AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,
                   "prc_silverstar", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM,
                   "prc_silverstar", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONUNAQUIREITEM,
                   "prc_silverstar", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERREST_FINISHED,
                   "prc_silverstar", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONHEARTBEAT,
                   "prc_silverstar", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERDEATH,
                   "prc_silverstar", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERRESPAWN,
                   "prc_silverstar", TRUE, FALSE);
}

void main()
{
    int nEvent = GetRunningEvent();
    object oPC = OBJECT_SELF;

    switch (nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:
            oPC = GetItemLastEquippedBy();
            break;

        case EVENT_ONPLAYERUNEQUIPITEM:
            oPC = GetItemLastUnequippedBy();
            break;

        case EVENT_ONUNAQUIREITEM:
            oPC = GetModuleItemLostBy();
            break;

        case EVENT_ONPLAYERREST_FINISHED:
            oPC = GetLastBeingRested();
            break;

        case EVENT_ONPLAYERDEATH:
            oPC = GetLastPlayerDied();
            break;

        case EVENT_ONPLAYERRESPAWN:
            oPC = GetLastRespawnButtonPresser();
            break;
    }

    if (nEvent == EVENT_ONPLAYERUNEQUIPITEM)
        SSClearMoonHandProperties(GetItemLastUnequipped());
    else if (nEvent == EVENT_ONUNAQUIREITEM)
        SSClearMoonHandProperties(GetModuleItemLost());

    if (!GetIsObjectValid(oPC)
    || GetObjectType(oPC) != OBJECT_TYPE_CREATURE) return;

    int nLevel = SSGetClassLevel(oPC);
    SSRefreshScent(oPC);
    SSRefreshDailyUses(oPC);

    // EvalPRCFeats calls this script with no running event.
    if (nEvent == FALSE)
    {
        if (nLevel < 1)
        {
            SSClearEquippedMoonHands(oPC);
            return;
        }

        SSRegisterEventHooks(oPC);
        SSRefreshMoonHands(oPC);
        return;
    }

    if (nEvent == EVENT_ONPLAYERREST_FINISHED)
        SSResetDailyUses(oPC);

    // The individual heartbeat keeps running while a PC is dead. It must
    // not restore the properties cleared by the death hook.
    if (nEvent == EVENT_ONPLAYERDEATH || GetIsDead(oPC))
    {
        SSClearEquippedMoonHands(oPC);
        return;
    }

    if (nLevel < 1)
    {
        SSClearEquippedMoonHands(oPC);
        return;
    }

    // Equip, unequip, unacquire, heartbeat, rest, and respawn all converge on
    // the same idempotent reconciliation step.
    SSRefreshMoonHands(oPC);
}
