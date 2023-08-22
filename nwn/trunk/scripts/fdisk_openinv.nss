/*
Tenser's Floating Disk script

This will open the disk's inventory for the disk's creator, so that items can
be placed on it or taken off.

Created by: The Amethyst Dragon (www.amethyst-dragon.com/nwn)
Created: June 18, 2008
*/

void main()
{
    object oDisk = OBJECT_SELF;
    object oCaster = GetPCSpeaker();

    OpenInventory(oDisk, oCaster);
}
