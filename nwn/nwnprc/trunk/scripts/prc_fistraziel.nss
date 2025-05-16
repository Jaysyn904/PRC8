#include "prc_inc_spells"
#include "inc_dynconv"

void main()
{
    //Declare main variables.
    int nEvent = GetRunningEvent();
    object oPC;
    switch(nEvent)
    {
        case EVENT_ONPLAYERREST_FINISHED:   oPC = GetLastBeingRested();	break;

        default:
            oPC = OBJECT_SELF;
    }
	
    int nClass = GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oPC);
	
	int nWeapon = GetPersistantLocalInt(oPC, "RazielSanctWeaponPersistent");

    if(nEvent == FALSE)
    {	
		if(nClass == 4)
		{
			if (!nWeapon)
			{
				DelayCommand(1.5, StartDynamicConversation("prc_sanc_raziel", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC));
			}
		}
	}
    else if(nEvent == EVENT_ONPLAYERREST_FINISHED && nClass >= 4)    
    {	
		if (!nWeapon)
		{
			DelayCommand(1.5, StartDynamicConversation("prc_sanc_raziel", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC));
		}
	
	}
}