//::///////////////////////////////////////////////
//:: Dragonfire Strike Activation
//:: prc_drgfr_active.nss
//::///////////////////////////////////////////////
/*
    Handles activation/deactivation of Dragonfire Strike
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 23, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{

	object oPC = OBJECT_SELF;

	if(GetLocalInt(oPC, "DragonFireOn"))
	{
	    SetLocalInt(oPC, "DragonFireOn", FALSE);
	    FloatingTextStringOnCreature("*Dragonfire Strike Deactivated*", oPC, FALSE);
	}
	else
	{
	    SetLocalInt(oPC, "DragonFireOn", TRUE);
	    FloatingTextStringOnCreature("*Dragonfire Strike Activated*", oPC, FALSE);
        }
}
