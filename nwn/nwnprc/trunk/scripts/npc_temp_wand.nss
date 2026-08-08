//:: npc_temp_wand.nss  
//::  
  
#include "inc_dynconv"  
  
void main()  
{  
    object oItem      = GetItemActivated();  
    object oPC        = GetItemActivator();  
    object oTarget    = GetItemActivatedTarget();  
  
    // DM-only item  
    DoDebug("npc_temp_wand: main() entered, oPC=" + GetName(oPC) +  
            " oTarget=" + (GetIsObjectValid(oTarget) ? GetName(oTarget) : "INVALID"));  
  
    if (!(GetIsDM(oPC) || GetIsDMPossessed(oPC)))  
    {  
        DoDebug("npc_temp_wand: DM check failed");  
        SendMessageToPC(oPC, "This item is for DM's, not players");  
        return;  
    }  
  
    if (oTarget == oPC || oTarget == OBJECT_INVALID)  
    {  
        DoDebug("npc_temp_wand: entering self-target branch, launching conversation");  
        SetLocalObject(oPC, "WND_TEMPLATE_ITEM", oItem);  
        StartDynamicConversation("wnd_tmpl_conv", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, oPC);  
    }  
    else if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && !GetIsPC(oTarget))  
    {  
        // Function 2: wand targeted an NPC -> apply the stored template choice  
        string sTemplate = GetLocalString(oItem, "WND_TEMPLATE_CHOICE");  
        if (sTemplate != "")  
            ExecuteScript(sTemplate, oTarget);  
    }  
}