//:://////////////////////////////////////////////
//:: Name     Axiomatic Water
//:: FileName   sp_axiowater.nss
//:://////////////////////////////////////////////
/** @file Transmutation [Lawful]
Level: Cleric 1, Paladin 1,
Components: V, S, M,
Casting Time: 1 minute
Range: Touch
Target: Flask of water touched
Duration: Instantaneous
Saving Throw: Will negates (object)
Spell Resistance: Yes (object)

You speak the ancient, slippery words as you pour the iron and silver into the flask. Despite the fact that there is more powder than will fit in the container, all of it dissolves, leaving a flask of water dotted with motes of gunmetal gray.

This transmutation imbues a flask (1 pint) of water with the order of law, turning it into axiomatic water. Axiomatic water damages chaotic outsiders the way holy water damages undead and evil outsiders. A flask of axiomatic water can be thrown as a splash weapon. Treat this attack as a ranged touch attack with a range increment of 10 feet. A flask breaks if thrown against the body of a corporeal creature, but to use it against an incorporeal creature, the bearer must open the flask and pout the axiomatic water out onto the target. Thus, a character can douse an incorporeal creature with axiomatic water only if he is adjacent to it. Doing so is a ranged touch attack that does not provoke attacks of opportunity.

A direct hit by a flask of axiomatic water deals 2d4 points of damage to a chaotic outsider. Each such creature within 5 feet of the point where the flask hits takes 1 point of damage from the splash.

Material Component: 5 pounds of powdered iron and silver (worth 25 gp).
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 6/10/2022
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{

	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
		
	object oPC = OBJECT_SELF;
		
	CreateItemOnObject("prc_axiowater", oPC, 1);
		
	PRCSetSchool();
        
        PRCSetSchool();
}