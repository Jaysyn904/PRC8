//::///////////////////////////////////////////////
//:: Dragonfire Assault Activation
//:: prc_drgfr_assact.nss
//::///////////////////////////////////////////////
/*
    Handles activation/deactivation of Dragonfire Assault
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 23, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{

	object oPC = OBJECT_SELF;

	if(GetLocalInt(oPC, "DragonFireAssOn"))
	{
	    SetLocalInt(oPC, "DragonFireAssOn", FALSE);
	    FloatingTextStringOnCreature("*Dragonfire Assault Deactivated*", oPC, FALSE);
	}
	else
	{
	    SetLocalInt(oPC, "DragonFireAssOn", TRUE);
	    FloatingTextStringOnCreature("*Dragonfire Assault Activated*", oPC, FALSE);
        }
}
