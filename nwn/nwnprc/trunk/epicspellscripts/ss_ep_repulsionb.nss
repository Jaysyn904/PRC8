//::////////////////////////////////////////////////////////
//:: Name      Epic Repulsion
//:: FileName  ss_ep_repulsionb.nss
//::////////////////////////////////////////////////////////
/** @file Epic Repulsion
School: Abjuration
Components: V,S
Range: Touch
Target: Creature or object touched
Duration: 24 hours
Saving Throw: None
Spell Resistance: Yes, see text

You can create a ward against a specific type of creature for 
the duration. Any creature of the specific type cannot come 
within the aura of the warded creature or object. Spell 
resistance can allow a creature to overcome this protection 
and enter the aura of the warded subject.

OnExit script
**/
//::////////////////////////////////////////////////////////
//::
//:: Author: Jaysyn
//:: Date: 2026-09-20 18:21:40
//::
//::////////////////////////////////////////////////////////

void main()
{
    object oTarget = GetExitingObject();
    DeleteLocalInt(oTarget,"EpicRepulsive");
}