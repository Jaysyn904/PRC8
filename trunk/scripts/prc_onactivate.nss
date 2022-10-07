//::///////////////////////////////////////////////
//:: OnActivateItem eventscript
//:: prc_onactivate
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    if(DEBUG) DoDebug("prc_onactivate executing");

    object oItem = GetItemActivated();
    object oPC = GetItemActivator();
    string sTag = GetTag(oItem);

    // Tag-based scripting hook for PRC items
    SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ACTIVATE);
    ExecuteScript("is_"+sTag, OBJECT_SELF);

    // One of the Epic Seed books.
    if(GetStringLeft(sTag, 8) == "EPIC_SD_")
        ExecuteScript("activate_seeds", oPC);

    // One of the Epic Spell books.
    if(GetStringLeft(GetResRef(oItem), 8) == "epic_sp_")
        ExecuteScript("activate_epspell", oPC);

    // "A Gem Caged Creature" item received from the epic spell Gem Cage.
    if(sTag == "IT_GEMCAGE_GEM")
        ExecuteScript("run_gemcage_gem", oPC);

    // "Whip of Shar" item received from the epic spell Whip of Shar.
    if(sTag == "WhipofShar")
        ExecuteScript("run_whipofshar", oPC);

    //rest kits
    if(GetPRCSwitch(PRC_SUPPLY_BASED_REST))
        ExecuteScript("sbr_onactivate", oPC);

    // Execute scripts hooked to this event for the player and item triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONACTIVATEITEM);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONACTIVATEITEM);
}