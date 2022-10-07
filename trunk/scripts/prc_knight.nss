#include "prc_alterations"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_knight running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
        case EVENT_ONPLAYERREST_FINISHED:   oPC = GetLastBeingRested();      break;
        case EVENT_ONCLIENTENTER:           oPC = GetEnteringObject();       break;
        case EVENT_ONPLAYERLEVELUP:         oPC = GetPCLevellingUp();        break;

        default:
            oPC = OBJECT_SELF;
    }

    object oItem;
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    object oAmmo;
    int nClass = GetLevelByClass(CLASS_TYPE_KNIGHT, oPC);
    int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    int nBonus = max(1, (nClass/2) + nCha);


    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events, needed from level 1 for Knight's Challenge
        if(DEBUG) DoDebug("prc_knight: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYERREST_FINISHED,   "prc_knight", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERLEVELUP,   "prc_knight", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONCLIENTENTER,   "prc_knight", TRUE, FALSE);
    }
    // Restore Knight's Challenge
    else if(nEvent == EVENT_ONPLAYERREST_FINISHED)
    {
        if(DEBUG) DoDebug("prc_knight: OnRest:\n" + "oPC = " + DebugObject2Str(oPC));
        SetLocalInt(oPC, "KnightsChallenge", nBonus);
        FloatingTextStringOnCreature("You have " +IntToString(nBonus) + " uses of Knight's Challenge remaining", oPC, FALSE);
    }// end if - Running OnRest event
    // Restore Knight's Challenge
    else if(nEvent == EVENT_ONPLAYERLEVELUP)
    {
        if(DEBUG) DoDebug("prc_knight: OnRest:\n" + "oPC = " + DebugObject2Str(oPC));
        SetLocalInt(oPC, "KnightsChallenge", nBonus);
        FloatingTextStringOnCreature("You have " +IntToString(nBonus) + " uses of Knight's Challenge remaining", oPC, FALSE);
    }// end if - Running OnRest event
    // Restore Knight's Challenge
    else if(nEvent == EVENT_ONCLIENTENTER)
    {
        if(DEBUG) DoDebug("prc_knight: OnRest:\n" + "oPC = " + DebugObject2Str(oPC));
        SetLocalInt(oPC, "KnightsChallenge", nBonus);
        FloatingTextStringOnCreature("You have " +IntToString(nBonus) + " uses of Knight's Challenge remaining", oPC, FALSE);
    }// end if - Running OnRest event    
}
