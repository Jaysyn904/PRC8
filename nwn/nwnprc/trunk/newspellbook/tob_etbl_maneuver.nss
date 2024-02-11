#include "inc_dynconv"
#include "inc_newspellbook"
////#include "prc_alterations"
#include "tob_inc_tobfunc"

void main()
{
	object oInitiator = OBJECT_SELF;
	int nID = GetSpellId();
	if (nID == ETBL_MANEUVER_SELECT_CONVO)
	{
		DelayCommand(0.5, StartDynamicConversation("tob_etbl_conv", OBJECT_SELF, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, OBJECT_SELF));
		SetPersistantLocalInt(oInitiator, "AllowedDisciplines", 6);//DISCIPLINE_DEVOTED_SPIRIT + DISCIPLINE_DIAMOND_MIND
	}
	else if (nID == ETBL_MANEUVER_SELECT_QUICK1)
	{
		//DelayCommand(0.5, StartDynamicConversation("pct_expellconv", OBJECT_SELF, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, OBJECT_SELF));


		int nManeuver = GetLocalInt(oInitiator, "ETBL_MANEUVER_QUICK1");
		int nName = GetLocalInt(oInitiator, "ETBL_MANEUVER_NAME_QUICK1");
		//if(DEBUG) DoDebug("tob_etbl_maneuver: ETBL_MANEUVER_NAME_QUICK1 value = " + IntToString(nName));
		FloatingTextStringOnCreature("*Selected Maneuver: " + GetStringByStrRef(nName) + "*", oInitiator, FALSE);
		SetLocalInt(oInitiator, "ETBL_MANEUVER_CURRENT", nManeuver);
	}
	else if (nID == ETBL_MANEUVER_SELECT_QUICK2)
	{
        //DelayCommand(0.5, StartDynamicConversation("pct_augment_conv", OBJECT_SELF, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, OBJECT_SELF));

		int nManeuver = GetLocalInt(oInitiator, "ETBL_MANEUVER_QUICK2");
		int nName = GetLocalInt(oInitiator, "ETBL_MANEUVER_NAME_QUICK2");
		//if(DEBUG) DoDebug("tob_etbl_maneuver: ETBL_MANEUVER_NAME_QUICK2 value = " + IntToString(nName));
		SetLocalInt(oInitiator, "ETBL_MANEUVER_CURRENT", nManeuver);
		FloatingTextStringOnCreature("*Selected Maneuver: " + GetStringByStrRef(nName) + "*", oInitiator, FALSE);

	}
	else if (nID == ETBL_MANEUVER_SELECT_QUICK3)
	{
		int nManeuver = GetLocalInt(oInitiator, "ETBL_MANEUVER_QUICK3");
		int nName = GetLocalInt(oInitiator, "ETBL_MANEUVER_NAME_QUICK3");
		//if(DEBUG) DoDebug("tob_etbl_maneuver: ETBL_MANEUVER_NAME_QUICK3 value = " + IntToString(nName));
		SetLocalInt(oInitiator, "ETBL_MANEUVER_CURRENT", nManeuver);
		FloatingTextStringOnCreature("*Selected Maneuver: " + GetStringByStrRef(nName) + "*", oInitiator, FALSE);
	}
	else if (nID == ETBL_MANEUVER_SELECT_QUICK4)
	{
		int nManeuver = GetLocalInt(oInitiator, "ETBL_MANEUVER_QUICK4");
		int nName = GetLocalInt(oInitiator, "ETBL_MANEUVER_NAME_QUICK4");
		//if(DEBUG) DoDebug("tob_etbl_maneuver: ETBL_MANEUVER_NAME_QUICK4 value = " + IntToString(nName));
		SetLocalInt(oInitiator, "ETBL_MANEUVER_CURRENT", nManeuver);
		FloatingTextStringOnCreature("*Selected Maneuver: " + GetStringByStrRef(nName) + "*", oInitiator, FALSE);
	}
}
