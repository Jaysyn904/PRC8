/*
Tenser's Floating Disk script

This will transfer ALL items from the disk's inventory.

Created by: The Amethyst Dragon (www.amethyst-dragon.com/nwn)
Created: June 18, 2008
*/
#include "spinc_fdisk"

void main()
{
    object oDisk = OBJECT_SELF;
    object oCaster = GetPCSpeaker();

    SetLocalInt(oDisk, "bDiskBussy", TRUE);
    ActionDoCommand(TransferItems(oDisk, oCaster));
    ActionDoCommand(SetLocalInt(oDisk, "bDiskBussy", FALSE));
}
