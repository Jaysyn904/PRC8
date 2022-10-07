/*
6/1/20 by Stratovarius

Landshark Boots Chakra Bind (Feet) 

The leathery skin of your landshark boots extends up to the middle of your thighs, and your legs thicken and grow stronger. 
The boots transmit vibrations from the earth into your feet, allowing you to sense the movement of nearby creatures.

You can take a move action to sense the closest creature and the direction to it. 
*/

#include "moi_inc_moifunc"
#include "prc_inc_scry" 

void main()
{
	object oMeldshaper    = OBJECT_SELF;
	if(!TakeMoveAction(oMeldshaper)) return;
	object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
	LocateCreatureOrObject(oMeldshaper, oTarget);
}