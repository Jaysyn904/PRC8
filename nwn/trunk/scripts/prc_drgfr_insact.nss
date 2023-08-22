//::///////////////////////////////////////////////
//:: Dragonfire Inspiration Activation
//:: prc_drgfr_insact.nss
//::///////////////////////////////////////////////
/*
    Handles activation/deactivation of Dragonfire Inspiration
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 23, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{

	object oPC = OBJECT_SELF;

	if(GetLocalInt(oPC, "DragonFireInspOn"))
	{
	    SetLocalInt(oPC, "DragonFireInspOn", FALSE);
	    FloatingTextStringOnCreature("*Dragonfire Inspire Deactivated*", oPC, FALSE);
	}
	else
	{
	    SetLocalInt(oPC, "DragonFireInspOn", TRUE);
	    FloatingTextStringOnCreature("*Dragonfire Inspire Activated*", oPC, FALSE);
        }
}
