/*
Tenser's Floating Disk script

This will start the disk's conversation if the PC is the caster of the spell.

Created by: The Amethyst Dragon (www.amethyst-dragon.com/nwn)
Created: June 18, 2008
Modified by: xwarren
Modified: August 15, 2009
*/

int StartingConditional()
{
    object oDisk = OBJECT_SELF;
    object oCaster = GetPCSpeaker();
    object oMaster = GetLocalObject(oDisk, "caster");
    if(oMaster == oCaster)
    {
        if(GetMaster(oDisk) != oCaster)
            AddHenchman(oCaster, oDisk);
        return TRUE;
    }
    return FALSE;
}
