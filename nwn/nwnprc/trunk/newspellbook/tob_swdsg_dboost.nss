//::///////////////////////////////////////////////
//:: Swordsage Dual Boost
//:: 
/*
    Marks Dual Boost as active
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: May 28, 2007
//:://////////////////////////////////////////////

void main()
{
	object oPC = OBJECT_SELF;
	// If the int isn't there, proceed as normal
    	if (!GetLocalInt(oPC, "SSDualBoostMarker"))
    	{
    		FloatingTextStringOnCreature("Dual Boost Activated.", oPC, FALSE);
    		SetLocalInt(oPC, "SSDualBoost", TRUE);
    		SetLocalInt(oPC, "SSDualBoostMarker", TRUE);
    		DelayCommand(6.0, DeleteLocalInt(oPC, "SSDualBoostMarker"));
    	}
    	else
    	{
    		FloatingTextStringOnCreature("You may only Dual Boost once per round.", oPC, FALSE);
    	}
}

