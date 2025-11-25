//:://////////////////////////////////////////////
//:: Created By: Jason Stephenson
//:: Created On: August 3, 2004
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Changed By: Jason Stephenson
//:: Changed On: November 24, 2004
//::       Note: Changed to use if instead of switch().
//::             Also fixed code for X2_ITEM_EVENT_SPELLCAST_AT.
//:: Changed On: December 12, 2004
//::       Note: Using helper functions from Axe Murderer's example.
//::             Click Here
//:: Changed On: February 03, 2005
//::       Note: Fix Axe Murderer's SetTagBasedScriptExitBehavior function to
//::             only clear the variables if the nEndContinue is set to
//::             X2_EXECUTE_SCRIPT_END.
//:: Changed By: Jaysyn
//:: Changed On: 2025-11-25 08:31:43
//::       Note: Modified for use with DM info tool
//:://////////////////////////////////////////////

#include "x2_inc_switches"
int GetTagBasedItemEventNumber()
{
    int nEvent = GetLocalInt(OBJECT_SELF, "X2_L_LAST_ITEM_EVENT");
    return (nEvent ? nEvent : GetLocalInt(GetModule(), "X2_L_LAST_ITEM_EVENT"));
}
void SetTagBasedScriptExitBehavior(int nEndContinue)
{
    if (nEndContinue == X2_EXECUTE_SCRIPT_END)
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_ITEM_EVENT");
        DeleteLocalInt(GetModule(), "X2_L_LAST_ITEM_EVENT");
    }
    SetExecutedScriptReturnValue(nEndContinue);
}
void main()
{
    //:: Get which event was fired.
    int nEvent = GetTagBasedItemEventNumber();

    //:: Declare major variables
    object oPC;
    object oItem;

    //:: Our unique power was activated.
    if (nEvent == X2_ITEM_EVENT_ACTIVATE)
    {
        oPC = GetItemActivator();
        oItem = GetItemActivated();
        object oTarget = GetItemActivatedTarget();
		
		SetLocalObject(oPC, "EXAMINE_TARGET", oTarget);
		
		if(!GetIsDM(oPC))
		{
			SendMessageToPC(oPC, "This tool is for DM's, not players");
		}
		else
		{
			ExecuteScript("prc_playerinfo", oPC);
		}
				
    }
    //:: Set the return value, and then fall through.
    SetTagBasedScriptExitBehavior(X2_EXECUTE_SCRIPT_END);
}