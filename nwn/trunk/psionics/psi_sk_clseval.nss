//::///////////////////////////////////////////////
//:: Soulknife: Class evaluation script
//:: psi_sk_clseval
//::///////////////////////////////////////////////
/** @file Soulknife: Class evaluation script
    Hooks the soulknife eventscripts.


    @author Ornedan
    @date   Created  - 2006.03.07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"


void main()
{
    object oPC = OBJECT_SELF;

    // Hook psi_sk_event to the mindblade-related events it handles
    AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONUNAQUIREITEM,      "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERDEATH,       "psi_sk_event", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERLEVELDOWN,   "psi_sk_event", TRUE, FALSE);
}
