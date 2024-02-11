/*
Tenser's Floating Disk script

Disk tries to follow the caster, even through doors.

Created by: The Amethyst Dragon (www.amethyst-dragon.com/nwn)
Created: June 18, 2008
*/

void main()
{
    object oDisk = OBJECT_SELF;
    object oCaster = GetMaster();

    DelayCommand(6.0, ActionJumpToLocation(GetLocation(oCaster)));
}