/*
Shadow Ride
Type of Feat: Class Specific
Prerequisite: Crinti Shadow Marauder 1
Specifics: You may teleport, as per Dimension Door, once per day per class level. 
Use: Selected
*/

#include "spinc_dimdoor"

void main()
{
    object oInitiator = OBJECT_SELF;
    DimensionDoor(oInitiator, GetHitDice(oInitiator));    
}

