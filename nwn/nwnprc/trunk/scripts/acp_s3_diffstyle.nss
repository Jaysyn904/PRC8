/////////////////////////////////////////////////
// ACP_S3_diffstyle
// Author: Ariel Kaiser
// Creation Date: 13 May 2005
// Updated by: Jason
// Updated on: 2024-09-03 20:16:26
////////////////////////////////////////////////
/*
  In combination with the right feat.2da and spells.2da entries, this script
  allows a player (or possessed NPC with the right feat, I guess) to change
  their fighting style and trade it for different animations. Part of the ACP pack.
*/
#include "prc_inc_spells"
#include "inc_acp"


void main()
{
    if (GetLocalInt(OBJECT_SELF, sLock)) //Feat is still locked? Bad user!
    {
        SendMessageToPC(OBJECT_SELF, "You need to wait at least 90 seconds before using this feat again.");
        return;
    }

    int nSpellID = PRCGetSpellId();
    if(nSpellID == 13507 || nSpellID == 13512 || nSpellID == 13518)	// Normal/Reset
    {
		ResetFightingStyle();
		SendMessageToPC(OBJECT_SELF, "Resetting to Default NWN Combat Style");
	}
    else if(nSpellID == 13503) 	// Kensai
	{
        SetCustomFightingStyle(PHENOTYPE_KENSAI);
		SendMessageToPC(OBJECT_SELF, "Switching to Kensai Combat Style");
	}	
    else if(nSpellID == 13504) 	// Assassin
    {
		SetCustomFightingStyle(PHENOTYPE_ASSASSIN);
		SendMessageToPC(OBJECT_SELF, "Switching to Assassin Combat Style");
	}	
    else if(nSpellID == 13505) 	// Arcane
	{
        SetCustomFightingStyle(PHENOTYPE_ARCANE);
		SendMessageToPC(OBJECT_SELF, "Switching to Arcane Combat Style");
	}	
    else if(nSpellID == 13506) 	// Fencing
	{
		SetCustomFightingStyle(PHENOTYPE_FENCING);
		SendMessageToPC(OBJECT_SELF, "Switching to Fencing Combat Style");
	}		
	else if(nSpellID == 13509) 	// Barbarian
    {
		SetCustomFightingStyle(PHENOTYPE_BARBARIAN);
		SendMessageToPC(OBJECT_SELF, "Switching to Barbarian Combat Style");
	}		
    else if(nSpellID == 13510) 	// Demon Blade
	{
        SetCustomFightingStyle(PHENOTYPE_DEMONBLADE);
		SendMessageToPC(OBJECT_SELF, "Switching to Demon Blade Combat Style");
	}			
	else if(nSpellID == 13511) 	// Warrior
	{
        SetCustomFightingStyle(PHENOTYPE_WARRIOR);
		SendMessageToPC(OBJECT_SELF, "Switching to Warrior Combat Style");
	}		
    else if(nSpellID == 13514) 	// Tiger Fang Style
	{
        SetCustomFightingStyle(PHENOTYPE_TIGERFANG);
		SendMessageToPC(OBJECT_SELF, "Switching to Tiger Fang Combat Style");
	}			
	else if(nSpellID == 13515) 	// Sun Fist Style
	{
        SetCustomFightingStyle(PHENOTYPE_SUNFIST);
		SendMessageToPC(OBJECT_SELF, "Switching to Sun Fist Combat Style");
	}			
    else if(nSpellID == 13516) 	// Dragon Palm Style
	{
        SetCustomFightingStyle(PHENOTYPE_DRAGONPALM);
		SendMessageToPC(OBJECT_SELF, "Switching to Dragon Palm Combat Style");
	}			
	else if(nSpellID == 13517) 	// Bear's Claw Style
	{
        SetCustomFightingStyle(PHENOTYPE_BEARSCLAW);
		SendMessageToPC(OBJECT_SELF, "Switching to Bear's Claw Combat Style");
	}			
}