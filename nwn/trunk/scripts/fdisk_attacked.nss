/*
Tenser's Floating Disk script

Causes any creature attacking the disk to instead attack the caster.

Created by: The Amethyst Dragon (www.amethyst-dragon.com/nwn)
Created: June 18, 2008
*/

void main()
{
    object oDisk = OBJECT_SELF;
    object oCaster = GetMaster();
    object oAttacker = GetLastAttacker(oDisk);

    AssignCommand(oAttacker, ClearAllActions());
    AssignCommand(oAttacker, ActionAttack(oCaster));
}