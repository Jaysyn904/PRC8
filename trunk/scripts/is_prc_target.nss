#include "x2_inc_switches"

void main()
{
    if(GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC = GetItemActivator();
        object oTarget = GetItemActivatedTarget();
        location lTarget = GetItemActivatedTargetLocation();

        if(GetIsObjectValid(oTarget))
        {
            SetLocalObject(oPC, "prc_chatcmd_target", oTarget);
            FloatingTextStringOnCreature("Chat command target set to "+GetName(oTarget), oPC, FALSE);
        }
        else
            SetLocalLocation(oPC, "prc_chatcmd_location", lTarget);
    }
}


