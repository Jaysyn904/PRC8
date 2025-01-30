/*
13/02/19 by Stratovarius

Flicker

Apprentice, Ebon Whispers 
Level/School: 3rd/Conjuration (Teleportation) 
Range: Personal 
Target: You 
Duration: 1 round/level

You flash through the conduits and pathways of the Plane of Shadow, manifesting in multiple locations in the real world.

Once per round, as an immediate action, you can instantly transfer yourself from your current location to any other spot within a close distance. 
*/

#include "shd_inc_shdfunc"
#include "spinc_dimdoor"

void main()
{
    object oShadow = OBJECT_SELF;
    
    if (!GetLocalInt(oShadow, "FlickerMyst"))
    {
    	int nLevel = PRCMax(GetShadowcasterLevel(oShadow), GetLocalInt(oShadow, "TenebrousFlicker"));
        DimensionDoor(oShadow, nLevel);
        SetLocalInt(oShadow, "FlickerMyst", TRUE);
        DelayCommand(5.5, DeleteLocalInt(oShadow, "FlickerMyst"));
        DelayCommand(5.5, FloatingTextStringOnCreature("You may Flicker again.", oShadow, FALSE));
    }
    else
        FloatingTextStringOnCreature("You may only use Flicker once per round.", oShadow, FALSE);
}