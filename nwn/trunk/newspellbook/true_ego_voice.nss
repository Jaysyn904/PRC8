/*
   ----------------
   Resonant Voice
   Acolyte of the Ego level 3

   true_ego_voice
   ----------------

   25/8/18 by Stratovarius
*/ /** @file

Type of Feat: Class
Prerequisite: Acolye of the Ego 3
Specifics:  The DC for the Truespeak check increases by 5, but if the check succeeds, you treat your class level as three higher for the purpose of determining the effect and duration of any morphic cadence you use that round (see above).
Use: Selected.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void main()
{
	// Free toggle to turn resonant voice on or off
    	object oTrueSpeaker = OBJECT_SELF;
    	
    	if (GetLocalInt(oTrueSpeaker, "ResonantVoice") == FALSE)
    	{
		SetLocalInt(oTrueSpeaker, "ResonantVoice", TRUE);
		FloatingTextStringOnCreature("Resonant Voice Activated", oTrueSpeaker, FALSE);
	}
	else // Deactivate
	{
		SetLocalInt(oTrueSpeaker, "ResonantVoice", FALSE);
		FloatingTextStringOnCreature("Resonant Voice Deactivated", oTrueSpeaker, FALSE);
	}
}
