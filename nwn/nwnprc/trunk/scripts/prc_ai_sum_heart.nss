#include "inc_prc_npc"
#include "inc_eventhook"

void main()
{
    //Any ideas why this is here? It messes up the Create Undead Uncontrolled switch
    //if (GetMaster()== OBJECT_INVALID) DestroyObject(OBJECT_SELF);
    ExecuteScript("nw_ch_ac1", OBJECT_SELF);
    ExecuteScript("prc_npc_hb", OBJECT_SELF);
    //NPC substiture for OnEquip
    DoEquipTest();

    // Execute scripts hooked to this event for the NPC triggering it
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONHEARTBEAT);
}