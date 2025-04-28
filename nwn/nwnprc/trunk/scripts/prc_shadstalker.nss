#include "prc_alterations"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_shadstalker running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    object oSkin = GetPCSkin(oPC);
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;

        default:
            oPC = OBJECT_SELF;
    }
	int nClass = GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER, oPC);
	int nAC = 0;

	// Add 2 ranks every 3 levels
	if (nClass >= 2)
	{
		nAC = 2 * ((nClass - 2) / 3 + 1);
	}

	SetCompositeBonus(oSkin, "ShadowStalkS", nAC, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
	SetCompositeBonus(oSkin, "ShadowStalkM", nAC, ITEM_PROPERTY_SKILL_BONUS, SKILL_SENSE_MOTIVE);

/*     int nClass = GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER, oPC);
    int nAC = 0;
    if (nClass >= 2) nAC += 2;
    if (nClass >= 5) nAC += 2;
    if (nClass >= 8) nAC += 2;
    
    SetCompositeBonus(oSkin, "ShadowStalkS", nAC, ITEM_PROPERTY_SKILL_BONUS,SKILL_SEARCH);
    SetCompositeBonus(oSkin, "ShadowStalkM", nAC, ITEM_PROPERTY_SKILL_BONUS,SKILL_SENSE_MOTIVE); */
}
