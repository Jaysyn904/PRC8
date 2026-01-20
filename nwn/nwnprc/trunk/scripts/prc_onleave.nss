//::///////////////////////////////////////////////
//:: OnClientLeave eventscript
//:: prc_onleave
//:://////////////////////////////////////////////
#include "prc_class_const"
#include "inc_utility"
#include "inc_persistsql"

// Save logout time when actually logging out    
void SaveCraftingLogoutTime(object oPC)        
{        
    if(DEBUG) DoDebug("prc_onleave >> SaveCraftingLogoutTime | Called for " + GetName(oPC));      
          
    // Check database first, then local int      
    int bCrafting = SQLocalsPlayer_GetInt(oPC, "crafting_active");      
    if(!bCrafting)      
    {      
        bCrafting = GetLocalInt(oPC, "PRC_CRAFT_HB");      
        if(DEBUG) DoDebug("prc_onleave >> SaveCraftingLogoutTime | DB crafting_active = " + IntToString(bCrafting) +       
                         ", Local PRC_CRAFT_HB = " + IntToString(GetLocalInt(oPC, "PRC_CRAFT_HB")));      
    }      
          
    if(bCrafting)        
    {        
        // Save the logout timestamp with fallback  
        int nLogoutTimestamp = GetCurrentUnixTimestamp(); 
			if(DEBUG) DoDebug("prc_onleave >> SaveCraftingLogoutTime | nLogoutTimestamp is: " + IntToString(nLogoutTimestamp));
		  
		if(nLogoutTimestamp == 0)    
		{    
			// Fallback: use a simple counter    
			int nLastLogout = SQLocalsPlayer_GetInt(oPC, "crafting_last_timestamp");    
			nLogoutTimestamp = nLastLogout + 1;    
			SQLocalsPlayer_SetInt(oPC, "crafting_last_timestamp", nLogoutTimestamp);    
			if(DEBUG) DoDebug("prc_onleave >> SaveCraftingLogoutTime | Using fallback counter: " + IntToString(nLogoutTimestamp));  
		}     
          
        // Save the timestamp  
        SQLocalsPlayer_SetInt(oPC, "crafting_last_timestamp", nLogoutTimestamp);      
              
        // Save current rounds remaining      
        int nRounds = GetLocalInt(oPC, "PRC_CRAFT_TIME");      
        SQLocalsPlayer_SetInt(oPC, "crafting_rounds", nRounds);      
		      
		// Save the crafting costs        
		SQLocalsPlayer_SetInt(oPC, "crafting_cost", GetLocalInt(oPC, "PRC_CRAFT_COST"));        
		SQLocalsPlayer_SetInt(oPC, "crafting_xp", GetLocalInt(oPC, "PRC_CRAFT_XP"));      
		      
        if(nRounds > 0)      
        {      
            SQLocalsPlayer_SetInt(oPC, "crafting_rounds", nRounds);      
        }      
              
        if(DEBUG) DoDebug("prc_onleave >> SaveCraftingLogoutTime | Saved logout timestamp " + IntToString(nLogoutTimestamp) + ", rounds remaining: " + IntToString(nRounds));      
		      
		SQLocalsPlayer_SetString(oPC, "crafting_file", GetLocalString(oPC, "PRC_CRAFT_FILE"));        
		SQLocalsPlayer_SetInt(oPC, "crafting_line", GetLocalInt(oPC, "PRC_CRAFT_LINE"));      
                
        // Remove concentration monitoring and clear heartbeat          
        RemoveEventScript(oPC, EVENT_VIRTUAL_ONDAMAGED, "prc_od_conc");          
        DeleteLocalInt(oPC, "PRC_CRAFT_HB");          
    }        
    else      
    {      
        if(DEBUG) DoDebug("prc_onleave >> SaveCraftingLogoutTime | Player not crafting, skipping");      
    }      
}
void main()
{
    //:: Execute scripts hooked to this event for the player triggering it
    object oPC = GetExitingObject();
	string sPCName = GetName(oPC);
	
	if (oPC == OBJECT_INVALID)
	{
		DoDebug("prc_onleave: oPC "+sPCName+" is invalid");
		return;
    }
	
    if(DEBUG) DoDebug("prc_onleave: Player " +sPCName+ " leaving");
    
    AssignCommand(GetModule(), DelayCommand(0.1, RecalculateTime()));	
    //SaveCraftingLogoutTime(oPC); 	
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONCLIENTLEAVE);
}
