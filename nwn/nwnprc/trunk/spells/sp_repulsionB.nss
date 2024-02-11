//::///////////////////////////////////////////////
//:: Name      Repulsion
//:: FileName  sp_repulsionB.nss
//:://////////////////////////////////////////////7
/** @file Repulsion
Abjuration
Level:  Clr 7, Protection 7, Sor/Wiz 6
Components:     V, S, F/DF
Casting Time:   1 standard action
Range:  Up to 10 ft./level
Area:   Up to 10-ft.-radius/level emanation centered on you
Duration:       1 round/level (D)
Saving Throw:   Will negates
Spell Resistance:       Yes

An invisible, mobile field surrounds you and prevents
creatures from approaching you. You decide how big 
the field is at the time of casting (to the limit 
your level allows). Any creature within or entering 
the field must attempt a save. If it fails, it becomes 
unable to move toward you for the duration of the 
spell. Repelled creatures’ actions are not otherwise 
restricted.

They can fight other creatures and can cast spells and 
attack you with ranged weapons. If you move closer to 
an affected creature, nothing happens. (The creature is
not forced back.) The creature is free to make melee 
attacks against you if you come within reach. If a 
repelled creature moves away from you and then tries to
turn back toward you, it cannot move any closer if it 
is still within the spell’s area.

Arcane Focus: A pair of small iron bars attached to two
small canine statuettes, one black and one white, the 
whole array worth 50 gp. 

OnExit script
**/
//////////////////////////////////////////////////////
// Author: fluffyamoeba
// Date:   2008-09-05
//////////////////////////////////////////////////////

void main()
{
    object oTarget = GetExitingObject();
    DeleteLocalInt(oTarget,"repulsive");
}
